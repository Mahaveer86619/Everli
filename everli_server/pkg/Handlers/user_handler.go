package handlers

import (
	"encoding/json"
	"net/http"

	impl "github.com/Mahaveer86619/Everli/pkg/Implementations"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

func CreateUserController(w http.ResponseWriter, r *http.Request) {
	var user impl.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_user, statusCode, err := impl.Createuser(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_user)
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

	returned_user, statusCode, err := impl.GetUserByID(user_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_user)
	successResponse.SetMessage("User fetched successfully")
	successResponse.JSON(w)
}

func UpdateUserController(w http.ResponseWriter, r *http.Request) {
	var user impl.MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body")
		failureResponse.JSON(w)
		return
	}

	returned_user, statusCode, err := impl.UpdateUser(&user)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(returned_user)
	successResponse.SetMessage("User updated successfully")
	successResponse.JSON(w)
}

func GetAllUsersController(w http.ResponseWriter, r *http.Request) {
	users, statusCode, err := impl.GetAllUsers()
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(users)
	successResponse.SetMessage("Users fetched successfully")
	successResponse.JSON(w)
}

func DeleteUserController(w http.ResponseWriter, r *http.Request) {
	user_id := r.URL.Query().Get("id")
	if user_id == "" {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(http.StatusBadRequest)
		failureResponse.SetMessage("Invalid request body: id is required")
		failureResponse.JSON(w)
		return
	}

	statusCode, err := impl.DeleteUser(user_id)
	if err != nil {
		failureResponse := resp.Failure{}
		failureResponse.SetStatusCode(statusCode)
		failureResponse.SetMessage(err.Error())
		failureResponse.JSON(w)
		return
	}

	successResponse := &resp.Success{}
	successResponse.SetStatusCode(statusCode)
	successResponse.SetData(nil)
	successResponse.SetMessage("User deleted successfully")
	successResponse.JSON(w)
}