# view: cross {
#
#   measure: average_gross_margin {
#     description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
#     type: average
#     sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
#     filters: {
#       field: order_items.status
#       value: "-Cancelled,-Returned"
#     }
#     value_format_name: usd
#     group_label: "Revenue and Profit Metrics"
#     drill_fields: [inventory_items.product_brand, inventory_items.product_category, average_gross_margin]
#   }
#
#   measure: total_gross_margin {
#     description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
#     type: sum
#     sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
#     filters: {
#       field: order_items.status
#       value: "-Cancelled,-Returned"
#     }
#     value_format_name: usd
#     group_label: "Revenue and Profit Metrics"
#     drill_fields: [inventory_items.product_brand, inventory_items.product_category, total_gross_margin]
#   }
#
#   measure: gross_margin_percent {
#     description: "Total Gross Margin Amount / Total Revenue"
#     type: number
#     sql: ${total_gross_margin} / NULLIF(${order_items.total_gross_revenue},0) ;;
#     value_format_name: percent_1
#     group_label: "Revenue and Profit Metrics"
#   }
#   measure: earliest_order {
#     type: date_time
#     sql: MIN(${order_items.created_raw}) ;;
#     convert_tz: no
#   }
#
#   measure: latest_order {
#     type: date_time
#     sql: MAX(${order_items.created_raw}) ;;
#     convert_tz: no
#   }
#
#
# ##### { single table fields
#
#   dimension: status {
#     type: string
#     sql: order_items.status ;;
#   }
#
#   dimension: is_cancelled {
#     type: yesno
#     sql: ${status} = 'Cancelled' ;;
#   }
#
# ##### } single table fields
# }
#
#
#
#
#
