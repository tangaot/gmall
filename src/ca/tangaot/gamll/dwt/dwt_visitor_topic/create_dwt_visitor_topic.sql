-- 访客主题

USE gmall;

DROP TABLE IF EXISTS dwt_visitor_topic;
CREATE EXTERNAL TABLE dwt_visitor_topic
(
    `mid_id`                   STRING COMMENT '设备id',
    `brand`                    STRING COMMENT '手机品牌',
    `model`                    STRING COMMENT '手机型号',
    `channel`                  ARRAY<STRING> COMMENT '渠道',
    `os`                       ARRAY<STRING> COMMENT '操作系统',
    `area_code`                ARRAY<STRING> COMMENT '地区ID',
    `version_code`             ARRAY<STRING> COMMENT '应用版本',
    `visit_date_first`         STRING COMMENT '首次访问时间',
    `visit_date_last`          STRING COMMENT '末次访问时间',
    `visit_last_1d_count`      BIGINT COMMENT '最近1日访问次数',
    `visit_last_1d_day_count`  BIGINT COMMENT '最近1日访问天数',
    `visit_last_7d_count`      BIGINT COMMENT '最近7日访问次数',
    `visit_last_7d_day_count`  BIGINT COMMENT '最近7日访问天数',
    `visit_last_30d_count`     BIGINT COMMENT '最近30日访问次数',
    `visit_last_30d_day_count` BIGINT COMMENT '最近30日访问天数',
    `visit_count`              BIGINT COMMENT '累积访问次数',--用户行为日志历史数据无法获取，故该字段实为从数仓搭建日至今的累积值
    `visit_day_count`          BIGINT COMMENT '累积访问天数'--用户行为日志历史数据无法获取，故该字段实为从数仓搭建日至今的累积值
) COMMENT '设备主题宽表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwt/dwt_visitor_topic'
    TBLPROPERTIES ("orc.compress" = "snappy");
