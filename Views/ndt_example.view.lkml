explore:ndt_example{}
view: ndt_example {
  derived_table: {
    explore_source: order_items {
      column: created_month {}
      column: order_count {}
      derived_column: last_3_month_avg {
        sql:1.0*(sum(order_count) over (order by created_month rows between 2 preceding and current row)) /90;;
      }
    }
  }
  dimension: created_month {
    type: date_month
  }
  dimension: order_count {
    type: number
  }
  dimension: last_3_month_avg {}
}
