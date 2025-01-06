package main

import (
	"errors"
	"github.com/disintegration/imaging"
)

func ResizeImageFromFile(imageFile string, outFile string, newHeight int) error {
	img, err := imaging.Open(imageFile)
	if err != nil {
		return errors.New("Failure opening " + imageFile + ": " + err.Error())
	}

	// calculator new width of image
	newWidth := newHeight * img.Bounds().Max.X / img.Bounds().Max.Y

	// resize new image
	nrgba := imaging.Resize(img, newWidth, newHeight, imaging.Lanczos)

	err = imaging.Save(nrgba, outFile)

	return err
}
