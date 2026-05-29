# Project workflow

## Repository setup

1. Fork the [training project repository](https://github.com/vib-training-conferences/project_docker_microcredential) to your personal GitHub account.
2. Clone the fork locally  
   `git clone https://github.com/carolienv/project_docker_microcredential.git`

Use `git add` and `git commit -m "commit message"` in the next steps to track and save changes.

## Containerize and run training and serving the machine learning model

### Training container

1. Complete Dockerfile.train 
2. Build container:  
   `docker build . -f Dockerfile.train --tag train-model:1.0`
3. Run container:  
   `docker run --rm -v "$(pwd)/models:/app/models" train-model:1.0`

*Troubleshooting: use $(pwd) to solve issues with relative paths.*

### Serving container

1. Complete Dockerfile.infer
2. Build container:  
   `docker build . -f Dockerfile.infer --tag serve-model:1.0`
3. Run/host container:  
   `docker run --detach --name ModelServer --rm -p 8080:8080 -v "$(pwd)/models:/app/models" serve-model:1.0`

Extra:
- Access server via http://localhost:8080
- Send a prediction request: 
  ```
  curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json"  \
  -d '{"input": [1, 1, 1, 1]}'
  ```


## Store Docker image on Docker Hub

1. Create Docker Hub account
2. Login to Docker Hub on command line and provide Docker Hub Personal Access Token to login:  
   `docker login -u carolienv`
3. Transfer images to Docker Hub:
   ```
   docker push carolienv/train-model:1.0
   docker push carolienv/serve-model:1.0
   ```

## Build Apptainer image on HPC

Push changes to your GitHub account before proceeding with this part: `git push`

1. Login to the HPC, open the login node and move to the scratch folder: `cd $VSC_SCRATCH`
2. Create a Slurm script to pull the Docker image using Apptainer.
3. Submit job:  
   `sbatch build_apptainer_HPC.sh`
4. Monitor job:
   `squeue` 
5. Add, commit and push changes to GitHub repository.

*Note: Apptainer successfully connected to Docker Hub and download the containers, but failed during SIF image creation with some proot/mksquashfs permission-related error. Some workarounds were attempted (cfr. script) but could not resolve the issue*

## Finalization

1. Pull HPC updates from GitHub to local repository: `git pull` 
2. Create a project workflow guide.
3. Add, commit and push final changes.
4. Create and send zip file of the repository for submission. 


