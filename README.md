# godot-lsp-wsl-bridge.nvim
Small bridge between Windows Godot's LSP server and WSL Neovim's client.

# Why not use [`godot-wsl-lsp`](https://github.com/lucasecdb/godot-wsl-lsp) ?

At the time I didn't want to have to deal with `node.js`.

# Set up

## WSL and Godot configuration

Follow the instructions from this gist: https://gist.github.com/lucasecdb/2baf6d328a10d7fea9ec085d868923a0 (forked in case it becomes unavailable: https://gist.github.com/Shakadak/7cfbbce830667f4af91712367c61d1b5)

If I remember correctly, I did the mirrored networking for WSL2, and the following for Godot:
- Open a project, menu `Editor > Editor Settings...`, check `Advanced Settings`,  go to section `Text Editor`, subsection `External`.
- Check `Use External Editor`.
- `Exec Path` : Input the path to your `nvim.cmd` (batch program, ensure it is executable).
- `Exec Flags` : `{file} {line} {col}`.

## Neovim configuration

By default, Godot runs its language server on port 6005. The default config of this bridge uses the same.

So you should only have to add in your own config:
```lua
vim.lsp.enable("gdscript")
```

If you changed the port, you can configure the language server like so:
```lua
vim.lsp.config("gdscript", {
    GDScript_Port = 6105,
})
```

Or by setting the environment variable `GDScript_Port=6205 nvim --listen /tmp/godot.pipe`.

# Logs

Some logs are written `/tmp/nvimdebug.log` in order to check if their are LSP methods that need to have some path conversions to be done.
