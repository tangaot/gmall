-- 活动主题

USE gmall;
set hive.exec.dynamic.partition.mode=nonstrict;


with
    tmp_order as
        (
            select
                activity_rule_id,
                activity_id,
                count(*) order_count,
                sum(split_activity_amount) order_reduce_amount,
                sum(original_amount) order_original_amount,
                sum(split_final_amount) order_final_amount
            from dwd_order_detail
            where dt='2021-06-17'
              and activity_id is not null
            group by activity_rule_id,activity_id
        ),
    tmp_pay as
        (
            select
                activity_rule_id,
                activity_id,
                count(*) payment_count,
                sum(split_activity_amount) payment_reduce_amount,
                sum(split_final_amount) payment_amount
            from dwd_order_detail
            where (dt='2021-06-17'
                or dt=date_add('2021-06-17',-1))
              and activity_id is not null
              and order_id in
                  (
                      select order_id from dwd_payment_info where dt='2021-06-17'
                  )
            group by activity_rule_id,activity_id
        )
insert overwrite table dws_activity_info_daycount partition(dt='2021-06-17')
select
    activity_rule_id,
    activity_id,
    sum(order_count),
    sum(order_reduce_amount),
    sum(order_original_amount),
    sum(order_final_amount),
    sum(payment_count),
    sum(payment_reduce_amount),
    sum(payment_amount)
from
    (
        select
            activity_rule_id,
            activity_id,
            order_count,
            order_reduce_amount,
            order_original_amount,
            order_final_amount,
            0 payment_count,
            0 payment_reduce_amount,
            0 payment_amount
        from tmp_order
        union all
        select
            activity_rule_id,
            activity_id,
            0 order_count,
            0 order_reduce_amount,
            0 order_original_amount,
            0 order_final_amount,
            payment_count,
            payment_reduce_amount,
            payment_amount
        from tmp_pay
    )t1
group by activity_rule_id,activity_id;
