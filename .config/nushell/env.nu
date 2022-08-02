# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = ($env.PWD)

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str collect)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

# CUSTOM Configs
#
# starship config
let-env STARSHIP_CONFIG = ($env.HOME + '/.config/starship/config.toml')
# asdf config
let-env ASDF_CONFIG_FILE = ($env.HOME + '/.config/asdf/.asdfrc')
# github cli config
let-env BROWSER = "wslview"

# PATH: lsit of paths to append to PATH
let paths_to_append = [
  # macOS for some reason was not explicitly adding the following to PATH
  # Starship requires /urs/local/bin to be in PATH
  '/usr/local/bin',
  '/usr/local/sbin',
  # Zoxide - is installed via webi: curl -sS https://webinstall.dev/zoxide | bash
  ($env.HOME + '/.local/bin'),
  # asdf bins & shims
  ($env.HOME + '/.asdf/bin'),
  ($env.HOME + '/.asdf/shims')
]
# PATH: append to PATH if not already in PATH
let-env PATH = ($env.PATH | append ($paths_to_append | where $it not-in $env.PATH))

# TODO(jthegedus): validate this works
let-env rm_always_trash = true

# Aliases
#
alias ll = ls -al
alias upd = sudo apt-get update
alias upg = sudo apt-get upgrade -y
alias ar = sudo apt-get autoremove -y
alias q = cd ~
alias pj = cd ~/projects
alias df = (^df | detect columns | drop column | into filesize 1K-blocks Used Available)
alias cat = batcat
alias bat = batcat
alias fd = fdfind
alias lg = git log --all --decorate --oneline --graph
alias gcurl = curl --header Authorization: Bearer $(gcloud auth print-identity-token)
