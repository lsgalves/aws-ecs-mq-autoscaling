# AWS ECS + Autoscaling over Amazon MQ

```bash
docker compose up -d --build

# Testing
for i in {1..5}; do
  curl -X POST -H "Content-Type: application/json" -d "{\"x\": $i, \"y\": $(( i + 1 ))}" http://localhost:5000/add-task
done
```

Flower: http://localhost:5555
RabbitMQ Management: http://localhost:15672
