// +build js,wasm

package main

import (
	"syscall/js"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGoGetVersionApp(t *testing.T) {
	jsVal := js.ValueOf("")
	jsVals := []js.Value{
		js.ValueOf(""),
	}
	expect := "dev (unknown)"
	actual := GoGetVersionApp(jsVal, jsVals)

	assert.Equal(t, expect, actual)
}
