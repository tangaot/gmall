-- 七天内连续三天活跃用户数

USE gmall;

DROP TABLE IF EXISTS ads_user_continuity;
CREATE EXTERNAL TABLE ads_user_continuity
(
    `dt`         STRING COMMENT '统计日期',
    `user_count` BIGINT COMMENT '最近7天内连续3天活跃用户数'
) COMMENT '最近7天内连续3天活跃用户数'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/warehouse/gmall/ads/ads_user_continuity/';

