-- 优惠券主题

USE gmall;

with tmp_cu as
         (
             select coalesce(coupon_get.dt, coupon_using.dt, coupon_used.dt, coupon_exprie.dt) dt,
                    coalesce(coupon_get.coupon_id, coupon_using.coupon_id, coupon_used.coupon_id,
                             coupon_exprie.coupon_id)                                          coupon_id,
                    nvl(get_count, 0)                                                          get_count,
                    nvl(order_count, 0)                                                        order_count,
                    nvl(payment_count, 0)                                                      payment_count,
                    nvl(expire_count, 0)                                                       expire_count
             from (
                      select date_format(get_time, 'yyyy-MM-dd') dt,
                             coupon_id,
                             count(*)                            get_count
                      from dwd_coupon_use
                      group by date_format(get_time, 'yyyy-MM-dd'), coupon_id
                  ) coupon_get
                      full outer join
                  (
                      select date_format(using_time, 'yyyy-MM-dd') dt,
                             coupon_id,
                             count(*)                              order_count
                      from dwd_coupon_use
                      where using_time is not null
                      group by date_format(using_time, 'yyyy-MM-dd'), coupon_id
                  ) coupon_using
                  on coupon_get.dt = coupon_using.dt
                      and coupon_get.coupon_id = coupon_using.coupon_id
                      full outer join
                  (
                      select date_format(used_time, 'yyyy-MM-dd') dt,
                             coupon_id,
                             count(*)                             payment_count
                      from dwd_coupon_use
                      where used_time is not null
                      group by date_format(used_time, 'yyyy-MM-dd'), coupon_id
                  ) coupon_used
                  on nvl(coupon_get.dt, coupon_using.dt) = coupon_used.dt
                      and nvl(coupon_get.coupon_id, coupon_using.coupon_id) = coupon_used.coupon_id
                      full outer join
                  (
                      select date_format(expire_time, 'yyyy-MM-dd') dt,
                             coupon_id,
                             count(*)                               expire_count
                      from dwd_coupon_use
                      where expire_time is not null
                      group by date_format(expire_time, 'yyyy-MM-dd'), coupon_id
                  ) coupon_exprie
                  on coalesce(coupon_get.dt, coupon_using.dt, coupon_used.dt) = coupon_exprie.dt
                      and coalesce(coupon_get.coupon_id, coupon_using.coupon_id, coupon_used.coupon_id) =
                          coupon_exprie.coupon_id
         ),
     tmp_order as
         (
             select date_format(create_time, 'yyyy-MM-dd') dt,
                    coupon_id,
                    sum(split_coupon_amount)               order_reduce_amount,
                    sum(original_amount)                   order_original_amount,
                    sum(split_final_amount)                order_final_amount
             from dwd_order_detail
             where coupon_id is not null
             group by date_format(create_time, 'yyyy-MM-dd'), coupon_id
         ),
     tmp_pay as
         (
             select date_format(callback_time, 'yyyy-MM-dd') dt,
                    coupon_id,
                    sum(split_coupon_amount)                 payment_reduce_amount,
                    sum(split_final_amount)                  payment_amount
             from (
                      select order_id,
                             coupon_id,
                             split_coupon_amount,
                             split_final_amount
                      from dwd_order_detail
                      where coupon_id is not null
                  ) od
                      join
                  (
                      select order_id,
                             callback_time
                      from dwd_payment_info
                  ) pi
                  on od.order_id = pi.order_id
             group by date_format(callback_time, 'yyyy-MM-dd'), coupon_id
         )
insert
overwrite
table
dws_coupon_info_daycount
partition
(
dt
)
select coupon_id,
       sum(get_count),
       sum(order_count),
       sum(order_reduce_amount),
       sum(order_original_amount),
       sum(order_final_amount),
       sum(payment_count),
       sum(payment_reduce_amount),
       sum(payment_amount),
       sum(expire_count),
       dt
from (
         select dt,
                coupon_id,
                get_count,
                order_count,
                0 order_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                payment_count,
                0 payment_reduce_amount,
                0 payment_amount,
                expire_count
         from tmp_cu
         union all
         select dt,
                coupon_id,
                0 get_count,
                0 order_count,
                order_reduce_amount,
                order_original_amount,
                order_final_amount,
                0 payment_count,
                0 payment_reduce_amount,
                0 payment_amount,
                0 expire_count
         from tmp_order
         union all
         select dt,
                coupon_id,
                0 get_count,
                0 order_count,
                0 order_reduce_amount,
                0 order_original_amount,
                0 order_final_amount,
                0 payment_count,
                payment_reduce_amount,
                payment_amount,
                0 expire_count
         from tmp_pay
     ) t1
group by dt, coupon_id;


