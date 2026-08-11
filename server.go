package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/thecodearcher/limen"
)

func NewServer(dbpool *sql.DB, config *limen.Config) http.Handler {
	r := chi.NewRouter()
	auth, err := limen.New(config)
	if err != nil {
		log.Fatalf("Failed to create limen: %v", err)
	}
	handler := auth.Handler()
	r.Mount("auth", handler)
	r.Use(middleware.RequestID)
	r.Use(middleware.ClientIPFromRemoteAddr)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("sup"))
	})

	r.Get("/slow", func(w http.ResponseWriter, r *http.Request) {
		// Simulates some hard work.
		//
		// We want this handler to complete successfully during a shutdown signal,
		// so consider the work here as some background routine to fetch a long-running
		// search query to find as many results as possible, but, instead we cut it short
		// and respond with what we have so far. How a shutdown is handled is entirely
		// up to the developer, as some code blocks are preemptible, and others are not.
		time.Sleep(5 * time.Second)
		fmt.Fprintf(w, "all done.\n")
	})

	// r.Mount("/users", api.NewUserResource(dbpool).Routes())

	return r
}
