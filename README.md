# Meshtastic BBS

[![CodeQL](https://github.com/ricardodantas/Meshtastic-BBS/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/ricardodantas/Meshtastic-BBS/actions/workflows/github-code-scanning/codeql) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/ricardodantas/meshtastic-bbs) ![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/ricardodantas/meshtastic-bbs) ![GitHub last commit](https://img.shields.io/github/last-commit/ricardodantas/meshtastic-bbs)

This is a fork from the [TC²-BBS](https://github.com/TheCommsChannel/Meshtastic-BBS) project with with some modern Python improvements and additional features. The system allows for message handling, bulletin boards, mail systems, and a channel directory.

**Warning:**

> This project is currently in Beta version, issues may happen.

## Table of Contents

- [Requirements](#requirements)
- [Automatic setup (recommended)](#automatic-setup-recommended)
- [Manual setup](#manual-setup)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Requirements

- python >= 3.11
- poetry

## Automatic setup (recommended)

1. Run the following command in you terminal:

 ```bash
curl -fsSL https://raw.githubusercontent.com/ricardodantas/meshtastic-bbs/main/scripts/setup.sh | bash
```

2. Set up the configuration in `config.ini`:

   You'll need to open up the config.ini file in a text editor and make your changes following the instructions below

   **[service]**

   `name="Meshtastic BBS"` if you want to change the name of the service

   **[interface]**
   If using `type = serial` and you have multiple devices connected, you will need to uncomment the `port =` line and enter the port of your device.

   Linux Example:
   `port = /dev/ttyUSB0`

   Windows Example:
   `port = COM3`

   If using type = tcp you will need to uncomment the hostname = 192.168.x.x line and put in the IP address of your Meshtastic device.

   **[sync]**
   Enter a list of other BBS nodes you would like to sync messages and bulletins with. Separate each by comma and no spaces as shown in the example below.
   You can find the nodeID in the menu under `Radio Configuration > User` for each node, or use this script for getting nodedb data from a device:

   [Meshtastic-Python-Examples/print-nodedb.py at main · pdxlocations/Meshtastic-Python-Examples (github.com)](https://github.com/pdxlocations/Meshtastic-Python-Examples/blob/main/print-nodedb.py)

   Example Config:

   ```ini
   [service]
   name = "My BBS"

   [interface]
   type = serial
   # port = /dev/ttyUSB0
   # hostname = 192.168.x.x

   [sync]
   bbs_nodes = !f53f4abc,!f3abc123
   ```

## Manual Setup

### Update and Install Git

   ```sh
   sudo apt update
   sudo apt upgrade
   sudo apt install git
   ```

### Installation

1. Clone the repository:

   ```sh
   cd ~
   git clone https://github.com/ricardodantas/meshtastic-bbs.git
   cd meshtastic-bbs
   ```

2. Set up a `Poetry`

   Follow instructions [here](https://python-poetry.org/docs/#installation).

3. Install the required packages

   ```sh
   poetry install
   ```

4. Rename `example_config.ini`

   ```sh
   mv example_config.ini config.ini
   ```

5. Set up the configuration in `config.ini`:

   You'll need to open up the config.ini file in a text editor and make your changes following the instructions below

   **[interface]**
   If using `type = serial` and you have multiple devices connected, you will need to uncomment the `port =` line and enter the port of your device.

   Linux Example:
   `port = /dev/ttyUSB0`

   Windows Example:
   `port = COM3`

   If using type = tcp you will need to uncomment the hostname = 192.168.x.x line and put in the IP address of your Meshtastic device.

   **[sync]**
   Enter a list of other BBS nodes you would like to sync messages and bulletins with. Separate each by comma and no spaces as shown in the example below.
   You can find the nodeID in the menu under `Radio Configuration > User` for each node, or use this script for getting nodedb data from a device:

   [Meshtastic-Python-Examples/print-nodedb.py at main · pdxlocations/Meshtastic-Python-Examples (github.com)](https://github.com/pdxlocations/Meshtastic-Python-Examples/blob/main/print-nodedb.py)

   Example Config:

   ```ini
   [service]
   name = "Meshtastic BBS"

   [interface]
   type = serial
   # port = /dev/ttyUSB0
   # hostname = 192.168.x.x

   [sync]
   bbs_nodes = !f53f4abc,!f3abc123
   ```

### Running the Server

Run the server with:

```sh
./scripts/start.sh
```

Be sure you've followed the Python virtual environment steps above and activated it before running.

## Command line arguments

```
$ poetry run python server.py --help

usage: server.py [-h] [--config CONFIG] [--interface-type {serial,tcp}] [--port PORT] [--host HOST] [--mqtt-topic MQTT_TOPIC]

Meshtastic BBS system

options:
  -h, --help            show this help message and exit
  --config CONFIG, -c CONFIG
                        System configuration file
  --interface-type {serial,tcp}, -i {serial,tcp}
                        Node interface type
  --port PORT, -p PORT  Serial port
  --host HOST           TCP host address
  --mqtt-topic MQTT_TOPIC, -t MQTT_TOPIC
                        MQTT topic to subscribe
```

### Automatically run at boot

If you would like to have the script automatically run at boot, follow the steps below:

1. **Edit the service file**

   First, edit the `meshtastic-bbs.service` file using your preferred text editor. The 3 following lines in that file are what we need to edit:

   ```sh
   User=pi
   WorkingDirectory=/home/pi/meshtastic-bbs
   ExecStart=poetry run python server.py
   ```

   The file is currently setup for a user named 'pi' and assumes that the `meshtastic-bbs` directory is located in the home directory (which it should be if the earlier directions were followed)

   We just need to replace the 4 parts that have "pi" in those 3 lines with your username.

2. **Configuring systemd**

   From the `meshtastic-bbs` directory, run the following commands:

   ```sh
   sudo cp meshtastic-bbs.service /etc/systemd/system/
   ```

   ```sh
   sudo systemctl enable meshtastic-bbs.service
   ```

   ```sh
   sudo systemctl start meshtastic-bbs.service
   ```

   The service should be started now and should start anytime your device is powered on or rebooted. You can check the status of the service by running the following command:

   ```sh
   sudo systemctl status meshtastic-bbs.service
   ```

   If you need to stop the service, you can run the following:

   ```sh
   sudo systemctl stop meshtastic-bbs.service
   ```

   If you need to restart the service, you can do so with the following command:

   ```sh
   sudo systemctl restart meshtastic-bbs.service
   ```

2. **Viewing Logs**

   Viewing past logs:

   ```sh
   journalctl -u meshtastic-bbs.service
   ```

   Viewing live logs:

   ```sh
   journalctl -u meshtastic-bbs.service -f
   ```

## Radio Configuration

Note: There have been reports of issues with some device roles that may allow the BBS to communicate for a short time, but then the BBS will stop responding to requests.

The following device roles have been working:

- **Client**
- **Router_Client**

## Features

- **Mail System**: Send and receive mail messages.
- **Bulletin Boards**: Post and view bulletins on various boards.
- **Channel Directory**: Add and view channels in the directory.
- **Statistics**: View statistics about nodes, hardware, and roles.
- **Wall of Shame**: View devices with low battery levels.
- **Fortune Teller**: Get a random fortune. Pulls from the fortunes.txt file. Feel free to edit this file remove or add more if you like.

## Usage

You interact with the BBS by sending direct messages to the node that's connected to the system running the Python script. Sending any message to it will get a response with the main menu.

Make selections by sending messages based on the letter or number in brackets - Send M for [M]ail Menu for example.

A video of it in use is available on [The Comms Channel](https://www.youtube.com/watch?v=d6LhY4HoimU).

## Sponsor

Help to maintain this project and become a sponsor on [Github Sponsors](https://github.com/sponsors/ricardodantas), [Ko-fi](https://ko-fi.com/ricardodantas), or [Buy Me A Coffee](https://www.buymeacoffee.com/ricardodantas)!

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Thanks

**TheCommsChannel:**

Big thanks to [TheCommsChannel](https://github.com/TheCommsChannel) for making this service available! 🙏

## License

GNU General Public License v3.0
