connection: "thelook_events_redshift"

include: "/Views/*.view.lkml"                   # include all views in this project
include: "/dashboards/bus_2.dashboard.lookml"   # include a LookML dashboard called my_dashboard


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
