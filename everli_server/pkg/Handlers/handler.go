package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
)

//* Users

func CreateUserController(w http.ResponseWriter, r *http.Request) {
	var user pkg.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.Createuser(&user)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

func GetUserController(w http.ResponseWriter, r *http.Request) {
	user_id := r.URL.Query().Get("id")
	if user_id == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body: id is required"))
		return
	}

	user, err := pkg.GetUser(user_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}

func UpdateUserController(w http.ResponseWriter, r *http.Request) {
	var user pkg.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.UpdateUser(&user)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}

//* Events

func CreateEventController(w http.ResponseWriter, r *http.Request) {
	var my_event pkg.Event
	err := json.NewDecoder(r.Body).Decode(&my_event)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.CreateEvent(&my_event)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(my_event)
}

func GetEventController(w http.ResponseWriter, r *http.Request) {
	event_id := r.URL.Query().Get("id")
	if event_id == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body: id is required"))
		return
	}

	event, err := pkg.GetEvent(event_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(event)
}

func UpdateEventController(w http.ResponseWriter, r *http.Request) {
	var my_event pkg.Event
	err := json.NewDecoder(r.Body).Decode(&my_event)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.UpdateEvent(&my_event)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(my_event)
}

func DeleteEventController(w http.ResponseWriter, r *http.Request) {
	event_id := r.URL.Query().Get("id")
	if event_id == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body: id is required"))
		return
	}

	_, err := pkg.DeleteEvent(event_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
}

//* Assignments

func CreateAssignmentController(w http.ResponseWriter, r *http.Request) {
	var my_assignment pkg.Assignment
	err := json.NewDecoder(r.Body).Decode(&my_assignment)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.CreateAssignment(&my_assignment)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(my_assignment)
}

func GetAssignmentController(w http.ResponseWriter, r *http.Request) {
	assignment_id := r.URL.Query().Get("id")
	if assignment_id == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body: id is required"))
		return
	}

	assignment, err := pkg.GetEvent(assignment_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(assignment)
}

func UpdateAssignmentController(w http.ResponseWriter, r *http.Request) {
	var my_assignment pkg.Assignment
	err := json.NewDecoder(r.Body).Decode(&my_assignment)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := pkg.UpdateAssignment(&my_assignment)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(my_assignment)
}

func DeleteAssignmentController(w http.ResponseWriter, r *http.Request) {
	assignment_id := r.URL.Query().Get("id")
	if assignment_id == "" {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body: id is required"))
		return
	}

	_, err := pkg.DeleteAssignment(assignment_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
}