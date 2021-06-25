-- 活动统计

USE gmall;

insert overwrite table ads_activity_stats
select *
from ads_activity_stats
union
select '2021-06-16' dt,
       t4.activity_id,
       activity_name,
       start_date,
       order_count,
       order_original_amount,
       order_final_amount,
       reduce_amount,
       reduce_rate
from (
         select activity_id,
                activity_name,
                date_format(start_time, 'yyyy-MM-dd') start_date
         from dim_activity_rule_info
         group by activity_id, activity_name, start_time
     ) t4
         left join
     (
         select activity_id,
                sum(order_count)                                                                    order_count,
                sum(order_original_amount)                                                          order_original_amount,
                sum(order_final_amount)                                                             order_final_amount,
                sum(order_reduce_amount)                                                            reduce_amount,
                cast(sum(order_reduce_amount) / sum(order_original_amount) * 100 as decimal(16, 2)) reduce_rate
         from dwt_activity_topic
         where dt = '2021-06-16'
         group by activity_id
     ) t5
     on t4.activity_id = t5.activity_id;
