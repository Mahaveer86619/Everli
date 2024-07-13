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

type Event struct {
	Id            string   `json:"id"`
	CreatorId     string   `json:"creator_id"`
	Name          string   `json:"name"`
	Description   string   `json:"description"`
	Tags          []string `json:"tags"`
	CoverImageUrl string   `json:"cover_image_url"`
	CreatedAt     string   `json:"created_at"`
}

func CreateEvent(event *Event) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/events"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Generate a unique ID for the event
	id := uuid.New().String()
	event.Id = id

	// Marshal user data to JSON
	jsonData, err := json.Marshal(event)
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

func GetEvent(event_id string) (*Event, int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/events"
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
	q.Add("id", "eq."+event_id)
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

	var event []Event
	err = json.NewDecoder(resp.Body).Decode(&event)
	if err != nil {
		fmt.Println(err)
		return nil, -1, err
	}

	return &event[0], -1, nil
}

func UpdateEvent(event *Event) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/events"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(event)
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
	q.Add("id", "eq."+event.Id)
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

func DeleteEvent(event_id string) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/events"
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
	q.Add("id", "eq."+event_id)
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
