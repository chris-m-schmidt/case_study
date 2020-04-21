view: users {
  sql_table_name: public.users ;;

  drill_fields: [id, email, city, created_date]

# --------------------------- DIMENSIONS -------------------

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

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${users.created_raw}, CURRENT_DATE) ;;
  }

  dimension: months_since_signup {
    type: number
    sql: DATEDIFF(month, ${users.created_raw}, CURRENT_DATE) ;;
  }

  dimension: months_since_signup_tier {
    type: tier
    tiers: [1, 4, 7, 10, 13, 19, 25]
    style: integer
    sql: ${months_since_signup} ;;
  }

  dimension: months_since_signup_tier_2 {
    type: tier
    tiers: [1, 2, 13, 25]
    style: integer
    sql: ${months_since_signup} ;;
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

  dimension: customer_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: state_2 {#Use with drill_link_for_state for custom drilling in map visualization
#     hidden: yes
    label: "State"
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    html: <b>{{rendered_value}}</b>;;
  }

  measure: drill_link_for_state {
    label: " " #uncomment after selecting the measure, otherwise you won't be able to see it in field picker!
#     hidden: yes
    type: sum
    sql: 1 ;;
    html:<a href="#drillmenu" target="_self">Drill by Practice
    <img src="https://i.imgur.com/oJcKRMW.jpg?1" style="width:12px; height:12px">
      ;;
    drill_fields: [city, users.count, order_items.order_count]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }


# ---------------------- MEASURES ----------------------------

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

  measure: average_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
  }

  measure: average_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
  }



# --------------------- FILTERS ------------------------------

  filter: is_before_minute_of_month {
    hidden: yes
    type: yesno
    sql:
        (EXTRACT(DAY FROM ${created_raw}) < EXTRACT(DAY FROM GETDATE())
          OR
          (
            EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE())
          )
          OR
          (
            EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM GETDATE()) AND
            EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM GETDATE())
          )
        ) ;;
  }


  filter: is_new_user {
#     hidden: yes
  description: "Users who have signed up with the website in the last 90 complete days."
  type: yesno
  sql: ${users.created_raw} >= DATEADD(day,-90, DATE_TRUNC('day', ${order_items.created_raw})) ;;
  }

  filter: is_existing_user {
    #     hidden: yes
    description: "Users who signed up with the website more than 90 complete days ago."
    type: yesno
    sql: ${users.created_raw} < DATEADD(day,-90, DATE_TRUNC('day', ${order_items.created_raw})) ;;
  }
}
