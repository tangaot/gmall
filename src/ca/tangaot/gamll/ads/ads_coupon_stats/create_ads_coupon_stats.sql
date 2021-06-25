--优惠券统计

USE gmall;

DROP TABLE IF EXISTS ads_coupon_stats;
CREATE EXTERNAL TABLE ads_coupon_stats
(
    `dt`                    STRING COMMENT '统计日期',
    `coupon_id`             STRING COMMENT '优惠券ID',
    `coupon_name`           STRING COMMENT '优惠券名称',
    `start_date`            STRING COMMENT '发布日期',
    `rule_name`             STRING COMMENT '优惠规则',
    `get_count`             BIGINT COMMENT '领取次数',
    `order_count`           BIGINT COMMENT '使用(下单)次数',
    `expire_count`          BIGINT COMMENT '过期次数',
    `order_original_amount` DECIMAL(16, 2) COMMENT '使用优惠券订单原始金额',
    `order_final_amount`    DECIMAL(16, 2) COMMENT '使用优惠券订单最终金额',
    `reduce_amount`         DECIMAL(16, 2) COMMENT '优惠金额',
    `reduce_rate`           DECIMAL(16, 2) COMMENT '补贴率'
) COMMENT '商品销售统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_coupon_stats/';
