-- 支付事实表

USE gmall;

insert overwrite table dwd_payment_info partition (dt)
select nvl(new.id, old.id),
       nvl(new.order_id, old.order_id),
       nvl(new.user_id, old.user_id),
       nvl(new.province_id, old.province_id),
       nvl(new.trade_no, old.trade_no),
       nvl(new.out_trade_no, old.out_trade_no),
       nvl(new.payment_type, old.payment_type),
       nvl(new.payment_amount, old.payment_amount),
       nvl(new.payment_status, old.payment_status),
       nvl(new.create_time, old.create_time),
       nvl(new.callback_time, old.callback_time),
       nvl(date_format(nvl(new.callback_time, old.callback_time), 'yyyy-MM-dd'), '9999-99-99')
from (
         select id,
                order_id,
                user_id,
                province_id,
                trade_no,
                out_trade_no,
                payment_type,
                payment_amount,
                payment_status,
                create_time,
                callback_time
         from dwd_payment_info
         where dt = '9999-99-99'
     ) old
         full outer join
     (
         select pi.id,
                pi.out_trade_no,
                pi.order_id,
                pi.user_id,
                oi.province_id,
                pi.payment_type,
                pi.trade_no,
                pi.payment_amount,
                pi.payment_status,
                pi.create_time,
                pi.callback_time
         from (
                  select *
                  from ods_payment_info
                  where dt = '2021-06-17'
              ) pi
                  left join
              (
                  select id, province_id
                  from ods_order_info
                  where dt = '2021-06-17'
              ) oi
              on pi.order_id = oi.id
     ) new
     on old.id = new.id;
