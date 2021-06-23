-- 用户统计

USE gmall;

insert overwrite table ads_user_total
select *
from ads_user_total
union
select '2021-06-16',
       sum(if(login_date_first = '2021-06-16', 1, 0))                           new_user_count,
       sum(if(order_date_first = '2021-06-16', 1, 0))                           new_order_user_count,
       sum(order_final_amount)                                                  order_final_amount,
       sum(if(order_final_amount > 0, 1, 0))                                    order_user_count,
       sum(if(login_date_last = '2021-06-16' and order_final_amount = 0, 1, 0)) no_order_user_count
from dwt_user_topic
where dt = '2021-06-16'

