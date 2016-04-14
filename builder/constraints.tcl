# Add constraint files
add_files -fileset constrs_1 -norecurse $design_constraint_file

# Add BlockDesign and generate wrapper
if {[info exists design_bd_tcl_file]} {
    source $design_bd_tcl_file
    regenerate_bd_layout
    save_bd_design
    set design_bd_name  [get_bd_designs]
    make_wrapper -files [get_files $design_bd_name.bd] -top -import
}

