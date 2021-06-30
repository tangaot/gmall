#!/bin/bash

APP=gmall

# 如果是输入的日期按照取输入日期；如果没输入日期取当前时间的前一天
if [ -n "$2" ]; then
  do_date=$2
else
  do_date=$(date -d "-1 day" +%F)
fi

ads_activity_stats="
insert overwrite table ${APP}.ads_activity_stats
select * from ${APP}.ads_activity_stats
union
select
    '$do_date' dt,
    t4.activity_id,
    activity_name,
    start_date,
    order_count,
    order_original_amount,
    order_final_amount,
    reduce_amount,
    reduce_rate
from
(
    select
        activity_id,
        activity_name,
        date_format(start_time,'yyyy-MM-dd') start_date
    from ${APP}.dim_activity_rule_info
    group by activity_id,activity_name,start_time
)t4
left join
(
    select
        activity_id,
        sum(order_count) order_count,
        sum(order_original_amount) order_original_amount,
        sum(order_final_amount) order_final_amount,
        sum(order_reduce_amount) reduce_amount,
        cast(sum(order_reduce_amount)/sum(order_original_amount)*100 as decimal(16,2)) reduce_rate
    from ${APP}.dwt_activity_topic
    where dt='$do_date'
    group by activity_id
)t5
on t4.activity_id=t5.activity_id;
"
ads_coupon_stats="
insert overwrite table ${APP}.ads_coupon_stats
select * from ${APP}.ads_coupon_stats
union
select
    '$do_date' dt,
    t1.id,
    coupon_name,
    start_date,
    rule_name,
    get_count,
    order_count,
    expire_count,
    order_original_amount,
    order_final_amount,
    reduce_amount,
    reduce_rate
from
(
    select
        id,
        coupon_name,
        date_format(start_time,'yyyy-MM-dd') start_date,
        case
            when coupon_type='3201' then concat('满',condition_amount,'元减',benefit_amount,'元')
            when coupon_type='3202' then concat('满',condition_num,'件打', (1-benefit_discount)*10,'折')
            when coupon_type='3203' then concat('减',benefit_amount,'元')
        end rule_name
    from ${APP}.dim_coupon_info
    where dt='$do_date'
    and date_format(start_time,'yyyy-MM-dd')>=date_add('$do_date',-29)
)t1
left join
(
    select
        coupon_id,
        get_count,
        order_count,
        expire_count,
        order_original_amount,
        order_final_amount,
        order_reduce_amount reduce_amount,
        cast(order_reduce_amount/order_original_amount as decimal(16,2)) reduce_rate
    from ${APP}.dwt_coupon_topic
    where dt='$do_date'
)t2
on t1.id=t2.coupon_id;
"
ads_order_by_province="
insert overwrite table ${APP}.ads_order_by_province
select * from ${APP}.ads_order_by_province
union
select
    '$do_date' dt,
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    order_last_1d_count,
    order_last_1d_final_amount
from
(
    select
        province_id,
        order_last_1d_count,
        order_last_1d_final_amount
    from ${APP}.dwt_area_topic
    where dt='$do_date'
)t1
left join
(
    select
        id,
        province_name,
        area_code,
        iso_code,
        iso_3166_2
    from ${APP}.dim_base_province
)t2
on t1.province_id=t2.id;
"
ads_order_spu_stats="
insert overwrite table ${APP}.ads_order_spu_stats
select * from ${APP}.ads_order_spu_stats
union
select
    '$do_date' dt,
    spu_id,
    spu_name,
    tm_id,
    tm_name,
    category3_id,
    category3_name,
    category2_id,
    category2_name,
    category1_id,
    category1_name,
    sum(order_last_1d_count),
    sum(order_last_1d_final_amount)
from
(
    select
        sku_id,
        order_last_1d_count,
        order_last_1d_final_amount
    from ${APP}.dwt_sku_topic
    where dt='$do_date'
)t1
left join
(
    select
        id,
        spu_id,
        spu_name,
        tm_id,
        tm_name,
        category3_id,
        category3_name,
        category2_id,
        category2_name,
        category1_id,
        category1_name
    from ${APP}.dim_sku_info
    where dt='$do_date'
)t2
on t1.sku_id=t2.id
group by spu_id,spu_name,tm_id,tm_name,category3_id,category3_name,category2_id,category2_name,category1_id,category1_name;
"
ads_order_total="
insert overwrite table ${APP}.ads_order_total
select * from ${APP}.ads_order_total
union
select
    '$do_date',
    sum(order_last_1d_count),
    sum(order_last_1d_final_amount) order_final_amount,
    sum(if(order_last_1d_final_amount>0,1,0)) order_user_count
from ${APP}.dwt_user_topic
where dt='$do_date';
"
ads_page_path="
insert overwrite table ${APP}.ads_page_path
select * from ${APP}.ads_page_path
union
select
    '$do_date',
    source,
    target,
    count(*)
