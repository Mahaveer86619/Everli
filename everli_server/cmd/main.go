package main

import (
	"fmt"
	"log"
	"net/http"

	handlers "github.com/Mahaveer86619/Everli/pkg/Handlers"
	"github.com/joho/godotenv"
)

func main() {
	mux := http.NewServeMux()
	fmt.Println(welcomeString)

	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file:", err)
	}

	handleFunctions(mux)

	if err := http.ListenAndServe(":5050", mux); err != nil {
		fmt.Println("Error running server:", err)
	}
}

var welcomeString = `

    ______   _    __   ______   ____     __       ____
   / ____/  | |  / /  / ____/  / __ \   / /      /  _/
  / __/     | | / /  / __/    / /_/ /  / /       / /  
 / /___     | |/ /  / /___   / _, _/  / /___   _/ /   
/_____/     |___/  /_____/  /_/ |_|  /_____/  /___/   
                                                      

`

func handleFunctions(mux *http.ServeMux) {
	mux.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, welcomeString)
	})

	//* User routes
	mux.HandleFunc("POST /u/create", handlers.CreateUserController)
	mux.HandleFunc("GET /u/get", handlers.GetUserController)
	mux.HandleFunc("PATCH /u/update", handlers.UpdateUserController)

	//* Event routes
	mux.HandleFunc("POST /e/create", handlers.CreateEventController)
	mux.HandleFunc("GET /e/get", handlers.GetEventController)
	mux.HandleFunc("PATCH /e/update", handlers.UpdateEventController)
	mux.HandleFunc("DELETE /e/delete", handlers.DeleteEventController)

	//* Assignments routes
	mux.HandleFunc("POST /a/create", handlers.CreateAssignmentController)
	mux.HandleFunc("GET /a/get", handlers.GetAssignmentController)
	mux.HandleFunc("PATCH /a/update", handlers.UpdateAssignmentController)
	mux.HandleFunc("DELETE /a/delete", handlers.DeleteAssignmentController)
}
