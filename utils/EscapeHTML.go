package utils

import "html"

// EscapeHTML escapes special chars to be HTML safe.
// Use function at the very last point to give the values to Javascript.
func EscapeHTML(str string) string {
	return html.EscapeString(str)
}
