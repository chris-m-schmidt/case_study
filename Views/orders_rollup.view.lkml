# If necessary, uncomment the line below to include explore_source.
# include: "daily_orders.view.lkml"

view: orders_rollup {
   derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: order_total {field:order_items.total_sales}
    }
  }

  dimension: order_id {
    type: number
    primary_key: yes
  }
  dimension: user_id {
    type: number
  }
  dimension: order_total {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_total_order_price {
    type: average
    sql: ${order_total} ;;
  }
}
