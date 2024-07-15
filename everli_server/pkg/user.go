package pkg

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	response "github.com/Mahaveer86619/Everli/pkg/Response"
	"github.com/google/uuid"
)

type MyUser struct {
	Id           string   `json:"id"`
	Firebase_uid string   `json:"firebase_uid"`
	Username     string   `json:"username"`
	Email        string   `json:"email"`
	Bio          string   `json:"bio"`
	Avatar_url   string   `json:"avatar_url"`
	Skills       []string `json:"skills"`
	Created_at   string   `json:"created_at"`
	Updated_at   string   `json:"updated_at"`
}

func Createuser(user *MyUser) (int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
		INSERT INTO profiles (id, firebase_uid, username, email, avatar_url, bio, skills, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
	`

	// Generate a unique ID and skillsJSON for the user
	user.Id = uuid.New().String()
	skillsStr := strings.Join(user.Skills, "|")

	fmt.Printf("Inserting user: %s, %s, %s, %s, %s, %s, %s, %s, %s\n", user.Id, user.Firebase_uid, user.Username, user.Email, user.Avatar_url, user.Bio, skillsStr, user.Created_at, user.Updated_at)

	_, err := conn.Exec(ctx, query, user.Id, user.Firebase_uid, user.Username, user.Email, user.Avatar_url, user.Bio, skillsStr, user.Created_at, user.Updated_at)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error creating user: %w", err)
	}

	return http.StatusCreated, nil
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
		return nil, -1, err
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
	q.Add("id", "eq."+user.Id)
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
