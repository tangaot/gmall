-- 订单事实表

USE gmall;

insert overwrite table dwd_order_info partition(dt)
select
    nvl(new.id,old.id),
    nvl(new.order_status,old.order_status),
    nvl(new.user_id,old.user_id),
    nvl(new.province_id,old.province_id),
    nvl(new.payment_way,old.payment_way),
    nvl(new.delivery_address,old.delivery_address),
    nvl(new.out_trade_no,old.out_trade_no),
    nvl(new.tracking_no,old.tracking_no),
    nvl(new.create_time,old.create_time),
    nvl(new.payment_time,old.payment_time),
    nvl(new.cancel_time,old.cancel_time),
    nvl(new.finish_time,old.finish_time),
    nvl(new.refund_time,old.refund_time),
    nvl(new.refund_finish_time,old.refund_finish_time),
    nvl(new.expire_time,old.expire_time),
    nvl(new.feight_fee,old.feight_fee),
    nvl(new.feight_fee_reduce,old.feight_fee_reduce),
    nvl(new.activity_reduce_amount,old.activity_reduce_amount),
    nvl(new.coupon_reduce_amount,old.coupon_reduce_amount),
    nvl(new.original_amount,old.original_amount),
    nvl(new.final_amount,old.final_amount),
    case
        when new.cancel_time is not null then date_format(new.cancel_time,'yyyy-MM-dd')
        when new.finish_time is not null and date_add(date_format(new.finish_time,'yyyy-MM-dd'),7)='2021-06-17' and new.refund_time is null then '2021-06-17'
        when new.refund_finish_time is not null then date_format(new.refund_finish_time,'yyyy-MM-dd')
        when new.expire_time is not null then date_format(new.expire_time,'yyyy-MM-dd')
        else '9999-99-99'
        end
from
    (
        select
            id,
            order_status,
            user_id,
            province_id,
            payment_way,
            delivery_address,
            out_trade_no,
            tracking_no,
            create_time,
            payment_time,
            cancel_time,
            finish_time,
            refund_time,
            refund_finish_time,
            expire_time,
            feight_fee,
            feight_fee_reduce,
            activity_reduce_amount,
            coupon_reduce_amount,
            original_amount,
            final_amount
        from dwd_order_info
        where dt='9999-99-99'
    )old
        full outer join
    (
        select
            oi.id,
            oi.order_status,
            oi.user_id,
            oi.province_id,
            oi.payment_way,
            oi.delivery_address,
            oi.out_trade_no,
            oi.tracking_no,
            oi.create_time,
            times.ts['1002'] payment_time,
            times.ts['1003'] cancel_time,
            times.ts['1004'] finish_time,
            times.ts['1005'] refund_time,
            times.ts['1006'] refund_finish_time,
            oi.expire_time,
            feight_fee,
            feight_fee_reduce,
            activity_reduce_amount,
            coupon_reduce_amount,
            original_amount,
            final_amount
        from
            (
                select
                    *
                from ods_order_info
                where dt='2021-06-17'
            )oi
                left join
            (
                select
                    order_id,
                    str_to_map(concat_ws(',',collect_set(concat(order_status,'=',operate_time))),',','=') ts
                from ods_order_status_log
                where dt='2021-06-17'
                group by order_id
            )times
            on oi.id=times.order_id
    )new
    on old.id=new.id;
