-- 订单事实表

USE gmall;

insert overwrite table dwd_order_info partition (dt)
select oi.id,
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
       final_amount,
       case
           when times.ts['1003'] is not null then date_format(times.ts['1003'], 'yyyy-MM-dd')
           when times.ts['1004'] is not null and
                date_add(date_format(times.ts['1004'], 'yyyy-MM-dd'), 7) <= '2021-06-16' and times.ts['1005'] is null
               then date_add(date_format(times.ts['1004'], 'yyyy-MM-dd'), 7)
           when times.ts['1006'] is not null then date_format(times.ts['1006'], 'yyyy-MM-dd')
           when oi.expire_time is not null then date_format(oi.expire_time, 'yyyy-MM-dd')
           else '9999-99-99'
           end
from (
         select *
         from ods_order_info
         where dt = '2021-06-16'
     ) oi
         left join
     (
         select order_id,
                str_to_map(concat_ws(',', collect_set(concat(order_status, '=', operate_time))), ',', '=') ts
         from ods_order_status_log
         where dt = '2021-06-16'
         group by order_id
     ) times
     on oi.id = times.order_id;
