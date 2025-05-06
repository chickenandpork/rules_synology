package main

import (
	"flag"
	"fmt"
	"io"
	"log"
)

func main() {
	destFilename := flag.String(
		"dest",
		"",
		"Filename Pattern for destination filename for image resize",
	)
	destFilenamePattern := flag.String(
		"destpattern",
		"PACKAGE_ICON_%d.PNG",
		"Filename Pattern for destination filename for image resize",
	)
	maxSize := flag.Int("size", 256, "Max size of either X or Y for image resize")
	srcFilename := flag.String("src", "PACKAGE_ICON.PNG", "Source filename for image resize")
	verbose := flag.Bool("verbose", false, "Be a bit more verbose on outputs")

	flag.Parse()
	if *verbose {
		log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)
	} else {
		log.SetOutput(io.Discard)
	}

	dest := *destFilename
	if len(dest) < 1 {
		dest = fmt.Sprintf(*destFilenamePattern, *maxSize)
	}

	if *verbose {
		log.Println("resizing", *srcFilename, "size", *maxSize, "to", dest)
	}

	// This is a bit brute-force:
	// 1. try to resize the source file as a PNG without even checking
	// 2. if it fails, the only possible reason is because the source is a SVG
	// 3. oh no!  it still failed!  log exceptions, throw up hands, wait for refactor
	//
	// yep, this is clearly in the "min-ship" or "make it work ugly" before "make it work well"

	err := ResizeImageFromFile(*srcFilename, dest, *maxSize)
	if err == nil {
		log.Println("OK:", dest)
	} else {
		if *verbose {
			log.Println("resizing as PNG failed; falling-back to SVG")
		}

		svgerr := ResizeSVGImageFromFile(*srcFilename, dest, *maxSize)
		if svgerr == nil {
			log.Println("OK:", dest)
		} else {
			log.Println("result:", dest, "pngerr:", err, "svgerr:", svgerr)
		}
	}
}
