package utils

import "strings"

func Parrotry(args []string) string {
	return strings.TrimSpace(strings.Join(args, " "))
}
