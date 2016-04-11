source "settings.tcl"
source "project_generator.tcl"

open_project [file join $project_directory $project_name]

launch_runs synth_1 -job 8
wait_on_run synth_1

launch_runs impl_1 -job 8
wait_on_run impl_1

launch_runs impl_1 -to_step write_bitstream -job 8
wait_on_run impl_1

close_project