from
(
    select
        concat('step-',step,':',source) source,
        concat('step-',step+1,':',target) target
    from
    (
        select
            page_id source,
            lead(page_id,1,null) over (partition by session_id order by ts) target,
            row_number() over (partition by session_id order by ts) step
        from
        (
            select
                last_page_id,
                page_id,
                ts,
                concat(mid_id,'-',last_value(if(last_page_id is null,ts,null),true) over (partition by mid_id order by ts)) session_id
            from ${APP}.dwd_page_log
            where dt='$do_date'
        )t1
    )t2
)t3
group by source,target;
"
ads_repeat_purchase="
insert overwrite table ${APP}.ads_repeat_purchase
select * from ${APP}.ads_repeat_purchase
union
select
    '$do_date' dt,
    tm_id,
    tm_name,
    cast(sum(if(order_count>=2,1,0))/sum(if(order_count>=1,1,0))*100 as decimal(16,2))
from
(
    select
        user_id,
        tm_id,
        tm_name,
        sum(order_count) order_count
    from
    (
        select
            user_id,
            sku_id,
            count(*) order_count
        from ${APP}.dwd_order_detail
        where dt>=date_add('$do_date',-29)
        group by user_id,sku_id
    )t1
    left join
    (
        select
            id,
            tm_id,
            tm_name
        from ${APP}.dim_sku_info
        where dt='$do_date'
    )t2
    on t1.sku_id=t2.id
    group by user_id,tm_id,tm_name
)t3
group by tm_id,tm_name;
"
ads_user_action="
with
tmp_page as
(
    select
        '$do_date' dt,
        sum(if(array_contains(pages,'home'),1,0)) home_count,
        sum(if(array_contains(pages,'good_detail'),1,0)) good_detail_count
    from
    (
        select
            mid_id,
            collect_set(page.page_id) pages
        from ${APP}.dws_visitor_action_daycount lateral view explode(page_stats) tmp as page
        where dt='$do_date'
        and page.page_id in ('home','good_detail')
        group by mid_id
    )t1
),
tmp_cop as
(
    select
        '$do_date' dt,
        sum(if(cart_last_1d_count>0,1,0)) cart_count,
        sum(if(order_last_1d_count>0,1,0)) order_count,
        sum(if(payment_last_1d_count>0,1,0)) payment_count
    from ${APP}.dwt_user_topic
    where dt='$do_date'
)
insert overwrite table ${APP}.ads_user_action
select * from ${APP}.ads_user_action
union
select
    tmp_page.dt,
    home_count,
    good_detail_count,
    cart_count,
    order_count,
    payment_count
from tmp_page
join tmp_cop
on tmp_page.dt=tmp_cop.dt;
"
ads_user_change="
insert overwrite table ${APP}.ads_user_change
select * from ${APP}.ads_user_change
union
select
    churn.dt,
    user_churn_count,
    user_back_count
from
(
    select
        '$do_date' dt,
        count(*) user_churn_count
    from ${APP}.dwt_user_topic
    where dt='$do_date'
    and login_date_last=date_add('$do_date',-7)
)churn
join
(
    select
        '$do_date' dt,
        count(*) user_back_count
    from
    (
        select
            user_id,
            login_date_last
        from ${APP}.dwt_user_topic
        where dt='$do_date'
        and login_date_last='$do_date'
    )t1
    join
    (
        select
            user_id,
            login_date_last login_date_previous
        from ${APP}.dwt_user_topic
        where dt=date_add('$do_date',-1)
    )t2
    on t1.user_id=t2.user_id
    where datediff(login_date_last,login_date_previous)>=8
)back
on churn.dt=back.dt;
"
ads_user_retention="
insert overwrite table ${APP}.ads_user_retention
select * from ${APP}.ads_user_retention
union
select
    '$do_date',
    login_date_first create_date,
    datediff('$do_date',login_date_first) retention_day,
    sum(if(login_date_last='$do_date',1,0)) retention_count,
    count(*) new_user_count,
    cast(sum(if(login_date_last='$do_date',1,0))/count(*)*100 as decimal(16,2)) retention_rate
from ${APP}.dwt_user_topic
where dt='$do_date'
and login_date_first>=date_add('$do_date',-7)
and login_date_first<'$do_date'
group by login_date_first;
"
ads_user_total="
insert overwrite table ${APP}.ads_user_total
select * from ${APP}.ads_user_total
union
select
    '$do_date',
    sum(if(login_date_first='$do_date',1,0)) new_user_count,
    sum(if(order_date_first='$do_date',1,0)) new_order_user_count,
    sum(order_final_amount) order_final_amount,
    sum(if(order_final_amount>0,1,0)) order_user_count,
    sum(if(login_date_last='$do_date' and order_final_amount=0,1,0)) no_order_user_count
from ${APP}.dwt_user_topic
where dt='$do_date';
"
ads_user_continuity="
insert overwrite table ${APP}.ads_user_continuity
select * from ${APP}.ads_user_continuity
union
select
    '$do_date' dt,
    count(distinct(user_id))
