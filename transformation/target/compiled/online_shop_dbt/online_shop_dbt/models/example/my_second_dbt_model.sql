-- Use the `ref` function to select from other models

select *
from `opensource-marketing-dwh`.`dbt_transformations`.`my_first_dbt_model`
where id = 1