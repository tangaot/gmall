-- 用户统计

USE gmall;

DROP TABLE IF EXISTS ads_user_total;
CREATE EXTERNAL TABLE `ads_user_total`
(
    `dt`                   STRING COMMENT '统计日期',
    `new_user_count`       BIGINT COMMENT '新注册用户数',
    `new_order_user_count` BIGINT COMMENT '新增下单用户数',
    `order_final_amount`   DECIMAL(16, 2) COMMENT '下单总金额',
    `order_user_count`     BIGINT COMMENT '下单用户数',
    `no_order_user_count`  BIGINT COMMENT '未下单用户数(具体指活跃用户中未下单用户)'
) COMMENT '用户统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_user_total/';
