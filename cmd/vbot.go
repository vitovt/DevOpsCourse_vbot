/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	// TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")
)

// vbotCmd represents the kbot command
var vbotCmd = &cobra.Command{
	Use:     "start",
	Aliases: []string{"enable"},
	Short:   "Start vbot daemon",
	Long: `Use vbot start to run process in background
mode. Application doesn't need open ports. It use telegram API
to listen incomming commands and reply to it.`,
	Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("vbot %s started", appVersion)

		vbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. [%s]", err)
			return
		}

		vbot.Handle(telebot.OnText, func(m telebot.Context) error {

			var (
				err error
			)
			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I'm vbot %s!", appVersion))

			case "red", "amber", "green":

				err = m.Send(fmt.Sprintf("Switch %s light signal to %s", payload, payload))

			default:
				err = m.Send("Usage: /s red|amber|green")

			}

			return err

		})

		vbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(vbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// vbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// vbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
