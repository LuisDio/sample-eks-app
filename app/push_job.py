from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
import random
import time

registry = CollectorRegistry()
g = Gauge('batch_job_last_success_unixtime', 'Last time batch job succeeded', registry=registry)
r = Gauge('batch_job_random_value', 'Random value for demo', registry=registry)

# Simulate some work
time.sleep(2)

# Push metrics
g.set_to_current_time()
r.set(random.random() * 100)

push_to_gateway('pushgateway:9091', job='demo_batch_job', registry=registry)
print("Pushed metrics to Pushgateway.")
