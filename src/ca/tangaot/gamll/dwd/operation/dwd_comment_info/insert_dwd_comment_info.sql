-- 评价事实表 数据导入

USE gmall;

SET hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table dwd_comment_info partition(dt='2021-06-17')
select
    id,
    user_id,
    sku_id,
    spu_id,
    order_id,
    appraise,
    create_time
from ods_comment_info where dt='2021-06-17';

