package main

import (
	"encoding/json"
	"net/http"
	"time"
)

type Response struct {
	ServiceName string `json:"service_name"`
	Status      string `json:"status"`
	Time        string `json:"time"`
	Role        string `json:"role"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	resp := Response{
		ServiceName: "go-service",
		Status:      "ok",
		Time:        time.Now().Format(time.RFC3339),
		Role:        "Backend processor",
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}

func main() {
	http.HandleFunc("/health", handler)
	http.ListenAndServe(":8080", nil)
}
