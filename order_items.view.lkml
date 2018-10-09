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
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "Complete"
    }
    value_format_name: usd
  }

  measure: total_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
  }

  measure: average_cost {
    type: average
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
  }

  measure: total_gross_margin {
    type: sum
    sql: ${sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: status
      value: "Complete"
    }
    value_format_name: usd
  }

  measure: average_gross_margin {
    type: average
    sql: ${sale_price} - ${inventory_items.cost} ;;
    filters: {
      field: status
      value: "Complete"
    }
    value_format_name: usd
  }

  measure: gross_margin_percent {
    type: number
    sql: (${total_gross_margin} / ${total_gross_revenue})*100 ;;
    value_format_name: percent_1
  }

  measure: returned_items_count {
    type: count
    filters: {
      field: status
      value: "Returned"
    }
  }

  measure: returned_items_rate {
    type: number
    sql: (${returned_items_count}/${count})*100 ;;
    value_format_name: percent_1
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
