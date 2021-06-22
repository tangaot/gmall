-- 用户主题

USE gmall;

with tmp_login as
         (
             select user_id,
                    count(*) login_count
             from dwd_page_log
             where dt = '2021-06-17'
               and user_id is not null
               and last_page_id is null
             group by user_id
         ),
     tmp_cf as
         (
             select user_id,
                    sum(if(action_id = 'cart_add', 1, 0))  cart_count,
                    sum(if(action_id = 'favor_add', 1, 0)) favor_count
             from dwd_action_log
             where dt = '2021-06-17'
               and user_id is not null
               and action_id in ('cart_add', 'favor_add')
             group by user_id
         ),
     tmp_order as
         (
             select user_id,
                    count(*)                                  order_count,
                    sum(if(activity_reduce_amount > 0, 1, 0)) order_activity_count,
                    sum(if(coupon_reduce_amount > 0, 1, 0))   order_coupon_count,
                    sum(activity_reduce_amount)               order_activity_reduce_amount,
                    sum(coupon_reduce_amount)                 order_coupon_reduce_amount,
                    sum(original_amount)                      order_original_amount,
                    sum(final_amount)                         order_final_amount
             from dwd_order_info
             where (dt = '2021-06-17'
                 or dt = '9999-99-99')
               and date_format(create_time, 'yyyy-MM-dd') = '2021-06-17'
             group by user_id
         ),
     tmp_pay as
         (
             select user_id,
                    count(*)            payment_count,
                    sum(payment_amount) payment_amount
             from dwd_payment_info
             where dt = '2021-06-17'
             group by user_id
         ),
     tmp_ri as
         (
             select user_id,
                    count(*)           refund_order_count,
                    sum(refund_num)    refund_order_num,
                    sum(refund_amount) refund_order_amount
             from dwd_order_refund_info
             where dt = '2021-06-17'
             group by user_id
         ),
     tmp_rp as
         (
             select rp.user_id,
                    count(*)              refund_payment_count,
                    sum(ri.refund_num)    refund_payment_num,
                    sum(rp.refund_amount) refund_payment_amount
             from (
                      select user_id,
                             order_id,
                             sku_id,
                             refund_amount
                      from dwd_refund_payment
                      where dt = '2021-06-17'
                  ) rp
                      left join
                  (
                      select user_id,
                             order_id,
                             sku_id,
                             refund_num
                      from dwd_order_refund_info
                      where dt >= date_add('2021-06-17', -15)
                  ) ri
                  on rp.order_id = ri.order_id
                      and rp.sku_id = rp.sku_id
             group by rp.user_id
         ),
     tmp_coupon as
         (
             select user_id,
                    sum(if(date_format(get_time, 'yyyy-MM-dd') = '2021-06-17', 1, 0))   coupon_get_count,
                    sum(if(date_format(using_time, 'yyyy-MM-dd') = '2021-06-17', 1, 0)) coupon_using_count,
                    sum(if(date_format(used_time, 'yyyy-MM-dd') = '2021-06-17', 1, 0))  coupon_used_count
             from dwd_coupon_use
             where (dt = '2021-06-17' or dt = '9999-99-99')
               and (date_format(get_time, 'yyyy-MM-dd') = '2021-06-17'
                 or date_format(using_time, 'yyyy-MM-dd') = '2021-06-17'
                 or date_format(used_time, 'yyyy-MM-dd') = '2021-06-17')
             group by user_id
         ),
     tmp_comment as
         (
             select user_id,
                    sum(if(appraise = '1201', 1, 0)) appraise_good_count,
                    sum(if(appraise = '1202', 1, 0)) appraise_mid_count,
                    sum(if(appraise = '1203', 1, 0)) appraise_bad_count,
                    sum(if(appraise = '1204', 1, 0)) appraise_default_count
             from dwd_comment_info
             where dt = '2021-06-17'
             group by user_id
         ),
     tmp_od as
         (
             select user_id,
                    collect_set(named_struct('sku_id', sku_id, 'sku_num', sku_num, 'order_count', order_count,
                                             'activity_reduce_amount', activity_reduce_amount, 'coupon_reduce_amount',
                                             coupon_reduce_amount, 'original_amount', original_amount, 'final_amount',
                                             final_amount)) order_detail_stats
             from (
                      select user_id,
                             sku_id,
                             sum(sku_num)                                       sku_num,
                             count(*)                                           order_count,
                             cast(sum(split_activity_amount) as decimal(16, 2)) activity_reduce_amount,
                             cast(sum(split_coupon_amount) as decimal(16, 2))   coupon_reduce_amount,
                             cast(sum(original_amount) as decimal(16, 2))       original_amount,
                             cast(sum(split_final_amount) as decimal(16, 2))    final_amount
                      from dwd_order_detail
                      where dt = '2021-06-17'
                      group by user_id, sku_id
                  ) t1
             group by user_id
         )
insert
overwrite
table
dws_user_action_daycount
partition
(
dt = '2021-06-17'
)
select coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id, tmp_ri.user_id, tmp_rp.user_id,
                tmp_comment.user_id, tmp_coupon.user_id, tmp_od.user_id),
       nvl(login_count, 0),
       nvl(cart_count, 0),
       nvl(favor_count, 0),
       nvl(order_count, 0),
       nvl(order_activity_count, 0),
       nvl(order_activity_reduce_amount, 0),
       nvl(order_coupon_count, 0),
       nvl(order_coupon_reduce_amount, 0),
       nvl(order_original_amount, 0),
       nvl(order_final_amount, 0),
       nvl(payment_count, 0),
       nvl(payment_amount, 0),
       nvl(refund_order_count, 0),
       nvl(refund_order_num, 0),
       nvl(refund_order_amount, 0),
       nvl(refund_payment_count, 0),
       nvl(refund_payment_num, 0),
       nvl(refund_payment_amount, 0),
       nvl(coupon_get_count, 0),
       nvl(coupon_using_count, 0),
       nvl(coupon_used_count, 0),
       nvl(appraise_good_count, 0),
       nvl(appraise_mid_count, 0),
       nvl(appraise_bad_count, 0),
       nvl(appraise_default_count, 0),
       order_detail_stats
from tmp_login
         full outer join tmp_cf on tmp_login.user_id = tmp_cf.user_id
         full outer join tmp_order on coalesce(tmp_login.user_id, tmp_cf.user_id) = tmp_order.user_id
         full outer join tmp_pay on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id) = tmp_pay.user_id
         full outer join tmp_ri on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id) =
                                   tmp_ri.user_id
         full outer join tmp_rp on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                            tmp_ri.user_id) = tmp_rp.user_id
         full outer join tmp_comment on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                                 tmp_ri.user_id, tmp_rp.user_id) = tmp_comment.user_id
         full outer join tmp_coupon on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                                tmp_ri.user_id, tmp_rp.user_id, tmp_comment.user_id) =
                                       tmp_coupon.user_id
         full outer join tmp_od on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                            tmp_ri.user_id, tmp_rp.user_id, tmp_comment.user_id, tmp_coupon.user_id) =
                                   tmp_od.user_id;
