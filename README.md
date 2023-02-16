# janet-find-in-files
Find in files implemented in Janet.

## Videos
[Find in files using Janet & Freja | Finding the Flow EP1](https://www.youtube.com/watch?v=6_vUD4tGPrs)

[Replace in files with Janet & Freja | Finding the Flow EP2](https://www.youtube.com/watch?v=dhOl0KrTNgo)


## Requirements

### To follow along the videos

[Freja](https://github.com/Saikyun/freja)

### To just run the code

[Janet](https://janet-lang.org/)

## To use

```
(find-in-files (finder "file") "./")
#              ^ the peg       ^ the directory
(find-in-file (finder "file") "./goal")
#              ^ the peg       ^ the file

(replace-in-files "cat" # peg to find
                  "dog" # replacement
                  "./" # directory
                  )
```

## License (MIT)
Copyright 2021 Jona Ekenberg

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
