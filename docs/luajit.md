# Using LuaJIT with sequence.lua

This guide explains how to use [LuaJIT](https://luajit.org/) as the runtime for child processes launched from `sequence.lua`.

## Key Usage: LUA_COMMAND Environment Variable

`sequence.lua` launches child processes using the interpreter specified by the `LUA_COMMAND` environment variable. By default, this is `lua`, but you can override it to use `luajit`:

```bash
LUA_COMMAND=luajit lua sequence.lua [options]
```
or
```bash
LUA_COMMAND=luajit luajit sequence.lua [options]
```

This ensures that all child processes spawned by `sequence.lua` will use `luajit` as the interpreter.

## Why LuaJIT?
LuaJIT is a Just-In-Time Compiler for Lua, offering significant performance improvements over the standard Lua interpreter. For installation instructions, visit the [official LuaJIT website](https://luajit.org/).


## More Information
- [LuaJIT Project](https://luajit.org/)
- [sequence.lua Source](../sequence.lua)
