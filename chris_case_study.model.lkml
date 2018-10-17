connection: "thelook_events_redshift"

# include all the views
include: "*.view"

datagroup: default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: default_datagroup

explore: users {
  label: "Customers"
  description: "User Attributes and Customer Behavior Metrics"
  join: order_items {
    fields: [order_items.customer_explore_field_set*]
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: order_items {
  description: "Detailed Order Item and Customer Metrics"
#   fields: [ALL_FIELDS*, -order_items.total_gross_revenue_from_new_customers, -order_items.total_gross_revenue_from_existing_customers]
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
#     fields: [inventory_items.cost]
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }
}
