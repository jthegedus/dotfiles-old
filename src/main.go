package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/urfave/cli/v2"
)

func main() {
	app := &cli.App{
		Name:    "dotty",
		Suggest: true,
		Usage:   "manage your dotfiles",
		Version: "0.0.1",
		Commands: []*cli.Command{
			{
				Name:  "setup",
				Usage: "symlinks your repo dotfiles to your home directory",
				Flags: []cli.Flag{
					&cli.StringFlag{
						Name:     "source",
						Value:    "",
						Usage:    "source directory to symlink from",
						Required: true,
						Action:   func(c *cli.Context, val string) error { return directoryValidationAction(c, val, "source") },
					},
					&cli.StringFlag{
						Name:   "destination",
						Value:  "",
						Usage:  "destination directory to symlink to",
						Action: func(c *cli.Context, val string) error { return directoryValidationAction(c, val, "destination") },
					},
				},
				Action: setupCommandAction,
			},
			// TODO:	add teardown command. This will remove all destination symlinks that would have been created from the provided source & destination directories.
			//			Skips any files from source not in the destination.
		},
		Flags: []cli.Flag{
			&cli.BoolFlag{
				Name:  "interactive",
				Value: false,
				Usage: "Enable interactive mode for confirmation prompts",
			},
			&cli.BoolFlag{
				Name:  "verbose",
				Value: false,
				Usage: "Enable debug logs",
			},
			cli.BashCompletionFlag,
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

func directoryValidationAction(c *cli.Context, val string, flag string) error {
	if val == "" {
		return cli.Exit(fmt.Sprintf("--%s cannot be empty", flag), 1)
	}

	if _, err := os.Stat(val); os.IsNotExist(err) {
		return cli.Exit(fmt.Sprintf("directory for flag \"--%s %s\" does not exist", flag, val), 1)
	}
	if info, err := os.Stat(val); err == nil {
		if !info.IsDir() {
			return cli.Exit(fmt.Sprintf("value set for flag \"--%s %s\" is not a directory", flag, val), 1)
		}
	}

	return nil
}

func setupCommandAction(c *cli.Context) error {
	sourceDir := c.String("source")
	destDir := c.String("destination")
	interactive := c.Bool("interactive")
	verbose := c.Bool("verbose")

	return setupCommand(sourceDir, destDir, interactive, verbose)
}

func setupCommand(sourceDirectory string, destinationDirectory string, interactive bool, verbose bool) error {
	if destinationDirectory == "" {
		var err error
		destinationDirectory, err = os.UserHomeDir()
		if err != nil {
			return err
		}
	}

	absoluteSourcePath, err := filepath.Abs(sourceDirectory)
	if err != nil {
		return err
	}
	absoluteDestinationPath, err := filepath.Abs(destinationDirectory)
	if err != nil {
		return err
	}

	if verbose {
		fmt.Printf("Provided:\nsource:%s\ndestination:%s\n\n", absoluteSourcePath, destinationDirectory)
	}

	if interactive {
		fmt.Printf("Are you sure you want to symlink files\n\tfrom %s\n\tto %s?\n(y/n): ", absoluteSourcePath, absoluteDestinationPath)
		var response string
		fmt.Scanln(&response)
		if strings.ToLower(response) != "y" {
			return cli.Exit("Bye\n", 0)
		}
	}

	files, err := filesInDir(absoluteSourcePath)
	if err != nil {
		return err
	}

	for _, file := range files {
		finalSourcePath, _ := filepath.Abs(file)
		finalDestinationPath := filepath.Join(absoluteDestinationPath, strings.TrimPrefix(file, absoluteSourcePath))

		dir, _ := filepath.Split(finalDestinationPath)

		if verbose {
			fmt.Printf("Making dir: %s\n", dir)
		}
		if err := os.MkdirAll(dir, 0755); err != nil {
			return err
		}

		if verbose {
			fmt.Printf("Symlinking: %s -> %s\n\n", finalSourcePath, finalDestinationPath)
		}
		if err := os.Symlink(finalSourcePath, finalDestinationPath); err != nil {
			fmt.Printf("Error: %s\n", err)
			fmt.Printf("Symlink failed: %s -> %s\n\n", finalSourcePath, finalDestinationPath)
			fmt.Printf("Continuing\n")
		}
	}

	return nil
}

func filesInDir(source string) ([]string, error) {
	var files []string
	err := filepath.Walk(source, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			files = append(files, path)
		}
		return nil
	})
	if err != nil {
		return nil, err
	}

	return files, nil
}