from
(
    select
        user_id
    from
    (
        select
            user_id,
            date_sub(dt,rk) diff
        from
        (
            select
                user_id,
                dt,
                rank() over (partition by user_id order by dt) rk
            from ${APP}.dws_user_action_daycount
            where dt>=date_add('$do_date',-6)
        )t1
    )t2
    group by user_id,diff
    having count(*)>=3
)t3;
"

ads_user_online_count_min="
insert overwrite table ${APP}.ads_user_online_count_min
select * from ${APP}.ads_user_online_count_min
union
select
    '$do_date' dt,
    mins,
    count(*) cnt
from
(
    select
        user_id,
        from_unixtime(session_start_timestamp+60*pos,'yyyy-MM-dd HH:mm') mins
    from
    (
        select
            session_id,
            user_id,
            unix_timestamp(from_unixtime(session_start_timestamp,'yyyy-MM-dd HH:mm'),'yyyy-MM-dd HH:mm') session_start_timestamp,
            unix_timestamp(from_unixtime(session_end_timestamp,'yyyy-MM-dd HH:mm'),'yyyy-MM-dd HH:mm') session_end_timestamp
        from
        (
            select
                session_id,
                user_id,
                cast(min(page_start_time)/1000 as bigint) session_start_timestamp,
                cast(max(page_end_time)/1000 as bigint) session_end_timestamp
            from
            (
                select
                    user_id,
                    ts page_start_time,
                    ts+during_time page_end_time,
                    concat(user_id,'-',last_value(session_start_point,true) over(partition by user_id order by ts)) session_id
                from
                (
                    select
                        user_id,
                        ts,
                        during_time,
                        if(last_page_id is null,ts,null) session_start_point
                    from ${APP}.dwd_page_log
                    where dt='$do_date'
                )t1
            )t2
            group by session_id,user_id
        )t3
    )t4
    lateral view posexplode(split(repeat("0",cast((session_end_timestamp-session_start_timestamp)/60 as int)),"0")) tmp as pos,item
)t5
group by mins;
"

ads_visit_stats="
insert overwrite table ${APP}.ads_visit_stats
select * from ${APP}.ads_visit_stats
union
select
    '$do_date' dt,
    is_new,
    channel,
    count(distinct(mid_id)) uv_count,
    cast(sum(duration)/1000 as bigint) duration_sec,
    cast(avg(duration)/1000 as bigint) avg_duration_sec,
    sum(page_count) page_count,
    cast(avg(page_count) as bigint) avg_page_count,
    count(*) sv_count,
    sum(if(page_count=1,1,0)) bounce_count,
    cast(sum(if(page_count=1,1,0))/count(*)*100 as decimal(16,2)) bounce_rate
from
(
    select
        session_id,
        mid_id,
        is_new,
        channel,
        count(*) page_count,
        sum(during_time) duration
    from
    (
        select
            t1.mid_id,
            channel,
            is_new,
            last_page_id,
            page_id,
            during_time,
            concat(t1.mid_id,'-',last_value(if(last_page_id is null,ts,null),true) over (partition by t1.mid_id order by ts)) session_id
        from
        (
            select
                mid_id,
                channel,
                last_page_id,
                page_id,
                during_time,
                dt,
                ts
            from ${APP}.dwd_page_log
            where dt='$do_date'
        )t1
        left join
        (
            select
                mid_id,
                if(visit_date_first='$do_date','1','0') is_new
            from ${APP}.dwt_visitor_topic
            where dt='$do_date'
        )t2
        on t1.mid_id=t2.mid_id
    )t3
    group by session_id,mid_id,is_new,channel
)t4
group by is_new,channel;
"
case $1 in
"ads_activity_stats")
  hive -e "$ads_activity_stats"
  ;;
"ads_coupon_stats")
  hive -e "$ads_coupon_stats"
  ;;
"ads_order_by_province")
  hive -e "$ads_order_by_province"
  ;;
"ads_order_spu_stats")
  hive -e "$ads_order_spu_stats"
  ;;
"ads_order_total")
  hive -e "$ads_order_total"
  ;;
"ads_page_path")
  hive -e "$ads_page_path"
  ;;
"ads_repeat_purchase")
  hive -e "$ads_repeat_purchase"
  ;;
"ads_user_action")
  hive -e "$ads_user_action"
  ;;
"ads_user_change")
  hive -e "$ads_user_change"
  ;;
"ads_user_retention")
  hive -e "$ads_user_retention"
  ;;
"ads_user_total")
  hive -e "$ads_user_total"
  ;;
"ads_user_continuity")
  hive -e "$ads_user_continuity"
  ;;
"ads_user_online_count_min")
  hive -e "$ads_user_online_count_min"
  ;;
"ads_visit_stats")
  hive -e "$ads_visit_stats"
  ;;
"all")
  hive -e "$ads_activity_stats$ads_coupon_stats$ads_order_by_province$ads_order_spu_stats$ads_order_total$ads_page_path$ads_repeat_purchase$ads_user_action$ads_user_change$ads_user_retention$ads_user_total$ads_user_continuity$ads_user_online_count_min$ads_visit_stats"
  ;;
esac

