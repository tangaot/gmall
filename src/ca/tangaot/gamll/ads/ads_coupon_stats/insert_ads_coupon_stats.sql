--优惠券统计

USE gmall;

insert overwrite table ads_coupon_stats
select *
from ads_coupon_stats
union
select '2021-06-16' dt,
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
from (
         select id,
                coupon_name,
                date_format(start_time, 'yyyy-MM-dd') start_date,
                case
                    when coupon_type = '3201' then concat('满', condition_amount, '元减', benefit_amount, '元')
                    when coupon_type = '3202' then concat('满', condition_num, '件打', (1 - benefit_discount) * 10, '折')
                    when coupon_type = '3203' then concat('减', benefit_amount, '元')
                    end                               rule_name
         from dim_coupon_info
         where dt = '2021-06-16'
           and date_format(start_time, 'yyyy-MM-dd') >= date_add('2021-06-16', -29)
     ) t1
         left join
     (
         select coupon_id,
                get_count,
                order_count,
                expire_count,
                order_original_amount,
                order_final_amount,
                order_reduce_amount                                                 reduce_amount,
                cast(order_reduce_amount / order_original_amount as decimal(16, 2)) reduce_rate
         from dwt_coupon_topic
         where dt = '2021-06-16'
     ) t2
     on t1.id = t2.coupon_id;
