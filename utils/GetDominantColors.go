package utils

import (
	"image"
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"

	"golang.org/x/xerrors"

	"github.com/EdlinOrg/prominentcolor"
)

// GetDominantColors returns an array of string with 3 elements of most frequently used color groups.
// The return color format are in RGB such as: #FFFFFF
func GetDominantColors(image image.Image) ([]string, error) {
	colors, err := prominentcolor.Kmeans(image)
	if err != nil {
		return nil, xerrors.Errorf("Failed to get dominant colors.\n%+w", err)
	}

	// 3 is the default
	colorsHex := make([]string, 3)

	for i, color := range colors {
		colorsHex[i] = "#" + color.AsString()
	}

	return colorsHex, nil
}
