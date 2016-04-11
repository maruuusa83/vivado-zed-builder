source "settings.tcl"

open_project [file join $project_directory $project_name]

### generate workspace ###
set sdk_workspace [file join $project_directory $project_name.sdk]
if { [file exists $sdk_workspace] == 0 } {
    file mkdir $sdk_workspace
}

### export hardware ###
set design_top_name [get_property "top" [current_fileset]]
file copy -force [file join $project_directory $project_name.runs "impl_1" $design_top_name.sysdef] \
                 [file join $sdk_workspace $design_top_name.hdf]

close_project

