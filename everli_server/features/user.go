package features

/*

User Status Codes
status code 201 if user created successfully
status code 409 if user name already exists
status code 200 if user successfully fetched
status code 204 if user updated successfully

*/

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

type MyUser struct {
	User_id    string   `json:"id"`
	Username   string   `json:"username"`
	Email      string   `json:"email"`
	Bio        string   `json:"bio"`
	Avatar_url string   `json:"avatar_url"`
	Skills     []string `json:"skills"`
}

func init() {
	godotenv.Load(".env")
}

func createuser(user *MyUser) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/profiles"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(user)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	// Create HTTP request
	req, err := http.NewRequest(http.MethodPost, url, bytes.NewReader(jsonData))
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	// Set headers
	req.Header.Set("apikey", serviceKey)
	req.Header.Set("Authorization", "Bearer "+serviceKey)
	req.Header.Set("Content-Type", "application/json")

	// Send request and handle response
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}
	defer resp.Body.Close()

	// Check response status code
	if resp.StatusCode != http.StatusCreated {
		return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	return -1, nil

}

func getUser(user_id string) (*MyUser, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/profiles"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Create HTTP request
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	// Set headers
	req.Header.Set("apikey", serviceKey)
	req.Header.Set("Authorization", "Bearer "+serviceKey)

	// Add query parameters (optional)
	q := req.URL.Query()
	q.Add("id", "eq."+user_id)
	q.Add("select", "*")
	req.URL.RawQuery = q.Encode()

	// Send request and handle response
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	defer resp.Body.Close()

	// Check response status code
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	var user []MyUser
	err = json.NewDecoder(resp.Body).Decode(&user)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	return &user[0], nil

}

func updateUser(user *MyUser) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/profiles"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(user)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	// Create HTTP request
	req, err := http.NewRequest(http.MethodPatch, url, bytes.NewReader(jsonData))
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	// Set headers
	req.Header.Set("apikey", serviceKey)
	req.Header.Set("Authorization", "Bearer "+serviceKey)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Prefer", "resolution=merge-duplicates")

	// Add query parameters (optional)
	q := req.URL.Query()
	q.Add("id", "eq."+user.User_id)
	req.URL.RawQuery = q.Encode()

	// Send request and handle response
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}
	defer resp.Body.Close()

	// Check response status code
	if resp.StatusCode != http.StatusOK {
		return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	return -1, nil

}

func CreateUserController(w http.ResponseWriter, r *http.Request) {
	var user MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := createuser(&user)
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
		w.Write([]byte("Invalid request body"))
		return
	}

	user, err := getUser(user_id)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}

func UpdateUserController(w http.ResponseWriter, r *http.Request) {
	var user MyUser
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("Invalid request body"))
		return
	}

	statusCode, err := updateUser(&user)
	if err != nil {
		w.WriteHeader(statusCode)
		w.Write([]byte(err.Error()))
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}
