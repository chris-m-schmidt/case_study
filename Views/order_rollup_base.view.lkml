# If necessary, uncomment the line below to include explore_source.
# include: "chris_case_study.model.lkml"

view: order_rollup_base {
  derived_table: {
    explore_source: order_items {
      column: total_sales {}
      column: order_id {}
    }
  }
  dimension: total_sales {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    type: number
  }
}


view: order_rollup_bindfilters {
  extends: [order_rollup_base]
  derived_table: {
    explore_source: order_items {
      bind_filters: {
        from_field: order_items.order_id
        to_field: order_items.order_id
      }
    }
  }
}

view: order_rollup_bindallfilters {
  extends: [order_rollup_base]
  derived_table: {
    explore_source: order_items {
      bind_all_filters: yes
    }
  }
}
