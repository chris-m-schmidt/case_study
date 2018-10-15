view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name]
  }

  measure: month_to_date_user_count {
    type: count
    filters: {
      field: is_before_minute_of_month
      value: "yes"
    }
  }

  filter: is_before_minute_of_month {
    hidden: yes
    type: yesno
    sql:
        (EXTRACT(DAY FROM ${TABLE}.created_at) < EXTRACT(DAY FROM GETDATE())
          OR
          (
            EXTRACT(DAY FROM ${TABLE}.created_at) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${TABLE}.created_at) < EXTRACT(HOUR FROM GETDATE())
          )
          OR
          (
            EXTRACT(DAY FROM ${TABLE}.created_at) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${TABLE}.created_at) <= EXTRACT(HOUR FROM GETDATE()) AND
            EXTRACT(MINUTE FROM ${TABLE}.created_at) < EXTRACT(MINUTE FROM GETDATE())
          )
        ) ;;
  }

  filter: is_new_user {
    description: "Users who have signed up with the website in the last 90 complete days."
    type: yesno
    sql: ${TABLE}.created_at >= DATEADD(day,-90, DATE_TRUNC('day', GETDATE())) ;;
  }

  filter: is_customer {
    description: "A customers is a user who has placed at least one order."
    type: yesno
    sql: ${TABLE}.id = ${order_items.user_id} ;;
  }
}
