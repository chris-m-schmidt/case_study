include: "/Views/*.view"
include: "/Views/cohort_analysis/cohort_facts.view"

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

  join: cohort_facts {
    relationship: one_to_one
    sql_on: ${users.id} = ${cohort_facts.user_id} ;;
  }
}
