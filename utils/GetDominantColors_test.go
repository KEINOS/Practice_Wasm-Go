package utils_test

import (
	"KEINOS/SampleWasm/utils"
	"image"
	"image/color"
	_ "image/jpeg"
	_ "image/png"
	"testing"

	"github.com/stretchr/testify/assert"
)

// ----------------------------------------------------------------------------
//  Tests
// ----------------------------------------------------------------------------
func TestGetDominantColors(t *testing.T) {
	img := genImageRect(t)

	result, err := utils.GetDominantColors(img)

	if err != nil {
		t.Fatal()
	}
	t.Logf("[LOG] Returned value: %#v", result)

	assert.Contains(t, result, "#FF0000", "should contain red color")
	assert.Contains(t, result, "#00FF00", "should contain green color")
	assert.Contains(t, result, "#0000FF", "should contain blue color")
	assert.NotContains(t, result, "#646464", "should not contain gray color")
}

func TestGetDominantColors_invalid_image(t *testing.T) {
	img := image.NewRGBA(image.Rectangle{Max: image.Point{X: 0, Y: 0}})

	_, err := utils.GetDominantColors(img)

	assert.Error(t, err)
}

// ----------------------------------------------------------------------------
//  Helper Function
// ----------------------------------------------------------------------------

// genImageRect generates an image with boxes with different color and size at
// each corner of the image.
func genImageRect(t *testing.T) image.Image {
	t.Helper()

	red := color.RGBA{255, 0, 0, 255}
	green := color.RGBA{0, 255, 0, 255}
	blue := color.RGBA{0, 0, 255, 255}
	gray := color.RGBA{100, 100, 100, 255}

	// Canvas size
	width := 100
	height := 100
	myBound := image.Rectangle{Max: image.Point{X: width, Y: height}}

	// Create image
	canvas := image.NewRGBA(myBound)

	// Draw red square with size 30px @ pos: 0,0
	for x := 0; x < 30; x++ {
		for y := 0; y < 30; y++ {
			canvas.SetRGBA(x, y, red)
		}
	}

	// Draw green square with size 29 @ pos: 0, -29
	for x := 0; x < 29; x++ {
		for y := 0; y < 29; y++ {
			canvas.SetRGBA(x, y+(height-29), green)
		}
	}

	// Draw blue square with size 28 @ pos: -28, 0
	for x := 0; x < 28; x++ {
		for y := 0; y < 28; y++ {
			canvas.SetRGBA(x+(width-28), y, blue)
		}
	}

	// Draw gray square with size 5px @ pos: -5, -5
	for x := 0; x < 5; x++ {
		for y := 0; y < 5; y++ {
			canvas.SetRGBA(x+(width-5), y+(height-5), gray)
		}
	}

	return canvas
}
