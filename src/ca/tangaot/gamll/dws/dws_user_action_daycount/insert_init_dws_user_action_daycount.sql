-- 用户主题

USE gmall;

set hive.exec.dynamic.partition.mode=nonstrict;

with tmp_login as
         (
             select dt,
                    user_id,
                    count(*) login_count
             from dwd_page_log
             where user_id is not null
               and last_page_id is null
             group by dt, user_id
         ),
     tmp_cf as
         (
             select dt,
                    user_id,
                    sum(if(action_id = 'cart_add', 1, 0))  cart_count,
                    sum(if(action_id = 'favor_add', 1, 0)) favor_count
             from dwd_action_log
             where user_id is not null
               and action_id in ('cart_add', 'favor_add')
             group by dt, user_id
         ),
     tmp_order as
         (
             select date_format(create_time, 'yyyy-MM-dd')    dt,
                    user_id,
                    count(*)                                  order_count,
                    sum(if(activity_reduce_amount > 0, 1, 0)) order_activity_count,
                    sum(if(coupon_reduce_amount > 0, 1, 0))   order_coupon_count,
                    sum(activity_reduce_amount)               order_activity_reduce_amount,
                    sum(coupon_reduce_amount)                 order_coupon_reduce_amount,
                    sum(original_amount)                      order_original_amount,
                    sum(final_amount)                         order_final_amount
             from dwd_order_info
             group by date_format(create_time, 'yyyy-MM-dd'), user_id
         ),
     tmp_pay as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    user_id,
                    count(*)                                 payment_count,
                    sum(payment_amount)                      payment_amount
             from dwd_payment_info
             group by date_format(callback_time, 'yyyy-MM-dd'), user_id
         ),
     tmp_ri as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    user_id,
                    count(*)                               refund_order_count,
                    sum(refund_num)                        refund_order_num,
                    sum(refund_amount)                     refund_order_amount
             from dwd_order_refund_info
             group by date_format(create_time, 'yyyy-MM-dd'), user_id
         ),
     tmp_rp as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    rp.user_id,
                    count(*)                                 refund_payment_count,
                    sum(ri.refund_num)                       refund_payment_num,
                    sum(rp.refund_amount)                    refund_payment_amount
             from (
                      select user_id,
                             order_id,
                             sku_id,
                             refund_amount,
                             callback_time
                      from dwd_refund_payment
                  ) rp
                      left join
                  (
                      select user_id,
                             order_id,
                             sku_id,
                             refund_num
                      from dwd_order_refund_info
                  ) ri
                  on rp.order_id = ri.order_id
                      and rp.sku_id = rp.sku_id
             group by date_format(callback_time, 'yyyy-MM-dd'), rp.user_id
         ),
     tmp_coupon as
         (
             select coalesce(coupon_get.dt, coupon_using.dt, coupon_used.dt)                dt,
                    coalesce(coupon_get.user_id, coupon_using.user_id, coupon_used.user_id) user_id,
                    nvl(coupon_get_count, 0)                                                coupon_get_count,
                    nvl(coupon_using_count, 0)                                              coupon_using_count,
                    nvl(coupon_used_count, 0)                                               coupon_used_count
             from (
                      select date_format(get_time, 'yyyy-MM-dd') dt,
                             user_id,
                             count(*)                            coupon_get_count
                      from dwd_coupon_use
                      where get_time is not null
                      group by user_id, date_format(get_time, 'yyyy-MM-dd')
                  ) coupon_get
                      full outer join
                  (
                      select date_format(using_time, 'yyyy-MM-dd') dt,
                             user_id,
                             count(*)                              coupon_using_count
                      from dwd_coupon_use
                      where using_time is not null
                      group by user_id, date_format(using_time, 'yyyy-MM-dd')
                  ) coupon_using
                  on coupon_get.dt = coupon_using.dt
                      and coupon_get.user_id = coupon_using.user_id
                      full outer join
                  (
                      select date_format(used_time, 'yyyy-MM-dd') dt,
                             user_id,
                             count(*)                             coupon_used_count
                      from dwd_coupon_use
                      where used_time is not null
                      group by user_id, date_format(used_time, 'yyyy-MM-dd')
                  ) coupon_used
                  on nvl(coupon_get.dt, coupon_using.dt) = coupon_used.dt
                      and nvl(coupon_get.user_id, coupon_using.user_id) = coupon_used.user_id
         ),
     tmp_comment as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    user_id,
                    sum(if(appraise = '1201', 1, 0))       appraise_good_count,
                    sum(if(appraise = '1202', 1, 0))       appraise_mid_count,
                    sum(if(appraise = '1203', 1, 0))       appraise_bad_count,
                    sum(if(appraise = '1204', 1, 0))       appraise_default_count
             from dwd_comment_info
             group by date_format(create_time, 'yyyy-MM-dd'), user_id
         ),
     tmp_od as
         (
             select dt,
                    user_id,
                    collect_set(named_struct('sku_id', sku_id, 'sku_num', sku_num, 'order_count', order_count,
                                             'activity_reduce_amount', activity_reduce_amount, 'coupon_reduce_amount',
                                             coupon_reduce_amount, 'original_amount', original_amount, 'final_amount',
                                             final_amount)) order_detail_stats
             from (
                      select date_format(create_time, 'yyyy-MM-dd')             dt,
                             user_id,
                             sku_id,
                             sum(sku_num)                                       sku_num,
                             count(*)                                           order_count,
                             cast(sum(split_activity_amount) as decimal(16, 2)) activity_reduce_amount,
                             cast(sum(split_coupon_amount) as decimal(16, 2))   coupon_reduce_amount,
                             cast(sum(original_amount) as decimal(16, 2))       original_amount,
                             cast(sum(split_final_amount) as decimal(16, 2))    final_amount
                      from dwd_order_detail
                      group by date_format(create_time, 'yyyy-MM-dd'), user_id, sku_id
                  ) t1
             group by dt, user_id
         )
