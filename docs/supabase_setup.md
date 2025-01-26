# Local Development Setup (macOS)

## Prerequisites

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Docker Desktop
brew install --cask docker

# Install Supabase CLI
brew install supabase/tap/supabase
```

## Project Setup

### 1. Start Local Environment

```bash
# Initialize supabase (run once)
supabase init

# Start services
supabase start
```

### 2. Save Connection Details

After `supabase start`, you'll get these local URLs - save them:

```bash
# API URLs
API URL: http://127.0.0.1:54321
GraphQL: http://127.0.0.1:54321/graphql/v1
Studio: http://127.0.0.1:54323

# Database Connection
Host: 127.0.0.1
Port: 54322
Database: postgres
User: postgres
Password: postgres
```

### 3. Daily Development Commands

```bash
# Start services
supabase start

# Stop services
supabase stop

# Check status
supabase status

# Reset database to clean state
supabase db reset

# Create new migration
supabase migration new my_migration_name

# Apply migrations
supabase db push
```

### 4. Connect with Table+

1. Open Table+
2. Create new connection with:

```properties
Host: 127.0.0.1
Port: 54322
Database: postgres
Username: postgres
Password: postgres
SSL Mode: Disable
```

### 5. Access Studio Dashboard

1. Open http://127.0.0.1:54323
2. Login with default credentials:

```
Email: admin@admin.com
Password: password
```

## Troubleshooting

### Services Not Starting

```bash
# 1. Stop supabase
supabase stop

# 2. Reset Docker
docker system prune
docker compose down --volumes

# 3. Restart Docker Desktop
# 4. Try starting again
supabase start
```

### Port Conflicts

```bash
# Check what's using the ports
sudo lsof -i :54321
sudo lsof -i :54322

# Kill process if needed
sudo kill -9 <PID>
```

### Database Connection Issues

```bash
# Test connection using psql
psql -h 127.0.0.1 -p 54322 -U postgres -d postgres

# If that works, you'll see:
# psql (15.x)
# Type "help" for help.
# postgres=#
```
