package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

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

	// var my_role pkg.Role = pkg.Role{Id: my_event.RoleId, EventId: my_event.Id, MemberId: my_event.CreatorId, Role: "Admin", CreatedAt: my_event.CreatedAt}
	// statusCode, err = pkg.CreateRole(&my_role)
	// if err != nil {
	// 	failureResponse := resp.Failure{}
	// 	failureResponse.SetStatusCode(statusCode)
	// 	failureResponse.SetMessage(err.Error())
	// 	failureResponse.JSON(w)
	// 	return
	// }

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
