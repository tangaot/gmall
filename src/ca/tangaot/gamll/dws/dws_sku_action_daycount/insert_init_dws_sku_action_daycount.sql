-- 商品主题

USE gmall;

with tmp_order as
         (
             select date_format(create_time, 'yyyy-MM-dd')   dt,
                    sku_id,
                    count(*)                                 order_count,
                    sum(sku_num)                             order_num,
                    sum(if(split_activity_amount > 0, 1, 0)) order_activity_count,
                    sum(if(split_coupon_amount > 0, 1, 0))   order_coupon_count,
                    sum(split_activity_amount)               order_activity_reduce_amount,
                    sum(split_coupon_amount)                 order_coupon_reduce_amount,
                    sum(original_amount)                     order_original_amount,
                    sum(split_final_amount)                  order_final_amount
             from dwd_order_detail
             group by date_format(create_time, 'yyyy-MM-dd'), sku_id
         ),
     tmp_pay as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    sku_id,
                    count(*)                                 payment_count,
                    sum(sku_num)                             payment_num,
                    sum(split_final_amount)                  payment_amount
             from dwd_order_detail od
                      join
                  (
                      select order_id,
                             callback_time
                      from dwd_payment_info
                      where callback_time is not null
                  ) pi on pi.order_id = od.order_id
             group by date_format(callback_time, 'yyyy-MM-dd'), sku_id
         ),
     tmp_ri as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    sku_id,
                    count(*)                               refund_order_count,
                    sum(refund_num)                        refund_order_num,
                    sum(refund_amount)                     refund_order_amount
             from dwd_order_refund_info
             group by date_format(create_time, 'yyyy-MM-dd'), sku_id
         ),
     tmp_rp as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    rp.sku_id,
                    count(*)                                 refund_payment_count,
                    sum(ri.refund_num)                       refund_payment_num,
                    sum(refund_amount)                       refund_payment_amount
             from (
                      select order_id,
                             sku_id,
                             refund_amount,
                             callback_time
                      from dwd_refund_payment
                  ) rp
                      left join
                  (
                      select order_id,
                             sku_id,
                             refund_num
                      from dwd_order_refund_info
                  ) ri
                  on rp.order_id = ri.order_id
                      and rp.sku_id = ri.sku_id
             group by date_format(callback_time, 'yyyy-MM-dd'), rp.sku_id
         ),
     tmp_cf as
         (
             select dt,
                    item                                   sku_id,
                    sum(if(action_id = 'cart_add', 1, 0))  cart_count,
                    sum(if(action_id = 'favor_add', 1, 0)) favor_count
             from dwd_action_log
             where action_id in ('cart_add', 'favor_add')
             group by dt, item
         ),
     tmp_comment as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    sku_id,
                    sum(if(appraise = '1201', 1, 0))       appraise_good_count,
                    sum(if(appraise = '1202', 1, 0))       appraise_mid_count,
                    sum(if(appraise = '1203', 1, 0))       appraise_bad_count,
                    sum(if(appraise = '1204', 1, 0))       appraise_default_count
             from dwd_comment_info
             group by date_format(create_time, 'yyyy-MM-dd'), sku_id
         )
insert
overwrite
table
dws_sku_action_daycount
partition
(
dt
)
select sku_id,
       sum(order_count),
       sum(order_num),
       sum(order_activity_count),
       sum(order_coupon_count),
       sum(order_activity_reduce_amount),
       sum(order_coupon_reduce_amount),
       sum(order_original_amount),
       sum(order_final_amount),
       sum(payment_count),
       sum(payment_num),
       sum(payment_amount),
       sum(refund_order_count),
       sum(refund_order_num),
       sum(refund_order_amount),
       sum(refund_payment_count),
       sum(refund_payment_num),
       sum(refund_payment_amount),
       sum(cart_count),
       sum(favor_count),
       sum(appraise_good_count),
       sum(appraise_mid_count),
       sum(appraise_bad_count),
       sum(appraise_default_count),
       dt
from (
         select dt,
                sku_id,
                order_count,
                order_num,
                order_activity_count,
                order_coupon_count,
                order_activity_reduce_amount,
                order_coupon_reduce_amount,
                order_original_amount,
                order_final_amount,
                0 payment_count,
                0 payment_num,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_num,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_num,
                0 refund_payment_amount,
                0 cart_count,
                0 favor_count,
                0 appraise_good_count,
                0 appraise_mid_count,
                0 appraise_bad_count,
                0 appraise_default_count
         from tmp_order
         union all
         select dt,
                sku_id,
                0 order_count,
                0 order_num,
                0 order_activity_count,
                0 order_coupon_count,
                0 order_activity_reduce_amount,
                0 order_coupon_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                payment_count,
                payment_num,
                payment_amount,
                0 refund_order_count,
                0 refund_order_num,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_num,
                0 refund_payment_amount,
                0 cart_count,
                0 favor_count,
                0 appraise_good_count,
                0 appraise_mid_count,
                0 appraise_bad_count,
                0 appraise_default_count
         from tmp_pay
         union all
         select dt,
                sku_id,
                0 order_count,
                0 order_num,
                0 order_activity_count,
                0 order_coupon_count,
                0 order_activity_reduce_amount,
                0 order_coupon_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_num,
                0 payment_amount,
                refund_order_count,
                refund_order_num,
                refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_num,
                0 refund_payment_amount,
                0 cart_count,
                0 favor_count,
                0 appraise_good_count,
                0 appraise_mid_count,
                0 appraise_bad_count,
                0 appraise_default_count
         from tmp_ri
         union all
         select dt,
                sku_id,
                0 order_count,
                0 order_num,
                0 order_activity_count,
                0 order_coupon_count,
                0 order_activity_reduce_amount,
                0 order_coupon_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_num,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_num,
                0 refund_order_amount,
                refund_payment_count,
                refund_payment_num,
                refund_payment_amount,
                0 cart_count,
                0 favor_count,
                0 appraise_good_count,
                0 appraise_mid_count,
                0 appraise_bad_count,
                0 appraise_default_count
         from tmp_rp
         union all
         select dt,
                sku_id,
                0 order_count,
                0 order_num,
                0 order_activity_count,
                0 order_coupon_count,
                0 order_activity_reduce_amount,
                0 order_coupon_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_num,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_num,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_num,
                0 refund_payment_amount,
                cart_count,
                favor_count,
                0 appraise_good_count,
                0 appraise_mid_count,
                0 appraise_bad_count,
                0 appraise_default_count
         from tmp_cf
         union all
         select dt,
                sku_id,
                0 order_count,
                0 order_num,
                0 order_activity_count,
                0 order_coupon_count,
                0 order_activity_reduce_amount,
                0 order_coupon_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                0 payment_num,
                0 payment_amount,
                0 refund_order_count,
                0 refund_order_num,
                0 refund_order_amount,
                0 refund_payment_count,
                0 refund_payment_num,
                0 refund_payment_amount,
                0 cart_count,
                0 favor_count,
                appraise_good_count,
                appraise_mid_count,
                appraise_bad_count,
                appraise_default_count
         from tmp_comment
     ) t1
group by dt, sku_id;
