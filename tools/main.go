package main

import (
	"flag"
	"fmt"
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

	flag.Parse()

	dest := *destFilename
	if len(dest) < 1 {
		dest = *destFilenamePattern
	}

	err := ResizeImageFromFile(*srcFilename, dest, *maxSize)

	if err == nil {
		fmt.Println("OK:", dest)
	} else {
		fmt.Println("result:", dest, err)
	}
}
