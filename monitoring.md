# SecureScan Monitoring Setup

## Tools Used
- Prometheus — collects metrics from Kubernetes
- Grafana — displays metrics as dashboards

## How to Run Monitoring

### Start everything:
1. Open Docker Desktop
2. Run: minikube start --driver=docker
3. Run: kubectl --namespace monitoring port-forward svc/monitoring-grafana 3000:80
4. Open: http://localhost:3000
5. Login: admin / admin123

## What We Monitor
- Service uptime (up = 1 means running)
- CPU usage of containers
- Memory usage of containers
- Kubernetes pod health