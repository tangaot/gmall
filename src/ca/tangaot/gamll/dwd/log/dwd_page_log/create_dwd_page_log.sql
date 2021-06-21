-- 页面日志表

USE gmall;

DROP TABLE IF EXISTS dwd_page_log;
CREATE EXTERNAL TABLE dwd_page_log
(
    `area_code`      STRING COMMENT '地区编码',
    `brand`          STRING COMMENT '手机品牌',
    `channel`        STRING COMMENT '渠道',
    `is_new`         STRING COMMENT '是否首次启动',
    `model`          STRING COMMENT '手机型号',
    `mid_id`         STRING COMMENT '设备id',
    `os`             STRING COMMENT '操作系统',
    `user_id`        STRING COMMENT '会员id',
    `version_code`   STRING COMMENT 'app版本号',
    `during_time`    BIGINT COMMENT '持续时间毫秒',
    `page_item`      STRING COMMENT '目标id ',
    `page_item_type` STRING COMMENT '目标类型',
    `last_page_id`   STRING COMMENT '上页类型',
    `page_id`        STRING COMMENT '页面ID ',
    `source_type`    STRING COMMENT '来源类型',
    `ts`             bigint
) COMMENT '页面日志表'
    PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/gmall/dwd/dwd_page_log'
    TBLPROPERTIES ("orc.compress" = "snappy");