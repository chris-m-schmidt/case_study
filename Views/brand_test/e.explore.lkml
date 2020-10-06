include: "*.view"

explore: a {
  join: b {
    type: cross
    relationship: many_to_many
  }
}
