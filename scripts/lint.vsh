#!/usr/bin/env -S v run

import os

repo_root_dir := os.norm_path(os.join_path(@FILE, '..', '..'))

println('linting files in ${repo_root_dir}')
print(os.execute_or_exit('v fmt -verify ${repo_root_dir}').output)
print(os.execute_or_exit('v vet ${repo_root_dir}').output)
println('PASSED')
