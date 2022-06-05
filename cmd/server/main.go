package main

import (
	"fmt"
	"log"

	"github.com/Brijeshlakkad/distributedlogging/internal/server"
)

func main() {
	port := 8080
	srv := server.NewHTTPAServer(fmt.Sprintf(":%d", port))
	fmt.Printf("Server started at %d\n", port)
	log.Fatal(srv.ListenAndServe())
}
