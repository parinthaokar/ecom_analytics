with orders as (
    select * from {{ref('stg_orders')}}

),
 item as (
    select * from {{ref('stg_order_items')}}

),
 products as (
    select * from {{ref('stg_products')}}

),
 translation as (
    select * from {{source('olist_raw', 'PRODUCT_CATEGORY_TRANSLATION')}}

)

select 
orders.ORDER_ID,
orders.CUSTOMER_ID,
orders.ORDER_PURCHASE_AT,
orders.ORDER_MONTH,
orders.ORDER_YEAR,
item.TOTAL_ITEM_COST,
translation.PRODUCT_CATEGORY_NAME_ENGLISH,
MIN(orders.ORDER_PURCHASE_AT) OVER (PARTITION BY orders.CUSTOMER_ID) AS CUSTOMER_FIRST_PURCHASE_AT
from orders 
join item 
on orders.ORDER_ID = item.ORDER_ID
join products 
on item.PRODUCT_ID = products.PRODUCT_ID
join translation 
on products.PRODUCT_CATEGORY_NAME = translation.PRODUCT_CATEGORY_NAME

