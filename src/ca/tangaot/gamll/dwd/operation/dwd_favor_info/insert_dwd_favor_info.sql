-- 收藏事实表

USE gmall;

insert overwrite table dwd_favor_info partition (dt = '2021-06-17')
select id,
       user_id,
       sku_id,
       spu_id,
       is_cancel,
       create_time,
       cancel_time
from ods_favor_info
where dt = '2021-06-17';

