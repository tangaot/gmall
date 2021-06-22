-- 地区主题

USE gmall;

with tmp_vu as
         (
             select dt,
                    id province_id,
                    visit_count,
                    login_count,
                    visitor_count,
                    user_count
             from (
                      select dt,
                             area_code,
                             count(*)                  visit_count,--访客访问次数
                             count(user_id)            login_count,--用户访问次数,等价于sum(if(user_id is not null,1,0))
                             count(distinct (mid_id))  visitor_count,--访客人数
                             count(distinct (user_id)) user_count--用户人数
                      from dwd_page_log
                      where last_page_id is null
                      group by dt, area_code
                  ) tmp
                      left join dim_base_province area
                                on tmp.area_code = area.area_code
         ),
     tmp_order as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    province_id,
                    count(*)                               order_count,
                    sum(original_amount)                   order_original_amount,
                    sum(final_amount)                      order_final_amount
             from dwd_order_info
             group by date_format(create_time, 'yyyy-MM-dd'), province_id
         ),
     tmp_pay as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    province_id,
                    count(*)                                 payment_count,
                    sum(payment_amount)                      payment_amount
             from dwd_payment_info
             group by date_format(callback_time, 'yyyy-MM-dd'), province_id
         ),
     tmp_ro as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    province_id,
                    count(*)                               refund_order_count,
                    sum(refund_amount)                     refund_order_amount
             from dwd_order_refund_info
             group by date_format(create_time, 'yyyy-MM-dd'), province_id
         ),
     tmp_rp as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    province_id,
                    count(*)                                 refund_payment_count,
                    sum(refund_amount)                       refund_payment_amount
             from dwd_refund_payment
             group by date_format(callback_time, 'yyyy-MM-dd'), province_id
         )
insert
overwrite
table
dws_area_stats_daycount
partition
(
dt
)
select province_id,
       sum(visit_count),
       sum(login_count),
       sum(visitor_count),
       sum(user_count),
       sum(order_count),
       sum(order_original_amount),
       sum(order_final_amount),
       sum(payment_count),
       sum(payment_amount),
       sum(refund_order_count),
       sum(refund_order_amount),
       sum(refund_payment_count),
       sum(refund_payment_amount),
       dt
from (
         select dt,
                province_id,
                visit_count,
                login_count,
                visitor_count,
                user_count,
                0 order_count,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_amount
         from tmp_vu
         union all
         select dt,
                province_id,
                0 visit_count,
                0 login_count,
                0 visitor_count,
                0 user_count,
                order_count,
                order_original_amount,
                order_final_amount,
                0 payment_count,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_amount
         from tmp_order
         union all
         select dt,
                province_id,
                0 visit_count,
                0 login_count,
                0 visitor_count,
                0 user_count,
                0 order_count,
                0 order_original_amount,
                0 order_final_amount,
                payment_count,
                payment_amount,
                0 refund_order_count,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_amount
         from tmp_pay
         union all
         select dt,
                province_id,
                0 visit_count,
                0 login_count,
                0 visitor_count,
                0 user_count,
                0 order_count,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_amount,
                refund_order_count,
                refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_amount
         from tmp_ro
         union all
         select dt,
                province_id,
                0 visit_count,
                0 login_count,
                0 visitor_count,
                0 user_count,
                0 order_count,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_amount,
                refund_payment_count,
                refund_payment_amount
         from tmp_rp
     ) t1
group by dt, province_id;

