package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

//* Users

func CreateUserController(w http.ResponseWriter, r *http.Request) {
	var user pkg.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.Createuser(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusCreated)
	successResponse.SetData(user)
	successResponse.SetMessage("User created successfully")
	successResponse.JSON(w)
}

func GetUserController(w http.ResponseWriter, r *http.Request) {
	user_id := r.URL.Query().Get("id")
	if user_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	user, statusCode, err := pkg.GetUser(user_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(user)
	successResponse.SetMessage("User fetched successfully")
	successResponse.JSON(w)
}

func UpdateUserController(w http.ResponseWriter, r *http.Request) {
	var user pkg.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.UpdateUser(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(user)
	successResponse.SetMessage("User updated successfully")
	successResponse.JSON(w)
}

//* Events

func CreateEventController(w http.ResponseWriter, r *http.Request) {
	var my_event pkg.Event
	err := json.NewDecoder(r.Body).Decode(&my_event)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.CreateEvent(&my_event)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusCreated)
	successResponse.SetData(my_event)
	successResponse.SetMessage("Event created successfully")
	successResponse.JSON(w)
}

func GetEventController(w http.ResponseWriter, r *http.Request) {
	event_id := r.URL.Query().Get("id")
	if event_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	event, statusCode, err := pkg.GetEvent(event_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(event)
	successResponse.SetMessage("Event fetched successfully")
	successResponse.JSON(w)
}

func UpdateEventController(w http.ResponseWriter, r *http.Request) {
	var my_event pkg.Event
	err := json.NewDecoder(r.Body).Decode(&my_event)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.UpdateEvent(&my_event)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(my_event)
	successResponse.SetMessage("Event updated successfully")
	successResponse.JSON(w)
}

func DeleteEventController(w http.ResponseWriter, r *http.Request) {
	event_id := r.URL.Query().Get("id")
	if event_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.DeleteEvent(event_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetMessage("Event deleted successfully")
	successResponse.JSON(w)
}

//* Assignments

func CreateAssignmentController(w http.ResponseWriter, r *http.Request) {
	var my_assignment pkg.Assignment
	err := json.NewDecoder(r.Body).Decode(&my_assignment)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.CreateAssignment(&my_assignment)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusCreated)
	successResponse.SetData(my_assignment)
	successResponse.SetMessage("Assignment updated successfully")
	successResponse.JSON(w)
}

func GetAssignmentController(w http.ResponseWriter, r *http.Request) {
	assignment_id := r.URL.Query().Get("id")
	if assignment_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	assignment, statusCode, err := pkg.GetEvent(assignment_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(assignment)
	successResponse.SetMessage("Assignment fetched successfully")
	successResponse.JSON(w)
}

func UpdateAssignmentController(w http.ResponseWriter, r *http.Request) {
	var my_assignment pkg.Assignment
	err := json.NewDecoder(r.Body).Decode(&my_assignment)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.UpdateAssignment(&my_assignment)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(my_assignment)
	successResponse.SetMessage("Assignment updated successfully")
	successResponse.JSON(w)
}

func DeleteAssignmentController(w http.ResponseWriter, r *http.Request) {
	assignment_id := r.URL.Query().Get("id")
	if assignment_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.DeleteAssignment(assignment_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetMessage("Assignment deleted successfully")
	successResponse.JSON(w)
}
