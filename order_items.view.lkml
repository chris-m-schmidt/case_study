view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sales Metrics"
  }

  measure: total_sales {
    description: "Total sales from items sold"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Sales Metrics"
  }

  measure: year_to_date_total_sales {
    description: "Total sales from beginning of year to today's date"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: is_before_hour_of_year
      value: "yes"
    }
    group_label: "Sales Metrics"
  }

  measure: cumulative_total_sales {
    description: "Cumulative total sales from items sold (also known as a running total)"
    type: running_total
    sql: ${total_sales} ;;
    value_format_name: usd
    group_label: "Sales Metrics"
  }

  measure: average_spend_per_customer {
    description: "Total Sale Price / total number of customers"
    type: number
    sql: ${total_sales} / NULLIF(${customer_count},0) ;;
    value_format_name: usd
    group_label: "Sales Metrics"
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: total_gross_revenue_from_new_customers {
    description: "Total revenue from users who have signed up with the website in the last 90 complete days."
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
      }
    filters: {
      field: order_items.is_new_user
      value: "yes"
    }
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: total_gross_revenue_from_existing_customers {
    description: "Total revenue from users who signed up with the website more than 90 complete days ago."
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
    }
    filters: {
      field: order_items.is_existing_user
      value: "yes"
    }
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: average_cost {
    description: "Average cost of items sold from inventory"
    type: average
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: total_cost {
    description: "Total cost of items sold from inventory"
    type: sum
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: average_gross_margin {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: average
    sql: ${sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: total_gross_margin {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: sum
    sql: ${sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Cost Metrics"
  }

  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Revenue"
    type: number
    sql: ${total_gross_margin} / NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_1
    group_label: "Revenue and Cost Metrics"
  }

  measure: returned_items_count {
    description: "Number of items that were returned by dissatisfied customers"
    type: count
    filters: {
      field: status
      value: "Returned"
    }
    group_label: "Return Metrics"
  }

  measure: returned_items_rate {
    description: "Number of Items Returned / total number of items sold"
    type: number
    sql: 1.0 * ${order_items.returned_items_count} / NULLIF(${order_items.count},0) ;;
    value_format_name: percent_1
    group_label: "Return Metrics"
  }

  measure: customer_count {
    hidden: yes
#     description: "A customers is a user who has placed at least one order."
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: customers_returning_items_count {
    description: "Number of customers who have returned an item at some point"
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: status
      value: "Returned"
    }
    group_label: "Return Metrics"
  }

  measure: percent_of_customers_with_returns {
    description: "Number of Customer Returning Items / total number of customers"
    type: number
    sql: 1.0 * ${customers_returning_items_count} / NULLIF(${customer_count},0) ;;
    value_format_name: percent_1
    group_label: "Return Metrics"
  }

  filter: is_before_hour_of_year {
    hidden: yes
    type: yesno
    sql:
        (EXTRACT(MONTH FROM ${created_raw}) < EXTRACT(MONTH FROM GETDATE())
          OR
          (
            EXTRACT(MONTH FROM ${created_raw}) = EXTRACT(MONTH FROM GETDATE()) AND
            EXTRACT(DAY FROM ${created_raw}) < EXTRACT(DAY FROM GETDATE())
          )
          OR
          (
            EXTRACT(MONTH FROM ${created_raw}) = EXTRACT(MONTH FROM GETDATE()) AND
            EXTRACT(DAY FROM ${created_raw}) <= EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE())
          )
        ) ;;
  }

  filter: is_new_user {
#     hidden: yes
    description: "Users who have signed up with the website in the last 90 complete days."
    type: yesno
    sql: ${users.created_raw} >= DATEADD(day,-90, DATE_TRUNC('day', ${order_items.created_raw})) ;;
  }

  filter: is_existing_user {
#     hidden: yes
    description: "Users who signed up with the website more than 90 complete days ago."
    type: yesno
    sql: ${users.created_raw} < DATEADD(day,-90, DATE_TRUNC('day', ${order_items.created_raw})) ;;
  }

  set: customer_explore_field_set {
    fields: [
      order_items.user_id,
      order_items.created_date,
      order_items.status,
      order_items.count,
      order_items.customer_count,
      order_items.total_sales,
      order_items.average_spend_per_customer,
      order_items.total_gross_revenue,
      order_items.total_gross_revenue_from_new_customers,
      order_items.total_gross_revenue_from_existing_customers,
      order_items.customers_returning_items_count,
      order_items.percent_of_customers_with_returns,
      order_items.is_new_user,
      order_items.is_existing_user
    ]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
