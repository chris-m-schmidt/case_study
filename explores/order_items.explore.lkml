include: "/Views/*.view.lkml"

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

  join: user_facts {
    view_label: "Users"
    relationship: many_to_one
    sql_on: ${users.id}= ${user_facts.id} ;;
  }
  join: products {
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    relationship: many_to_one
  }
}
