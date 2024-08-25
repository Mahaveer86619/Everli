package handlers

import (
	"encoding/json"
	"net/http"

	pkg "github.com/Mahaveer86619/Everli/pkg"
	resp "github.com/Mahaveer86619/Everli/pkg/Response"
)

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

	returned_user, statusCode, err := pkg.Createuser(&user)
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

	returned_user, statusCode, err := pkg.GetUserByID(user_id)
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

// func GetUserByFirebaseIdController(w http.ResponseWriter, r *http.Request) {
// 	firebase_id := r.URL.Query().Get("firebase_uid")
// 	if firebase_id == "" {
// 		failureResponse := resp.Failure{}
// 		failureResponse.SetStatusCode(http.StatusBadRequest)
// 		failureResponse.SetMessage("Invalid request body: firebase_id is required")
// 		failureResponse.JSON(w)
// 		return
// 	}

// 	returned_user, statusCode, err := pkg.GetUserByFirebaseID(firebase_id)
// 	if err != nil {
// 		failureResponse := resp.Failure{}
// 		failureResponse.SetStatusCode(statusCode)
// 		failureResponse.SetMessage(err.Error())
// 		failureResponse.JSON(w)
// 		return
// 	}

// 	successResponse := &resp.Success{}
// 	successResponse.SetStatusCode(statusCode)
// 	successResponse.SetData(returned_user)
// 	successResponse.SetMessage("User fetched successfully")
// 	successResponse.JSON(w)
// }

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

	returned_user, statusCode, err := pkg.UpdateUser(&user)
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
	users, statusCode, err := pkg.GetAllUsers()
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

	statusCode, err := pkg.DeleteUser(user_id)
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