package pkg

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"strings"

	db "github.com/Mahaveer86619/Everli/pkg/DB"
	"github.com/google/uuid"
)

type MyUser struct {
	Id           string   `json:"id"`
	Firebase_uid string   `json:"firebase_uid"`
	Username     string   `json:"username"`
	Email        string   `json:"email"`
	Bio          string   `json:"bio"`
	Avatar_url   string   `json:"avatar_url"`
	Skills       []string `json:"skills"`
	Created_at   string   `json:"created_at"`
	Updated_at   string   `json:"updated_at"`
}

type pg_return struct {
	Id           string `json:"id"`
	Firebase_uid string `json:"firebase_uid"`
	Username     string `json:"username"`
	Email        string `json:"email"`
	Bio          string `json:"bio"`
	Avatar_url   string `json:"avatar_url"`
	Skills       string `json:"skills"`
	Created_at   string `json:"created_at"`
	Updated_at   string `json:"updated_at"`
}

func Createuser(user *MyUser) (*MyUser, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
		INSERT INTO profiles (id, firebase_uid, username, email, avatar_url, bio, skills, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *
	`

	// Generate a unique ID and skillsJSON for the user
	user.Id = uuid.New().String()
	skillsStr := strings.Join(user.Skills, "|")

	var pg_user pg_return
	err := conn.QueryRow(
		ctx,
		query,
		user.Id,
		user.Firebase_uid,
		user.Username,
		user.Email,
		user.Avatar_url,
		user.Bio,
		skillsStr,
		user.Created_at,
		user.Updated_at).Scan(
		&pg_user.Id,
		&pg_user.Firebase_uid,
		&pg_user.Username,
		&pg_user.Email,
		&pg_user.Avatar_url,
		&pg_user.Bio,
		&pg_user.Skills,
		&pg_user.Created_at,
		&pg_user.Updated_at)
	if err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error creating user: %w", err)
	}

	my_user, err := pgUserToUser(pg_user)
	if err != nil {
		log.Panic(err)
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return my_user, http.StatusCreated, nil
}

func GetAllUsers() ([]MyUser, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM profiles
	`

	rows, err := conn.Query(ctx, query)
	if err != nil {
		fmt.Print("error getting users: %w", err)
	}
	defer rows.Close()

	var users []MyUser

	for rows.Next() {
		var user *MyUser
		var pg_return pg_return
		err := rows.Scan(
			&pg_return.Id,
			&pg_return.Firebase_uid,
			&pg_return.Username,
			&pg_return.Email,
			&pg_return.Avatar_url,
			&pg_return.Bio,
			&pg_return.Skills,
			&pg_return.Created_at,
			&pg_return.Updated_at)
		if err != nil {
			return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
		}
		user, err = pgUserToUser(pg_return)
		if err != nil {
			log.Panic(err)
			return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
		}

		users = append(users, *user)
	}
	return users, http.StatusOK, nil
}

func GetUserByID(userID string) (*MyUser, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM profiles
	  WHERE id = $1
	`
	var pg_return pg_return
	if err := conn.QueryRow(
		ctx,
		query,
		userID,
	).Scan(
		&pg_return.Id,
		&pg_return.Firebase_uid,
		&pg_return.Username,
		&pg_return.Email,
		&pg_return.Avatar_url,
		&pg_return.Bio,
		&pg_return.Skills,
		&pg_return.Created_at,
		&pg_return.Updated_at,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with id: %s", userID)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}
	// Parse skills string to slice
	user, err := pgUserToUser(pg_return)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return user, http.StatusOK, nil
}

func GetUserByFirebaseID(firebase_id string) (*MyUser, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `
	  SELECT *
	  FROM profiles
	  WHERE firebase_uid = $1
	`
	var pg_return pg_return
	if err := conn.QueryRow(
		ctx,
		query,
		firebase_id,
	).Scan(
		&pg_return.Id,
		&pg_return.Firebase_uid,
		&pg_return.Username,
		&pg_return.Email,
		&pg_return.Avatar_url,
		&pg_return.Bio,
		&pg_return.Skills,
		&pg_return.Created_at,
		&pg_return.Updated_at,
	); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with firebase_uid: %s", firebase_id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}
	// Parse skills string to slice
	user, err := pgUserToUser(pg_return)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return user, http.StatusOK, nil
}



func UpdateUser(user *MyUser) (*MyUser, int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := `UPDATE profiles 
	SET firebase_uid = $1, username = $2, email = $3, bio = $4, avatar_url = $5, skills = $6, created_at = $7, updated_at = $8
	WHERE id = $9 RETURNING *
	`

	skillsStr := strings.Join(user.Skills, "|")
	var pg_return pg_return

	if err := conn.QueryRow(
		ctx,
		query,
		user.Firebase_uid,
		user.Username,
		user.Email,
		user.Bio,
		user.Avatar_url,
		skillsStr,
		user.Created_at,
		user.Updated_at,
		user.Id).Scan(
		&pg_return.Id,
		&pg_return.Firebase_uid,
		&pg_return.Username,
		&pg_return.Email,
		&pg_return.Avatar_url,
		&pg_return.Bio,
		&pg_return.Skills,
		&pg_return.Created_at,
		&pg_return.Updated_at); err != nil {
		if err == sql.ErrNoRows {
			return nil, http.StatusNotFound, fmt.Errorf("user not found with id: %s", user.Id)
		}
		return nil, http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	}
	// Parse skills string to slice
	user, err := pgUserToUser(pg_return)
	if err != nil {
		return nil, http.StatusInternalServerError, fmt.Errorf("error converting user: %w", err)
	}

	return user, http.StatusOK, nil
}

func DeleteUser(userId string) (int, error) {
	conn := db.GetDBConnection()
	ctx := context.Background()

	query := "DELETE FROM profiles WHERE id = $1"

	result, err := conn.Exec(ctx, query, userId)
	if err != nil {
		return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
	}

	rowsAffected := result.RowsAffected()

	if rowsAffected == 0 {
		return http.StatusNotFound, fmt.Errorf("user not found with id: %s", userId)
	}

	return http.StatusNoContent, nil
}

func pgUserToUser(pg_user pg_return) (*MyUser, error) {
	user := &MyUser{
		Id:           pg_user.Id,
		Firebase_uid: pg_user.Firebase_uid,
		Username:     pg_user.Username,
		Email:        pg_user.Email,
		Avatar_url:   pg_user.Avatar_url,
		Bio:          pg_user.Bio,
		Created_at:   pg_user.Created_at,
		Updated_at:   pg_user.Updated_at,
	}

	skills := strings.Split(pg_user.Skills, "|")
	user.Skills = skills

	return user, nil
}

func UserTopgUser(user *MyUser) (*pg_return, error) {
	pg_user := &pg_return{
		Id:           user.Id,
		Firebase_uid: user.Firebase_uid,
		Username:     user.Username,
		Email:        user.Email,
		Avatar_url:   user.Avatar_url,
		Bio:          user.Bio,
		Created_at:   user.Created_at,
		Updated_at:   user.Updated_at,
	}

	skillsStr := strings.Join(user.Skills, "|")
	pg_user.Skills = skillsStr

	return pg_user, nil
}
