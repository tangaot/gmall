-- 加购事实表

USE gmall;

DROP TABLE IF EXISTS dwd_cart_info;
CREATE EXTERNAL TABLE dwd_cart_info
(
    `id`           STRING COMMENT '编号',
    `user_id`      STRING COMMENT '用户ID',
    `sku_id`       STRING COMMENT '商品ID',
    `source_type`  STRING COMMENT '来源类型',
    `source_id`    STRING COMMENT '来源编号',
    `cart_price`   DECIMAL(16, 2) COMMENT '加入购物车时的价格',
    `is_ordered`   STRING COMMENT '是否已下单',
    `create_time`  STRING COMMENT '创建时间',
    `operate_time` STRING COMMENT '修改时间',
    `order_time`   STRING COMMENT '下单时间',
    `sku_num`      BIGINT COMMENT '加购数量'
) COMMENT '加购事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_cart_info/'
    TBLPROPERTIES ("orc.compress" = "snappy");
