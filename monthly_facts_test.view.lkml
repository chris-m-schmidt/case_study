# view: month_facts_test {
#
#   derived_table: {
#     explore_source: order_items {
#       column: created_month {}
#       column: order_count {}
#     }
#   }
#
#   dimension: created_month {
#     label: "Created Month"
#     type: date_month
#   }
#
#   dimension: order_count {
#     label: "Order Count"
#     type: number
#   }
# }

view: monthly_facts_test {
  derived_table: {
    explore_source: order_items {
      timezone: "America/Los_Angeles"
      column: created_month {}
      column: order_count {}
    }
  }

  dimension: created_month {
    label: "Created Month"
    type: date_month
  }

  dimension: order_count {
    label: "Order Count"
    type: number
  }
}
