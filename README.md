# DevOps Home Assignment

## Overview
For this assignment, I decided to keep everything simple as instructed, and to show a proof of concept for a k8s deployment of a Backend Web Server, running on koa, a node.js package. My planning approach was to tackle all of the requirements I was given for the deployment from the bottom up. Written here are the steps that were taken to complete the assignment.

## 1. Setting up a Koa Web Service as a Container
For setting up the Koa web server, I first wrote the basic **koa.js** file, which all it does is import koa, strings out the phrase "Hello Koa", and then exposes the app to port 3000.

I installed and started node locally before containerizing it, so that it can provide me with a good package.json template to put inside the container, inside **package.json** template, all I did was change some of the metadata and have it execute **koa.js**.

Finally the **Dockerfile** Imports node.js, installs koa, and copies the files to deploy the application inside a container, it then exposes port 3000 and starts the application.

I also pushed the container to a public Docker Hub repository, named as [lnachmias/koa-server](https://hub.docker.com/repository/docker/lnachmias/koa-server).

## 2. Initializing Kubernetes and deploying the Image
I used minikube to create the deployment, which means the entire infrastructure runs on a single control-plane node. In a production environment there would be one control-plane node and a worker node. 

Attached in the repo is the **kube-config.yaml** file, this file pulls the container from Docker Hub, and deploys the koa application, the service file and the volume mounts were added later. It is also standard practice to add the service and deployment config in the same .yaml.

The yaml file contains comments that detail various nuances of the config file.

## 3. Adding a Service to the pods and External access

**kube-config.yaml** file also contains the attached service, koa HTML page is accessed externally through it, by adding type: LoadBalancer
After using the apply command to create the service, you can access the external service through the command:

minikube service koa-service 

## 4. Outputting logs from the pods to a persistent volume

### Creating the persistent volumes
**volume-config.yaml** file details a new persistent volume and a pvc for the application to use, the pv contains 10Gb and is meant to be mounted on /var/log , this specific directory is used for the capturing of logs in a Kubernetes pod

### Outputting logs from pods into this volume
In the args: section of the deployment file, the deployment is mandated to output date logs into a file in /var/log.

Since 3 pods are now outputting the current date into /var/log/date.log , there are 3 outputs of the same seconds into the date file. Therefore proving that the logs of the 3 pods are concenrated inside the /var/log mounted volume.

You can access this file through:
minikube ssh
cat /var/log/date.log