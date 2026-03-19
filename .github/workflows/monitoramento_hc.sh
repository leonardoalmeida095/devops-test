#!/usr/bin/env bash
set -e
ATTEMPTS=20         # ~10 min se o HC roda a cada 30s
SLEEP=15            # intervalo de polling (independe do intervalo do HEALTHCHECK)
i=0

echo "Aguardando container ficar healthy..."

while [ $i -lt $ATTEMPTS ]; do
  STATUS=$(docker inspect --format='{{ .State.Health.Status }}' test-app 2>/dev/null || echo "unknown")
  echo "Saude atual: $STATUS"

  if [ "$STATUS" = "healthy" ]; then
    echo "Container esta healthy."
    exit 0

  elif [ "$STATUS" = "unhealthy" ]; then
    echo "Container ficou unhealthy."
    docker logs --tail 200 test-app || true
    exit 1
  fi

  i=$((i+1))
  sleep $SLEEP
done

echo "Timeout aguardando container ficar healthy."
docker logs --tail 200 test-app || true
exit 1