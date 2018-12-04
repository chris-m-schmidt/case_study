# If necessary, uncomment the line below to include explore_source.
# include: "chris_case_study.model.lkml"

view: customer_facts {
  derived_table: {
    explore_source: users {
      column: user_id { field: order_items.user_id }
      column: earliest_order { field: order_items.earliest_order }
      column: latest_order { field: order_items.latest_order }
      column: order_count { field: order_items.order_count }
      column: total_gross_revenue { field: order_items.total_gross_revenue }
    }
  }


# -------------------------- DIMENSIONS ---------------------------------

  dimension: user_id {
    primary_key: yes
    type: number
  }

  dimension: order_count {
#     hidden: yes
    type: number
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${order_count} > 1 ;;
  }

  dimension: customer_lifetime_order_tier {
    type: tier
    tiers: [2, 5, 9, 10]
    style: integer
    sql: ${order_count} ;;
  }

  dimension: total_gross_revenue {
    hidden: yes
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    value_format: "$#,##0.00"
    type: number
  }

  dimension: customer_lifetime_revenue_tier {
    type: tier
    tiers: [5, 20, 50, 100, 500, 1000]
    style: integer
    sql: ${total_gross_revenue} ;;
  }

  dimension: earliest_order {
    hidden: yes
    type: date
    }

  dimension_group: earliest_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${earliest_order} ;;
  }

  dimension: latest_order {
    hidden: yes
    type: date
  }

  dimension_group: latest_order {
    type: time
    timeframes: [date, week, month, year]
    sql: ${latest_order} ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${latest_order_date} >= CURRENT_DATE - 90 ;;
  }

  dimension: days_since_latest_order {
    type: number
    sql: CURRENT_DATE - ${latest_order_date} ;;
  }

  dimension: months_since_latest_order {
    type: number
    sql: DATEDIFF(month, ${latest_order_date}, CURRENT_DATE) ;;
  }


# -------------------------- MEASURES ---------------------------------

  measure: count {
    type: count
  }

  measure: total_lifetime_orders {
    type: sum
    sql: ${order_count} ;;
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${order_count} ;;
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${total_gross_revenue} ;;
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${total_gross_revenue} ;;
    value_format_name: usd
  }

  measure: average_days_since_latest_order {
    type: average
    sql: ${days_since_latest_order} ;;
  }

  measure: average_months_since_latest_order {
    type: average
    sql: ${months_since_latest_order} ;;
  }

  measure: repeat_customer_count {
    hidden: yes
    type: count
    filters: {
      field: is_repeat_customer
      value: "Yes"
    }
  }

  measure: repeat_customer_percent {
    type: number
    sql: 1.0*${repeat_customer_count}/NULLIF(${count},0) ;;
    value_format_name: percent_1
  }

}
