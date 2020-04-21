connection: "thelook_events_redshift"
# include: "//second_project/*.lkml"

include: "/**/*.view"                 # All views anywhere
include: "/**/*.dashboard"
# include: "/Views/**/*.view"         # All views anywhere inside "Views" folder (sub-folder or free)
# include: "/Views/*.view"            # All views in "Views" folder that are not in sub-folder (redundant from 1st)
# include: "/Views/*/*.view"          # All views in "Views" folder that are in sub-folder     (redundant from 1st)
# include: "/*.view"                  # All views not in any folder
include: "/single_tile_lookml.dashboard.lookml"

datagroup: eleven_am {
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*11)/(60*60*24)) ;;
}
persist_with: eleven_am

datagroup: no_cache {
  max_cache_age: "0 seconds"
}

explore: users {
  join: order_items {
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: events {
    type: inner
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
  }

  join: inventory_items {
    type: inner
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}


explore: users2 {
  extends: [users]
  from: users
  view_name: users
  persist_with: no_cache
}

explore: order_items {
  description: "Detailed Order Item and Customer Metrics"

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: order_rollup_base {
    sql_on: ${order_items.order_id}=${order_rollup_base.order_id} ;;
    relationship: many_to_one
  }

  join: order_rollup_bindfilters {
    sql_on: ${order_items.order_id}=${order_rollup_bindfilters.order_id} ;;
    relationship: many_to_one
  }

  join: order_rollup_bindallfilters {
    sql_on: ${order_items.order_id}=${order_rollup_bindallfilters.order_id} ;;
    relationship: many_to_one
  }

}


explore: brand_comparison {
  from: order_items
  view_name: order_items
  fields: [order_items.created_date, order_items.created_month,
          order_items.items_count, order_items.total_gross_revenue, order_items.status,
          inventory_items.product_category, inventory_items.product_brand, inventory_items.brand_comparison,
          inventory_items.brand_to_compare]

  join: inventory_items {
    type: inner
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}
