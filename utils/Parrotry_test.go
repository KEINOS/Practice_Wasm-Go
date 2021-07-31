package utils_test

import (
	"KEINOS/SampleWasm/utils"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParrotry(t *testing.T) {
	data := []string{
		"one",
		"two",
		"three ",
	}

	expect := "one two three"
	actual := utils.Parrotry(data)

	assert.Equal(t, expect, actual,
		"the results should be joind and stripped the white spaces before and after")
}
