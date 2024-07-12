package pkg

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	response "github.com/Mahaveer86619/Everli/pkg/Response"
)

type MyUser struct {
	User_id      string   `json:"id"`
	Firebase_uid string   `json:"firebase_uid"`
	Username     string   `json:"username"`
	Email        string   `json:"email"`
	Bio          string   `json:"bio"`
	Avatar_url   string   `json:"avatar_url"`
	Skills       []string `json:"skills"`
}

func Createuser(user *MyUser) (int, error) {
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
		var supabaseErr response.SupabaseError
		if err := json.NewDecoder(resp.Body).Decode(&supabaseErr); err != nil {
			return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
		}
		return resp.StatusCode, fmt.Errorf(supabaseErr.Message)
	}

	return -1, nil

}

func GetUser(user_id string) (*MyUser, int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/profiles"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Create HTTP request
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		fmt.Println(err)
		return nil, -1, err
	}

	// Set headers
	req.Header.Set("apikey", serviceKey)
	req.Header.Set("Authorization", "Bearer "+serviceKey)

	// Add query parameters
	q := req.URL.Query()
	q.Add("firebase_uid", "eq."+user_id)
	q.Add("select", "*")
	req.URL.RawQuery = q.Encode()

	// Send request and handle response
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return nil, -1, err
	}
	defer resp.Body.Close()

	// Check response status code
	if resp.StatusCode != http.StatusOK {
		var supabaseErr response.SupabaseError
		if err := json.NewDecoder(resp.Body).Decode(&supabaseErr); err != nil {
			return nil, resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
		}
		return nil, resp.StatusCode, fmt.Errorf(supabaseErr.Message)
	}

	var user []MyUser
	err = json.NewDecoder(resp.Body).Decode(&user)
	if err != nil {
		fmt.Println(err)
		return nil,-1, err
	}

	return &user[0], -1, nil

}

func UpdateUser(user *MyUser) (int, error) {
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
	if resp.StatusCode != http.StatusNoContent {
		var supabaseErr response.SupabaseError
		if err := json.NewDecoder(resp.Body).Decode(&supabaseErr); err != nil {
			return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
		}
		return resp.StatusCode, fmt.Errorf(supabaseErr.Message)
	}

	return -1, nil
}
