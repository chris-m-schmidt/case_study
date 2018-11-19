connection: "thelook_events_redshift"

include: "*.view"

datagroup: default_datagroup {
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

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
