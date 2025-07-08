# Minecraft Server Makefile
# Complete server management without external scripts

.PHONY: start stop restart logs status backup clean help init update plugins

# Default target
help:
	@echo "🎮 Dionysos Minecraft Server Management"
	@echo "======================================="
	@echo "Available commands:"
	@echo "  make start    - Start the server"
	@echo "  make stop     - Stop the server"
	@echo "  make restart  - Restart the server"
	@echo "  make logs     - Show server logs (live)"
	@echo "  make status   - Show server status"
	@echo "  make backup   - Create manual backup"
	@echo "  make clean    - Remove old containers and images"
	@echo "  make init     - First time server setup"
	@echo "  make update   - Update server to latest version"
	@echo "  make plugins  - Reload plugins from plugins.txt"
	@echo "  make help     - Show this help"
	@echo ""
	@echo "Quick start: make init"

# Create necessary directories if they don't exist

start:
	@echo "🚀 Starting Minecraft server..."
	@docker compose up -d
	@echo "✅ Server started! Check status with: make status"
	@echo "📋 View logs with: make logs"

stop:
	@echo "🛑 Stopping Minecraft server..."
	@docker compose down
	@echo "✅ Server stopped!"

restart:
	@echo "🔄 Restarting Minecraft server..."
	@docker compose restart mc
	@echo "✅ Server restarted!"

logs:
	@echo "📋 Showing server logs (Ctrl+C to exit)..."
	@docker compose logs -f mc

status:
	@echo "📊 Server Status:"
	@echo "=================="
	@docker compose ps
	@echo ""
	@echo "💾 Disk Usage:"
	@du -sh srv/ 2>/dev/null || echo "No data yet"
	@echo ""
	@echo "🐳 Docker Stats:"
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "No containers running"

backup:
	@echo "💾 Creating manual backup..."
	@docker compose exec -T mc-backup backup-now || echo "⚠️  Backup service not running. Starting backup manually..."
	@if [ ! $$(docker compose ps -q mc-backup) ]; then \
		echo "📦 Creating backup using tar..."; \
		tar -czf srv/mc-backups/manual-backup-$$(date +%Y%m%d-%H%M%S).tar.gz -C srv/minecraft-data .; \
		echo "✅ Manual backup created!"; \
	fi

clean:
	@echo "🧹 Cleaning up old Docker containers and images..."
	@docker compose down --remove-orphans
	@docker system prune -f
	@echo "✅ Cleanup complete!"

# Initialize the server (first time setup)
init: setup-dirs
	@echo "🎮 Initializing Dionysos Minecraft Server..."
	@echo "============================================="
	@if [ ! -f srv/minecraft-data/plugins.txt ] || [ ! -s srv/minecraft-data/plugins.txt ]; then \
		echo "📝 Creating plugins.txt with default plugins..."; \
		echo "# Minecraft Server Plugins" > srv/minecraft-data/plugins.txt; \
		echo "# Add plugin URLs here, one per line" >> srv/minecraft-data/plugins.txt; \
		echo "" >> srv/minecraft-data/plugins.txt; \
		echo "# Simple Voice Chat for communication" >> srv/minecraft-data/plugins.txt; \
		echo "https://github.com/henkelmax/simple-voice-chat/releases/download/bukkit-2.5.21/voicechat-bukkit-2.5.21.jar" >> srv/minecraft-data/plugins.txt; \
	fi
	@echo "🚀 Starting server for the first time..."
	@docker compose up -d
	@echo "⏳ Server is initializing... This may take a few minutes."
	@echo "📋 Monitor progress with: make logs"
	@echo "🎯 Server will be available at: localhost:25565"

# Update server to latest version
update:
	@echo "🔄 Updating server to latest version..."
	@docker compose pull
	@docker compose up -d
	@echo "✅ Server updated!"

# Reload plugins from plugins.txt
plugins:
	@echo "🔌 Reloading plugins..."
	@docker compose restart mc
	@echo "✅ Plugins reloaded! Check logs for any errors."

# Advanced: Enter server console
console:
	@echo "🖥️  Entering server console (type 'exit' to leave)..."
	@docker compose exec mc rcon-cli

# Advanced: View backup logs
backup-logs:
	@echo "💾 Backup service logs:"
	@docker compose logs mc-backup

# Quick health check
health:
	@echo "🏥 Server Health Check:"
	@echo "======================="
	@if docker compose ps | grep -q "Up"; then \
		echo "✅ Server is running"; \
		echo "📊 Container status:"; \
		docker compose ps; \
	else \
		echo "❌ Server is not running"; \
		echo "💡 Start with: make start"; \
	fi
