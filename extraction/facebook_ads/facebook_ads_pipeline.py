import dlt

from facebook_ads import (
    facebook_ads_source,
    facebook_insights_source,
    DEFAULT_ADCREATIVE_FIELDS,
    AdCreative,
    enrich_ad_objects,
)


def load_all_ads_objects() -> None:
    """Loads campaigns, ad sets, ads"""
    pipeline = dlt.pipeline(
        pipeline_name="facebook_ads",
        destination='bigquery',
        dataset_name="facebook_ads_dimensions",
        progress="log"
    )
    info = pipeline.run(facebook_ads_source())
    print(info)


# def merge_ads_objects() -> None:
#     """Shows how to convert the source into a merge one, where subsequent loads add or update records but not delete old ones"""
#     pipeline = dlt.pipeline(
#         pipeline_name="facebook_insights",
#         destination='bigquery',
#         dataset_name="facebook_insights_data",
#         dev_mode=True,
#     )
#     fb_ads = facebook_ads_source()
#     # enable root key propagation on a source that is not a merge one by default. this is not required if you always use merge but below we start
#     # with replace
#     fb_ads.root_key = True
#     # load only disapproved ads
#     fb_ads.ads.bind(states=("DISAPPROVED",))
#     info = pipeline.run(fb_ads.with_resources("ads"), write_disposition="replace")
#     # merge the paused ads. the disapproved ads stay there!
#     fb_ads = facebook_ads_source()
#     fb_ads.ads.bind(states=("PAUSED",))
#     info = pipeline.run(fb_ads.with_resources("ads"), write_disposition="merge")
#     print(info)
#     # prove we have them all
#     with pipeline.sql_client() as c:
#         with c.execute_query("SELECT id, name, effective_status FROM ads") as q:
#             print(q.df())


# def load_ads_with_custom_fields() -> None:
#     """Shows how to change the fields loaded for a particular object"""
#     pipeline = dlt.pipeline(
#         pipeline_name="facebook_ads",
#         destination='bigquery',
#         dataset_name="facebook_ads_data",
#         dev_mode=True,
#     )
#     fb_ads = facebook_ads_source()
#     # only loads add ids, works the same for campaigns, leads etc.
#     fb_ads.ads.bind(fields=("id",))
#     info = pipeline.run(fb_ads.with_resources("ads"))
#     print(info)


# def load_only_disapproved_ads() -> None:
#     """Shows how to load objects with a given statuses"""
#     pipeline = dlt.pipeline(
#         pipeline_name="facebook_ads",
#         destination='bigquery',
#         dataset_name="facebook_ads_data",
#         dev_mode=True,
#     )
#     fb_ads = facebook_ads_source()
#     # we want only disapproved ads
#     fb_ads.ads.bind(
#         states=("DISAPPROVED",)
#     )  # states=("DISAPPROVED", "PAUSED") for many states
#     info = pipeline.run(fb_ads.with_resources("ads"))
#     print(info)


# def load_and_enrich_objects() -> None:
#     """Show how to enrich objects by adding an enrichment transformation that adds fields to objects
#     This (probably) goes around facebook limitations ie. it makes sense to get just ids for ad creatives and the rest via enrichments
#     """
#     pipeline = dlt.pipeline(
#         pipeline_name="facebook_ads",
#         destination='bigquery',
#         dataset_name="facebook_ads_data",
#         dev_mode=True,
#     )
#     # also shows how to reduce chunk size: many small requests will be made
#     fb_ads = facebook_ads_source(chunk_size=2)
#     # request only id
#     fb_ads.ad_creatives.bind(fields=("id",))
#     # add a transformation to a ad_creatives resource
#     fb_ads.ad_creatives.add_step(
#         # pass AdCreative object type (you can import more object from `facebook_ads` ie Campaign, Ad etc.) and request the fields
#         enrich_ad_objects(AdCreative, DEFAULT_ADCREATIVE_FIELDS)
#     )
#     info = pipeline.run(fb_ads.with_resources("ad_creatives"))
#     print(info)


def load_insights() -> None:
    """Loads insights with 7 days attribution window"""
    pipeline = dlt.pipeline(
        pipeline_name="facebook_insights",
        destination='bigquery',
        dataset_name="facebook_insights_data",
        progress="log",
        # pipelines_dir="." # specify a directory for dlt pipeline meta data. dlt defaults to $PWD/.dlt/your_pipeline_name, which will not be mounted to docker
    )

    i_daily = facebook_insights_source(
        initial_load_past_days=365,
        breakdowns="ads_insights", # we only need ads insights breakdown for now
        action_breakdowns=("action_type",), # breakdown actions by type
        action_attribution_windows=("7d_click", "1d_view"), # agency standard is set here
        batch_size=50, # may need to be adjusted
        level="ad"
        )
    # i_weekly = facebook_insights_source(
    #     initial_load_past_days=1,
    #     time_increment_days=7)
    info = pipeline.run(i_daily)
    print(info)


if __name__ == "__main__":
    load_all_ads_objects()
    load_insights()

    # merge_ads_objects()
    # load_ads_with_custom_fields()
    # load_only_disapproved_ads()
    # load_and_enrich_objects()
