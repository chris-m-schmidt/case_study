connection: "thelook_events_redshift"

include: "*.view"

datagroup: default_datagroup {
  max_cache_age: "1 hour"
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
    relationship: one_to_one
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
