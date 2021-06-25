-- 订单统计

USE gmall;

insert overwrite table ads_order_total
select *
from ads_order_total
union
select '2021-06-16',
       sum(order_last_1d_count),
       sum(order_last_1d_final_amount)               order_final_amount,
       sum(if(order_last_1d_final_amount > 0, 1, 0)) order_user_count
from dwt_user_topic
where dt = '2021-06-16';
