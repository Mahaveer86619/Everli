package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/src"
	resp "github.com/Mahaveer86619/Everli/src/Response"
)

func CreateInvitationController(w http.ResponseWriter, r *http.Request) {
	var my_invitation pkg.Invitation
	err := json.NewDecoder(r.Body).Decode(&my_invitation)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	pg_invitations, statusCode, err := pkg.CreateInvitation(&my_invitation)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusCreated)
	successResponse.SetData(pg_invitations)
	successResponse.SetMessage("Invitation created successfully")
	successResponse.JSON(w)
}

func GetInvitationController(w http.ResponseWriter, r *http.Request) {
	code := r.URL.Query().Get("code")
	if code == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: code is required")
		failureResponse.JSON(w)
		return
	}

	pg_invitations, statusCode, err := pkg.GetInvitation(code)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(pg_invitations)
	successResponse.SetMessage("Invitation fetched successfully")
	successResponse.JSON(w)
}

func UpdateInvitationController(w http.ResponseWriter, r *http.Request) {
	var my_invitation pkg.Invitation
	err := json.NewDecoder(r.Body).Decode(&my_invitation)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	pg_invitations, statusCode, err := pkg.UpdateInvitation(&my_invitation)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetData(pg_invitations)
	successResponse.SetMessage("Invitation updated successfully")
	successResponse.JSON(w)
}

func DeleteInvitationController(w http.ResponseWriter, r *http.Request) {
	invitation_id := r.URL.Query().Get("id")
	if invitation_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := pkg.DeleteInvitation(invitation_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(http.StatusOK)
	successResponse.SetMessage("Invitation deleted successfully")
	successResponse.JSON(w)
}
