#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env"
EXAMPLE_FILE=".env.local.example"

# Check if .env file already exists
if [ -f "$ENV_FILE" ]; then
  # Create a timestamped filename for the new .env file with a human-readable format
  TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")
  NEW_ENV_FILE=".env_${TIMESTAMP}"
  echo "⚠️  $ENV_FILE already exists. Creating $NEW_ENV_FILE instead."
  ENV_FILE="$NEW_ENV_FILE"
fi

# Check if example file exists
if [ ! -f "$EXAMPLE_FILE" ]; then
  echo "❌ $EXAMPLE_FILE not found. Cannot generate .env file."
  exit 1
fi

# Copy the example file as a starting point
cp "$EXAMPLE_FILE" "$ENV_FILE"

# Function to generate a random hex string of specified length
generate_hex() {
  local length=$1
  openssl rand -hex "$length"
}

# Function to generate a random alphanumeric string with a prefix
generate_random_string() {
  local prefix=$1
  local length=$2
  echo "${prefix}-$(openssl rand -hex "$length")"
}

# Generate secure values for all placeholders
echo "🔐 Generating secure values for .env file..."

# Security & Authentication
SALT=$(generate_hex 32)
ENCRYPTION_KEY=$(generate_hex 32)
NEXTAUTH_SECRET=$(generate_hex 32)

# Database Configuration
POSTGRES_PASSWORD="postgres" # Simple password for local development
CLICKHOUSE_USER=$(generate_random_string "clickhouse-user" 4)
CLICKHOUSE_PASSWORD=$(generate_random_string "clickhouse-password" 4)

# Redis
REDIS_AUTH="myredissecret" # Simple password for local development

# Minio/S3 Credentials
MINIO_ROOT_USER=$(generate_random_string "minio-root-user" 4)
MINIO_ROOT_PASSWORD=$(generate_random_string "minio-root-password" 4)

# Replace placeholders in the .env file while preserving comments and section headers
echo "🔄 Replacing placeholder values with secure generated values..."

# Security & Authentication
sed -i.bak "s|SALT=your-random-salt-key|SALT=$SALT|" "$ENV_FILE"
sed -i.bak "s|ENCRYPTION_KEY=your-random-encryption-key|ENCRYPTION_KEY=$ENCRYPTION_KEY|" "$ENV_FILE"
sed -i.bak "s|NEXTAUTH_SECRET=your-random-nextauth-secret|NEXTAUTH_SECRET=$NEXTAUTH_SECRET|" "$ENV_FILE"

# Database Configuration
sed -i.bak "s|POSTGRES_PASSWORD=yourpassword|POSTGRES_PASSWORD=$POSTGRES_PASSWORD|" "$ENV_FILE"
sed -i.bak "s|DATABASE_URL=postgresql://postgres:yourpassword@postgres:5432/postgres|DATABASE_URL=postgresql://postgres:$POSTGRES_PASSWORD@postgres:5432/postgres|" "$ENV_FILE"
sed -i.bak "s|DIRECT_URL=postgresql://postgres:yourpassword@postgres:5432/postgres|DIRECT_URL=postgresql://postgres:$POSTGRES_PASSWORD@postgres:5432/postgres|" "$ENV_FILE"

sed -i.bak "s|CLICKHOUSE_USER=your-clickhouse-user|CLICKHOUSE_USER=$CLICKHOUSE_USER|" "$ENV_FILE"
sed -i.bak "s|CLICKHOUSE_PASSWORD=your-clickhouse-password|CLICKHOUSE_PASSWORD=$CLICKHOUSE_PASSWORD|" "$ENV_FILE"

sed -i.bak "s|REDIS_AUTH=your-redis-password|REDIS_AUTH=$REDIS_AUTH|" "$ENV_FILE"

# Storage Configuration
sed -i.bak "s|MINIO_ROOT_USER=your-minio-root-user|MINIO_ROOT_USER=$MINIO_ROOT_USER|" "$ENV_FILE"
sed -i.bak "s|MINIO_ROOT_PASSWORD=your-minio-root-password|MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD|" "$ENV_FILE"

# Use the same Minio credentials for S3 access
sed -i.bak "s|LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID=your-minio-root-user|LANGFUSE_S3_EVENT_UPLOAD_ACCESS_KEY_ID=$MINIO_ROOT_USER|" "$ENV_FILE"
sed -i.bak "s|LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID=your-minio-root-user|LANGFUSE_S3_MEDIA_UPLOAD_ACCESS_KEY_ID=$MINIO_ROOT_USER|" "$ENV_FILE"
sed -i.bak "s|LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID=your-minio-root-user|LANGFUSE_S3_BATCH_EXPORT_ACCESS_KEY_ID=$MINIO_ROOT_USER|" "$ENV_FILE"

sed -i.bak "s|LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=your-minio-secret|LANGFUSE_S3_EVENT_UPLOAD_SECRET_ACCESS_KEY=$MINIO_ROOT_PASSWORD|" "$ENV_FILE"
sed -i.bak "s|LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=your-minio-secret|LANGFUSE_S3_MEDIA_UPLOAD_SECRET_ACCESS_KEY=$MINIO_ROOT_PASSWORD|" "$ENV_FILE"
sed -i.bak "s|LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY=your-minio-secret|LANGFUSE_S3_BATCH_EXPORT_SECRET_ACCESS_KEY=$MINIO_ROOT_PASSWORD|" "$ENV_FILE"

# Clean up backup files
rm -f "$ENV_FILE.bak"

echo "✅ $ENV_FILE created with secure random values."

if [ "$ENV_FILE" != ".env" ]; then
  echo "ℹ️  To use this file, either:"
  echo "   - Rename it to .env: mv $ENV_FILE .env"
  echo "   - Or specify it when running docker-compose: docker-compose --env-file $ENV_FILE up"
else
  echo "🚀 You can now start Langfuse with 'make up'"
fi
