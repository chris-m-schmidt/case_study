include: "/explores/order_items.explore"

view: daily_category_facts {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: order_items_count {}
      column: category { field: products.category }
      derived_column: order_items_count_per_category_rolling_average_7_day {
        sql: AVG(order_items_count) OVER (PARTITION BY category ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING);;
      }
      derived_column: difference_from_7_day_rolling_average_per_category {
        sql: 1.0*(order_items_count - AVG(order_items_count) OVER (PARTITION BY category ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING) )
          / AVG(order_items_count) OVER (PARTITION BY category ORDER BY created_date ROWS BETWEEN 8 PRECEDING AND 1 PRECEDING);;
      }
      filters: {
        field: order_items.created_date
        value: "8 days ago for 8 days"
      }
    }
  }
  dimension: created_date {
    hidden: yes
    type: date
  }
  dimension: order_items_count {
    hidden: yes
    type: number
  }
  dimension: category {
    hidden: yes}
  dimension: order_items_count_per_category_rolling_average_7_day {
    hidden: yes
    type: number
    value_format_name: decimal_1
  }

  dimension: difference_from_7_day_rolling_average_per_category {
    hidden: yes
    description: "This number in it's true form is a decimal. It is formatted as a percentage. (So if you filter on it, filter on >0.15)"
    type: number
    value_format_name: percent_1
  }
}

explore: +order_items {
  join: daily_category_facts {
#     fields: []
    relationship: many_to_one
    sql_on: ${order_items.created_date} = ${daily_category_facts.created_date}
    AND ${products.category} = ${daily_category_facts.category};;
  }
}
