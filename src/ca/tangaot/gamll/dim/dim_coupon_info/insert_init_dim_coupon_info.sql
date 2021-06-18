--5.2 优惠券维度表 首日装载
USE gmall;

insert overwrite table dim_coupon_info partition (dt = '2021-06-16')
select id,
       coupon_name,
       coupon_type,
       condition_amount,
       condition_num,
       activity_id,
       benefit_amount,
       benefit_discount,
       create_time,
       range_type,
       limit_num,
       taken_count,
       start_time,
       end_time,
       operate_time,
       expire_time
from ods_coupon_info
where dt = '2021-06-16';
