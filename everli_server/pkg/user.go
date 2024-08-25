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

type MyUser struct {
	Id           string   `json:"id"`
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

	query := `
		INSERT INTO profiles (id, username, email, avatar_url, bio, skills, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *
	`

	// Generate a unique ID and skillsJSON for the user
	user.Id = uuid.New().String()
	skillsStr := strings.Join(user.Skills, "|")

	var pg_user pg_return
	err := conn.QueryRow(
		query,
		user.Id,
		user.Username,
		user.Email,
		user.Avatar_url,
		user.Bio,
		skillsStr,
		user.Created_at,
		user.Updated_at,
	).Scan(
		&pg_user.Id,
		&pg_user.Username,
		&pg_user.Email,
		&pg_user.Avatar_url,
		&pg_user.Bio,
		&pg_user.Skills,
		&pg_user.Created_at,
		&pg_user.Updated_at,
	)

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

	query := `
	  SELECT *
	  FROM profiles
	`

	rows, err := conn.Query(query)
	if err != nil {
		fmt.Print("error getting users: %w", err)
	}
	defer rows.Close()

	var users []MyUser

	for rows.Next() {
		var user *MyUser
		var pg_return pg_return
		if err := rows.Scan(
			&pg_return.Id,
			&pg_return.Username,
			&pg_return.Email,
			&pg_return.Avatar_url,
			&pg_return.Bio,
			&pg_return.Skills,
			&pg_return.Created_at,
			&pg_return.Updated_at,
		); err != nil {
			if err == sql.ErrNoRows {
				return []MyUser{}, http.StatusOK, nil
			}
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

	query := `
	  SELECT *
	  FROM profiles
	  WHERE id = $1
	`
	
	var pg_return pg_return
	if err := conn.QueryRow(
		query,
		userID,
	).Scan(
		&pg_return.Id,
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

func UpdateUser(user *MyUser) (*MyUser, int, error) {
	conn := db.GetDBConnection()

	query := `UPDATE profiles 
	SET username = $1, email = $2, bio = $3, avatar_url = $4, skills = $5, created_at = $6, updated_at = $7
	WHERE id = $8 RETURNING *
	`

	skillsStr := strings.Join(user.Skills, "|")
	var pg_return pg_return

	if err := conn.QueryRow(
		query,
		user.Username,
		user.Email,
		user.Bio,
		user.Avatar_url,
		skillsStr,
		user.Created_at,
		user.Updated_at,
		user.Id,
	).Scan(
		&pg_return.Id,
		&pg_return.Username,
		&pg_return.Email,
		&pg_return.Avatar_url,
		&pg_return.Bio,
		&pg_return.Skills,
		&pg_return.Created_at,
		&pg_return.Updated_at,
	); err != nil {
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

	query := `SELECT * FROM profiles WHERE id = $1`
	del_query := "DELETE FROM profiles WHERE id = $1"

	var pg_return pg_return
	if err := conn.QueryRow(
		query,
		userId,
	).Scan(
		&pg_return.Id,
		&pg_return.Username,
		&pg_return.Email,
		&pg_return.Avatar_url,
		&pg_return.Bio,
		&pg_return.Skills,
		&pg_return.Created_at,
		&pg_return.Updated_at,
	); err != nil {
		if err == sql.ErrNoRows {
			return http.StatusNotFound, fmt.Errorf("user not found with id: %s", userId)
		}
		return http.StatusInternalServerError, fmt.Errorf("error scanning row: %w", err)
	} else {
		_, err = conn.Exec(del_query, userId)
		if err != nil {
			return http.StatusInternalServerError, fmt.Errorf("error deleting row: %w", err)
		}
	}

	return http.StatusNoContent, nil
}

func pgUserToUser(pg_user pg_return) (*MyUser, error) {
	user := &MyUser{
		Id:           pg_user.Id,
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
