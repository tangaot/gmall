-- 品牌复购率（最近三十天）

USE gmall;

DROP TABLE IF EXISTS ads_repeat_purchase;
CREATE EXTERNAL TABLE `ads_repeat_purchase`
(
    `dt`                         STRING COMMENT '统计日期',
    `tm_id`                      STRING COMMENT '品牌ID',
    `tm_name`                    STRING COMMENT '品牌名称',
    `order_last_30d_repeat_rate` DECIMAL(16, 2) COMMENT '复购率'
) COMMENT '品牌复购率'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_repeat_purchase/';
