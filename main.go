package main

import (
	"database/sql"
	"log"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"strconv"

	_ "dating_app/docs"

	"dating_app/api"

	_ "github.com/lib/pq"
)

// @title Dating App API
// @description This is a sample dating app API.
// @version 1.0
// @host localhost:8080
// @BasePath /


func main() {
	var err error
	var db  *sql.DB
	var portInt int
	var psqlInfo string

	// Get the db environment variables
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	
	portInt, err = strconv.Atoi(dbPort)
	if err != nil {
		log.Fatalf("Invalid DB_PORT: %s", dbPort)
	}

	psqlInfo = fmt.Sprintf("host=%s port=%d user=%s "+
    "password=%s dbname=%s sslmode=disable",
    dbHost, dbPort, dbUser, dbPassword, dbName)

	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
	  panic(err)
	}
	defer db.Close()

	// Setup HTTP routes
	api.Routes(db)

	// Start the HTTP server
	serverAddr := "0.0.0.0:8080"
	go func() {
		log.Printf("Server is starting and listening on %s", serverAddr)
		if err := http.ListenAndServe(serverAddr, nil); err != nil {
			log.Fatalf("Error starting server: %s", err)
		}
	}()

	// Wait for server shutdown
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, os.Interrupt)
	<-stop

	log.Println("Server stopped gracefully")
}
