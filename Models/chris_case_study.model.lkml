connection: "thelook_events_redshift"

include: "/Views/**/*.view.lkml"                  # All views anywhere
# include: "/dashboards/business_stuff_1.dashboard"
include: "/explores/*.explore.lkml"

include: "/Views/brand_test/e.explore"
datagroup: eleven_am {
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*11)/(60*60*24)) ;;
}
persist_with: eleven_am

datagroup: no_cache {
  max_cache_age: "0 seconds"
}

datagroup: every_15_min {
  sql_trigger: select 1;;
}

access_grant: testy {
  allowed_values: ["Yes"]
  user_attribute: can_see_pii
}

explore: events {}


explore: brand_comparison {
  from: order_items
  view_name: order_items
  fields: [order_items.created_date, order_items.created_month,
          order_items.order_items_count, order_items.total_gross_revenue, order_items.status,
          inventory_items.product_category, inventory_items.product_brand, inventory_items.brand_comparison,
          inventory_items.brand_to_compare]

  join: inventory_items {
    type: inner
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}
