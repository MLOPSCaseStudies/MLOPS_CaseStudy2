#!/bin/bash

# Build the container
docker build --build-arg HF_API_KEY=$HF_API_KEY --build-arg OMDB=$OMDB -t poojary9991/cs553_casestudy4 .
# Push the container to Docker Hub
docker push poojary9991/cs553_casestudy4



# Run the container on Azure
az containerapp create \
    --name casestudy4group11 \
    --resource-group CS553_CaseStudy4_group11 \
    --environment managedEnvironment-CS553CaseStudy4-aadd \
    --image poojary9991/cs553_casestudy4:latest \  
    --ingress external \
    --target-port 7860
    # --env-vars HF_API_KEY=${HF_API_KEY} OMDB=${OMDB}


# Enable HTTPS Ingress
az containerapp ingress enable \
    --name casestudy4group11 \
    --resource-group CS553_CaseStudy4_group11 \
    --type external \
    --target-port 7860

# Get the URL
az containerapp show \
    --name casestudy4group11 \
    --resource-group CS553_CaseStudy4_group11 \
    --query properties.configuration.ingress.fqdn
