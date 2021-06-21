-- 退款事实表

USE gmall;

insert overwrite table dwd_refund_payment partition (dt)
select rp.id,
       user_id,
       order_id,
       sku_id,
       province_id,
       trade_no,
       out_trade_no,
       payment_type,
       refund_amount,
       refund_status,
       create_time,
       callback_time,
       nvl(date_format(callback_time, 'yyyy-MM-dd'), '9999-99-99')
from (
         select id,
                out_trade_no,
                order_id,
                sku_id,
                payment_type,
                trade_no,
                refund_amount,
                refund_status,
                create_time,
                callback_time
         from ods_refund_payment
         where dt = '2021-06-16'
     ) rp
         left join
     (
         select id,
                user_id,
                province_id
         from ods_order_info
         where dt = '2021-06-16'
     ) oi
     on rp.order_id = oi.id;