insert
overwrite
table
dws_user_action_daycount
partition
(
dt
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
       order_detail_stats,
       coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt, tmp_ri.dt, tmp_rp.dt, tmp_comment.dt, tmp_coupon.dt,
                tmp_od.dt)
from tmp_login
         full outer join tmp_cf
                         on tmp_login.user_id = tmp_cf.user_id
                             and tmp_login.dt = tmp_cf.dt
         full outer join tmp_order
                         on coalesce(tmp_login.user_id, tmp_cf.user_id) = tmp_order.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt) = tmp_order.dt
         full outer join tmp_pay
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id) = tmp_pay.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt) = tmp_pay.dt
         full outer join tmp_ri
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id) =
                            tmp_ri.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt) = tmp_ri.dt
         full outer join tmp_rp
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                     tmp_ri.user_id) = tmp_rp.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt, tmp_ri.dt) = tmp_rp.dt
         full outer join tmp_comment
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                     tmp_ri.user_id, tmp_rp.user_id) = tmp_comment.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt, tmp_ri.dt, tmp_rp.dt) =
                                 tmp_comment.dt
         full outer join tmp_coupon
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                     tmp_ri.user_id, tmp_rp.user_id, tmp_comment.user_id) = tmp_coupon.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt, tmp_ri.dt, tmp_rp.dt,
                                          tmp_comment.dt) = tmp_coupon.dt
         full outer join tmp_od
                         on coalesce(tmp_login.user_id, tmp_cf.user_id, tmp_order.user_id, tmp_pay.user_id,
                                     tmp_ri.user_id, tmp_rp.user_id, tmp_comment.user_id, tmp_coupon.user_id) =
                            tmp_od.user_id
                             and coalesce(tmp_login.dt, tmp_cf.dt, tmp_order.dt, tmp_pay.dt, tmp_ri.dt, tmp_rp.dt,
                                          tmp_comment.dt, tmp_coupon.dt) = tmp_od.dt;
