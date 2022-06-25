# Distributed Logging
A distributed logging service, a largely-scalable, highly available, secure, and millisecond latency system to stream data. Streams data securely!

### **Why build this? What's new here?**

- Simple reason is that distributed systems are cool because of many reasons and some of them are large-scalable, high availability, secure, and fast.
- With this project, I attempt to go in-depth on how to build a system that grows in functionality as well as users and the team developing it.
- It's my attempt to broaden my knowledge and make it strong by developing this real-world end-to-end product.

### **Why choose Go?**

- Simplicity
- Strongly typed and compiled
- Compiles to a single binary with no external dependencies
- Fast and lightweight
- Good coding practices
- Excellent support for network programming and concurrency
- Easy to deploy
  
### Prerequisites
- Kind tool to run a local Kubernetes cluster in Docker. (I am using: kind v0.14.0 go1.18.2 darwin/arm64)
- Go 1.13+

### **Where is it deployed?**
It’s not deployed anywhere right now.

### Directory Structure
- **deploy** - Helm charts to install this application with custom configurations.

- **internal** - Contains different packages together to build the distributed system.

- **cmd** - Various utilities and one-time commands live here

- **api** - Contains gRPC contracts and generated code.

- **test** - CFSSL for signing, verifying, and bundling TLS certificates.

### **How can I run this locally?**
Deploying your local Kubernetes cluster is very easy. Clone the repo and follow the below steps:
1. Create a Kubernetes cluster
> kind create cluster --image=kindest/node:v1.21.2
2. Deploy to local
> export PROJECT_ID=distributedlogging
- You can use the prebuilt docker image from gcr.io/$PROJECT_ID/distributedlogging
> helm install distributedlogging distributedlogging --set image.repository=gcr.io/$PROJECT_ID/distributedlogging
- Or, you can build the docker image on your local
> make build-local-docker
> docker push <your-docker-image>
> helm install distributedlogging --set image.repository=<your-docker-image>
3. After following the above steps, you would want to forward a pod or Service's pod to a port on your computer so you can request a service running inside Kubernetes without a load balancer:
> kubectl port-forward pod/distributedlogging-0 8400 8400

Hurray, now you have deployed the application on your local cluster.

### **How can I run this on the Cloud?**
You can deploy the application to the Cloud (we use Google Kubernetes Engine (GKE)) by following the below steps:
1. To deploy to the Cloud, you should have a GKE cluster with version=1.21.* from the stable channel.
2. Connect to your GKE cluster from your local or from Cloud Shell.
> gcloud container clusters get-credentials distributedlogging --zone us-central1-c --project distributedlogging
3. Install the Metacontroller chart
> cd deploy
> kubectl create namespace metacontroller
> helm install metacontroller metacontroller
4. Deploy to the Cloud
> export PROJECT_ID=distributedlogging
- You can use the prebuilt docker image from gcr.io/$PROJECT_ID/distributedlogging
> helm install distributedlogging distributedlogging --set image.repository=gcr.io/$PROJECT_ID/distributedlogging --set service.lb=true
- Or, you can build the docker image on your local and push it to the gcr.io registry.
> make build-docker
> docker tag <your-docker-image>:<image-tag>-linux-amd64 gcr.io/$PROJECT_ID/distributedlogging:<image-tag>
> docker push gcr.io/$PROJECT_ID/distributedlogging:<image-tag>
> Before running the below command, **don’t forget to make your image at gcr.io/$PROJECT_ID/distributedlogging public**
> helm install distributedlogging distributedlogging --set image.repository=gcr.io/$PROJECT_ID/distributedlogging --set service.lb=true
5. After following the above steps, you can get the ip of your External load balancer
> kubectl get service -l app=service-per-pod -o go-template='{{range .items}}{{(index .status.loadBalancer.ingress 0).ip}}{{"\n"}}{{end}}'| head -n 1
6. Run following command to verify that our client connects to our service running in the cloud and that our service nodes discovered each other:
> ADDR=$(kubectl get service -l app=service-per-pod -o go-template='{{range .items}}{{(index .status.loadBalancer.ingress 0).ip}}{{"\n"}}{{end}}'| head -n 1)
> go run cmd/getservers/main.go -addr=$ADDR:8400

That's it, you have successfully deployed the application on your Cloud Kubernetes cluster.
### **Can I contribute to this project?**

Feel free to create a PR, I’m more than happy to review and merge it.

### **What's the long-term goal?**

- Onboarding videos and documentation
- Clean code, full test coverage and minimal tech debt

# Thank you!
Feel free to create an issue, if you have any problem running this distributed system or any suggestions. I will be happy to help anytime. I have learned so many things from https://github.com/travisjeffery/proglog while developing this project and my skills are now the strongest ever. I hope you will find this repo same or more useful.