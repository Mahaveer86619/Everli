package pkg

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	"github.com/google/uuid"
)

type Assignment struct {
	Id          string `json:"id"`
	EventId     string `json:"event_id"`
	MemberId    string `json:"member_id"`
	Goal        string `json:"goal"`
	Description string `json:"description"`
	DueDate     string `json:"due_date"`
	Status      string `json:"status"`
	IsCompleted bool   `json:"is_completed"`
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string `json:"updated_at"`
}

func CreateAssignment(assignment *Assignment) (*Assignment, int, error) {
	conn := db.GetDBConnection()

	query := `
		INSERT INTO assignments (id, event_id, member_id, goal, description, due_date, status, is_completed, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *
	`

	// Generate a unique ID for the event
	assignment.Id = uuid.New().String()

	if err := conn.QueryRow(
		query,
		assignment.Id,
		assignment.EventId,
		assignment.MemberId,
		assignment.Goal,
		assignment.Description,
		assignment.DueDate,
		assignment.Status,
		assignment.IsCompleted,
		assignment.CreatedAt,
		assignment.UpdatedAt,
	).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
		&assignment.IsCompleted,
		&assignment.CreatedAt,
		&assignment.UpdatedAt,
	); err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating assignment: %w", err)
	}

	return assignment, http.StatusCreated, nil
}

func GetAssignment(assignment_id string) (*Assignment, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE id = $1
	`
	var assignment Assignment
	if err := conn.QueryRow(
		query,
		assignment_id,
	).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
		&assignment.IsCompleted,
		&assignment.CreatedAt,
		&assignment.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("assignment not found with id: %s", assignment_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return &assignment, http.StatusOK, nil
}

func GetAssignmentsByEventId(event_id string) ([]Assignment, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE event_id = $1
	`

	rows, err := conn.Query(query, event_id)
	if err != nil {
		fmt.Print("error getting assignments: %w", err)
	}
	defer rows.Close()

	var assignments []Assignment
	for rows.Next() {
		var assignment Assignment
		if err := rows.Scan(
			&assignment.Id,
			&assignment.EventId,
			&assignment.MemberId,
			&assignment.Goal,
			&assignment.Description,
			&assignment.DueDate,
			&assignment.Status,
			&assignment.IsCompleted,
			&assignment.CreatedAt,
			&assignment.UpdatedAt,
		); err != nil {
			if err == sql.ErrNoRows {
				return []Assignment{}, http.StatusOK, nil
			}
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		assignments = append(assignments, assignment)
	}

	return assignments, http.StatusOK, nil
}

func GetAssignmentsByMemberId(member_id string) ([]Assignment, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE member_id = $1
	`

	rows, err := conn.Query(query, member_id)
	if err != nil {
		fmt.Print("error getting assignments: %w", err)
	}
	defer rows.Close()

	var assignments []Assignment
	for rows.Next() {
		var assignment Assignment
		if err := rows.Scan(
			&assignment.Id,
			&assignment.EventId,
			&assignment.MemberId,
			&assignment.Goal,
			&assignment.Description,
			&assignment.DueDate,
			&assignment.Status,
			&assignment.IsCompleted,
			&assignment.CreatedAt,
			&assignment.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, sql.ErrNoRows
		}

		assignments = append(assignments, assignment)
	}

	return assignments, http.StatusOK, nil
}

func UpdateAssignment(assignment *Assignment) (*Assignment, int, error) {
	conn := db.GetDBConnection()

	query := `UPDATE assignments 
	SET event_id = $1, member_id = $2, goal = $3, description = $4, due_date = $5, status = $6, created_at = $7, updated_at = $8
	WHERE id = $9 RETURNING *
	`

	if err := conn.QueryRow(
		query,
		assignment.EventId,
		assignment.MemberId,
		assignment.Goal,
		assignment.Description,
		assignment.DueDate,
		assignment.Status,
		assignment.IsCompleted,
		assignment.CreatedAt,
		assignment.UpdatedAt,
		assignment.Id,
	).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
		&assignment.IsCompleted,
		&assignment.CreatedAt,
		&assignment.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("assignment not found with id: %s", assignment.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return assignment, http.StatusOK, nil
}

func DeleteAssignment(assignment_id string) (int, error) {
	conn := db.GetDBConnection()

	query := `SELECT * FROM assignments WHERE id = $1`
	del_query := "DELETE FROM assignments WHERE id = $1"

	var assignment Assignment
	if err := conn.QueryRow(
		query,
		assignment_id,
	).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
		&assignment.IsCompleted,
		&assignment.CreatedAt,
		&assignment.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("assignment not found with id: %s", assignment_id)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, assignment_id)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusNoContent, nil
}

// func printAssignment(assignment *Assignment) {
// 	fmt.Println("Assignment Details:")
// 	fmt.Printf("  - Id:           %s\n", assignment.Id)
// 	fmt.Printf("  - EventId:      %s\n", assignment.EventId)
// 	fmt.Printf("  - MemberId:     %s\n", assignment.MemberId)
// 	fmt.Printf("  - Goal:         %s\n", assignment.Goal)
// 	fmt.Printf("  - Description:  %s\n", assignment.Description)
// 	fmt.Printf("  - DueDate:      %s\n", assignment.DueDate)
// 	fmt.Printf("  - Status:       %s\n", assignment.Status)
// 	fmt.Printf("  - IsCompleted:  %t\n", assignment.IsCompleted)
// 	fmt.Printf("  - CreatedAt:   %s\n", assignment.CreatedAt)
// 	fmt.Printf("  - UpdatedAt:   %s\n", assignment.UpdatedAt)
// }
