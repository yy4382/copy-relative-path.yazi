# copy-relative-path.yazi

A [Yazi](https://yazi-rs.github.io) plugin that copies the relative path of the hovered file to the nearest git repository root.

## Install

```bash
ya pkg add yy4382/copy-relative-path.yazi
```

## Usage

Add to your `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on   = ["c", "r"]
run  = "plugin copy-relative-path"
desc = "Copy relative path to git root"
```
