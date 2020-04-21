- dashboard: base
  title: Business Stuff
  layout: newspaper
  elements:
  - title: Recent Orders
    name: Recent Orders
    model: chris_case_study
    explore: order_items
    type: looker_grid
    fields: [inventory_items.product_brand, order_items.link]
    filters:
      order_items.created_date: 26 hours
    limit: 500
    query_timezone: America/Denver
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Brand: inventory_items.product_brand
    row: 0
    col: 0
    width: 11
    height: 6
  - title: New users
    name: New users
    model: chris_case_study
    explore: order_items
    type: single_value
    fields: [users.count]
    filters:
      users.days_since_signup: '1'
    limit: 500
    series_types: {}
    listen:
      Brand: inventory_items.product_brand
    row: 0
    col: 11
    width: 8
    height: 6
  filters:
  - name: Brand
    title: Brand
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: chris_case_study
    explore: order_items
    listens_to_filters: []
    field: inventory_items.product_brand
