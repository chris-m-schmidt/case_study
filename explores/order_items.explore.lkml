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
  join: orders_rollup {
    sql_on: ${order_items.order_id} = ${orders_rollup.order_id} ;;
    relationship: many_to_one
  }
}

# Place in `chris_case_study` model
explore: +order_items {  # refinements
  aggregate_table: rollup__created_date {
    query: {
      dimensions: [created_date]
      measures: [total_sales]
      timezone: "UTC"
    }

    materialization: {
      datagroup_trigger: eleven_am
    }
  }
}
# Place in `chris_case_study` model
explore: +order_items {
  aggregate_table: rollup__created_date__products_brand {
    query: {
      dimensions: [created_date, products.brand]
      measures: [total_sales]
      timezone: "UTC"
    }

    materialization: {
      datagroup_trigger: eleven_am
    }
  }
}
