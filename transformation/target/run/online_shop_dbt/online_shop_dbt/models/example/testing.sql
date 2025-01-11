

  create or replace view `opensource-marketing-dwh`.`dbt_transformations_new`.`testing`
  OPTIONS()
  as SELECT * FROM opensource-marketing-dwh.facebook_ads_dimensions.ad_sets;

