package main

import (
	"fmt"
	"net/http"
)

func healthHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "OK")
}

func main() {
	http.HandleFunc("/health", healthHandler)
	fmt.Println("Starting Go service on :8080...")
	http.ListenAndServe(":8080", nil)
}