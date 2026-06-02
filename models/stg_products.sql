with raw_product as (
    select * from {{source('olist_raw', 'PRODUCTS')}}
)

select 
PRODUCT_ID,
PRODUCT_CATEGORY_NAME
from raw_product
