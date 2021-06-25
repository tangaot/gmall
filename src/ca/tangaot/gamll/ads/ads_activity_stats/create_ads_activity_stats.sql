-- 活动统计

USE gmall;

DROP TABLE IF EXISTS ads_activity_stats;
CREATE EXTERNAL TABLE `ads_activity_stats`
(
    `dt`                    STRING COMMENT '统计日期',
    `activity_id`           STRING COMMENT '活动ID',
    `activity_name`         STRING COMMENT '活动名称',
    `start_date`            STRING COMMENT '活动开始日期',
    `order_count`           BIGINT COMMENT '参与活动订单数',
    `order_original_amount` DECIMAL(16, 2) COMMENT '参与活动订单原始金额',
    `order_final_amount`    DECIMAL(16, 2) COMMENT '参与活动订单最终金额',
    `reduce_amount`         DECIMAL(16, 2) COMMENT '优惠金额',
    `reduce_rate`           DECIMAL(16, 2) COMMENT '补贴率'
) COMMENT '商品销售统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_activity_stats/';
