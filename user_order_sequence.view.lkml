view: user_order_sequence {
  derived_table: {
    sql:

    WITH orders AS (SELECT DISTINCT user_id, id, created_at FROM order_items)
            SELECT
              user_id
            , id AS order_id
            , RANK() OVER(PARTITION BY user_id ORDER BY created_at) as user_order_sequence_number
            , DATEDIFF(days, LAG(created_at, 1) RESPECT NULLS OVER(PARTITION BY user_id ORDER BY created_at), created_at) as days_since_previous_order
              FROM orders
 ;;
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_order_sequence_number {
    type: number
    sql: ${TABLE}.user_order_sequence_number ;;
  }

  dimension: days_since_previous_order {
    type: number
    sql: ${TABLE}.days_since_previous_order ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${user_order_sequence_number} = 1 ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${user_order_sequence_number} < ${customer_facts.order_count} ;;
  }

  measure: average_days_between_orders {
    type: average
    sql: ${days_since_previous_order} ;;
  }

  measure: customer_count {
    hidden: yes
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: 60_day_repeat_customer_count {
    hidden: yes
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: days_since_previous_order
      value: "<= 60"
    }
  }

  measure: 60_day_repeat_customer_percent {
    type: number
    sql: 1.0*${60_day_repeat_customer_count}/NULLIF(${customer_count},0) ;;
    value_format_name: percent_1
  }

#   measure: first_order_count {
#     type: count_distinct
#     sql: ${order_id} ;;
#     filters: {
#       field: is_first_purchase
#       value: "Yes"
#     }
#   }
#
#   measure: first_order_with_subsequent_order_count {
#     type: count_distinct
#     sql: ${order_id} ;;
#     filters: {
#       field: is_first_purchase
#       value: "Yes"
#     }
#     filters: {
#       field: has_subsequent_order
#       value: "Yes"
#     }
#   }
#
#   measure: percent_of_first_order_with_subsequent_order {
#     type: number
#     sql: 1.0*${first_order_with_subsequent_order_count}/NULLIF(${first_order_count},0) ;;
#     value_format_name: percent_1
#   }


  measure: order_count {
    type: count
  }

  measure: subsequent_order_count {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: has_subsequent_order
      value: "Yes"
    }
  }

  measure: percent_of_orders_with_subsequent_order {
    type: number
    sql: 1.0*${subsequent_order_count}/NULLIF(${order_count},0) ;;
    value_format_name: percent_1
  }


  set: detail {
    fields: [order_id, user_order_sequence_number, days_since_previous_order]
  }
}
