#!/usr/bin/env -S v run

// TODO: extract into it's own repo and tool. This is a very basic implementation to lint commits with the conventional commit spec.
import os
import regex

debug := false // TODO: support debug mode

commit_msg_file := os.args[1] or { panic('missing commit message file') }
commit_msg := os.read_file(commit_msg_file) or { panic('failed to read commit message file') }

// TODO: support custom types
conventional_commits_types := ['fix', 'feat', 'build', 'chore', 'ci', 'docs', 'style', 'refactor',
	'perf', 'test']

// TODO: eforce entire ruleset, like spec rule #6 from - https://www.conventionalcommits.org/en/v1.0.0/#specification
conventional_commits_regex_query := r'(?P<type>\w+)(?P<optional_scope>\(\w\))?(?P<optional_breaking>\!)?(?P<break>\: )(?P<description>.*)'

mut re := regex.regex_opt(conventional_commits_regex_query) or { panic(err) }
start, end := re.match_string(commit_msg)

if start < 0 {
	println('----ERROR----')
	println('Commit message does not follow the conventional commit style')
	println('See https://www.conventionalcommits.org/en/v1.0.0/')
	println('---Conventional Commit Format----')
	println('<type>[optional scope]: <description')
	println('[optional body]')
	println('[optional footer(s)]')
	println('---------------------------------')
	exit(1)
}

if re.get_group_by_name(commit_msg, 'type') !in conventional_commits_types {
	println('----ERROR----')
	println('Commit message does not start with a conventional commit type')
	println('Valid types are: ${conventional_commits_types}\n')
	println('See https://www.conventionalcommits.org/en/v1.0.0/')
	println('-------------')
	exit(1)
}

if debug {
	println('String: ${commit_msg}')
	println('Query : ${re.get_query()}')
	if start >= 0 {
		println('Match : (${start}, ${end}) => ${commit_msg[start..end]}')
	}
}

if debug {
	for name in re.group_map.keys() {
		println("group:'${name}'\n\t[${re.get_group_by_name(commit_msg, name)}]\n\tbounds: ${re.get_group_bounds_by_name(name)}")
	}
}
