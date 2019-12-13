--   ======================================================================================
--    AUTOGENERATED!!!! DO NOT EDIT!!!!
--   ======================================================================================

DROP STREAM IF EXISTS {{ target_table.schema }}__{{ target_table.name }} DELETE TOPIC;
{% for source_table in mappings.source_tables(target_table) %}
{% set source_filter = mappings.filter(source_table, target_table) %}

{% if loop.first %}
CREATE STREAM {{ target_table.schema }}__{{ target_table.name }}
AS
{% else %}
INSERT INTO {{ target_table.schema }}__{{ target_table.name }}
{% endif %}
SELECT
  {{ mappings.source_column(source_table, target_table.key) }} AS {{ target_table.key.name }}
  ,{{ mappings.source_column(source_table, target_table.load_dts) }} AS {{ target_table.load_dts.name }}
  {% for attribute in target_table.attributes %}
  ,{{ mappings.source_column(source_table, attribute) }} AS {{ attribute.name }}
  {% endfor %}
  ,{{ mappings.source_column(source_table, target_table.rec_src) }} AS {{ target_table.rec_src.name }}
FROM
  {{ source_table.schema }}__{{ source_table.name }}
{% if source_filter %}
WHERE
  {{ source_filter }}
{% endif %}
;
{% endfor %}
