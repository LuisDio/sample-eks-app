from prometheus_client import start_http_server, Summary, Counter, Gauge
import random
import time

# Metrics
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
REQUEST_COUNT = Counter('my_request_count', 'Total number of requests', ['name', 'method'])
INPROGRESS_GAUGE = Gauge('inprogress_requests', 'Number of in-progress requests')

@REQUEST_TIME.time()
def process_request(t):
    """A dummy function that takes some time."""
    REQUEST_COUNT.labels(name='process', method='GET').inc()
    with INPROGRESS_GAUGE.track_inprogress():
        time.sleep(t)

if __name__ == "__main__":
    start_http_server(8000)
    print("App started: metrics available at http://localhost:8000/metrics")
    while True:
        process_request(random.uniform(0.1, 1.0))
