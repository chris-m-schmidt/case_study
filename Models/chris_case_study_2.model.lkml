connection: "thelook_events_redshift"

include: "*.view"

datagroup: default_datagroup {
  max_cache_age: "1 hour"
  sql_trigger: SELECT CURRENT_DATE ;;
}

persist_with: default_datagroup

explore: users {
  label: "Customer"
  description: "User Attributes and Customer Behavior Metrics"

  join: customer_facts {
    type: inner
    sql_on: ${users.id} = ${customer_facts.user_id} ;;
    relationship: one_to_one
  }

  join: order_items {
#     fields: [order_items.customer_explore_field_set*]
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: user_order_sequence {
    type: left_outer
    sql_on: ${order_items.order_id} = ${user_order_sequence.order_id} ;;
    relationship: many_to_one
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
  view_label: "Order Items View_Label"
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

  join: monthly_facts_test {
    type: left_outer
    sql_on: ${order_items.created_month::date} = ${monthly_facts_test.created_month::date} ;;
    relationship: many_to_one
  }
}

# explore: brand_comparison {
#   from: order_items
#   view_name: order_items
#   fields: [order_items.created_date, order_items.created_week, order_items.created_month,
#           order_items.items_count, order_items.total_gross_revenue, order_items.status,
#           inventory_items.product_category, inventory_items.product_brand, inventory_items.brand_comparison,
#           inventory_items.brand_to_compare]
#
#   join: inventory_items {
#     type: inner
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }
# }
