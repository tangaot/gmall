-- 订单明细事实表

USE gmall;

DROP TABLE IF EXISTS dwd_order_detail;
CREATE EXTERNAL TABLE dwd_order_detail
(
    `id`                    STRING COMMENT '订单编号',
    `order_id`              STRING COMMENT '订单号',
    `user_id`               STRING COMMENT '用户id',
    `sku_id`                STRING COMMENT 'sku商品id',
    `province_id`           STRING COMMENT '省份ID',
    `activity_id`           STRING COMMENT '活动ID',
    `activity_rule_id`      STRING COMMENT '活动规则ID',
    `coupon_id`             STRING COMMENT '优惠券ID',
    `create_time`           STRING COMMENT '创建时间',
    `source_type`           STRING COMMENT '来源类型',
    `source_id`             STRING COMMENT '来源编号',
    `sku_num`               BIGINT COMMENT '商品数量',
    `original_amount`       DECIMAL(16, 2) COMMENT '原始价格',
    `split_activity_amount` DECIMAL(16, 2) COMMENT '活动优惠分摊',
    `split_coupon_amount`   DECIMAL(16, 2) COMMENT '优惠券优惠分摊',
    `split_final_amount`    DECIMAL(16, 2) COMMENT '最终价格分摊'
) COMMENT '订单明细事实表表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_order_detail/'
    TBLPROPERTIES ("orc.compress" = "snappy");
