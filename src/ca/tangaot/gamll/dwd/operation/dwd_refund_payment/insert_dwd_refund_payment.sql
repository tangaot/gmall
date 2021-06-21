-- 退款事实表

USE gmall;

insert overwrite table dwd_refund_payment partition (dt)
select nvl(new.id, old.id),
       nvl(new.user_id, old.user_id),
       nvl(new.order_id, old.order_id),
       nvl(new.sku_id, old.sku_id),
       nvl(new.province_id, old.province_id),
       nvl(new.trade_no, old.trade_no),
       nvl(new.out_trade_no, old.out_trade_no),
       nvl(new.payment_type, old.payment_type),
       nvl(new.refund_amount, old.refund_amount),
       nvl(new.refund_status, old.refund_status),
       nvl(new.create_time, old.create_time),
       nvl(new.callback_time, old.callback_time),
       nvl(date_format(nvl(new.callback_time, old.callback_time), 'yyyy-MM-dd'), '9999-99-99')
from (
         select id,
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
                callback_time
         from dwd_refund_payment
         where dt = '9999-99-99'
     ) old
         full outer join
     (
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
                callback_time
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
                  where dt = '2021-06-17'
              ) rp
                  left join
              (
                  select id,
                         user_id,
                         province_id
                  from ods_order_info
                  where dt = '2021-06-17'
              ) oi
              on rp.order_id = oi.id
     ) new
     on old.id = new.id;
