-- 地区主题

USE gmall;

insert overwrite table dwt_area_topic partition (dt = '2021-06-17')
select nvl(old.province_id, 1d_ago.province_id),
       nvl(1d_ago.visit_count, 0),
       nvl(1d_ago.login_count, 0),
       nvl(old.visit_last_7d_count, 0) + nvl(1d_ago.visit_count, 0) - nvl(7d_ago.visit_count, 0),
       nvl(old.login_last_7d_count, 0) + nvl(1d_ago.login_count, 0) - nvl(7d_ago.login_count, 0),
       nvl(old.visit_last_30d_count, 0) + nvl(1d_ago.visit_count, 0) - nvl(30d_ago.visit_count, 0),
       nvl(old.login_last_30d_count, 0) + nvl(1d_ago.login_count, 0) - nvl(30d_ago.login_count, 0),
       nvl(old.visit_count, 0) + nvl(1d_ago.visit_count, 0),
       nvl(old.login_count, 0) + nvl(1d_ago.login_count, 0),
       nvl(1d_ago.order_count, 0),
       nvl(1d_ago.order_original_amount, 0.0),
       nvl(1d_ago.order_final_amount, 0.0),
       nvl(old.order_last_7d_count, 0) + nvl(1d_ago.order_count, 0) - nvl(7d_ago.order_count, 0),
       nvl(old.order_last_7d_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0) -
       nvl(7d_ago.order_original_amount, 0.0),
       nvl(old.order_last_7d_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0) -
       nvl(7d_ago.order_final_amount, 0.0),
       nvl(old.order_last_30d_count, 0) + nvl(1d_ago.order_count, 0) - nvl(30d_ago.order_count, 0),
       nvl(old.order_last_30d_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0) -
       nvl(30d_ago.order_original_amount, 0.0),
       nvl(old.order_last_30d_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0) -
       nvl(30d_ago.order_final_amount, 0.0),
       nvl(old.order_count, 0) + nvl(1d_ago.order_count, 0),
       nvl(old.order_original_amount, 0.0) + nvl(1d_ago.order_original_amount, 0.0),
       nvl(old.order_final_amount, 0.0) + nvl(1d_ago.order_final_amount, 0.0),
       nvl(1d_ago.payment_count, 0),
       nvl(1d_ago.payment_amount, 0.0),
       nvl(old.payment_last_7d_count, 0) + nvl(1d_ago.payment_count, 0) - nvl(7d_ago.payment_count, 0),
       nvl(old.payment_last_7d_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0) - nvl(7d_ago.payment_amount, 0.0),
       nvl(old.payment_last_30d_count, 0) + nvl(1d_ago.payment_count, 0) - nvl(30d_ago.payment_count, 0),
       nvl(old.payment_last_30d_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0) - nvl(30d_ago.payment_amount, 0.0),
       nvl(old.payment_count, 0) + nvl(1d_ago.payment_count, 0),
       nvl(old.payment_amount, 0.0) + nvl(1d_ago.payment_amount, 0.0),
       nvl(1d_ago.refund_order_count, 0),
       nvl(1d_ago.refund_order_amount, 0.0),
       nvl(old.refund_order_last_7d_count, 0) + nvl(1d_ago.refund_order_count, 0) - nvl(7d_ago.refund_order_count, 0),
       nvl(old.refund_order_last_7d_amount, 0.0) + nvl(1d_ago.refund_order_amount, 0.0) -
       nvl(7d_ago.refund_order_amount, 0.0),
       nvl(old.refund_order_last_30d_count, 0) + nvl(1d_ago.refund_order_count, 0) - nvl(30d_ago.refund_order_count, 0),
       nvl(old.refund_order_last_30d_amount, 0.0) + nvl(1d_ago.refund_order_amount, 0.0) -
       nvl(30d_ago.refund_order_amount, 0.0),
       nvl(old.refund_order_count, 0) + nvl(1d_ago.refund_order_count, 0),
       nvl(old.refund_order_amount, 0.0) + nvl(1d_ago.refund_order_amount, 0.0),
       nvl(1d_ago.refund_payment_count, 0),
       nvl(1d_ago.refund_payment_amount, 0.0),
       nvl(old.refund_payment_last_7d_count, 0) + nvl(1d_ago.refund_payment_count, 0) -
       nvl(7d_ago.refund_payment_count, 0),
       nvl(old.refund_payment_last_7d_amount, 0.0) + nvl(1d_ago.refund_payment_amount, 0.0) -
       nvl(7d_ago.refund_payment_amount, 0.0),
       nvl(old.refund_payment_last_30d_count, 0) + nvl(1d_ago.refund_payment_count, 0) -
       nvl(30d_ago.refund_payment_count, 0),
       nvl(old.refund_payment_last_30d_amount, 0.0) + nvl(1d_ago.refund_payment_amount, 0.0) -
       nvl(30d_ago.refund_payment_amount, 0.0),
       nvl(old.refund_payment_count, 0) + nvl(1d_ago.refund_payment_count, 0),
       nvl(old.refund_payment_amount, 0.0) + nvl(1d_ago.refund_payment_amount, 0.0)

from (
         select province_id,
                visit_last_1d_count,
                login_last_1d_count,
                visit_last_7d_count,
                login_last_7d_count,
                visit_last_30d_count,
                login_last_30d_count,
                visit_count,
                login_count,
                order_last_1d_count,
                order_last_1d_original_amount,
                order_last_1d_final_amount,
                order_last_7d_count,
                order_last_7d_original_amount,
                order_last_7d_final_amount,
                order_last_30d_count,
                order_last_30d_original_amount,
                order_last_30d_final_amount,
                order_count,
                order_original_amount,
                order_final_amount,
                payment_last_1d_count,
                payment_last_1d_amount,
                payment_last_7d_count,
                payment_last_7d_amount,
                payment_last_30d_count,
                payment_last_30d_amount,
                payment_count,
                payment_amount,
                refund_order_last_1d_count,
                refund_order_last_1d_amount,
                refund_order_last_7d_count,
                refund_order_last_7d_amount,
                refund_order_last_30d_count,
                refund_order_last_30d_amount,
                refund_order_count,
                refund_order_amount,
                refund_payment_last_1d_count,
                refund_payment_last_1d_amount,
                refund_payment_last_7d_count,
                refund_payment_last_7d_amount,
                refund_payment_last_30d_count,
                refund_payment_last_30d_amount,
                refund_payment_count,
                refund_payment_amount
         from dwt_area_topic
         where dt = date_add('2021-06-17', -1)
     ) old
         full outer join
     (
         select province_id,
                visit_count,
                login_count,
                order_count,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_amount,
                refund_order_count,
                refund_order_amount,
                refund_payment_count,
                refund_payment_amount
         from dws_area_stats_daycount
         where dt = '2021-06-17'
     ) 1d_ago
     on old.province_id = 1d_ago.province_id
         left join
     (
         select province_id,
                visit_count,
                login_count,
                order_count,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_amount,
                refund_order_count,
                refund_order_amount,
                refund_payment_count,
                refund_payment_amount
         from dws_area_stats_daycount
         where dt = date_add('2021-06-17', -7)
     ) 7d_ago
     on old.province_id = 7d_ago.province_id
         left join
     (
         select province_id,
                visit_count,
                login_count,
                order_count,
                order_original_amount,
                order_final_amount,
                payment_count,
                payment_amount,
                refund_order_count,
                refund_order_amount,
                refund_payment_count,
                refund_payment_amount
         from dws_area_stats_daycount
         where dt = date_add('2021-06-17', -30)
     ) 30d_ago
     on old.province_id = 30d_ago.province_id;
