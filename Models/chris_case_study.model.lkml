connection: "thelook_events_redshift"
# include: "//second_project/*.lkml"

include: "/**/*.view"                 # All views anywhere
# include: "/Views/**/*.view"         # All views anywhere inside "Views" folder (sub-folder or free)
# include: "/Views/*.view"            # All views in "Views" folder that are not in sub-folder (redundant from 1st)
# include: "/Views/*/*.view"          # All views in "Views" folder that are in sub-folder     (redundant from 1st)
# include: "/*.view"                  # All views not in any folder

datagroup: ten_am {
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*10)/(60*60*24)) ;;
}

persist_with: ten_am


explore: users {
  label: "Customer"
  description: "User Attributes and Customer Behavior Metrics"

  join: cohort_facts { #comment
    type: inner
    sql_on: ${users.id} = ${cohort_facts.user_id} ;;
    relationship: one_to_one
  }
#   new thing

  join: order_items {
#     fields: [order_items.customer_explore_field_set*]
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

  join: free_text {
    type: left_outer
    relationship: many_to_one
    sql:  ;;
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
