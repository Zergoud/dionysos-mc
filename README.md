# Dionysos Minecraft Server

A Dockerized Minecraft server with automatic backups and plugin support, featuring comprehensive management tools.

## Features

- **Paper Server**: High-performance Minecraft server
- **Auto Backups**: Daily automated backups with retention
- **Voice Chat**: Simple Voice Chat plugin pre-installed
- **Easy Management**: Comprehensive Makefile for server control
- **Persistent Data**: World saves and configurations preserved
- **Plugin Support**: Easy plugin management via plugins.txt

## Quick Start

1. **Prerequisites**: Ensure Docker and Docker Compose are installed on your system

2. **Initialize the server** (first time setup):
   ```bash
   make init
   ```

3. **View all available commands**:
   ```bash
   make help
   ```

4. **View server logs**:
   ```bash
   make logs
   ```

## Server Management

Use Makefile commands to manage the server:
```bash
# First time setup
make init

# Start the server
make start

# Stop the server
make stop

# Restart the server
make restart

# View server logs (live)
make logs

# Check server status
make status

# Create manual backup
make backup

# Update server to latest version
make update

# Reload plugins
make plugins

# Clean up containers and images
make clean

# Enter server console
make console

# View backup logs
make backup-logs

# Quick health check
make health

# Show all available commands
make help
```

## Server Configuration

- **Server Type**: Paper (optimized Bukkit)
- **Memory**: 4GB allocated
- **Max Players**: 20
- **Ports**: 
  - 25565 (Minecraft)
  - 24454 (Voice Chat)
- **Difficulty**: Normal
- **PvP**: Enabled

## Adding Plugins

Edit `srv/minecraft-data/plugins.txt` and add plugin download URLs:

```
# Example plugins
https://github.com/henkelmax/simple-voice-chat/releases/download/bukkit-2.5.21/voicechat-bukkit-2.5.21.jar
https://dev.bukkit.org/projects/essentialsx/files/latest
```

Then restart the server: `make restart`

## Backups

- **Automatic**: Daily backups at midnight
- **Location**: `srv/mc-backups/`
- **Retention**: 7 days
- **Manual**: `make backup`

## Connecting

- **Server Address**: `your-server-ip:25565`
- **Version**: Latest Paper/Bukkit compatible
- **Cracked Clients**: Supported (offline mode enabled)

## Troubleshooting

- Check logs: `make logs`
- Check server status: `make status`
- Health check: `make health`
- Restart server: `make restart`
- Check Docker containers: `docker-compose ps`
- View backup logs: `make backup-logs`
- Enter server console: `make console`

## File Structure

```
dionysos-mc/
├── docker-compose.yml     # Docker configuration
├── Makefile              # Server management commands
├── README.md             # This file
└── srv/
    ├── minecraft-data/   # Server data & world files
    │   └── plugins.txt   # Plugin management
    └── mc-backups/       # Automated backups
```

Backups are created automatically every 24 hours and stored in `./srv/mc-backups`. The backup service runs alongside the main server.

## Connecting to the Server

- **Address**: `localhost:25565` (if running locally)
- **Address**: `YOUR_SERVER_IP:25565` (if running on a remote server)

## Advanced Features

- **RCON Console**: Direct server console access with `make console`
- **Health Monitoring**: Quick status checks with `make health`
- **Auto-Updates**: Easy server updates with `make update`
- **Plugin Hot-Reload**: Restart with new plugins using `make plugins`
- **Backup Monitoring**: View backup service logs with `make backup-logs`
- **Docker Optimization**: Uses Aikar flags for optimal performance
- **Automatic Cleanup**: Remove old containers with `make clean`
