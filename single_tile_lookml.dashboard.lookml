- dashboard: single_tile_lookml_dashboard
  title: Single Tile LookML Dashboard
  layout: newspaper
  elements:
  - title: tile
    name: tile
    model: chris_case_study
    explore: users
    type: looker_column
    fields: [order_items.average_gross_margin, users.months_since_signup_tier_2]
    filters:
      users.months_since_signup_tier_2: Below 1,13 to 24
    sorts: [users.months_since_signup_tier_2]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
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
    series_colors:
      order_items.average_gross_margin: "#82c2ca"
      order_items.total_gross_margin: "#9fdee0"
    defaults_version: 1
    row: 0
    col: 0
    width: 8
    height: 6
