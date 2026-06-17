package main

import (
	"encoding/json"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"
)

type Task struct {
	ID          int       `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

var tasks = []Task{}

func main() {
	http.HandleFunc("/tasks", tasksHandler)
	http.HandleFunc("/tasks/", taskHandler)

	println("Server running on :8080")

	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

func tasksHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	switch r.Method {

	case http.MethodGet:
		sorted := make([]Task, len(tasks))
		copy(sorted, tasks)
		sort.Slice(sorted, func(i, j int) bool {
			return sorted[i].CreatedAt.After(sorted[j].CreatedAt)
		})
		json.NewEncoder(w).Encode(sorted)

	case http.MethodPost:
		var req struct {
			Title       string `json:"title"`
			Description string `json:"description"`
		}

		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}

		if strings.TrimSpace(req.Title) == "" {
			http.Error(w, "title is required", http.StatusBadRequest)
			return
		}

		task := Task{
			ID:          len(tasks) + 1,
			Title:       req.Title,
			Description: req.Description,
			Status:      "pending",
			CreatedAt:   time.Now(),
		}

		tasks = append(tasks, task)

		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(task)

	default:
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
	}
}

func taskHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	path := strings.TrimPrefix(r.URL.Path, "/tasks/")
	parts := strings.Split(path, "/")

	id, err := strconv.Atoi(parts[0])
	if err != nil {
		http.Error(w, "invalid task id", http.StatusBadRequest)
		return
	}

	var task *Task

	for i := range tasks {
		if tasks[i].ID == id {
			task = &tasks[i]
			break
		}
	}

	if task == nil {
		http.Error(w, "task not found", http.StatusNotFound)
		return
	}

	if len(parts) == 1 && r.Method == http.MethodGet {
		json.NewEncoder(w).Encode(task)
		return
	}

	if len(parts) == 2 &&
		parts[1] == "status" &&
		r.Method == http.MethodPatch {

		var req struct {
			Status string `json:"status"`
		}

		if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
			http.Error(w, "invalid request body", http.StatusBadRequest)
			return
		}

		if req.Status != "pending" && req.Status != "done" {
			http.Error(
				w,
				"status must be pending or done",
				http.StatusBadRequest,
			)
			return
		}

		task.Status = req.Status

		json.NewEncoder(w).Encode(task)
		return
	}

	http.Error(w, "endpoint not found", http.StatusNotFound)
}
