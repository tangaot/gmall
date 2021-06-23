-- 活动主题

USE gmall;


insert overwrite table dwt_activity_topic partition (dt = '2021-06-17')
select nvl(1d_ago.activity_rule_id, old.activity_rule_id),
       nvl(1d_ago.activity_id, old.activity_id),
       nvl(1d_ago.order_count, 0),
       nvl(1d_ago.order_reduce_amount, 0.0),
       nvl(1d_ago.order_original_amount, 0.0),
       nvl(1d_ago.order_final_amount, 0.0),
       nvl(old.order_count, 0) + nvl(1d_ago.order_count, 0),
       nvl(old.order_reduce_amount, 0.0) + nvl(1d_ago.order_reduce_amount, 0.0),
       nvl(old.order_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0),
       nvl(old.order_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0),
       nvl(1d_ago.payment_count, 0),
       nvl(1d_ago.payment_reduce_amount, 0.0),
       nvl(1d_ago.payment_amount, 0.0),
       nvl(old.payment_count, 0) + nvl(1d_ago.payment_count, 0),
       nvl(old.payment_reduce_amount, 0.0) + nvl(1d_ago.payment_reduce_amount, 0.0),
       nvl(old.payment_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0)
from (
         select activity_rule_id,
                activity_id,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount
         from dwt_activity_topic
         where dt = date_add('2021-06-17', -1)
     ) old
         full outer join
     (
         select activity_rule_id,
                activity_id,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount
         from dws_activity_info_daycount
         where dt = '2021-06-17'
     ) 1d_ago
     on old.activity_rule_id = 1d_ago.activity_rule_id;
