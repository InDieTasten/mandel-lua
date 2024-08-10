# mandel-lua
Mandelbrot renderer in pure Lua

## Usage

```bash
# renders a 900x600 image by default
luajit main.lua

# renders a 3000x2000 image
luajit main.lua 3000 2000
```

## Sample output file

![mandel-900x600.bmp](./docs/images/mandel-900x600.bmp)

See higher res images here

| Image | Resolution | Render Time | Size |
| --- | --- | --- | --- |
| [mandel-900x600.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-900x600.bmp) | 900x600 | 0.24s | 1.55 MB |
| [mandel-3000x2000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-3000x2000.bmp) | 3000x2000 | 2.83s | 17.2 MB |
| [mandel-9000x6000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-9000x6000.bmp) | 9000x6000 | 47.99s | 154 MB |

