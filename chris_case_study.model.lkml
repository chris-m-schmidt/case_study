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
    fields: [order_items.count,
            order_items.status,
            order_items.customer_count,
            order_items.average_spend_per_customer,
            order_items.customers_returning_items_count,
            order_items.percent_of_customers_with_returns]
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: order_items {
  description: "Detailed Order Item and Customer Metrics"
  join: inventory_items {
    fields: [inventory_items.cost]
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }
}
