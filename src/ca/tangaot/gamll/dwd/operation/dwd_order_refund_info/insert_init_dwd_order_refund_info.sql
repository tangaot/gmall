-- 退单事实表 首日装载

USE gmall;

insert overwrite table dwd_order_refund_info partition (dt)
select ri.id,
       ri.user_id,
       ri.order_id,
       ri.sku_id,
       oi.province_id,
       ri.refund_type,
       ri.refund_num,
       ri.refund_amount,
       ri.refund_reason_type,
       ri.create_time,
       date_format(ri.create_time, 'yyyy-MM-dd')
from (
         select *
         from ods_order_refund_info
         where dt = '2021-06-16'
     ) ri
         left join
     (
         select id, province_id
         from ods_order_info
         where dt = '2021-06-16'
     ) oi
     on ri.order_id = oi.id;

