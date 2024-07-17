package pkg

import (
	"context"
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
	CreatedAt   string `json:"created_at"`
	UpdatedAt   string `json:"updated_at"`
}

func CreateAssignment(assignment *Assignment) (*Assignment, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
		INSERT INTO assignments (id, event_id, member_id, goal, description, due_date, status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *
	`

	// Generate a unique ID for the event
	assignment.Id = uuid.New().String()

	if err := conn.QueryRow(
		ctx,
		query,
		assignment.Id,
		assignment.EventId,
		assignment.MemberId,
		assignment.Goal,
		assignment.Description,
		assignment.DueDate,
		assignment.Status,
		assignment.CreatedAt,
		assignment.UpdatedAt).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
		&assignment.CreatedAt,
		&assignment.UpdatedAt); err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating assignment: %w", err)
	}

	return assignment, http.StatusCreated, nil
}

func GetAssignment(assignment_id string) (*Assignment, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE id = $1
	`
	var assignment Assignment
	if err := conn.QueryRow(
		ctx,
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
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE event_id = $1
	`

	rows, err := conn.Query(ctx, query, event_id)
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
			&assignment.CreatedAt,
			&assignment.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		assignments = append(assignments, assignment)
	}

	return assignments, http.StatusOK, nil
}

func GetAssignmentsByMemberId(member_id string) ([]Assignment, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM assignments
	  WHERE member_id = $1
	`

	rows, err := conn.Query(ctx, query, member_id)
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
			&assignment.CreatedAt,
			&assignment.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		assignments = append(assignments, assignment)
	}

	return assignments, http.StatusOK, nil
}

func UpdateAssignment(assignment *Assignment) (*Assignment, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `UPDATE assignments 
	SET event_id = $1, member_id = $2, goal = $3, description = $4, due_date = $5, status = $6, created_at = $7, updated_at = $8
	WHERE id = $9 RETURNING *
	`

	if err := conn.QueryRow(
		ctx,
		query,
		assignment.EventId,
		assignment.MemberId,
		assignment.Goal,
		assignment.Description,
		assignment.DueDate,
		assignment.Status,
		assignment.CreatedAt,
		assignment.UpdatedAt,
		assignment.Id).Scan(
		&assignment.Id,
		&assignment.EventId,
		&assignment.MemberId,
		&assignment.Goal,
		&assignment.Description,
		&assignment.DueDate,
		&assignment.Status,
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
	ctx := context.Background()

	query := "DELETE FROM assignments WHERE id = $1"

	result, err := conn.Exec(ctx, query, assignment_id)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	rowsAffected := result.RowsAffected()

	if rowsAffected == 0 {
		return http.StatusNotFound, fmt.Errorf("assignment not found with id: %s", assignment_id)
	}

	return http.StatusNoContent, nil
}
