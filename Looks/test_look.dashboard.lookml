- dashboard: test_look
  title: Test Look
  layout: tile
  tile_size: 100

  filters:

  elements:
    - name: hello_world
      type: looker_column

- name: add_a_unique_name_1590701520
  title: Untitled Visualization
  model: pop
  explore: pop_parameters_with_custom_range
  type: looker_column
  fields: [pop_parameters_with_custom_range.period, pop_parameters_with_custom_range.total_sale_price]
  filters:
    pop_parameters_with_custom_range.current_date_range: 1 months
    pop_parameters_with_custom_range.previous_date_range: 2 months ago for 1 month
  sorts: [pop_parameters_with_custom_range.total_sale_price desc]
  limit: 500
  query_timezone: America/Denver
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
