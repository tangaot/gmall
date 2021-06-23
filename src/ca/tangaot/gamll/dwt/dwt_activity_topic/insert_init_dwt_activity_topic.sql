-- 活动主题

USE gmall;

insert overwrite table dwt_activity_topic partition (dt = '2021-06-16')
select t1.activity_rule_id,
       t1.activity_id,
       nvl(order_last_1d_count, 0),
       nvl(order_last_1d_reduce_amount, 0),
       nvl(order_last_1d_original_amount, 0),
       nvl(order_last_1d_final_amount, 0),
       nvl(order_count, 0),
       nvl(order_reduce_amount, 0),
       nvl(order_original_amount, 0),
       nvl(order_final_amount, 0),
       nvl(payment_last_1d_count, 0),
       nvl(payment_last_1d_reduce_amount, 0),
       nvl(payment_last_1d_amount, 0),
       nvl(payment_count, 0),
       nvl(payment_reduce_amount, 0),
       nvl(payment_amount, 0)
from (
         select activity_rule_id,
                activity_id
         from dim_activity_rule_info
         where dt = '2021-06-16'
     ) t1
         left join
     (
         select activity_rule_id,
                activity_id,

                sum(if(dt = '2021-06-16', order_count, 0))           order_last_1d_count,
                sum(if(dt = '2021-06-16', order_reduce_amount, 0))   order_last_1d_reduce_amount,
                sum(if(dt = '2021-06-16', order_original_amount, 0)) order_last_1d_original_amount,
                sum(if(dt = '2021-06-16', order_final_amount, 0))    order_last_1d_final_amount,
                sum(order_count)                                     order_count,
                sum(order_reduce_amount)                             order_reduce_amount,
                sum(order_original_amount)                           order_original_amount,
                sum(order_final_amount)                              order_final_amount,
                sum(if(dt = '2021-06-16', payment_count, 0))         payment_last_1d_count,
                sum(if(dt = '2021-06-16', payment_reduce_amount, 0)) payment_last_1d_reduce_amount,
                sum(if(dt = '2021-06-16', payment_amount, 0))        payment_last_1d_amount,
                sum(payment_count)                                   payment_count,
                sum(payment_reduce_amount)                           payment_reduce_amount,
                sum(payment_amount)                                  payment_amount
         from dws_activity_info_daycount
         group by activity_rule_id, activity_id
     ) t2
     on t1.activity_rule_id = t2.activity_rule_id
         and t1.activity_id = t2.activity_id;
