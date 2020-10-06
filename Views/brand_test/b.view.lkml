
view: b {
  derived_table: {
    sql:
    -- table b
      SELECT
        6 AS id, 13 AS order_id, 30 AS sale_price
      UNION ALL
      SELECT
        7 AS id, 14 AS order_id, 40 AS sale_price
      UNION ALL
      SELECT
        8 AS id, 15 AS order_id, 50 AS sale_price
      UNION ALL
      SELECT
        9 AS id, 15 AS order_id, 30 AS sale_price
      UNION ALL
      SELECT
        10 AS id, 15 AS order_id, 29 AS sale_price

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
