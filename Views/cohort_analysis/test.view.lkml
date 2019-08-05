explore: dt1 {}
view: dt1 {

  # GOAL: IF filter is empty, don't build SQL query part of union.
  # ISSUE: No way to reference filter in liquid UNLESS it's a condition
  # Figured out syntax for that, next issue is you can't select multiple items in a case statement
  derived_table: {
    sql:

    {% if dt1.order_id_filter._is_filtered %}
    SELECT order_id as id, shipped_at as date FROM public.order_items
    WHERE {% condition order_id_filter %} order_id {% endcondition %}

    UNION ALL
    {% endif %}

    SELECT id as id, created_at as date FROM public.events
    WHERE {% condition event_id_filter %} id {% endcondition %}

    ;;
  }

  filter: order_id_filter {}

  filter: event_id_filter {}

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: date {
    type: time
    sql: ${TABLE}.date ;;
    timeframes: [date]
  }

}




#
#
# sql:
# with has_order_selected as
# (select case when {% condition order_id_filter %} '' {% endcondition %} then null else 1 end)
#
# SELECT order_id as id, shipped_at as date FROM public.order_items
# WHERE {% condition order_id_filter %} order_id {% endcondition %} AND has_order_selected = 1
#
# UNION ALL
#
# SELECT id, created_at FROM public.events
# WHERE {% condition event_id_filter %} id {% endcondition %}
#
# ;;
