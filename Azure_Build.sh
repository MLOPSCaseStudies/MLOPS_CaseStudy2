#! /bin/bash

#Build the container
docker build -t poojary9991/cs553_casestudy4 .

#Push the container to docker hub
docker push poojary9991/cs553_casestudy4

#Run the container on Azure
az containerapp create \
    --name  casestudy4group11\
    --resource-group CS553_CaseStudy4_group11  \
    --environment managedEnvironment-CS553CaseStudy4-9707
    --image poojary9991/cs553_casestudy4:latest \
    --environment-variables 'KHF_API_KEY=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' 'OMDB=628cb164' \
    -- ingress external \
    --target-ports 7860



  #Get the URL
  az containerapp show \
  --name casestudy4group11 \
  --resource-group CS553_CaseStudy4_group11 \  
  --query properties.configuration.ingress.fqdn  