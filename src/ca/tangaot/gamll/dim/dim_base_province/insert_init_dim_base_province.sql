--5.4 地区维度表 首日装载
-- 地区维度表数据相对稳定，变化概率较低，故无需每日装载。
USE gmall;

insert overwrite table dim_base_province
select bp.id,
       bp.name,
       bp.area_code,
       bp.iso_code,
       bp.iso_3166_2,
       bp.region_id,
       br.region_name
from ods_base_province bp
         join ods_base_region br on bp.region_id = br.id;
