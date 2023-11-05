package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestSetupCommand(t *testing.T) {
	sourceDir := "home"
	cwd, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}
	repoRoot := filepath.Join(cwd, "../")

	sourceDir = filepath.Join(repoRoot, sourceDir)
	destDir, err := os.MkdirTemp("/tmp", "dotfiles")
	if err != nil {
		t.Fatal(err)
	}

	err = setupCommand(sourceDir, destDir, false, true)
	if err != nil {
		t.Fatal(err)
	}

	sourceFiles, err := filesInDir(sourceDir)
	if err != nil {
		t.Fatal(err)
	}

	for _, file := range sourceFiles {
		relativePath := strings.TrimPrefix(file, sourceDir)
		destFile := filepath.Join(destDir, relativePath)
		fmt.Printf("Destination File: %s\n", destFile)
		if _, err := os.Stat(destFile); os.IsNotExist(err) {
			t.Errorf("File %s was not copied to destination", relativePath)
		}
	}
}
