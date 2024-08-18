package db

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/lib/pq"
)

var db *sql.DB

func ConnectDB() (*sql.DB, error) {
	db, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
	if err != nil {
		fmt.Printf("Unable to connect to database: %v", err)
	}

	return db, nil
}

// SetDBConnection sets the database connection
func SetDBConnection(conn *sql.DB) {
	db = conn
}

// GetDBConnection returns the database connection
func GetDBConnection() *sql.DB {
	return db
}

func CloseDBConnection(conn *sql.DB) {
	conn.Close()
}

func CreateTables(conn *sql.DB) error {
	queries := []string{
		`CREATE TABLE IF NOT EXISTS profiles (
  			id UUID PRIMARY KEY,
			firebase_uid VARCHAR(255) UNIQUE NOT NULL,
  			username TEXT UNIQUE NOT NULL,
  			email TEXT UNIQUE NOT NULL,
  			avatar_url TEXT,
  			bio TEXT,
  			skills TEXT,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS events (
			id UUID PRIMARY KEY,
			creator_id UUID REFERENCES profiles(id) NOT NULL,
			name TEXT NOT NULL,
			description TEXT,
			tags TEXT,
			cover_image_url TEXT,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS assignments (
			id UUID PRIMARY KEY,
			event_id UUID REFERENCES events(id) NOT NULL,
			member_id UUID REFERENCES profiles(id),
			goal TEXT NOT NULL,
			description TEXT,
			due_date TEXT,
			status TEXT,
			is_completed BOOLEAN,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS checkpoints (
			id UUID PRIMARY KEY,
			assignment_id UUID REFERENCES assignments(id) NOT NULL,
			member_id UUID REFERENCES profiles(id) NOT NULL,
			goal TEXT NOT NULL,
			description TEXT,
			due_date TEXT,
			status TEXT,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS roles (
			id UUID PRIMARY KEY,
			event_id UUID REFERENCES events(id) NOT NULL,
			member_id UUID REFERENCES profiles(id) NOT NULL,
			role TEXT NOT NULL,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS invitations (
			id UUID PRIMARY KEY,
			code TEXT UNIQUE NOT NULL,
			event_id UUID REFERENCES events(id) NOT NULL,
			expiry TEXT,
			role TEXT,
  			created_at TEXT
		);`,
	}

	for _, query := range queries {
		_, err := conn.Exec(query)
		if err != nil {
			return fmt.Errorf("error creating table: %w", err)
		}
	}

	return nil
}
