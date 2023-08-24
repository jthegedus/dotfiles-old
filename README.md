<div align="center">

# Dotfiles & Developer Environment

Cross-platform dotfiles & developer environment.

</div>

```shell
TODO: curl binary
```

## Features

- symlink files recursively from one directory to another
  - EG: symlink files under `home/**` to `$HOME/`
- install tools from provided `tools.json` file

---

- find binary alternative(s) to [thefuck](https://github.com/nvbn/thefuck)
- per-directory gitconfigs like https://stackoverflow.com/a/43884702
	- global with includes to per-dir configs: `~/.gitconfig` -> symlinked to `~/projects/dotfiles/gitconfigs/.global.gitconfig`
	- personal: `~/projects/dotfiles/gitconfigs/.personal.gitconfig`
	- work: `~/projects/dotfiles/gitconfigs/.work.gitconfig`

## License

[MIT License](LICENSE) © [James Hegedus](https://github.com/jthegedus/)
