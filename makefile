# Load variables from .env
include .env
export $(shell sed 's/=.*//' .env)

ALERTMANAGER_TEMPLATE = alertmanager.yml.template
ALERTMANAGER_CONFIG   = alertmanager.yml

# Default target
all: up

# Generate alertmanager.yml from template
$(ALERTMANAGER_CONFIG): $(ALERTMANAGER_TEMPLATE) .env
	@echo "Generating $@ from template..."
	@envsubst < $(ALERTMANAGER_TEMPLATE) > $(ALERTMANAGER_CONFIG)
	@echo "Generated $@"

# Start stack
up: $(ALERTMANAGER_CONFIG)
	docker-compose up -d

# Stop stack
down:
	docker-compose down

# Rebuild services
build:
	docker-compose build

# View logs
logs:
	docker-compose logs -f

# Clean generated files
clean:
	rm -f $(ALERTMANAGER_CONFIG)

# Fire a test alert into Alertmanager
test-alert:
	@echo "Sending test alert to Alertmanager..."
	curl -XPOST http://localhost:9093/api/v2/alerts \
		-H "Content-Type: application/json" \
		-d '[{"labels":{"alertname":"TestAlert","severity":"warning"},"annotations":{"summary":"This is a test alert","description":"Triggered from Makefile test-alert target"},"startsAt":"'$$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}]'
	@echo "Test alert sent. Check Slack!"

