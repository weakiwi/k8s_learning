package main

import (
	"errors"
	"fmt"
	"log"
	"net"
	"os"
	"strings"
	"time"

    "github.com/urfave/cli"

)

func main() {
	app := cli.NewApp()
	app.Name = "portcheck"
	app.Usage = "portcheck"
	app.Version = "1.1"
	app.Action = Run
	app.Author = "Kaesa Li"
	app.Email = "kaesalai@gmail.com"
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:   "address",
			Usage:  "Input the check host and port, just like host:port.",
			EnvVar: "ADDRESS",
		},
	}
	app.Run(os.Args)
}

// Run initializes the driver
func Run(c *cli.Context) {
	log.Println("Starting PortCheck")
	address := mustGetStringVar(c, "address")
	address = strings.TrimSpace(address)
	addresses := strings.Split(address, ",")
	for _, ad := range addresses {
		fmt.Println(fmt.Sprintf("Making TCP connection to %s ...", ad))
		for {
			err := portCheck(ad)
			if err != nil {
				log.Println(err)
			} else {
				fmt.Println(fmt.Sprintf("Connected to %s successfully", ad))
				break
			}
			time.Sleep(2 * time.Second)
		}
	}
}

func errExit(code int, format string, val ...interface{}) {
	fmt.Fprintf(os.Stderr, format+"\n", val...)
	os.Exit(code)
}

func mustGetStringVar(c *cli.Context, key string) string {
	v := strings.TrimSpace(c.String(key))
	if v == "" {
		errExit(1, "%s must be provided", key)
	}
	return v
}

func portCheck(address string) error {
	_, err := net.LookupIP( address)
	if err == nil {
		return nil
	}
	if err, ok := err.(net.Error); ok && err.Timeout() {
		return errors.New(fmt.Sprintf("timeout when making TCP connection: %+v", err))
	}
	return errors.New(fmt.Sprintf("failure to make TCP connection: %+v", err))
}
