package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v4"
	_ "github.com/lib/pq"
)

var db *pgx.Conn

func ConnectDB() (*pgx.Conn, error) {
	// Get database connection details from environment variables
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")

	// Create the connection string
	connString := fmt.Sprintf("postgres://%s:%s@%s:%s/%s", dbUser, dbPassword, dbHost, dbPort, dbName)

	// Connect to the database
	conn, err := pgx.Connect(context.Background(), connString)
	if err != nil {
		fmt.Printf("Unable to connect to database: %v", err)
	}

	return conn, nil
}

// SetDBConnection sets the database connection
func SetDBConnection(conn *pgx.Conn) {
	db = conn
}

// GetDBConnection returns the database connection
func GetDBConnection() *pgx.Conn {
	return db
}

func CloseDBConnection(conn *pgx.Conn) {
	conn.Close(context.Background())
}

func CreateTables(conn *pgx.Conn) error {
	ctx := context.Background()

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
			due_date TIMESTAMP,
			status TEXT,
  			created_at TEXT,
  			updated_at TEXT
		);`,
		`CREATE TABLE IF NOT EXISTS checkpoints (
			id UUID PRIMARY KEY,
			assignment_id UUID REFERENCES assignments(id) NOT NULL,
			member_id UUID REFERENCES profiles(id) NOT NULL,
			goal TEXT NOT NULL,
			description TEXT,
			due_date TIMESTAMP,
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
		_, err := conn.Exec(ctx, query)
		if err != nil {
			return fmt.Errorf("error creating table: %w", err)
		}
	}

	return nil
}
