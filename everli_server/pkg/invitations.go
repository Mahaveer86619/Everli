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

type Invitation struct {
	Id         string `json:"id"`
	EventId    string `json:"event_id"`
	Code       string `json:"code"`
	Role       string `json:"role"`
	ExpiryDate string `json:"expiry"`
	CreatedAt  string `json:"created_at"`
}

func CreateInvitation(invitation *Invitation) (*Invitation, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
		INSERT INTO invitations (id, event_id, code, role, expiry, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *
	`

	// Generate a unique ID for the event
	invitation.Id = uuid.New().String()

	if err := conn.QueryRow(
		ctx,
		query,
		invitation.Id,
		invitation.EventId,
		invitation.Code,
		invitation.Role,
		invitation.ExpiryDate,
		invitation.CreatedAt,
	).Scan(
		&invitation.Id,
		&invitation.EventId,
		&invitation.Code,
		&invitation.Role,
		&invitation.ExpiryDate,
		&invitation.CreatedAt,
	); err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating checkpoint: %w", err)
	}

	return invitation, http.StatusCreated, nil
}

func GetInvitation(code string) (*Invitation, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM invitations
	  WHERE code = $1
	`
	var invitation Invitation
	if err := conn.QueryRow(
		ctx,
		query,
		code,
	).Scan(
		&invitation.Id,
		&invitation.EventId,
		&invitation.Code,
		&invitation.Role,
		&invitation.ExpiryDate,
		&invitation.CreatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("invitation not found with code: %s", code)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return &invitation, http.StatusOK, nil
}

func UpdateInvitation(invitation *Invitation) (*Invitation, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `UPDATE invitations 
	SET event_id = $1, code = $2, role = $3, expiry = $4, created_at = $5, updated_at = $6
	WHERE id = $7 RETURNING *
	`

	if err := conn.QueryRow(
		ctx,
		query,
		invitation.EventId,
		invitation.Code,
		invitation.Role,
		invitation.ExpiryDate,
		invitation.CreatedAt,
		invitation.Id).Scan(
		&invitation.Id,
		&invitation.EventId,
		&invitation.Code,
		&invitation.Role,
		&invitation.ExpiryDate,
		&invitation.CreatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("invitation not found with id: %s", invitation.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return invitation, http.StatusOK, nil
}

func DeleteInvitation(invitation_id string) (int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := "DELETE FROM invitations WHERE id = $1"

	result, err := conn.Exec(ctx, query, invitation_id)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	rowsAffected := result.RowsAffected()

	if rowsAffected == 0 {
		return http.StatusNotFound, fmt.Errorf("invitation not found with id: %s", invitation_id)
	}

	return http.StatusNoContent, nil
}
