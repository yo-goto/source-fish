# source-fish 🍣🥢
This is a simple fish plugin to source all fish files in `functions`, `completions`, and `conf.d` directories under the current directory. Use this plugin for testing your fish plugin. You can also source fish files in the config directory (usually `~./.config/fish`).

I changed the previous repo & command name "tsc.fish" to "source-fish" for avoiding conflict against the TypeScript compiler command "tsc".

## Installation 🎣

Using [fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install yo-goto/source-fish
```

Update

```console
fisher update yo-goto/source-fish
```

## Usage 🔦

```console
Usage:
      source-fish [OPTION]
      source-fish DIRECOTRIES...
Options
      -v, --version   Show version info
      -h, --help      Show help
      -a, --all       Source all fish files under the current directory
      -t, --test      Source all fish files in the "test" folder
      -c, --config    Source fish files in the config directory
```

If your current directory structure is like this, `source-fish` finds all fish files in `comptions`, `functions` and `conf.d` directories, and then source them at once. (This example is my [ggl.fish](https://github.com/yo-goto/ggl.fish) plugin)

```console
.
├── CHANGELOG.md
├── LICENSE
├── README.md
├── completions
│   ├── fin.fish
│   └── ggl.fish
├── conf.d
│   └── ggl.fish
└── functions
    ├── fin.fish
    └── ggl.fish
```

```console
$ source-fish
Current: /Projects/ggl.fish
Source fish files in this project? [Y/n]: y
-->complete: ./functions/ggl.fish
-->complete: ./functions/fin.fish
-->complete: ./completions/ggl.fish
-->complete: ./completions/fin.fish
-->complete: ./conf.d/ggl.fish
```

You can also source all fish files inside the specific directories under the current directory using arguments. After `source-fish `, use the Tab key to show auto-suggestions.

```console
$ source-fish functions/ conf.d/
found fish files:
./functions/ggl.fish
./functions/fin.fish
./conf.d/ggl.fish
Source these fish files? [Y/n]: y
-->complete: ./functions/ggl.fish
-->complete: ./functions/fin.fish
-->complete: ./conf.d/ggl.fish
```

You can also source bulk fish files in the config direcotry (to check your config dir, use `echo $__fish_config_dir`). To do so, use `-c` or `--config` option flag. In this option mode, you can interactively select a directory to source.

```console
$ source-fish --config
Config [a/all | t/top | c/conf | f/functons | p/completions | e/exit]: p
Source? [s/source | l/ls&source | t/test | b/back | e/exit ]: t
-->found: /Users/userName/.config/fish/completions/ggl.fish
-->found: /Users/userName/.config/fish/completions/tide.fish
-->found: /Users/userName/.config/fish/completions/fish_logo.fish
-->found: /Users/userName/.config/fish/completions/source-fish.fish
-->found: /Users/userName/.config/fish/completions/fin.fish
-->found: /Users/userName/.config/fish/completions/to.fish
Source? [s/source | l/ls&source | t/test | b/back | e/exit ]: l
-->complete: /Users/userName/.config/fish/completions/ggl.fish
-->complete: /Users/userName/.config/fish/completions/tide.fish
-->complete: /Users/userName/.config/fish/completions/fish_logo.fish
-->complete: /Users/userName/.config/fish/completions/source-fish.fish
-->complete: /Users/userName/.config/fish/completions/fin.fish
-->complete: /Users/userName/.config/fish/completions/to.fish
```

In the second question, you can check the selected fish files with `t` or `test` without sourcing. To source files and check the results at the same time, type `l` or `ls`. To go back to select config, type `b` or `back`. Typing `s` or `source` results in sourcing fish files in the selected directory without printing results.

## Change Log 🔖

- [CHANGELOG.md](/CHANGELOG.md)

