with sum_order as (
    select * from {{source('olist_raw', 'ORDER_ITEMS')}}
)

select 
ORDER_ID,
ORDER_ITEM_ID,
PRODUCT_ID,
PRICE,
FREIGHT_VALUE,
(PRICE + FREIGHT_VALUE) as TOTAL_ITEM_COST
from sum_order