// +build js,wasm

package main

import (
	"KEINOS/SampleWasm/utils"
	"bytes"
	"image"
	_ "image/jpeg"
	_ "image/png"
	"log"
	"syscall/js"
)

// registCallbacks associate Javascript function to Go function.
func registCallbacks() {
	listAssociate := []struct {
		nameJs string
		funcGo func(js.Value, []js.Value) interface{}
	}{
		{nameJs: "GoGetVersionApp", funcGo: GoGetVersionApp},
		{nameJs: "GoPong", funcGo: GoPong},
		{nameJs: "GoParrotry", funcGo: GoParrotry},
		{nameJs: "GoFindCommonColors", funcGo: GoFindCommonColors},
	}

	for _, a := range listAssociate {
		js.Global().Set(a.nameJs, js.FuncOf(a.funcGo))
	}
}

// ----------------------------------------------------------------------------
//  Alias Functions to Associate
// ----------------------------------------------------------------------------

// GoGetVersionApp returns the version info of the app.
func GoGetVersionApp(_ js.Value, args []js.Value) interface{} {
	const (
		versionAppDefault = "dev (Compiler: unknown)"
	)

	if versionApp == "" {
		versionApp = versionAppDefault
	}

	return js.ValueOf(versionApp)
}

// GoPong returns "pong" if the "args" contain "ping".
func GoPong(_ js.Value, args []js.Value) interface{} {
	var argsSlice []string

	for _, v := range args {
		argsSlice = append(argsSlice, v.String())
	}

	return utils.EscapeHTML(utils.Pong(argsSlice))
}

// GoParrotry returns the joined string of "args".
func GoParrotry(_ js.Value, args []js.Value) interface{} {
	var argsSlice []string

	for _, v := range args {
		argsSlice = append(argsSlice, v.String())
	}

	return utils.EscapeHTML(utils.Parrotry(argsSlice))
}

// GoFindCommonColors returns an array with 3 objects of color such like
// "#15608E,#79C9E9,#3F2213".
// The returned colors are the colors mostly used in a given image from
// the first element of "args"(args[0]).
func GoFindCommonColors(this js.Value, args []js.Value) interface{} {
	sourceImage := getImageFromArgs(args)
	colors := getDominantColors(sourceImage)

	return js.ValueOf(colors)
}

func getImageFromArgs(args []js.Value) image.Image {
	src := args[0]
	inBuf := make([]uint8, src.Get("byteLength").Int())

	js.CopyBytesToGo(inBuf, src)

	reader := bytes.NewReader(inBuf)

	sourceImage, _, err := image.Decode(reader)
	if err != nil {
		log.Fatal("Failed to load image", err)
	}

	return sourceImage
}

func getDominantColors(image image.Image) []interface{} {
	colors, err := utils.GetDominantColors(image)
	if err != nil {
		log.Fatal("Failed to get dominant color tones", err)
	}

	// Convert string slice to interface slice
	items := make([]interface{}, len(colors))
	for key, val := range colors {
		items[key] = js.ValueOf(val)
	}

	return items
}
