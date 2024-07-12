package pkg

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
)

type Assignment struct {
	Id          string `json:"id"`
	EventId     string `json:"event_id"`
	MemberId    string `json:"member_id"`
	Goal        string `json:"goal"`
	Description string `json:"description"`
	DueDate     string `json:"due_date"`
	Status      string `json:"status"`
	CreatedAt   string `json:"created_at"`
}

func CreateAssignment(assignment *Assignment) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/assignments"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(assignment)
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
		// Read the response body
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Println("Error reading response body:", err)
			return -1, err
		}

		// Print the response body
		fmt.Println("Response body:", string(body))
		return resp.StatusCode, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	return -1, nil
}

func GetAssignment(assignment_id string) (*Assignment, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/assignments"
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

	// Add query parameters
	q := req.URL.Query()
	q.Add("id", "eq."+assignment_id)
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

	var assignments []Assignment
	err = json.NewDecoder(resp.Body).Decode(&assignments)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	return &assignments[0], nil
}

func UpdateAssignment(assignment *Assignment) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/assignments"
	serviceKey := os.Getenv("SUPABASE_SERVICE_KEY")

	// Marshal user data to JSON
	jsonData, err := json.Marshal(assignment)
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
	q.Add("id", "eq."+assignment.Id)
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

func DeleteAssignment(assignment_id string) (int, error) {
	url := os.Getenv("SUPABASE_BASE_URL") + "/rest/v1/assignments"
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
	q.Add("id", "eq."+assignment_id)
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
		return -1, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	var assignments []Assignment
	err = json.NewDecoder(resp.Body).Decode(&assignments)
	if err != nil {
		fmt.Println(err)
		return -1, err
	}

	return -1, nil
}
