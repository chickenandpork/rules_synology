package main

import (
	"errors"
	"image"
	"image/png"
	"os"

	"github.com/disintegration/imaging"
	"github.com/srwiley/oksvg"
	"github.com/srwiley/rasterx"
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

func ResizeSVGImageFromFile(imageFile string, outFile string, newHeight int) error {
	f, err := os.Open(imageFile)
	if err != nil {
		return err
	}
	defer f.Close()

	icon, err := oksvg.ReadIconStream(f)
	if err != nil {
		return err
	}

	newWidth := int(float64(newHeight) * icon.ViewBox.W / icon.ViewBox.H)

	icon.SetTarget(0, 0, float64(newWidth), float64(newHeight))
	nrgba := image.NewRGBA(image.Rect(0, 0, newWidth, newHeight))
	icon.Draw(rasterx.NewDasher(newWidth, newHeight, rasterx.NewScannerGV(newWidth, newHeight, nrgba, nrgba.Bounds())), 1.0)

	out, err := os.Create(outFile)
	if err != nil {
		return err
	}
	defer out.Close()

	return png.Encode(out, nrgba)
}
