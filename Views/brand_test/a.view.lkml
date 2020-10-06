
view: a {
  derived_table: {
    sql:
    -- table a
      SELECT
        1 AS id, 10 AS order_id, 30 AS sale_price
      UNION ALL
      SELECT
        2 AS id, 10 AS order_id, 40 AS sale_price
      UNION ALL
      SELECT
        3 AS id, 11 AS order_id, 50 AS sale_price
      UNION ALL
      SELECT
        4 AS id, 11 AS order_id, 30 AS sale_price
      UNION ALL
      SELECT
        5 AS id, 12 AS order_id, 29 AS sale_price
      ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
  }
}
