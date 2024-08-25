package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

func AuthenticateUserController(w http.ResponseWriter, r *http.Request) {
	var creds pkg.AuthenticatingUser
	err := json.NewDecoder(r.Body).Decode(&creds)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_creds, statusCode, err := pkg.AuthenticateUser(&creds)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_creds)
	successResponse.SetMessage("User Authenticated successfully")
	successResponse.JSON(w)
}

func RegisterUserController(w http.ResponseWriter, r *http.Request) {
	var creds pkg.RegisteringUser
	err := json.NewDecoder(r.Body).Decode(&creds)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_creds, statusCode, err := pkg.RegisterUser(&creds)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_creds)
	successResponse.SetMessage("User Registered successfully")
	successResponse.JSON(w)
}

func RefreshTokenController(w http.ResponseWriter, r *http.Request) {
	var refreshingToken pkg.RefreshingToken
	err := json.NewDecoder(r.Body).Decode(&refreshingToken)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_tokens, statusCode, err := pkg.RefreshToken(&refreshingToken)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_tokens)
	successResponse.SetMessage("Token refreshed successfully")
	successResponse.JSON(w)
}