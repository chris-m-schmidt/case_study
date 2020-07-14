connection: "thelook_events_redshift"
# include: "//second_project/*.lkml"

include: "/**/*.view"                 # All views anywhere
# include: "/**/*.dashboard"
# include: "/Views/**/*.view"         # All views anywhere inside "Views" folder (sub-folder or free)
# include: "/Views/*.view"            # All views in "Views" folder that are not in sub-folder (redundant from 1st)
# include: "/Views/*/*.view"          # All views in "Views" folder that are in sub-folder     (redundant from 1st)
# include: "/*.view"                  # All views not in any folder

datagroup: eleven_am {
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*11)/(60*60*24)) ;;
}
persist_with: eleven_am

datagroup: no_cache {
  max_cache_age: "0 seconds"
}

access_grant: testy {
  allowed_values: ["Yes"]
  user_attribute: can_see_pii
}

explore: users {
  sql_always_where: ${order_items.order_id} is not null  ;;
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

explore: order_items {
#   persist_with: 2am_etl
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

  join: user_facts {
    relationship: many_to_one
    sql_on: ${users.id}= ${user_facts.id} ;;
  }
  join: products {
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    relationship: many_to_one
  }
}


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
