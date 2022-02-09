# tsc.fish 🌪
This is a simple fish plugin to source all fish files in `functions`, `completions` and `conf.d` directories under the current directory. Use this plugin for testing your fish plugin. "tsc" is the abbriviation of "**T**est **S**our**C**e

## Installation 🚰

Using [fisher](https://github.com/jorgebucaran/fisher):

```console
fisher install yo-goto/tsc.fish
```

Update

```console
fisher update yo-goto/tsc.fish
```

## Usage

```console
$ tsc
Current: /Projects/ggl.fish
Source fish files in this project? [Y/n]: y
-->complete: ./functions/fin.fish ./functions/ggl.fish
-->complete: ./completions/fin.fish ./completions/ggl.fish
-->complete: ./conf.d/ggl.fish
```