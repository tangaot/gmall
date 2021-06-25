-- 各地区订单统计

USE gmall;

DROP TABLE IF EXISTS ads_order_by_province;
CREATE EXTERNAL TABLE `ads_order_by_province`
(
    `dt`              STRING COMMENT '统计日期',
    `province_id`     STRING COMMENT '省份id',
    `province_name`   STRING COMMENT '省份名称',
    `area_code`       STRING COMMENT '地区编码',
    `iso_code`        STRING COMMENT '国际标准地区编码',
    `iso_code_3166_2` STRING COMMENT '国际标准地区编码',
    `order_count`     BIGINT COMMENT '订单数',
    `order_amount`    DECIMAL(16, 2) COMMENT '订单金额'
) COMMENT '用户留存率'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_order_by_province/';
