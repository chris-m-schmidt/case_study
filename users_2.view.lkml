view: users_2 {
#   sql_table_name: public.users ;;
  derived_table: {
    sql:  select * from public.users
          where {% condition order_items.derived_table_date_filter %} users.created_at {% endcondition %}
    ;;
  }


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

  parameter: tier_selector {
    type: unquoted
    allowed_value: {
      label: "Tier 1"
      value: "tier_1"
    }
    allowed_value: {
      label: "Tier 2"
      value: "tier_2"
    }
  }

  dimension: age_tier_1 {
    hidden: yes
    type: tier
    sql: ${TABLE}.age ;;
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
    style: integer
  }

  dimension: age_tier_2 {
    hidden: yes
    type: tier
    sql: ${TABLE}.age ;;
    tiers: [0, 20, 40, 60, 80]
    style: interval
  }

  dimension: dynamic_age_tier {
    label_from_parameter: tier_selector
    sql:
    {% if tier_selector._parameter_value == 'tier_1' %}
      ${age_tier_1}
    {% else %}
      ${age_tier_2}
    {% endif %};;
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

  dimension: zoom_value {
    type: number
    sql: 6 ;;
  }

  dimension: state {
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
    link: {
      label: "Test Treemap Drill"
#       url: "https://profservices.dev.looker.com/dashboards/VNdC28OQOQiNLv8XXPjKC3?State={{ value }}"
      url: "/dashboards/VNdC28OQOQiNLv8XXPjKC3?State={{ value }}"

    }
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: zip_2 {
    type: number
    sql: ${zip} ;;
    value_format: "0"
  }

# ---------------------- MEASURES ----------------------------

  measure: count {
    type: count
#     drill_fields: [id, last_name, first_name]
    drill_fields: [state, count]
#     html:  <p style="color: black; font-size: 150%; background: silver"> {{linked_value}} </p> ;;
    link: {
      label: "Drill as Map"
      url: "
      {% assign vis_config = '{\"type\": \"looker_map\"}' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    }
    link: {
      label: "Drill as Table"
      url: "
      {% assign vis_config = '{\"type\": \"table\"}' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    }
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
    sql: ${days_since_signup}_signup} ;;
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
