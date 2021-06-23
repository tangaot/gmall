-- 优惠券主题

USE gmall;

insert overwrite table dwt_coupon_topic partition (dt = '2021-06-17')
select nvl(1d_ago.coupon_id, old.coupon_id),
       nvl(1d_ago.get_count, 0),
       nvl(old.get_last_7d_count, 0) + nvl(1d_ago.get_count, 0) - nvl(7d_ago.get_count, 0),
       nvl(old.get_last_30d_count, 0) + nvl(1d_ago.get_count, 0) - nvl(30d_ago.get_count, 0),
       nvl(old.get_count, 0) + nvl(1d_ago.get_count, 0),
       nvl(1d_ago.order_count, 0),
       nvl(1d_ago.order_reduce_amount, 0.0),
       nvl(1d_ago.order_original_amount, 0.0),
       nvl(1d_ago.order_final_amount, 0.0),
       nvl(old.order_last_7d_count, 0) + nvl(1d_ago.order_count, 0) - nvl(7d_ago.order_count, 0),
       nvl(old.order_last_7d_reduce_amount, 0.0) + nvl(1d_ago.order_reduce_amount, 0.0) -
       nvl(7d_ago.order_reduce_amount, 0.0),
       nvl(old.order_last_7d_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0) -
       nvl(7d_ago.order_original_amount, 0.0),
       nvl(old.order_last_7d_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0) -
       nvl(7d_ago.order_final_amount, 0.0),
       nvl(old.order_last_30d_count, 0) + nvl(1d_ago.order_count, 0) - nvl(30d_ago.order_count, 0),
       nvl(old.order_last_30d_reduce_amount, 0.0) + nvl(1d_ago.order_reduce_amount, 0.0) -
       nvl(30d_ago.order_reduce_amount, 0.0),
       nvl(old.order_last_30d_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0) -
       nvl(30d_ago.order_original_amount, 0.0),
       nvl(old.order_last_30d_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0) -
       nvl(30d_ago.order_final_amount, 0.0),
       nvl(old.order_count, 0) + nvl(1d_ago.order_count, 0),
       nvl(old.order_reduce_amount, 0.0) + nvl(1d_ago.order_reduce_amount, 0.0),
       nvl(old.order_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0),
       nvl(old.order_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0),
       nvl(old.payment_last_1d_count, 0) + nvl(1d_ago.payment_count, 0) - nvl(1d_ago.payment_count, 0),
       nvl(old.payment_last_1d_reduce_amount, 0.0) + nvl(1d_ago.payment_reduce_amount, 0.0) -
       nvl(1d_ago.payment_reduce_amount, 0.0),
       nvl(old.payment_last_1d_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0) - nvl(1d_ago.payment_amount, 0.0),
       nvl(old.payment_last_7d_count, 0) + nvl(1d_ago.payment_count, 0) - nvl(7d_ago.payment_count, 0),
       nvl(old.payment_last_7d_reduce_amount, 0.0) + nvl(1d_ago.payment_reduce_amount, 0.0) -
       nvl(7d_ago.payment_reduce_amount, 0.0),
       nvl(old.payment_last_7d_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0) - nvl(7d_ago.payment_amount, 0.0),
       nvl(old.payment_last_30d_count, 0) + nvl(1d_ago.payment_count, 0) - nvl(30d_ago.payment_count, 0),
       nvl(old.payment_last_30d_reduce_amount, 0.0) + nvl(1d_ago.payment_reduce_amount, 0.0) -
       nvl(30d_ago.payment_reduce_amount, 0.0),
       nvl(old.payment_last_30d_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0) - nvl(30d_ago.payment_amount, 0.0),
       nvl(old.payment_count, 0) + nvl(1d_ago.payment_count, 0),
       nvl(old.payment_reduce_amount, 0.0) + nvl(1d_ago.payment_reduce_amount, 0.0),
       nvl(old.payment_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0),
       nvl(1d_ago.expire_count, 0),
       nvl(old.expire_last_7d_count, 0) + nvl(1d_ago.expire_count, 0) - nvl(7d_ago.expire_count, 0),
       nvl(old.expire_last_30d_count, 0) + nvl(1d_ago.expire_count, 0) - nvl(30d_ago.expire_count, 0),
       nvl(old.expire_count, 0) + nvl(1d_ago.expire_count, 0)
from (
         select coupon_id,
                get_last_1d_count,
                get_last_7d_count,
                get_last_30d_count,
                get_count,
                order_last_1d_count,
                order_last_1d_reduce_amount,
                order_last_1d_original_amount,
                order_last_1d_final_amount,
                order_last_7d_count,
                order_last_7d_reduce_amount,
                order_last_7d_original_amount,
                order_last_7d_final_amount,
                order_last_30d_count,
                order_last_30d_reduce_amount,
                order_last_30d_original_amount,
                order_last_30d_final_amount,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_last_1d_count,
                payment_last_1d_reduce_amount,
                payment_last_1d_amount,
                payment_last_7d_count,
                payment_last_7d_reduce_amount,
                payment_last_7d_amount,
                payment_last_30d_count,
                payment_last_30d_reduce_amount,
                payment_last_30d_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount,
                expire_last_1d_count,
                expire_last_7d_count,
                expire_last_30d_count,
                expire_count
         from dwt_coupon_topic
         where dt = date_add('2021-06-17', -1)
     ) old
         full outer join
     (
         select coupon_id,
                get_count,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount,
                expire_count
         from dws_coupon_info_daycount
         where dt = '2021-06-17'
     ) 1d_ago
     on old.coupon_id = 1d_ago.coupon_id
         left join
     (
         select coupon_id,
                get_count,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount,
                expire_count
         from dws_coupon_info_daycount
         where dt = date_add('2021-06-17', -7)
     ) 7d_ago
     on old.coupon_id = 7d_ago.coupon_id
         left join
     (
         select coupon_id,
                get_count,
                order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_reduce_amount,
                payment_amount,
                expire_count
         from dws_coupon_info_daycount
         where dt = date_add('2021-06-17', -30)
     ) 30d_ago
     on old.coupon_id = 30d_ago.coupon_id;
