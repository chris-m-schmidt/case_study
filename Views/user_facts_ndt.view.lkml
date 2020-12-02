# If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"
include: "order_items.view"

view: +order_items {
  measure: earliest_order {
    type: date_time
    sql: MIN(${created_raw}) ;;
    convert_tz: no
    hidden: yes
  }

  measure: latest_order {
    type: date_time
    sql: MAX(${created_raw}) ;;
    convert_tz: no
    hidden: yes
  }
}

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_count {}
      column: email { field: users.email }
      column: earliest_order { }
      column: latest_order {}
      bind_all_filters: yes
        # 1. cannot persist
        # 2. only use this NDT in the original explore from where it was defined
    }
  }

  dimension: order_count {
    type: number
  }
  dimension: email {}

  measure: avg_order_count_per_user {
    type: average
    sql: ${order_count} ;;
  }
}
