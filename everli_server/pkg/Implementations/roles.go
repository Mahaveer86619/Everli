package Implementations

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	"github.com/google/uuid"
)

type Role struct {
	Id        string `json:"id"`
	EventId   string `json:"event_id"`
	MemberId  string `json:"member_id"`
	Role      string `json:"role"`
	CreatedAt string `json:"created_at"`
	UpdatedAt string `json:"updated_at"`
}

func CreateRole(role *Role) (*Role, int, error) {
	conn := db.GetDBConnection()

	query := `
		INSERT INTO roles (id, event_id, member_id, role, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6) RETURNING *
	`

	// Generate a unique ID for the event
	role.Id = uuid.New().String()

	if err := conn.QueryRow(
		query,
		role.Id,
		role.EventId,
		role.MemberId,
		role.Role,
		role.CreatedAt,
		role.UpdatedAt,
	).Scan(
		&role.Id,
		&role.EventId,
		&role.MemberId,
		&role.Role,
		&role.CreatedAt,
		&role.UpdatedAt,
	); err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating checkpoint: %w", err)
	}

	fmt.Println("Created role:")
	PrintRole(role)

	return role, http.StatusCreated, nil
}

func GetRoleById(role_id string) (*Role, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM roles
	  WHERE id = $1
	`
	var role Role
	if err := conn.QueryRow(
		query,
		role_id,
	).Scan(
		&role.Id,
		&role.EventId,
		&role.MemberId,
		&role.Role,
		&role.CreatedAt,
		&role.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("role not found with id: %s", role_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return &role, http.StatusOK, nil
}

func GetRolesByEventId(event_id string) ([]Role, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM roles
	  WHERE event_id = $1
	`

	rows, err := conn.Query(query, event_id)
	if err != nil {
		fmt.Print("error getting members: %w", err)
	}
	defer rows.Close()

	var roles []Role
	for rows.Next() {
		var role Role
		if err := rows.Scan(
			&role.Id,
			&role.EventId,
			&role.MemberId,
			&role.Role,
			&role.CreatedAt,
			&role.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		roles = append(roles, role)
	}

	return roles, http.StatusOK, nil
}

func GetRolesByMemberId(member_id string) ([]Role, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM roles
	  WHERE member_id = $1
	`

	rows, err := conn.Query(query, member_id)
	if err != nil {
		fmt.Print("error getting members: %w", err)
	}
	defer rows.Close()

	var roles []Role

	for rows.Next() {
		var role Role
		if err := rows.Scan(
			&role.Id,
			&role.EventId,
			&role.MemberId,
			&role.Role,
			&role.CreatedAt,
			&role.UpdatedAt,
		); err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}

		roles = append(roles, role)
	}

	return roles, http.StatusOK, nil
}

func UpdateRole(role *Role) (*Role, int, error) {
	conn := db.GetDBConnection()

	query := `UPDATE invitations 
	SET event_id = $1, member_id = $2, role = $3, created_at = $4, updated_at = $5
	WHERE id = $6 RETURNING *
	`

	if err := conn.QueryRow(
		query,
		role.EventId,
		role.MemberId,
		role.Role,
		role.CreatedAt,
		role.UpdatedAt,
		role.Id,
	).Scan(
		&role.Id,
		&role.EventId,
		&role.MemberId,
		&role.Role,
		&role.CreatedAt,
		&role.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("role not found with id: %s", role.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}

	return role, http.StatusOK, nil
}

func DeleteRole(role_id string) (int, error) {
	conn := db.GetDBConnection()

	query := `SELECT * FROM roles WHERE id = $1`
	del_query := "DELETE FROM roles WHERE id = $1"
	
	var role Role
	if err := conn.QueryRow(
		query,
		role_id,
	).Scan(
		&role.Id,
		&role.EventId,
		&role.MemberId,
		&role.Role,
		&role.CreatedAt,
		&role.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("role not found with id: %s", role_id)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, role_id)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusNoContent, nil
}

func PrintRole(role *Role) {
	fmt.Println("role:")
	fmt.Printf(`
	ID: %s
	Event ID: %s
	Member ID: %s
	Role: %s
	Created At: %s
	Updated At: %s
	`, role.Id, role.EventId, role.MemberId, role.Role, role.CreatedAt, role.UpdatedAt)
}