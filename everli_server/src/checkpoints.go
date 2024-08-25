package pkg

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	db "github.com/Mahaveer86619/Everli/src/DB"
	"github.com/google/uuid"
)

type Checkpoint struct {
	Id           string `json:"id"`
	AssignmentId string `json:"assignment_id"`
	MemberId     string `json:"member_id"`
	Goal         string `json:"goal"`
	Description  string `json:"description"`
	DueDate      string `json:"due_date"`
	Status       string `json:"status"`
	CreatedAt    string `json:"created_at"`
	UpdatedAt    string `json:"updated_at"`
}

func CreateCheckpoint(checkpoint *Checkpoint) (*Checkpoint, int, error) {
	conn := db.GetDBConnection()

	query := `
		INSERT INTO checkpoints (id, assignment_id, member_id, goal, description, due_date, status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *
	`
	// Generate a unique ID for the event
	checkpoint.Id = uuid.New().String()

	if err := conn.QueryRow(
		query,
		checkpoint.Id,
		checkpoint.AssignmentId,
		checkpoint.MemberId,
		checkpoint.Goal,
		checkpoint.Description,
		checkpoint.DueDate,
		checkpoint.Status,
		checkpoint.CreatedAt,
		checkpoint.UpdatedAt,
	).Scan(
		&checkpoint.Id,
		&checkpoint.AssignmentId,
		&checkpoint.MemberId,
		&checkpoint.Goal,
		&checkpoint.Description,
		&checkpoint.DueDate,
		&checkpoint.Status,
		&checkpoint.CreatedAt,
		&checkpoint.UpdatedAt,
	); err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating checkpoint: %w", err)
	}

	return checkpoint, http.StatusCreated, nil
}

func GetCheckpoint(checkpoint_id string) (*Checkpoint, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM checkpoints
	  WHERE id = $1
	`
	var checkpoint Checkpoint
	if err := conn.QueryRow(
		query,
		checkpoint_id,
	).Scan(
		&checkpoint.Id,
		&checkpoint.AssignmentId,
		&checkpoint.MemberId,
		&checkpoint.Goal,
		&checkpoint.Description,
		&checkpoint.DueDate,
		&checkpoint.Status,
		&checkpoint.CreatedAt,
		&checkpoint.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("checkpoint not found with id: %s", checkpoint_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return &checkpoint, http.StatusOK, nil
}

func GetCheckpointsByMemberId(member_id string) ([]Checkpoint, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM checkpoints
	  WHERE member_id = $1
	`

	rows, err := conn.Query(query, member_id)
	if err != nil {
		fmt.Print("error getting checkpoints: %w", err)
	}
	defer rows.Close()

	var checkpoints []Checkpoint
	for rows.Next() {
		var checkpoint Checkpoint
		if err := rows.Scan(
			&checkpoint.Id,
			&checkpoint.AssignmentId,
			&checkpoint.MemberId,
			&checkpoint.Goal,
			&checkpoint.Description,
			&checkpoint.DueDate,
			&checkpoint.Status,
			&checkpoint.CreatedAt,
			&checkpoint.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}
		checkpoints = append(checkpoints, checkpoint)
	}
	if err := rows.Err(); err != nil {
		log.Panic(err)
	}
	return checkpoints, http.StatusOK, nil
}

func GetCheckpointsByAssignmentId(assignment_id string) ([]Checkpoint, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM checkpoints
	  WHERE assignment_id = $1
	`

	rows, err := conn.Query(query, assignment_id)
	if err != nil {
		fmt.Print("error getting checkpoints: %w", err)
	}
	defer rows.Close()

	var checkpoints []Checkpoint
	for rows.Next() {
		var checkpoint Checkpoint
		if err := rows.Scan(
			&checkpoint.Id,
			&checkpoint.AssignmentId,
			&checkpoint.MemberId,
			&checkpoint.Goal,
			&checkpoint.Description,
			&checkpoint.DueDate,
			&checkpoint.Status,
			&checkpoint.CreatedAt,
			&checkpoint.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		checkpoints = append(checkpoints, checkpoint)
	}
	if err := rows.Err(); err != nil {
		log.Panic(err)
	}

	return checkpoints, http.StatusOK, nil
}

func UpdateCheckpoint(checkpoint *Checkpoint) (*Checkpoint, int, error) {
	conn := db.GetDBConnection()

	query := `UPDATE checkpoints 
	SET assignment_id = $1, member_id = $2, goal = $3, description = $4, due_date = $5, status = $6, created_at = $7, updated_at = $8
	WHERE id = $9 RETURNING *
	`

	if err := conn.QueryRow(
		query,
		checkpoint.AssignmentId,
		checkpoint.MemberId,
		checkpoint.Goal,
		checkpoint.Description,
		checkpoint.DueDate,
		checkpoint.Status,
		checkpoint.CreatedAt,
		checkpoint.UpdatedAt,
		checkpoint.Id,
	).Scan(
		&checkpoint.Id,
		&checkpoint.AssignmentId,
		&checkpoint.MemberId,
		&checkpoint.Goal,
		&checkpoint.Description,
		&checkpoint.DueDate,
		&checkpoint.Status,
		&checkpoint.CreatedAt,
		&checkpoint.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("checkpoint not found with id: %s", checkpoint.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return checkpoint, http.StatusOK, nil
}

func DeleteCheckpoint(checkpoint_id string) (int, error) {
	conn := db.GetDBConnection()

	query := "SELECT * FROM checkpoints WHERE id = $1"
	del_query := "DELETE FROM checkpoints WHERE id = $1"

	var checkpoint Checkpoint
	if err := conn.QueryRow(
		query,
		checkpoint_id,
	).Scan(
		&checkpoint.Id,
		&checkpoint.AssignmentId,
		&checkpoint.MemberId,
		&checkpoint.Goal,
		&checkpoint.Description,
		&checkpoint.DueDate,
		&checkpoint.Status,
		&checkpoint.CreatedAt,
		&checkpoint.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("checkpoint not found with id: %s", checkpoint_id)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, checkpoint_id)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusNoContent, nil
}
