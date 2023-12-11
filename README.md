# DevOpsCourse_vbot
Telegram bot written on GO lang.
Advanced version of bot with some interesting and useful functions.

## Building/Compiling

simple way:

```sh
git clone https://github.com/vitovt/DevOpsCourse_vbot.git
cd DevOpsCourse_vbot
go get
go build -o vbot
```

Or you can run pre-defined rules using **gnu make**:
`make build`

## Usage

`./vbot help` - see help message

`./vbot version` - see version (may be useful for bug reporting)

`TELE_TOKEN="1234567890:AABBCC_12345678901234567890123456789012"./vbot start` - **start app** (after this command you can test TG bot)

## Test

start bot in Telegram and use commands:

```
/s color
```
as a result you'll see answer that light changed to this color.

Use one of the pre-defined color: _red_, _amber_, _green_

You can **test it here:** https://t.me/prometheus_course_bot

## Docker image
You can build Docker image using `make image'

After build you can run app in docker:

```sh
docker run -e TELE_TOKEN="1234567890:AABBCC_12345678901234567890123456789012" vitovt/vbot:0.99.2-da63311-linux-amd64
```

`make clean` also removes docker image

`make push` pushes image to remote registry

