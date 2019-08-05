
view: free_text {
  parameter: text_field_1 {type:string suggestable:no}
  dimension: text_field_1_value {
    type: string
    sql:  {% parameter text_field_1 %} ;;
  }
}
