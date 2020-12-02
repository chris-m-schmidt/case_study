include: "events_base.view"

view: +events {

  dimension: longitude {
    description: "alksdhf"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  measure: count_sources {
    type: count_distinct
    sql: ${traffic_source} ;;
  }
}


view: +events {

  dimension: longitude {
    description: "different "
    type: number
    sql: ${TABLE}.longitude ;;
  }

  measure: count_sources {
    type: count_distinct
    sql: ${traffic_source} ;;
  }
}
