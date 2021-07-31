package utils_test

import (
	"KEINOS/SampleWasm/utils"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestPong(t *testing.T) {
	testData := []struct {
		input  []string
		expect interface{}
	}{
		{
			input:  []string{"foo"},
			expect: "",
		},
		{
			input:  []string{"ping"},
			expect: "pong",
		},
	}

	for _, data := range testData {
		result := utils.Pong(data.input)

		assert.Equal(t, data.expect, result, "should be pong")
	}
}
