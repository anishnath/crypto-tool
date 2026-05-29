package main

import (
	"log"

	"github.com/anish/crypto-tool/openai-go-api/internal/config"
	"github.com/anish/crypto-tool/openai-go-api/internal/logging"
	"github.com/anish/crypto-tool/openai-go-api/internal/server"
)

func main() {
	logging.Init()

	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("config: %v", err)
	}

	srv := server.New(cfg)
	if err := srv.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
