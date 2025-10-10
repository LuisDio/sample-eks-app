# Observability Lab with Prometheus, Thanos, Grafana, Loki, and MinIO

This repository contains a Docker-based observability lab that simulates a near production-grade monitoring stack with **short-term and long-term metrics storage**, alerting, logging, and application instrumentation.

---

## Architecture Overview



                +--------------------+
                |     Grafana        |
                |  (dashboards)      |
                +---------+----------+
                          |
                          v
                 +-----------------+
                 | Thanos Query    |
                 | (fan-out + UI)  |
                 +--------+--------+
                          |
            +-------------+-------------+
            |                           |
    +-------v--------+           +------v-------+
    | Thanos Sidecar |           | Thanos Sidecar|
    | Prometheus 1   |           | Prometheus 2  |
    +-------+--------+           +------+--------+
            |                           |
     Local TSDB blocks           Local TSDB blocks
            |                           |
            +-------------+-------------+
                          |
                 +--------v--------+
                 |     MinIO       |
                 |  (S3 bucket)    |
                 +-----------------+




### Components

- **Prometheus Shards**
  - Collect metrics from instrumented applications.
  - Store local TSDB blocks for short-term metrics.

- **Thanos Sidecars**
  - Watch Prometheus TSDB directories.
  - Upload blocks to **MinIO** for long-term storage.
  - Expose Prometheus metrics to **Thanos Query**.

- **MinIO**
  - S3-compatible object storage for long-term metrics.
  - Stores all TSDB blocks from Prometheus shards.

- **Thanos Query**
  - Aggregates data from multiple sidecars and MinIO.
  - Provides a single query endpoint for Grafana or CLI queries.

- **Grafana**
  - Visualization layer.
  - Queries Thanos Query to display dashboards for real-time and historical metrics.

- **Loki + Promtail**
  - Collect and centralize logs from applications and the system.
  - Grafana can visualize logs alongside metrics.

- **Pushgateway**
  - Receives ephemeral job metrics and exposes them to Prometheus.

---

## Features

- Multi-shard Prometheus setup simulating scaling.
- Long-term storage using MinIO.
- Centralized query with Thanos Query.
- Dashboards in Grafana for both metrics and logs.
- Alerting with Alertmanager.
- Application instrumentation support via Prometheus Python client.
- Ability to simulate high metric volume to test Thanos scaling benefits.

---

## Quick Start

Before starting, make sure you have these folder created
- prometheus-shard1-data
- prometheus-shard2-data
- minio-data

```bash
# Start the full stack
make up

# Check logs for any issues
docker-compose logs -f


- Grafana: http://localhost:3000
- Prometheus Shard 1: http://localhost:9090
- Prometheus Shard 2: http://localhost:9092
- Alertmanager: http://localhost:9093
- Thanos Query: http://localhost:10905
- MinIO Console: http://localhost:9001