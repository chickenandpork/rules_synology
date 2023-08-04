package main

import (
	"flag"
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
		dest = *destFilenamePattern
	}

	err := ResizeImageFromFile(*srcFilename, dest, *maxSize)

	if err == nil {
		log.Println("OK:", dest)
	} else {
		log.Println("result:", dest, err)
	}
}
