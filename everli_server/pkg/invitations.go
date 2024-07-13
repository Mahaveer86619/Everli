package pkg

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	response "github.com/Mahaveer86619/Everli/pkg/Response"
	"github.com/google/uuid"
)

type Invitation struct {
	Id         string `json:"id"`
	EventId    string `json:"event_id"`
	Code       string `json:"code"`
	Role       string `json:"role"`
	ExpiryDate string `json:"expiry"`
}

func CreateInvitation(invitation *Invitation) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/invitations"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Generate a unique ID for the invitation
	id := uuid.New().String()
	invitation.Id = id

	// Marshal user data to JSON
	jsonData, err := json.Marshal(invitation)
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

func GetInvitation(invitation_id string) (*Invitation, int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/invitations"
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
	q.Add("id", "eq."+invitation_id)
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

	var invitations []Invitation
	err = json.NewDecoder(resp.Body).Decode(&invitations)
	if err != nil {
		fmt.Println(err)
		return nil, -1, err
	}

	return &invitations[0], -1, nil
}

func UpdateInvitation(invitation *Invitation) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/invitations"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(invitation)
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
	q.Add("id", "eq."+invitation.Id)
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
	if resp.StatusCode != 204 {
		var supabaseErr response.SupabaseError
		if err := json.NewDecoder(resp.Body).Decode(&supabaseErr); err != nil {
			return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
		}
		return resp.StatusCode, fmt.Errorf(supabaseErr.Message)
	}

	return -1, nil
}

func DeleteInvitation(invitation_id string) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/invitations"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Create HTTP request
	req, err := http.NewRequest(http.MethodDelete, url, nil)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	// Set headers
	req.Header.Set("apikey", serviceKey)
	req.Header.Set("Authorization", "Bearer "+serviceKey)

	// Add query parameters
	q := req.URL.Query()
	q.Add("id", "eq."+invitation_id)
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
