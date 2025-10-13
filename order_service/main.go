package main

import (
	"encoding/json"
	"net/http"
)

func homeHandler(w http.ResponseWriter, r *http.Request) {
	json.NewEncoder(w).Encode(map[string]string{"message": "Order Service is running"})
}

func ordersHandler(w http.ResponseWriter, r *http.Request) {
	orders := []map[string]interface{}{
		{"id": 1, "product": "Laptop", "quantity": 1},
		{"id": 2, "product": "Phone", "quantity": 2},
	}
	json.NewEncoder(w).Encode(orders)
}

func main() {
	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/orders", ordersHandler)
	http.ListenAndServe(":5003", nil)
}

