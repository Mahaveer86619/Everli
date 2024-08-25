package main

import (
	"fmt"
	"log"
	"net/http"

	postgres "github.com/Mahaveer86619/Everli/pkg/DB"
	handlers "github.com/Mahaveer86619/Everli/pkg/Handlers"
	middleware "github.com/Mahaveer86619/Everli/pkg/Middleware"
	"github.com/joho/godotenv"
)

func main() {
	mux := http.NewServeMux()

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file:", err)
	}

	db, err := postgres.ConnectDB()
	if err != nil {
		fmt.Println("Error connecting to database:", err)
	}

	defer postgres.CloseDBConnection(db)

	err = postgres.CreateTables(db)
	if err != nil {
		log.Fatal("Error creating tables:", err)
	}

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
		if r.URL.Path == "/favicon.ico" {
			return
		}
		fmt.Fprint(w, welcomeString)
	})

	//* Auth routes
	mux.HandleFunc("POST /api/v1/auth/register", middleware.LoggingMiddleware(handlers.RegisterUserController))
	mux.HandleFunc("POST /api/v1/auth/login", middleware.LoggingMiddleware(handlers.AuthenticateUserController))
	mux.HandleFunc("POST /api/v1/auth/refresh", middleware.LoggingMiddleware(handlers.RefreshTokenController))

	//* Users routes
	mux.Handle("POST /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateUserController)))
	mux.Handle("GET /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetUserController)))
	mux.Handle("PATCH /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateUserController)))
	mux.Handle("DELETE /api/v1/users", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteUserController)))

	//* Events routes
	mux.Handle("POST /api/v1/events", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateEventController)))
	mux.Handle("GET /api/v1/events", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetEventController)))
	mux.Handle("GET /api/v1/all_events", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAllEventsController)))
	mux.Handle("PATCH /api/v1/events", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateEventController)))
	mux.Handle("DELETE /api/v1/events", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteEventController)))

	//* Assignments routes
	mux.Handle("POST /api/v1/assignments", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateAssignmentController)))
	mux.Handle("GET /api/v1/assignments", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAssignmentController)))
	mux.Handle("GET /api/v1/assignments/event", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAssignmentsByEventIdController)))
	mux.Handle("GET /api/v1/assignments/member", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetAssignmentsByMemberIdController)))
	mux.Handle("PATCH /api/v1/assignments", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateAssignmentController)))
	mux.Handle("DELETE /api/v1/assignments", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteAssignmentController)))

	//* Checkpoints routes
	mux.Handle("POST /api/v1/checkpoints", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateCheckpointController)))
	mux.Handle("GET /api/v1/checkpoints", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetCheckpointController)))
	mux.Handle("GET /api/v1/checkpoints/assignment", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetCheckpointsByAssignmentIdController)))
	mux.Handle("GET /api/v1/checkpoints/member", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetCheckpointsByMemberIdController)))
	mux.Handle("PATCH /api/v1/checkpoints", middleware.LoggingMiddleware(http.HandlerFunc(handlers.UpdateCheckpointController)))
	mux.Handle("DELETE /api/v1/checkpoints", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteCheckpointController)))

	//* Roles routes
	mux.Handle("POST /api/v1/roles", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateRoleController)))
	mux.Handle("GET /api/v1/roles", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetRoleController)))
	mux.Handle("GET /api/v1/roles/event", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetRolesByEventIdController)))
	mux.Handle("GET /api/v1/roles/member", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetRolesByMemberIdController)))
	mux.Handle("PATCH /api/v1/roles", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateRoleController)))
	mux.Handle("DELETE /api/v1/roles", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteRoleController)))

	//* Invitations routes
	mux.Handle("POST /api/v1/invitations", middleware.AuthMiddleware(http.HandlerFunc(handlers.CreateInvitationController)))
	mux.Handle("GET /api/v1/invitations", middleware.AuthMiddleware(http.HandlerFunc(handlers.GetInvitationController)))
	mux.Handle("PATCH /api/v1/invitations", middleware.AuthMiddleware(http.HandlerFunc(handlers.UpdateInvitationController)))
	mux.Handle("DELETE /api/v1/invitations", middleware.AuthMiddleware(http.HandlerFunc(handlers.DeleteInvitationController)))

	//* Dev routes
	mux.HandleFunc("GET /api/v1/dev/users", middleware.LoggingMiddleware(handlers.GetAllUsersController))

}
