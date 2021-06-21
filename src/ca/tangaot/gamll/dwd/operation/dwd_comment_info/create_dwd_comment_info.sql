-- 评价事实表

USE gmall;

DROP TABLE IF EXISTS dwd_comment_info;
CREATE EXTERNAL TABLE dwd_comment_info
(
    `id`          STRING COMMENT '编号',
    `user_id`     STRING COMMENT '用户ID',
    `sku_id`      STRING COMMENT '商品sku',
    `spu_id`      STRING COMMENT '商品spu',
    `order_id`    STRING COMMENT '订单ID',
    `appraise`    STRING COMMENT '评价(好评、中评、差评、默认评价)',
    `create_time` STRING COMMENT '评价时间'
) COMMENT '评价事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_comment_info/'
    TBLPROPERTIES ("orc.compress" = "snappy");
