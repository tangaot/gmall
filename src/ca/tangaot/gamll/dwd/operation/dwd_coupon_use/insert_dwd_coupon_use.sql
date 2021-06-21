-- 优惠券领用事实表

USE gmall;

insert overwrite table dwd_coupon_use partition (dt)
select nvl(new.id, old.id),
       nvl(new.coupon_id, old.coupon_id),
       nvl(new.user_id, old.user_id),
       nvl(new.order_id, old.order_id),
       nvl(new.coupon_status, old.coupon_status),
       nvl(new.get_time, old.get_time),
       nvl(new.using_time, old.using_time),
       nvl(new.used_time, old.used_time),
       nvl(new.expire_time, old.expire_time),
       coalesce(date_format(nvl(new.used_time, old.used_time), 'yyyy-MM-dd'),
                date_format(nvl(new.expire_time, old.expire_time), 'yyyy-MM-dd'), '9999-99-99')
from (
         select id,
                coupon_id,
                user_id,
                order_id,
                coupon_status,
                get_time,
                using_time,
                used_time,
                expire_time
         from dwd_coupon_use
         where dt = '9999-99-99'
     ) old
         full outer join
     (
         select id,
                coupon_id,
                user_id,
                order_id,
                coupon_status,
                get_time,
                using_time,
                used_time,
                expire_time
         from ods_coupon_use
         where dt = '2021-06-17'
     ) new
     on old.id = new.id;
