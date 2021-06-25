-- 订单统计

USE gmall;

DROP TABLE IF EXISTS ads_order_total;
CREATE EXTERNAL TABLE `ads_order_total`
(
    `dt`               STRING COMMENT '统计日期',
    `order_count`      BIGINT COMMENT '订单数',
    `order_amount`     DECIMAL(16, 2) COMMENT '订单金额',
    `order_user_count` BIGINT COMMENT '下单人数'
) COMMENT '订单统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_order_total/';
