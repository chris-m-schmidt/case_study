# The purpose of this derived table is to get a rolling average of order_count

include: "/explores/order_items.explore"

view: daily_facts {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: order_items_count {}
      derived_column: order_items_count_rolling_average_7_day {
        sql: AVG(order_items_count) OVER (ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING);;
      }
      derived_column: difference_from_7_day_rolling_average {
        sql: 1.0*(order_items_count - AVG(order_items_count) OVER (ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING) )
          / AVG(order_items_count) OVER (ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING);;
      }
      filters: {
        field: order_items.created_date
        value: "8 days ago for 8 days"
      }
      timezone: UTC
    }
  }
  dimension: created_date {
    type: date
    primary_key: yes
    hidden: yes
  }
  dimension: order_items_count {
    type: number
    hidden: yes
  }
  dimension: order_items_count_rolling_average_7_day {
    hidden: yes
    type: number
    value_format_name: decimal_1
  }

  dimension: difference_from_7_day_rolling_average {
    hidden: yes
    description: "This number in it's true form is a decimal. It is formatted as a percentage. (So if you filter on it, filter on >0.15)"
    type: number
    value_format_name: percent_1
  }
}

explore: +order_items {
  join: daily_facts {
    relationship: many_to_one
    sql_on: ${order_items.created_date} = ${daily_facts.created_date};;
  }
}
