package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

func CreateCheckpointController(w http.ResponseWriter, r *http.Request) {
	var my_checkpoint pkg.Checkpoint
	err := json.NewDecoder(r.Body).Decode(&my_checkpoint)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.CreateCheckpoint(&my_checkpoint)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusCreated)
	successResponse.SetData(my_checkpoint)
	successResponse.SetMessage("Checkpoint created successfully")
	successResponse.JSON(w)
}

func GetCheckpointController(w http.ResponseWriter, r *http.Request) {
	checkpoint_id := r.URL.Query().Get("id")
	if checkpoint_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	checkpoint, statusCode, err := pkg.GetCheckpoint(checkpoint_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(checkpoint)
	successResponse.SetMessage("Checkpoint fetched successfully")
	successResponse.JSON(w)
}

func UpdateCheckpointController(w http.ResponseWriter, r *http.Request) {
	var my_checkpoint pkg.Checkpoint
	err := json.NewDecoder(r.Body).Decode(&my_checkpoint)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.UpdateCheckpoint(&my_checkpoint)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(my_checkpoint)
	successResponse.SetMessage("Checkpoint updated successfully")
	successResponse.JSON(w)
}

func DeleteCheckpointController(w http.ResponseWriter, r *http.Request) {
	checkpoint_id := r.URL.Query().Get("id")
	if checkpoint_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.DeleteCheckpoint(checkpoint_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetMessage("Checkpoint deleted successfully")
	successResponse.JSON(w)
}
