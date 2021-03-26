explore: sku_facts {}
view: sku_facts {
  derived_table: {#quick change
    explore_source: order_items {
      column: total_sales {}
      column: sku { field: products.sku }
      column: customers_returning_items_count {}
      # bind_all_filters: yes
    }
  }
  dimension: sku {primary_key:yes}
  dimension: sku_lifetime_total_sales {
    description: "Total sales from items sold"
    value_format: "$#,##0.00"
    type: number
    sql: ${TABLE}.total_sales ;;
  }
  # dimension: customers_returning_items_count {
  #   description: "Number of customers who have returned an item at some point"
  #   type: number
  # }
  measure: average_sales {
    type: average
    sql: ${sku_lifetime_total_sales} ;;
  }
}
