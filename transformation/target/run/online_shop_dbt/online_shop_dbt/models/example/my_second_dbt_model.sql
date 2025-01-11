

  create or replace view `opensource-marketing-dwh`.`dbt_transformations_new`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `facebook_ads_dimensions.ads`;

