# DevOpsCourse_vbot
Telegram bot written on GO lang.
Advanced version of bot with some interesting and useful functions.

# Building/Compiling

simple way:

```sh
git clone https://github.com/vitovt/DevOpsCourse_vbot.git
cd DevOpsCourse_vbot
go get
go build -o vbot
```

Or you can run pre-defined rules using **gnu make**:
`make build`

# Usage

`./vbot help` - see help message

`./vbot version` - see version (may be useful for bug reporting)

`./vbot start` - **start app** (after this command you can test TG bot)

# Test

start bot in Telegram and use commands:

```
/s color
```
as a result you'll see answer that light changed to this color.

Use one of the pre-defined color: _red_, _amber_, _green_

You can **test it here:** https://t.me/prometheus_course_bot

