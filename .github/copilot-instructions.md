# mandel-lua

Pure Lua Mandelbrot set renderer that generates high-quality BMP images and animated sequences. Works with both standard Lua and LuaJIT (LuaJIT provides 100x+ performance improvement).

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Install Dependencies
- Install Lua: `sudo apt install -y lua5.4 && sudo ln -sf /usr/bin/lua5.4 /usr/bin/lua`
- Install LuaJIT (STRONGLY RECOMMENDED): `sudo apt install -y luajit`
- Install ffmpeg for sequences/GIFs: `sudo apt install -y ffmpeg`
- Verify installation: `lua -v && luajit -v && ffmpeg -version`

### Build and Test
- **No build process required** - pure interpreted Lua code
- Run tests: `lua test.lua` - takes <1 second, should show "Tests passed: 13, failed: 0"
- NEVER CANCEL: All commands complete quickly (<5 minutes max)

### Run Single Image Generation
- Basic usage: `lua main.lua` or `luajit main.lua` (default: 900x600 image)
- With LuaJIT: `luajit main.lua -w 3000 -h 2000` - takes ~4 seconds. NEVER CANCEL. Set timeout to 10+ minutes for safety.
- With standard Lua: `lua main.lua -w 900 -h 600` - takes ~37 seconds. NEVER CANCEL. Set timeout to 60+ minutes.
- Help: `lua main.lua --help`

### Run Sequence Generation
- Basic sequence: `LUA_COMMAND=luajit luajit sequence.lua -s 10` 
- With GIF output: `LUA_COMMAND=luajit luajit sequence.lua -s 10 -g`
- CRITICAL: Always set LUA_COMMAND=luajit for performance (100x faster than standard Lua)
- NEVER CANCEL: Sequences can take 5-30 minutes depending on size and frame count. Set timeout to 60+ minutes.
- Help: `lua sequence.lua --help`

## Performance Expectations
- **LuaJIT (RECOMMENDED)**: 900x600 image ~0.34s, 3000x2000 image ~3.8s
- **Standard Lua**: 900x600 image ~37s, 3000x2000 image ~6+ minutes
- **Test suite**: <1 second
- **Small sequences (10 frames, 100x100)**: <1 second with LuaJIT
- **Large sequences**: Scale linearly with frame count and image size

## Validation Scenarios
Always manually validate any changes by running these complete scenarios:

1. **Basic single image**: `luajit main.lua -w 100 -h 100 -v` - should complete in <1s and create mandel-100x100.bmp
2. **Color gradient**: `luajit main.lua -w 100 -h 100 --color1 FF0000 --color2 FFFF00 --color3 0000FF` - creates fire gradient
3. **Interactive mode**: `lua main.lua -x -w 100 -h 100` then press 'q' to quit - should allow parameter adjustment
4. **Test suite**: `lua test.lua` - all 13 tests must pass
5. **Sequence generation**: `LUA_COMMAND=luajit luajit sequence.lua -w 100 -h 100 -s 3 -g` - creates frames/ directory and output.gif

## Common Tasks

### Available Commands
```bash
# Single image generation (default 900x600)
lua main.lua [options]
luajit main.lua [options]

# Sequence generation (default 10 frames)  
lua sequence.lua [options]
luajit sequence.lua [options]

# Run test suite
lua test.lua
```

### Key Options for main.lua
- `-w, --width <width>` - Image width [Default: 900]
- `-h, --height <height>` - Image height [Default: 600]  
- `-r, --real <real>` - Real part of center [Default: -0.5]
- `-i, --imag <imag>` - Imaginary part of center [Default: 0]
- `-z, --zoom <zoom>` - Zoom level [Default: 0]
- `-n, --iterations <iter>` - Max iterations [Default: 255]
- `--color1/2/3 <hex>` - RGB gradient colors [Default: 000000,808080,FFFFFF]
- `-x, --interactive` - Interactive mode for exploration
- `-v, --verbose` - Show detailed progress

### Key Options for sequence.lua  
- All main.lua options plus:
- `-R/-I/-Z/-N` - Target values for sequence endpoint
- `-s, --sequence <frames>` - Number of frames [Default: 10]
- `--targetcolor1/2/3 <hex>` - Target gradient for color animation
- `-g, --gif` - Generate GIF using ffmpeg

### Repository Structure
```
/home/runner/work/mandel-lua/mandel-lua/
├── main.lua              # Single image generator
├── sequence.lua          # Sequence/animation generator  
├── test.lua              # Test suite runner
├── lib/                  # Core libraries
│   ├── complex.lua       # Complex number operations
│   ├── color.lua         # Color gradient handling
│   ├── cli-command.lua   # Command line parsing
│   ├── lua-bitmap.lua    # BMP file generation
│   └── *-tests.lua       # Unit tests for each library
├── docs/                 # Documentation and sample images
└── frames/               # Generated during sequence creation
```

### Environment Variables
- `LUA_COMMAND` - Controls which interpreter sequence.lua uses for child processes
- Set to 'luajit' for optimal performance: `LUA_COMMAND=luajit luajit sequence.lua`

### Output Files
- Single images: `mandel-<width>x<height>.bmp` (or custom with `-o`)
- Sequences: `frames/frame-NNNN.bmp` + `output.gif` (if `-g` specified)
- Test output: Text summary to console

## Error Handling
- Invalid hex colors show clear error messages
- Missing dependencies will cause command not found errors
- Interactive mode accepts 'wasd+-erqv' keys plus 'q' to quit
- All library functions have comprehensive error checking

## Development Guidelines
- Always run `lua test.lua` before committing changes
- Test both single image and sequence generation after modifications
- Use LuaJIT for performance testing and validation
- Library modules are in `/lib/` - complex.lua, color.lua, cli-command.lua, lua-bitmap.lua
- Each library has corresponding test file: `*-tests.lua`

## Troubleshooting
- If renders take too long: Use LuaJIT instead of standard Lua  
- If sequence.lua is slow: Set LUA_COMMAND=luajit environment variable
- If GIFs don't generate: Ensure ffmpeg is installed and in PATH
- If tests fail: Check Lua version compatibility (tested with Lua 5.4 and LuaJIT 2.1)
- Missing frames directory: sequence.lua creates it automatically with `mkdir -p frames`