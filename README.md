# mandel-lua
Mandelbrot renderer in pure Lua

## Usage

```
Usage: lua main.lua [options]
Options:
  -w, --width <width>       Width of the image           [Default: 900]
  -h, --height <height>     Height of the image          [Default: 600]
  -i, --iterations <iter>   Maximum number of iterations [Default: 255]
  -o, --output <file>       Output file path             [Default: docs/images/mandel-<width>x<height>.bmp]
  -b, --black               Black inside the set
  -v, --verbose             Verbose output
  -p, --progress            Show progress
  -?, --help                Show this help
```

## Examples
```bash
# renders a 900x600 image by default
lua main.lua

# renders a 3000x2000 image
lua main.lua -w 3000 -h 2000

# renders a 9000x6000 image
lua main.lua -w 9000 -h 6000

# renders a 900x600 image with 512 iterations
lua main.lua -i 512

# renders a 900x600 image with black inside the set
lua main.lua -b
```

## Sample output file

![mandel-900x600.bmp](./docs/images/mandel-900x600.bmp)

See higher res images here

| Image | Resolution | Render Time | Size |
| --- | --- | --- | --- |
| [mandel-900x600.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-900x600.bmp) | 900x600 | 0.24s | 1.55 MB |
| [mandel-3000x2000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-3000x2000.bmp) | 3000x2000 | 2.83s | 17.2 MB |
| [mandel-9000x6000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-9000x6000.bmp) | 9000x6000 | 47.99s | 154 MB |

