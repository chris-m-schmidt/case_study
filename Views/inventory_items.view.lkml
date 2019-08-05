view: inventory_items {
  sql_table_name: public.inventory_items ;;


#-------------- DIMENSIONS ---------------

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
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

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    link: {
      label: "Google"
      url: "http://www.google.com/search?q={{ value | url_encode }}"
      icon_url: "http://google.com/favicon.ico"
    }
    link: {
      label: "Brand Comparison"
      url: "https://profservices.dev.looker.com/dashboards/107?Brand%20to%20Compare={{ value | url_encode }}"
      icon_url: "http://looker.com/favicon.ico"
    }

    drill_fields: [id, product_category, product_name]
  }

  dimension: brand_comparison {
    type: string
    sql:  CASE
            WHEN {% condition brand_to_compare %} ${product_brand} {% endcondition %} THEN ${product_brand}
            ELSE 'All Other Brands'
          END ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
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
    sql: ${TABLE}.sold_at ;;
  }


#-------------- MEASURES ---------------

  measure: count {
    type: count
    drill_fields: [id, product_name]
  }

  measure: average_cost {
    description: "Average cost of items sold from inventory"
    type: average
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    group_label: "Cost Metrics"
    }

  measure: total_cost {
    description: "Total cost of items sold from inventory"
    type: sum
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    group_label: "Cost Metrics"
  }


#---------------- FILTERS -----------------------

  filter: brand_to_compare {
    type: string
    suggest_explore: brand_comparison
    suggest_dimension: product_brand
  }
}
