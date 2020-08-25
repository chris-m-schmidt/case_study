include: "/*/chris_case_study.model.lkml"

# view: cohort_facts {
#   derived_table: {
#     explore_source: users {
#       column: user_id { field: order_items.user_id }
#       column: earliest_order { field: order_items.earliest_order }
#       column: latest_order { field: order_items.latest_order }
#       column: order_count { field: order_items.order_count }
#       column: total_gross_revenue { field: order_items.total_gross_revenue }
#       bind_filters: {
#         from_field: cohort_facts.ndt_date_filter
#         to_field: users.created_date
#       }
#     }
#   }
#
#   filter: ndt_date_filter {
#     type: date
#   }
#
# # -------------------------- DIMENSIONS ---------------------------------
#
#   dimension: user_id {
#     primary_key: yes
#     type: number
#   }
#
#   dimension: order_count {
# #     hidden: yes
#     type: number
#   }
#
#   dimension: is_repeat_customer {
#     type: yesno
#     sql: ${order_count} > 1 ;;
#   }
#
#   dimension: customer_lifetime_order_tier {
#     type: tier
#     tiers: [2, 5, 9, 10]
#     style: integer
#     sql: ${order_count} ;;
#   }
#
#   dimension: total_gross_revenue {
#     hidden: yes
#     description: "Total revenue from completed sales (cancelled and returned orders excluded)"
#     value_format: "$#,##0.00"
#     type: number
#   }
#
#   dimension: customer_lifetime_revenue_tier {
#     type: tier
#     tiers: [5, 20, 50, 100, 500, 1000]
#     style: integer
#     sql: ${total_gross_revenue} ;;
#   }
#
#   dimension: earliest_order {
#     hidden: yes
#     type: date
#     }
#
#   dimension_group: earliest_order {
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${earliest_order} ;;
#   }
#
#   dimension: latest_order {
#     hidden: yes
#     type: date
#   }
#
#   dimension_group: latest_order {
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${latest_order} ;;
#   }
#
#   dimension: is_active {
#     type: yesno
#     sql: ${latest_order_date} >= CURRENT_DATE - 90 ;;
#   }
#
#   dimension: days_since_latest_order {
#     type: number
#     sql: CURRENT_DATE - ${latest_order_date} ;;
#   }
#
#   dimension: months_since_latest_order {
#     type: number
#     sql: DATEDIFF(month, ${latest_order_date}, CURRENT_DATE) ;;
#   }
#
#
# # -------------------------- MEASURES ---------------------------------
#
#   measure: count {
#     type: count
#   }
#
#   measure: total_lifetime_orders {
#     type: sum
#     sql: ${order_count} ;;
#   }
#
#   measure: average_lifetime_orders {
#     type: average
#     sql: ${order_count} ;;
#   }
#
#   measure: total_lifetime_revenue {
#     type: sum
#     sql: ${total_gross_revenue} ;;
#     value_format_name: usd
#   }
#
#   measure: average_lifetime_revenue {
#     type: average
#     sql: ${total_gross_revenue} ;;
#     value_format_name: usd
#   }
#
#   measure: average_days_since_latest_order {
#     type: average
#     sql: ${days_since_latest_order} ;;
#   }
#
#   measure: average_months_since_latest_order {
#     type: average
#     sql: ${months_since_latest_order} ;;
#   }
#
#   measure: repeat_customer_count {
#     hidden: yes
#     type: count
#     filters: {
#       field: is_repeat_customer
#       value: "Yes"
#     }
#   }
#
#   measure: repeat_customer_percent {
#     type: number
#     sql: 1.0*${repeat_customer_count}/NULLIF(${count},0) ;;
#     value_format_name: percent_1
#   }
#
# }

view: cohort_facts {
  derived_table: {
    sql: SELECT
      order_items.user_id  AS user_id,
      MIN(order_items.created_at)  AS earliest_order,
      MAX(order_items.created_at)  AS latest_order,
      COUNT(DISTINCT order_items.order_id ) AS order_count,
      COALESCE(SUM(CASE WHEN (order_items.status  NOT IN ('Cancelled', 'Returned') OR order_items.status IS NULL) THEN order_items.sale_price  ELSE NULL END), 0) AS total_gross_revenue
    FROM public.users  AS users
    INNER JOIN public.order_items  AS order_items ON users.id = order_items.user_id

    WHERE order_items.order_id is not null
    GROUP BY 1
     ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: earliest_order {
    type: time
    sql: ${TABLE}.earliest_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: total_gross_revenue {
    type: number
    sql: ${TABLE}.total_gross_revenue ;;
  }

  set: detail {
    fields: [user_id, earliest_order_time, latest_order_time, order_count, total_gross_revenue]
  }
}

view: +cohort_facts {
  derived_table: {
    sql: SELECT

      gender ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
}
