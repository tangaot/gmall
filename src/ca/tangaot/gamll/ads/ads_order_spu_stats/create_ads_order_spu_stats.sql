-- 商品统计

USE gmall;

DROP TABLE IF EXISTS ads_order_spu_stats;
CREATE EXTERNAL TABLE `ads_order_spu_stats`
(
    `dt`             STRING COMMENT '统计日期',
    `spu_id`         STRING COMMENT '商品ID',
    `spu_name`       STRING COMMENT '商品名称',
    `tm_id`          STRING COMMENT '品牌ID',
    `tm_name`        STRING COMMENT '品牌名称',
    `category3_id`   STRING COMMENT '三级品类ID',
    `category3_name` STRING COMMENT '三级品类名称',
    `category2_id`   STRING COMMENT '二级品类ID',
    `category2_name` STRING COMMENT '二级品类名称',
    `category1_id`   STRING COMMENT '一级品类ID',
    `category1_name` STRING COMMENT '一级品类名称',
    `order_count`    BIGINT COMMENT '订单数',
    `order_amount`   DECIMAL(16, 2) COMMENT '订单金额'
) COMMENT '商品销售统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_order_spu_stats/';
