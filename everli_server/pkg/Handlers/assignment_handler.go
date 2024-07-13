package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

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

	assignment, statusCode, err := pkg.GetAssignment(assignment_id)
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
