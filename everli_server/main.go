package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	postgres "github.com/Mahaveer86619/Everli/pkg/DB"
	handlers "github.com/Mahaveer86619/Everli/pkg/Handlers"
	middleware "github.com/Mahaveer86619/Everli/pkg/Middleware"
	"github.com/jackc/pgx/v4"

	"github.com/joho/godotenv"
)

func main() {
	mux := http.NewServeMux()

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file:", err)
	}

	var db *pgx.Conn
	for {
		time.Sleep(2 * time.Second)

		db, err = postgres.ConnectDB()
		if err == nil {
			break
		}
		fmt.Println("Error connecting to database:", err)
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

	if err := http.ListenAndServe(":8080", mux); err != nil {
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
	mux.HandleFunc("/", middleware.LoggingMiddleware(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.Error(w, "Not Found", http.StatusNotFound)
			return
		}
		fmt.Fprint(w, welcomeString)
	}))

	//* Users routes
	mux.HandleFunc("POST /api/v1/users", middleware.LoggingMiddleware(handlers.CreateUserController))
	mux.HandleFunc("GET /api/v1/all_users", middleware.LoggingMiddleware(handlers.GetAllUsersController))
	mux.HandleFunc("GET /api/v1/users", middleware.LoggingMiddleware(handlers.GetUserController))
	mux.HandleFunc("PATCH /api/v1/users", middleware.LoggingMiddleware(handlers.UpdateUserController))
	mux.HandleFunc("DELETE /api/v1/users", middleware.LoggingMiddleware(handlers.DeleteUserController))

	//* Events routes
	mux.HandleFunc("POST /api/v1/events", middleware.LoggingMiddleware(handlers.CreateEventController))
	mux.HandleFunc("GET /api/v1/events", middleware.LoggingMiddleware(handlers.GetEventController))
	mux.HandleFunc("PATCH /api/v1/events", middleware.LoggingMiddleware(handlers.UpdateEventController))
	mux.HandleFunc("DELETE /api/v1/events", middleware.LoggingMiddleware(handlers.DeleteEventController))

	//* Assignments routesloggingMiddleware(
	mux.HandleFunc("POST /api/v1/assignments", middleware.LoggingMiddleware(handlers.CreateAssignmentController))
	mux.HandleFunc("GET /api/v1/assignments", middleware.LoggingMiddleware(handlers.GetAssignmentController))
	mux.HandleFunc("GET /api/v1/assignments/event", middleware.LoggingMiddleware(handlers.GetAssignmentsByEventIdController))
	mux.HandleFunc("GET /api/v1/assignments/member", middleware.LoggingMiddleware(handlers.GetAssignmentsByMemberIdController))
	mux.HandleFunc("PATCH /api/v1/assignments", middleware.LoggingMiddleware(handlers.UpdateAssignmentController))
	mux.HandleFunc("DELETE /api/v1/assignments", middleware.LoggingMiddleware(handlers.DeleteAssignmentController))

	//* Checkpoints routes
	mux.HandleFunc("POST /api/v1/checkpoints", middleware.LoggingMiddleware(handlers.CreateCheckpointController))
	mux.HandleFunc("GET /api/v1/checkpoints", middleware.LoggingMiddleware(handlers.GetCheckpointController))
	mux.HandleFunc("GET /api/v1/checkpoints/assignment", middleware.LoggingMiddleware(handlers.GetCheckpointsByAssignmentIdController))
	mux.HandleFunc("GET /api/v1/checkpoints/member", middleware.LoggingMiddleware(handlers.GetCheckpointsByMemberIdController))
	mux.HandleFunc("PATCH /api/v1/checkpoints", middleware.LoggingMiddleware(handlers.UpdateCheckpointController))
	mux.HandleFunc("DELETE /api/v1/checkpoints", middleware.LoggingMiddleware(handlers.DeleteCheckpointController))

	//* Roles routes
	mux.HandleFunc("POST /api/v1/roles", middleware.LoggingMiddleware(handlers.CreateRoleController))
	mux.HandleFunc("GET /api/v1/roles", middleware.LoggingMiddleware(handlers.GetRoleController))
	mux.HandleFunc("GET /api/v1/roles/event", middleware.LoggingMiddleware(handlers.GetRolesByEventIdController))
	mux.HandleFunc("GET /api/v1/roles/member", middleware.LoggingMiddleware(handlers.GetRolesByMemberIdController))
	mux.HandleFunc("PATCH /api/v1/roles", middleware.LoggingMiddleware(handlers.UpdateRoleController))
	mux.HandleFunc("DELETE /api/v1/roles", middleware.LoggingMiddleware(handlers.DeleteRoleController))

	//* Invitations routes X
	mux.HandleFunc("POST /api/v1/invitations", middleware.LoggingMiddleware(handlers.CreateInvitationController))
	mux.HandleFunc("GET /api/v1/invitations", middleware.LoggingMiddleware(handlers.GetInvitationController))
	mux.HandleFunc("PATCH /api/v1/invitations", middleware.LoggingMiddleware(handlers.UpdateInvitationController))
	mux.HandleFunc("DELETE /api/v1/invitations", middleware.LoggingMiddleware(handlers.DeleteInvitationController))

}
