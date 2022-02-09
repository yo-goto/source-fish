# tsc.fish 🌪
This is a simple fish plugin to source all fish files in `functions`, `completions` and `conf.d` directories under the current directory. Use this plugin for testing your fish plugin. "tsc" is the abbriviation of "**T**est **S**our**C**e".

## Installation 🎣

Using [fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install yo-goto/tsc.fish
```

Update

```console
fisher update yo-goto/tsc.fish
```

## Usage 🔦

If your current directory structure is like this, `tsc` finds all fish files in `comptions`, `functions` and `conf.d` directories, and then source them at once. (This example is my [ggl.fish](https://github.com/yo-goto/ggl.fish) plugin)

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
$ tsc
Current: /Projects/ggl.fish
Source fish files in this project? [Y/n]: y
-->complete: ./functions/fin.fish ./functions/ggl.fish
-->complete: ./completions/fin.fish ./completions/ggl.fish
-->complete: ./conf.d/ggl.fish
```