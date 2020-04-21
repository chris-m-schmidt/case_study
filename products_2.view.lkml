explore: products_2 {}

view: products_2 {
  sql_table_name: public.products ;;


# --------- DIMENSIONS --------------

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    case: {
      when: {
        sql: ${TABLE}.department = 'Women' ;;
        label: "Women"
      }
      when: {
        sql: ${TABLE}.department = 'Men' ;;
        label: "Men"
      }
    }
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

#   dimension: brand_comparison {
#     type: string
#     sql:  CASE
#             WHEN {% condition brand_to_compare %} ${brand} {% endcondition %} THEN ${brand}
#             ELSE 'All Other Brands'
#           END ;;
#   }


#----------- MEASURES ------------

measure: count {
  type: count
}


#---------- FILTERS -----------

#   filter: brand_to_compare {
#     type: string
#     suggest_explore: brand_comparison
#     suggest_dimension: products.brand
#   }
}
