-- 退单事实表

USE gmall;

DROP TABLE IF EXISTS dwd_order_refund_info;
CREATE EXTERNAL TABLE dwd_order_refund_info
(
    `id`                 STRING COMMENT '编号',
    `user_id`            STRING COMMENT '用户ID',
    `order_id`           STRING COMMENT '订单ID',
    `sku_id`             STRING COMMENT '商品ID',
    `province_id`        STRING COMMENT '地区ID',
    `refund_type`        STRING COMMENT '退单类型',
    `refund_num`         BIGINT COMMENT '退单件数',
    `refund_amount`      DECIMAL(16, 2) COMMENT '退单金额',
    `refund_reason_type` STRING COMMENT '退单原因类型',
    `create_time`        STRING COMMENT '退单时间'
) COMMENT '退单事实表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_order_refund_info/'
    TBLPROPERTIES ("orc.compress" = "snappy");
