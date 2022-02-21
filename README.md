# 10Print-Smooth-Scroll

The Video [Machine Language 10 PRINT Size-Optimized for Commodore 64](https://www.youtube.com/watch?v=IPP-EMBQPhE) from 8-Bit Show and Tell inspried me to write my own implementation of the interesting simple scroller.

My goal was not to optimize for size, but to make the scrolling as pretty as possible.

The register $d011 is used to shift the vertical offset of the screen one pixel at a time. Every 8 pixels, the whole screen memory is copied one line up and the vertical offset is set back to 0. It's amazing how smooth the scrolling is on a real C64. It looks pretty jerky with the vice emulator in comparison.

## Contents

There is a C64 Studio Version in directory ```C64Studio```. The file ```scroll1.asm``` was the simple starting point. The file ```scroll2.asm``` is a more complex demo. With variable ```userasterirq``` set to 1, it will use the raster interrupt to sync with the screen refresh. With ```userasterirq``` set to 0, it will use a busy-wait-loop instead.

Directory ```TMP``` contains a simpler version with just a busy-wait-loop, which can be compiled directly on a real C64 with [Turbo Macro Pro](http://turbo.style64.org/).
