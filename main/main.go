// +build js,wasm

package main

import (
	"fmt"
)

var (
	versionApp  string
	compilerApp string
)

func main() {
	// This prints to the browser's console in the dev tool
	fmt.Println("Hello, Webassembly!!")

	// Create channel to receive calls from Javascript
	c := make(chan struct{})
	registCallbacks()
	fmt.Println("The Web Assembly Is Ready")
	<-c
}
