# If necessary, uncomment the line below to include explore_source.
# include: "order_items.explore.lkml"

view: dtc_orders_window {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: earliest_order {}
      column: created_date {}
      column: status {}
      column: order_id {}
      derived_column: rank {
        sql: RANK() over (PARTITION BY user_id ORDER BY created_date) ;;
      }
#       bind_all_filters: yes
        # limitations of bind_all_filters:
          # 1. cannot persist table
          # 2.
      bind_filters: {
        from_field: order_items.status
        to_field: order_items.status
      }
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: earliest_order {
    type: number
  }
  dimension: status {}
  dimension: order_id {
    type: number
  }
  dimension: rank {
    type: number
  }
}
