#!/usr/bin/env -S v run

import os

repo_root_dir := os.norm_path(os.join_path(@FILE, '..', '..'))

println('formatting files in ${repo_root_dir}')
print(os.execute_or_exit('v fmt -w ${repo_root_dir}').output)
println('PASSED')
