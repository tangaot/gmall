-- 支付事实表

USE gmall;

insert overwrite table dwd_payment_info partition (dt)
select pi.id,
       pi.order_id,
       pi.user_id,
       oi.province_id,
       pi.trade_no,
       pi.out_trade_no,
       pi.payment_type,
       pi.payment_amount,
       pi.payment_status,
       pi.create_time,
       pi.callback_time,
       nvl(date_format(pi.callback_time, 'yyyy-MM-dd'), '9999-99-99')
from (
         select *
         from ods_payment_info
         where dt = '2021-06-16'
     ) pi
         left join
     (
         select id, province_id
         from ods_order_info
         where dt = '2021-06-16'
     ) oi
     on pi.order_id = oi.id;
