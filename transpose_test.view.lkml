explore: transpose_test {
  always_filter: {
    filters: {
      field: date_filter
    }
  }
}

view: transpose_test {
  sql_table_name: public.order_items ;;

  filter: date_filter {
    convert_tz: no
    type: date
  }

  dimension: created_at_date {
    convert_tz: no
    type: date
    sql: ${TABLE}.created_at ;;
  }

  dimension: sale_price {
    hidden: yes
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price_start_date {
    label: "Starting Sale Price"
    type: sum
    sql:
        CASE
            WHEN ${created_at_date} = DATE({% date_start date_filter %}) THEN ${sale_price}
            ELSE NULL
        END
    ;;
    value_format_name: usd
  }

  measure: total_sale_price_end_date {
    label: "Ending Sale Price"
    type: sum
    sql:
        CASE
            WHEN ${created_at_date} = DATE({% date_end date_filter %}) THEN ${sale_price}
            ELSE NULL
        END
    ;;
    value_format_name: usd
  }

  measure: percent_change {
    label: "% Change"
    type: number
    sql: (${total_sale_price_end_date} - ${total_sale_price_start_date}) / NULLIF(${total_sale_price_start_date},0) ;;
    value_format_name: percent_1
  }
}
