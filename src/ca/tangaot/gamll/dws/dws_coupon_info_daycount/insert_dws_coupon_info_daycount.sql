-- 优惠券主题

USE gmall;

with
    tmp_cu as
        (
            select
                coupon_id,
                sum(if(date_format(get_time,'yyyy-MM-dd')='2021-06-17',1,0)) get_count,
                sum(if(date_format(using_time,'yyyy-MM-dd')='2021-06-17',1,0)) order_count,
                sum(if(date_format(used_time,'yyyy-MM-dd')='2021-06-17',1,0)) payment_count,
                sum(if(date_format(expire_time,'yyyy-MM-dd')='2021-06-17',1,0)) expire_count
            from dwd_coupon_use
            where dt='9999-99-99'
               or dt='2021-06-17'
            group by coupon_id
        ),
    tmp_order as
        (
            select
                coupon_id,
                sum(split_coupon_amount) order_reduce_amount,
                sum(original_amount) order_original_amount,
                sum(split_final_amount) order_final_amount
            from dwd_order_detail
            where dt='2021-06-17'
              and coupon_id is not null
            group by coupon_id
        ),
    tmp_pay as
        (
            select
                coupon_id,
                sum(split_coupon_amount) payment_reduce_amount,
                sum(split_final_amount) payment_amount
            from dwd_order_detail
            where (dt='2021-06-17'
                or dt=date_add('2021-06-17',-1))
              and coupon_id is not null
              and order_id in
                  (
                      select order_id from dwd_payment_info where dt='2021-06-17'
                  )
            group by coupon_id
        )
insert overwrite table dws_coupon_info_daycount partition(dt='2021-06-17')
select
    coupon_id,
    sum(get_count),
    sum(order_count),
    sum(order_reduce_amount),
    sum(order_original_amount),
    sum(order_final_amount),
    sum(payment_count),
    sum(payment_reduce_amount),
    sum(payment_amount),
    sum(expire_count)
from
    (
        select
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
        select
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
        select
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
    )t1
group by coupon_id;


