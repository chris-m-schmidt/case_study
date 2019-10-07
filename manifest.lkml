project_name: "chris_case_study"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
local_dependency: {
  project: "taylor_project_import"
  override_constant: domain {
    value: "alksdhdf"
  }
}
