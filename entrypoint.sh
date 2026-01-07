#!/bin/bash
set -e

if [ -n "$DOKPLOY_DEPLOY_URL" ]; then
  # Preview environment - use ephemeral container storage
  echo "=== PREVIEW MODE ==="
  echo "Preview URL: $DOKPLOY_DEPLOY_URL"

  mkdir -p /app/data
  export DATABASE_PATH=/app/data/preview.db

  # Copy production database if requested
  if [ "$COPY_PROD_DB" = "true" ] && [ -f "/data/prod.db" ]; then
    echo "Copying production database..."
    sqlite3 /data/prod.db ".backup '/app/data/preview.db'"
    echo "Database copied successfully"
  else
    echo "Starting with fresh database"
  fi

  echo "Database path: $DATABASE_PATH"
else
  # Production environment - use persistent mounted volume
  echo "=== PRODUCTION MODE ==="
  export DATABASE_PATH=/data/prod.db
  echo "Database path: $DATABASE_PATH"
fi

# Run migrations
echo "Running migrations..."
/app/bin/test_deploy eval "TestDeploy.Release.migrate"

echo "Starting application..."
exec /app/bin/test_deploy start
