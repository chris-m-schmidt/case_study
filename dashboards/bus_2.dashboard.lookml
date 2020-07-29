- dashboard: business_stuff2
  title: Business Stuff2
  layout: newspaper
  elements:
  - title: Recent Orders
    name: Recent Orders
    model: second_connection
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
    model: second_connection
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
  - title: New Tile
    name: New Tile
    model: fashionly_jc
    explore: order_items
    type: looker_pie
    fields: [order_items.status, order_items.count]
    filters:
      order_items.created_date: 7 days
    sorts: [order_items.count desc]
    limit: 500
    column_limit: 50
    value_labels: legend
    label_type: labPer
    inner_radius: 45
    color_application:
      collection_id: aed851c8-b22d-4b01-8fff-4b02b91fe78d
      palette_id: e26878fa-802e-47d9-9478-62fb4307f763
      options:
        steps: 5
    series_colors: {}
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    row: 6
    col: 0
    width: 8
    height: 6
  filters:
  - name: Brand
    title: Brand
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: second_connection
    explore: order_items
    listens_to_filters: []
    field: inventory_items.product_brand
