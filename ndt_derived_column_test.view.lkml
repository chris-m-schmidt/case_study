explore: ndt_derived_column_test {}

view: ndt_derived_column_test {
# If necessary, uncomment the line below to include explore_source.
# include: "chris_case_study.model.lkml"

  derived_table: {
    explore_source: order_items {
      column: state { field: users.state }
      column: order_count {}
      derived_column: total_order_count {
        sql: sum(order_count) over() ;;
      }
    }
  }

  dimension: state {}

  dimension: order_count {
    label: "Order Items View_Label Order Count"
    type: number
  }

  dimension: total_order_count {
    type: number
  }
}
