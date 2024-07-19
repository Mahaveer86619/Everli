package middleware

import (
	"log"
	"net/http"
	"strings"
)

func LoggingMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// Get the remote address
		remoteAddr := r.RemoteAddr

		// Extract the IP address from remoteAddr (host:port format)
		ipAddress := remoteAddr[:strings.LastIndex(remoteAddr, ":")]

		// Log the request with IP address
		log.Printf("Request received from IP address: %s - URL: %s", ipAddress, r.URL.Path)

		// Call the next handler in the chain
		next(w, r)
	}
}
