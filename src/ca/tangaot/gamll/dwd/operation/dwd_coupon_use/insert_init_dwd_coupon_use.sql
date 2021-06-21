-- 优惠券领用事实表

USE gmall;

insert overwrite table dwd_coupon_use partition (dt)
select id,
       coupon_id,
       user_id,
       order_id,
       coupon_status,
       get_time,
       using_time,
       used_time,
       expire_time,
       coalesce(date_format(used_time, 'yyyy-MM-dd'), date_format(expire_time, 'yyyy-MM-dd'), '9999-99-99')
from ods_coupon_use
where dt = '2021-06-16';
