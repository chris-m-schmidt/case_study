# If necessary, uncomment the line below to include explore_source.
# include: "chris_case_study.model.lkml"

view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_sales {}
      bind_all_filters: yes # can only use derived table in explore it came from
    }
  }
  dimension: id {
    primary_key: yes
    type: number
  }
  dimension: total_sales {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_clv {
    type: average
    sql: ${total_sales} ;;
  }
}
