

  create or replace view `opensource-marketing-dwh`.`dbt_transformations`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `opensource-marketing-dwh`.`dbt_transformations`.`my_first_dbt_model`
where id = 1;

