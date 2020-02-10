explore: add_new_row {
  always_filter: {
    filters: {
      field: created_date
    }
  }
}

view: results {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: total_sales {}
    }
#     sql: select date(created_at) as created_date, sum(sale_price) as total_sales
#           from public.order_items
#           where {% condition add_new_row.created_date %} created_date {% endcondition %}
#           group by 1
#     ;;
  }
}

view: add_new_row {
  derived_table: {
    sql:  select *
          , created_date::varchar as transpose_col
          , first_value(total_sales) over(order by created_date rows between unbounded preceding and unbounded following) as first_value
          , last_value(total_sales) over(order by created_date rows between unbounded preceding and unbounded following) as last_value
          from ${results.SQL_TABLE_NAME} as x
          where {% condition add_new_row.created_date %} created_date {% endcondition %}
          union all
          select NULL, NULL, '% Change' as transpose_col, x.first_value, x.last_value
    ;;
  }

  filter: created_date {
    type: date
  }

  dimension: transpose_col {
    type: string
    sql: ${TABLE}.transpose_col ;;
  }

  dimension: total_sales {
    type: number
    value_format_name: usd
  }

  dimension: first_value {
    type: number
    value_format_name: usd
  }
}
