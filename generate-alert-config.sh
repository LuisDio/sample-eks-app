#!/bin/bash
set -e

# Load environment variables from .env
export $(grep -v '^#' .env | xargs)

# Generate alertmanager.yml by replacing ${SLACK_API_URL}
envsubst < alertmanager.yml.template > alertmanager.yml

echo "✅ Generated alertmanager.yml with Slack API URL."
