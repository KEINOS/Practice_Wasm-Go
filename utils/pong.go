package utils

// Pong は args に "ping" が含まれていた場合に "pong" を返します.
func Pong(args []string) string {
	// スライス（可変長変数）をループして "ping" を探す
	for _, val := range args {
		if val == "ping" {
			return "pong"
		}
	}

	return ""
}
