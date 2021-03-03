- dashboard: old_dashboard
  title: Old Dashboard
  layout: newspaper
  preferred_viewer: dashboards
  elements:
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
    listen: {}
    row: 3
    col: 16
    width: 8
    height: 2
  - title: Products
    name: Products
    model: chris_case_study
    explore: order_items
    type: single_value
    fields: [inventory_items.count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 3
    col: 0
    width: 8
    height: 2
  - title: Revenue
    name: Revenue
    model: chris_case_study
    explore: order_items
    type: single_value
    fields: [order_items.total_sales]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    row: 3
    col: 8
    width: 8
    height: 2
  - name: Order Items by Brand
    title: Order Items by Brand
    model: chris_case_study
    explore: order_items
    type: looker_grid
    fields: [inventory_items.product_brand, order_items.order_count, inventory_items.total_cost]
    filters:
      order_items.created_date: 26 hours
      inventory_items.product_brand: ''
    sorts: [order_items.order_count desc]
    limit: 500
    column_limit: 50
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
    row: 5
    col: 0
    width: 13
    height: 6
  - name: User Location
    title: User Location
    model: chris_case_study
    explore: order_items
    type: looker_map
    fields: [users.count, users.state_2]
    sorts: [users.count desc]
    limit: 500
    column_limit: 50
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    series_types: {}
    defaults_version: 1
    row: 5
    col: 13
    width: 11
    height: 6
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      This dashboard contains information about bottom line sales, and breaks that out across different attributes of the user base. It should be used to keep a finger on the pulse for how sales are progressing throughout the year.

      If you need help understanding an individual KPI metric, see [data dictionary](url).
    row: 0
    col: 0
    width: 10
    height: 3
  - name: Summary of Looks
    title: Summary of Looks
    model: system__activity
    explore: dashboard
    type: looker_grid
    fields: [look.title, look.description]
    filters:
      dashboard.title: Business Pulse and User Overview
      dashboard_element.result_source: Saved Look
      look.title: "-Summary of Looks"
    sorts: [look.title]
    limit: 500
    query_timezone: America/New_York
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    x_axis_gridlines: false
    y_axis_gridlines: true
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
    row: 0
    col: 10
    width: 14
    height: 3
