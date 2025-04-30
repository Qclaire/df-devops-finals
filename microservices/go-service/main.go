package main

import (
	"fmt"
	"net/http"
	"time"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now().Format("2006-01-02 15:04:05")
	fmt.Fprintf(w, "OK at %s", currentTime)
}

func main() {
	http.HandleFunc("/health", healthHandler)
	fmt.Println("Starting Go service on :8080...")
	http.ListenAndServe(":8080", nil)
}
