package main

import (
	"fmt"
	"net/http"

	"github.com/Mahaveer86619/Everli/features"
)

func main() {
	mux := http.NewServeMux()
	fmt.Println(welcomeString)

	handleFunctions(mux)

	if err := http.ListenAndServe(":5050", mux); err != nil {
		fmt.Println("Error starting server:", err)
	}
}

var welcomeString = `

    ______   _    __   ______   ____     __       ____
   / ____/  | |  / /  / ____/  / __ \   / /      /  _/
  / __/     | | / /  / __/    / /_/ /  / /       / /  
 / /___     | |/ /  / /___   / _, _/  / /___   _/ /   
/_____/     |___/  /_____/  /_/ |_|  /_____/  /___/   
                                                      


Serving at: http://192.168.29.150:5050
Running in development mode

`

func handleFunctions(mux *http.ServeMux) {
	mux.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, welcomeString)
	})

	//* User routes
	mux.HandleFunc("POST /u/create", features.CreateUserController)
	mux.HandleFunc("GET /u/get", features.GetUserController)
	mux.HandleFunc("PATCH /u/update", features.UpdateUserController)
}
