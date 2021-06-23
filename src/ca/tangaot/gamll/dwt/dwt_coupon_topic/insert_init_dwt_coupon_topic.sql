-- 优惠券主题

USE gmall;

insert overwrite table dwt_coupon_topic partition (dt = '2021-06-16')
select id,
       nvl(get_last_1d_count, 0),
       nvl(get_last_7d_count, 0),
       nvl(get_last_30d_count, 0),
       nvl(get_count, 0),
       nvl(order_last_1d_count, 0),
       nvl(order_last_1d_reduce_amount, 0),
       nvl(order_last_1d_original_amount, 0),
       nvl(order_last_1d_final_amount, 0),
       nvl(order_last_7d_count, 0),
       nvl(order_last_7d_reduce_amount, 0),
       nvl(order_last_7d_original_amount, 0),
       nvl(order_last_7d_final_amount, 0),
       nvl(order_last_30d_count, 0),
       nvl(order_last_30d_reduce_amount, 0),
       nvl(order_last_30d_original_amount, 0),
       nvl(order_last_30d_final_amount, 0),
       nvl(order_count, 0),
       nvl(order_reduce_amount, 0),
       nvl(order_original_amount, 0),
       nvl(order_final_amount, 0),
       nvl(payment_last_1d_count, 0),
       nvl(payment_last_1d_reduce_amount, 0),
       nvl(payment_last_1d_amount, 0),
       nvl(payment_last_7d_count, 0),
       nvl(payment_last_7d_reduce_amount, 0),
       nvl(payment_last_7d_amount, 0),
       nvl(payment_last_30d_count, 0),
       nvl(payment_last_30d_reduce_amount, 0),
       nvl(payment_last_30d_amount, 0),
       nvl(payment_count, 0),
       nvl(payment_reduce_amount, 0),
       nvl(payment_amount, 0),
       nvl(expire_last_1d_count, 0),
       nvl(expire_last_7d_count, 0),
       nvl(expire_last_30d_count, 0),
       nvl(expire_count, 0)
from (
         select id
         from dim_coupon_info
         where dt = '2021-06-16'
     ) t1
         left join
     (
         select coupon_id                                                            coupon_id,
                sum(if(dt = '2021-06-16', get_count, 0))                             get_last_1d_count,
                sum(if(dt >= date_add('2021-06-16', -6), get_count, 0))              get_last_7d_count,
                sum(if(dt >= date_add('2021-06-16', -29), get_count, 0))             get_last_30d_count,
                sum(get_count)                                                       get_count,
                sum(if(dt = '2021-06-16', order_count, 0))                           order_last_1d_count,
                sum(if(dt = '2021-06-16', order_reduce_amount, 0))                   order_last_1d_reduce_amount,
                sum(if(dt = '2021-06-16', order_original_amount, 0))                 order_last_1d_original_amount,
                sum(if(dt = '2021-06-16', order_final_amount, 0))                    order_last_1d_final_amount,
                sum(if(dt >= date_add('2021-06-16', -6), order_count, 0))            order_last_7d_count,
                sum(if(dt >= date_add('2021-06-16', -6), order_reduce_amount, 0))    order_last_7d_reduce_amount,
                sum(if(dt >= date_add('2021-06-16', -6), order_original_amount, 0))  order_last_7d_original_amount,
                sum(if(dt >= date_add('2021-06-16', -6), order_final_amount, 0))     order_last_7d_final_amount,
                sum(if(dt >= date_add('2021-06-16', -29), order_count, 0))           order_last_30d_count,
                sum(if(dt >= date_add('2021-06-16', -29), order_reduce_amount, 0))   order_last_30d_reduce_amount,
                sum(if(dt >= date_add('2021-06-16', -29), order_original_amount, 0)) order_last_30d_original_amount,
                sum(if(dt >= date_add('2021-06-16', -29), order_final_amount, 0))    order_last_30d_final_amount,
                sum(order_count)                                                     order_count,
                sum(order_reduce_amount)                                             order_reduce_amount,
                sum(order_original_amount)                                           order_original_amount,
                sum(order_final_amount)                                              order_final_amount,
                sum(if(dt = '2021-06-16', payment_count, 0))                         payment_last_1d_count,
                sum(if(dt = '2021-06-16', payment_reduce_amount, 0))                 payment_last_1d_reduce_amount,
                sum(if(dt = '2021-06-16', payment_amount, 0))                        payment_last_1d_amount,
                sum(if(dt >= date_add('2021-06-16', -6), payment_count, 0))          payment_last_7d_count,
                sum(if(dt >= date_add('2021-06-16', -6), payment_reduce_amount, 0))  payment_last_7d_reduce_amount,
                sum(if(dt >= date_add('2021-06-16', -6), payment_amount, 0))         payment_last_7d_amount,
                sum(if(dt >= date_add('2021-06-16', -29), payment_count, 0))         payment_last_30d_count,
                sum(if(dt >= date_add('2021-06-16', -29), payment_reduce_amount, 0)) payment_last_30d_reduce_amount,
                sum(if(dt >= date_add('2021-06-16', -29), payment_amount, 0))        payment_last_30d_amount,
                sum(payment_count)                                                   payment_count,
                sum(payment_reduce_amount)                                           payment_reduce_amount,
                sum(payment_amount)                                                  payment_amount,
                sum(if(dt = '2021-06-16', expire_count, 0))                          expire_last_1d_count,
                sum(if(dt >= date_add('2021-06-16', -6), expire_count, 0))           expire_last_7d_count,
                sum(if(dt >= date_add('2021-06-16', -29), expire_count, 0))          expire_last_30d_count,
                sum(expire_count)                                                    expire_count
         from dws_coupon_info_daycount
         group by coupon_id
     ) t2
     on t1.id = t2.coupon_id;
