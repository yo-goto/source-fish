# source-fish 🌪
This is a simple fish plugin to source all fish files in `functions`, `completions` and `conf.d` directories under the current directory. Use this plugin for testing your fish plugin. Changed privious repo name "tsc.fish" to "source-fish" in order to avoid conflict TypeScript compiler command "tsc".

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
-->complete: ./functions/fin.fish ./functions/ggl.fish
-->complete: ./completions/fin.fish ./completions/ggl.fish
-->complete: ./conf.d/ggl.fish
```

## Options ⚙️

- `-t`, `--test` : find `test` directory, and source fish files inside it
- `-a`, `--all` : find all fish files in the current directory and the subdirectories