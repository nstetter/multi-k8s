#! /bin/bash
docker build -t namron/multi-client:latest -t namron/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t namron/multi-server:latest -t namron/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t namron/multi-worker:latest -t namron/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push namron/multi-client:latest
docker push namron/multi-server:latest
docker push namron/multi-worker:latest

docker push namron/multi-client:$SHA
docker push namron/multi-server:$SHA
docker push namron/multi-worker:$SHA

kubectl apply -f k8s

#force pull of image
kubectl set image deployments/client-deployment client=namron/multi-client:$SHA
kubectl set image deployments/server-deployment server=namron/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=namron/multi-worker:$SHA

# restart rollout so pull latest tags
# kubectl rollout restart deployments/server-deployment
