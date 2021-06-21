-- 加购事实表

USE gmall;

insert overwrite table dwd_cart_info partition (dt = '2021-06-17')
select id,
       user_id,
       sku_id,
       source_type,
       source_id,
       cart_price,
       is_ordered,
       create_time,
       operate_time,
       order_time,
       sku_num
from ods_cart_info
where dt = '2021-06-17';


