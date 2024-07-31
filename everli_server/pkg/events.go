package pkg

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"strings"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
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
	UpdatedAt     string   `json:"updated_at"`
}

type event_pg struct {
	Id            string `json:"id"`
	CreatorId     string `json:"creator_id"`
	Name          string `json:"name"`
	Description   string `json:"description"`
	Tags          string `json:"tags"`
	CoverImageUrl string `json:"cover_image_url"`
	CreatedAt     string `json:"created_at"`
	UpdatedAt     string `json:"updated_at"`
}

func CreateEvent(event *Event) (*Event, int, error) {
	conn := db.GetDBConnection()

	query := `
		INSERT INTO events (id, creator_id, name, description, tags, cover_image_url, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *
	`

	// Generate a unique ID for the event
	event.Id = uuid.New().String()
	tagsStr := strings.Join(event.Tags, "|")

	var pg_event event_pg
	err := conn.QueryRow(
		query,
		event.Id,
		event.CreatorId,
		event.Name,
		event.Description,
		tagsStr,
		event.CoverImageUrl,
		event.CreatedAt,
		event.UpdatedAt).Scan(
		&pg_event.Id,
		&pg_event.CreatorId,
		&pg_event.Name,
		&pg_event.Description,
		&pg_event.Tags,
		&pg_event.CoverImageUrl,
		&pg_event.CreatedAt,
		&pg_event.UpdatedAt)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating event: %w", err)
	}

	my_event := pgEventToEvent(pg_event)

	return my_event, http.StatusCreated, nil
}

func GetEvent(event_id string) (*Event, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT * FROM events WHERE id = $1
	`
	var pg_event event_pg
	if err := conn.QueryRow(
		query,
		event_id,
	).Scan(
		&pg_event.Id,
		&pg_event.CreatorId,
		&pg_event.Name,
		&pg_event.Description,
		&pg_event.Tags,
		&pg_event.CoverImageUrl,
		&pg_event.CreatedAt,
		&pg_event.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("event not found with id: %s", event_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}
	// Parse skills string to slice
	my_event := pgEventToEvent(pg_event)

	return my_event, http.StatusOK, nil
}

func GetAllEvents() ([]Event, int, error) {
	conn := db.GetDBConnection()

	query := `
	  SELECT *
	  FROM events
	`

	rows, err := conn.Query(query)
	if err != nil {
		fmt.Print("error getting events: %w", err)
	}
	defer rows.Close()

	var events []Event

	for rows.Next() {
		var event *Event
		var pg_return event_pg
		err := rows.Scan(
			&pg_return.Id,
			&pg_return.CreatorId,
			&pg_return.Name,
			&pg_return.Description,
			&pg_return.Tags,
			&pg_return.CoverImageUrl,
			&pg_return.CreatedAt,
			&pg_return.UpdatedAt,
		)
		if err != nil {
			if err == sql.ErrNoRows {
				return []Event{}, http.StatusOK, nil
			}
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}
		event = pgEventToEvent(pg_return)
		events = append(events, *event)
	}
	if err := rows.Err(); err != nil {
		log.Panic(err)
	}

	return events, http.StatusOK, nil
}

func UpdateEvent(event *Event) (*Event, int, error) {
	conn := db.GetDBConnection()

	query := `UPDATE events 
	SET creator_id = $1, name = $2, description = $3, tags = $4, cover_image_url = $5, created_at = $6, updated_at = $7
	WHERE id = $8 RETURNING *
	`

	tagsStr := strings.Join(event.Tags, "|")
	var pg_event event_pg

	if err := conn.QueryRow(
		query,
		event.CreatorId,
		event.Name,
		event.Description,
		tagsStr,
		event.CoverImageUrl,
		event.CreatedAt,
		event.UpdatedAt,
		event.Id,
	).Scan(
		&pg_event.Id,
		&pg_event.CreatorId,
		&pg_event.Name,
		&pg_event.Description,
		&pg_event.Tags,
		&pg_event.CoverImageUrl,
		&pg_event.CreatedAt,
		&pg_event.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("event not found with id: %s", event.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}
	// Parse skills string to slice
	my_event := pgEventToEvent(pg_event)

	return my_event, http.StatusOK, nil
}

func DeleteEvent(event_id string) (int, error) {
	conn := db.GetDBConnection()

	query := `SELECT * FROM events WHERE id = $1`
	del_query := "DELETE FROM events WHERE id = $1"

	var pg_event event_pg
	if err := conn.QueryRow(
		query,
		event_id,
	).Scan(
		&pg_event.Id,
		&pg_event.CreatorId,
		&pg_event.Name,
		&pg_event.Description,
		&pg_event.Tags,
		&pg_event.CoverImageUrl,
		&pg_event.CreatedAt,
		&pg_event.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("event not found with id: %s", event_id)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, event_id)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusNoContent, nil
}

func pgEventToEvent(pg_event event_pg) *Event {
	event := &Event{
		Id:            pg_event.Id,
		CreatorId:     pg_event.CreatorId,
		Name:          pg_event.Name,
		Description:   pg_event.Description,
		Tags:          strings.Split(pg_event.Tags, "|"),
		CoverImageUrl: pg_event.CoverImageUrl,
		CreatedAt:     pg_event.CreatedAt,
		UpdatedAt:     pg_event.UpdatedAt,
	}

	return event
}

func EventTopgEvent(event *Event) *event_pg {
	pg_event := &event_pg{
		Id:            event.Id,
		CreatorId:     event.CreatorId,
		Name:          event.Name,
		Description:   event.Description,
		Tags:          strings.Join(event.Tags, "|"),
		CoverImageUrl: event.CoverImageUrl,
		CreatedAt:     event.CreatedAt,
		UpdatedAt:     event.UpdatedAt,
	}

	return pg_event
}
