package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	postgres "github.com/Mahaveer86619/Everli/pkg/DB"
	handlers "github.com/Mahaveer86619/Everli/pkg/Handlers"

	"github.com/joho/godotenv"
)

func main() {
	mux := http.NewServeMux()

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file:", err)
	}
	time.Sleep(2 * time.Second)

	db, err := postgres.ConnectDB()
	if err != nil {
		log.Fatal("Error connecting to database:", err)
	}
	defer postgres.CloseDBConnection(db)

	err = postgres.CreateTables(db)
	if err != nil {
		log.Fatal("Error creating tables:", err)
	}

	// Pass the connection to your handlers
	postgres.SetDBConnection(db)

	fmt.Println(welcomeString)
	fmt.Println("Successfully connected to the database!")
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

	//* Users routes
	mux.HandleFunc("POST /api/v1/users", handlers.CreateUserController)
	mux.HandleFunc("GET /api/v1/all_users", handlers.GetAllUsersController)
	mux.HandleFunc("GET /api/v1/users", handlers.GetUserController)
	mux.HandleFunc("PATCH /api/v1/users", handlers.UpdateUserController)
	mux.HandleFunc("DELETE /api/v1/users", handlers.DeleteUserController)

	//* Events routes
	mux.HandleFunc("POST /api/v1/events", handlers.CreateEventController)
	mux.HandleFunc("GET /api/v1/events", handlers.GetEventController)
	mux.HandleFunc("PATCH /api/v1/events", handlers.UpdateEventController)
	mux.HandleFunc("DELETE /api/v1/events", handlers.DeleteEventController)

	//* Assignments routes
	mux.HandleFunc("POST /api/v1/assignments", handlers.CreateAssignmentController)
	mux.HandleFunc("GET /api/v1/assignments", handlers.GetAssignmentController)
	mux.HandleFunc("PATCH /api/v1/assignments", handlers.UpdateAssignmentController)
	mux.HandleFunc("DELETE /api/v1/assignments", handlers.DeleteAssignmentController)

	//* Checkpoints routes
	mux.HandleFunc("POST /api/v1/checkpoints", handlers.CreateCheckpointController)
	mux.HandleFunc("GET /api/v1/checkpoints", handlers.GetCheckpointController)
	mux.HandleFunc("PATCH /api/v1/checkpoints", handlers.UpdateCheckpointController)
	mux.HandleFunc("DELETE /api/v1/checkpoints", handlers.DeleteCheckpointController)

	//* Roles routes
	mux.HandleFunc("POST /api/v1/roles", handlers.CreateRoleController)
	mux.HandleFunc("GET /api/v1/roles", handlers.GetRoleController)
	mux.HandleFunc("PATCH /api/v1/roles", handlers.UpdateRoleController)
	mux.HandleFunc("DELETE /api/v1/roles", handlers.DeleteRoleController)

	//* Invitations routes X
	mux.HandleFunc("POST /api/v1/invitations", handlers.CreateInvitationController)
	mux.HandleFunc("GET /api/v1/invitations", handlers.GetInvitationController)
	mux.HandleFunc("PATCH /api/v1/invitations", handlers.UpdateInvitationController)
	mux.HandleFunc("DELETE /api/v1/invitations", handlers.DeleteInvitationController)
}
