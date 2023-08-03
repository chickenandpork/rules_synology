package main

import (
	"flag"
	"fmt"
)

func main() {

	srcFilename := flag.String("src", "PACKAGE_ICON.PNG", "Source filename for image resize")
	destFilenamePattern := flag.String(
		"dest",
		"PACKAGE_ICON_%d.PNG",
		"Filename Pattern for destination filename for image resize",
	)
	maxSize := flag.Int("size", 256, "Max size of either X or Y for image resize")

	flag.Parse()

	dest := fmt.Sprintf(*destFilenamePattern, *maxSize)

	err := ResizeImageFromFile(*srcFilename, dest, *maxSize)
	if err == nil {
		fmt.Println("OK:", dest)
	} else {
		fmt.Println("result:", dest, err)
	}
}
