package utils_test

import (
	"KEINOS/SampleWasm/utils"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestEscapeHTML(t *testing.T) {
	str := "&'\"<>"

	expect := "&amp;&#39;&#34;&lt;&gt;"
	actual := utils.EscapeHTML(str)

	assert.Equal(t, expect, actual, "the output should be escaped")
}
