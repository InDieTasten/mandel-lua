# mandel-lua
Mandelbrot renderer in pure Lua

## Usage

### Single images
```
Usage: lua main.lua [options]
Options:
  -w, --width <width>       Width of the image                 [Default: 900]
  -h, --height <height>     Height of the image                [Default: 600]

  -r, --real <real>         Real part of the center point      [Default: -0.5]
  -i, --imag <imag>         Imaginary part of the center point [Default: 0]
  -z, --zoom <zoom>         Zoom level                         [Default: 0]
  -n, --iterations <iter>   Maximum number of iterations       [Default: 255]

  -o, --output <file>       Output file path                   [Default: ./mandel-<width>x<height>.bmp]
  -x, --interactive         Interactive mode
  -b, --black               Black inside the set
  -v, --verbose             Verbose output
  -p, --progress            Show progress
  -?, --help                Show this help
```

#### Examples
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

#### Sample output file

![mandel-900x600.bmp](./docs/images/mandel-900x600.bmp)

See higher res images here

| Image | Resolution | Render Time | Size |
| --- | --- | --- | --- |
| [mandel-900x600.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-900x600.bmp) | 900x600 | 0.24s | 1.55 MB |
| [mandel-3000x2000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-3000x2000.bmp) | 3000x2000 | 2.83s | 17.2 MB |
| [mandel-9000x6000.bmp](https://github.com/InDieTasten/mandel-lua/raw/main/docs/images/mandel-9000x6000.bmp) | 9000x6000 | 47.99s | 154 MB |

### Sequences

Requires [ffmpeg](https://ffmpeg.org/) to be installed and in the PATH in order to create gifs.

```
Usage: luajit sequence.lua [options]
Options:
  -w, --width <width>       Width of the image                 [Default: 900]
  -h, --height <height>     Height of the image                [Default: 600]

  -r, --real <real>         Real part of the center point      [Default: -0.5]
  -i, --imag <imag>         Imaginary part of the center point [Default: 0]
  -z, --zoom <zoom>         Zoom level                         [Default: 0]
  -n, --iterations <iter>   Maximum number of iterations       [Default: 255]

  -R, --real2 <real>        Target -r for sequence             [Default: -0.5]
  -I, --imag2 <imag>        Target -i for sequence             [Default: 0]
  -Z, --zoom2 <zoom>        Target -z for sequence             [Default: 0]
  -N, --iterations2 <iter>  Target -n for sequence             [Default: 255]
  -s, --sequence <frames>   Number of frames in the sequence   [Default: 10]
  -b, --black               Black inside the set

  -g, --gif                 Use ffmpeg to create a gif
```

#### Example (white)
```bash
luajit sequence.lua -n 1000 -v -R -1.7635735993133 -I 0 -Z 4 -N 2000 -s 80 --gif
```
#### Output
![sequenceWhite.gif](./docs/images/sequenceWhite.gif)

#### Example (black)
```bash
luajit sequence.lua -n 1000 -v -R -1.7635735993133 -I 0 -Z 4 -N 2000 -s 80 --gif -b
```
#### Output
![sequenceBlack.gif](./docs/images/sequenceBlack.gif)