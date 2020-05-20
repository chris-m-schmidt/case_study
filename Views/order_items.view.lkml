view: order_items {
  sql_table_name: public.order_items ;;

# -------------------- DIMENSIONS ---------------------------

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id;;
  }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  ##### { TESTING WORKAROUND FOR DIFFERENT DRILL BASED ON MEASURE VALUE

  measure: order_count_original {      # 1. This is your original measure
    hidden: yes
    type: count_distinct
    sql: ${order_id} ;;
    # 3. define an inclusive list of fields
    drill_fields: [order_id, delivered_date, returned_date]

  }

  measure: order_count_custom_drill { # 4. Create another version of the measure.
    hidden: yes
    sql: ${order_count};;     # 5. The SQL will just reference the measure above
    type: number              # 6. Type: number is a placeholder, since the aggregation
    link: {                   # logic (count_distinct, in this case) is defined above
      label: "Drill"          # 7. Add link to customize to the drill path defined above
      url:
      "{{ order_count._link }}
      {% if order_items.status._value == 'Complete' %}
      &fields=order_items.order_id,order_items.delivered_date
      {% elsif order_items.status._value == 'Returned' %}
      &fields=order_items.order_id,order_items.returned_date
      {% endif %}"
    }
  }

  ##### } TESTING WORKAROUND FOR DIFFERENT DRILL BASED ON MEASURE VALUE

  dimension_group: current {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_year,
      month,
      year,
      fiscal_month_num,
      fiscal_year
    ]
    sql: GETDATE() ;;
  }

  dimension_group: max_subquery {
    sql: select max( order_items.created_at) from public.order_items ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_year,
      month,
      year,
      fiscal_month_num,
      fiscal_year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: created_month_2 {
    type: date_month
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
    html: <b>{{ value }}</b> ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }



# ------------------- MEASURES ----------------------------

  measure: order_items_count {
    type: count
    drill_fields: [id]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [detail*]
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
    html:
    {% if value > 100000 %}
    <font color="darkgreen">{{ rendered_value }}</font>
    {% elsif value > 50 %}
    <font color="goldenrod">{{ rendered_value }}</font>
    {% else %}
    <font color="darkred">{{ rendered_value }}</font>
    {% endif %} ;;
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
    drill_fields: [users.gender, users.age_tier, average_spend_per_customer]
  }

  measure: average_gross_margin {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: average
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: order_items.status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Profit Metrics"
    drill_fields: [inventory_items.product_brand, inventory_items.product_category, average_gross_margin]
  }

  measure: total_gross_margin {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: sum
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: order_items.status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Profit Metrics"
    drill_fields: [inventory_items.product_brand, inventory_items.product_category, total_gross_margin]
  }

  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Revenue"
    type: number
    sql: ${total_gross_margin} / NULLIF(${total_gross_revenue},0) ;;
    value_format_name: percent_1
    group_label: "Revenue and Profit Metrics"
  }
  measure: earliest_order {
    type: date_time
    sql: MIN(${created_raw}) ;;
    convert_tz: no
  }

  measure: latest_order {
    type: date_time
    sql: MAX(${created_raw}) ;;
    convert_tz: no
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_cancelled {
    type: yesno
    sql: ${status} = 'Cancelled' ;;
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
    group_label: "Revenue and Profit Metrics"
    }

  measure: total_gross_revenue_from_existing_customers {
    description: "Total revenue from users who signed up with the website more than 90 complete days ago."
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "-Cancelled,-Returned"
    }
    value_format_name: usd
    group_label: "Revenue and Profit Metrics"
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
    sql: 1.0 * ${order_items.returned_items_count} / NULLIF(${order_items.order_items_count},0) ;;
    value_format_name: percent_1
    group_label: "Return Metrics"
  }

#   measure: returned_first_order_item {
#     hidden: yes
#     type: yesno
#     sql: ${returned_items_count} > 0 AND ${created_raw} = ${earliest_order} ;;
#     group_label: "Return Metrics"
#   }

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

### [ Percentile testing

  measure: percentile_90 {
    type: percentile
    percentile: 90
    sql: ${sale_price} ;;
    drill_fields: [sale_price, order_items_count]
  }

### ] Percentile testing


# --------------- FILTERS -------------------------------

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



# ---------------- SETS -----------------------------

set: customer_explore_field_set {
  fields: [
    order_items.user_id,
    order_items.created_date,
    order_items.created_month,
    order_items.status,
    order_items.order_items_count,
    order_items.order_count,
    order_items.customer_count,
    order_items.earliest_order,
    order_items.latest_order,
    order_items.total_sales,
    order_items.average_spend_per_customer,
    order_items.total_gross_revenue,
    order_items.total_gross_revenue_from_new_customers,
    order_items.total_gross_revenue_from_existing_customers,
    order_items.returned_items_count,
    order_items.returned_items_rate,
#     order_items.returned_first_order_item,
    order_items.customers_returning_items_count,
    order_items.percent_of_customers_with_returns,
  ]
}

# ----- Sets of fields for drilling ------
set: detail {
  fields: [
    id,
    users.id,
    users.first_name,
    users.last_name
#     inventory_items.id,
#     inventory_items.product_name
  ]
}
}
