package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

type PodInfo struct {
	PodName string `json:"pod_name"`
	PodIP   string `json:"pod_ip"`
	AppName string `json:"app_name"`
	Message string `json:"message"`
}

func handler(w http.ResponseWriter, r *http.Request) {
	podName := os.Getenv("POD_NAME")
	podIP := os.Getenv("POD_IP")
	appName := os.Getenv("APP_NAME")
	
	if podName == "" {
		podName = "unknown"
	}
	if podIP == "" {
		podIP = "unknown"
	}
	if appName == "" {
		appName = "webapp"
	}

	response := PodInfo{
		PodName: podName,
		PodIP:   podIP,
		AppName: appName,
		Message: fmt.Sprintf("Hello from %s!", appName),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK"))
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	http.HandleFunc("/", handler)
	http.HandleFunc("/health", healthHandler)
	
	log.Printf("Server starting on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}