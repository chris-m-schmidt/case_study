- dashboard: extended
  title: Extended
  extends: base
  layout: tile
  tile_size: 100
  elements:
  - name: order_items_by_brand
    title: Untitled Visualization
    model: chris_case_study
    explore: order_items
    type: looker_grid
    fields: [inventory_items.product_brand, order_items.items_count]
    filters:
      order_items.created_date: 26 hours
      inventory_items.product_brand: ''
    sorts: [order_items.items_count desc]
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
    row: 2
    col: 0
    width: 8
    height: 6
