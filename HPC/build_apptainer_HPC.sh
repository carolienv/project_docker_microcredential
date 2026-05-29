#!/bin/bash
#SBATCH --job-name=build-apptainer
#SBATCH --partition=doduo
#SBATCH --mail-user=carolien.vlieghe@ugent.be
#SBATCH --mail-type=end #### NONE, BEGIN, END, FAIL, REQUEUE, ALL
#SBATCH --mem=8G
#SBATCH -e /scratch/gent/456/vsc45620/project_docker_microcredential/HPC/slurm_%x_%j.error  ## %x takes job name; %j takes job ID
#SBATCH -o /scratch/gent/456/vsc45620/project_docker_microcredential/HPC/slurm_%x_%j.out
#SBATCH --time=00:10:00

# KEEP GETTING ERROR (SEE SLURM OUTPUT), TRIED A LOT OF DIFFERENT THINGS (see code commented out)
# BUT CAN'T SEEM TO FIX THE ISSUE.

# Apptainer cachedir should be scratch (or DATA, conflicting advice during training) folder, this is already in my bashrc file 

# cd /tmp
# mkdir /tmp/$USER

# Make sure you're in scratch folder
cd "$VSC_SCRATCH/project_docker_microcredential/HPC"
# pwd

# Try different directory, hoping to solve error
# cd "$VSC_DATA"
# export APPTAINER_CACHEDIR="$VSC_DATA/apptainer_cache"
# export APPTAINER_TMPDIR="$VSC_DATA/apptainer_tmp"
# mkdir -p "$APPTAINER_CACHEDIR" "$APPTAINER_TMPDIR"

# Define variables
DOCKER_TRAIN="docker://carolienv/train-model:1.0"
DOCKER_SERVE="docker://carolienv/serve-model:1.0"

# Best practice to purge all loaded modules first
module purge

# Try purge force to solve error
# module --force purge

# Get Docker image, Apptainer converts Docker image to sif automatically.
apptainer pull train-model-1.0.sif $DOCKER_TRAIN
apptainer pull serve-model-1.0.sif $DOCKER_SERVE

# Try build --fakeroot, maybe this solves error: same error
# APPTAINER_CACHEDIR=/tmp/ \
# APPTAINER_TMPDIR=/tmp/ \
# apptainer build --fakeroot /tmp/$USER/trainmodel-1.0.sif $DOCKER_TRAIN

# mv /tmp/$USER/trainmodel-1.0.sif $VSC_SCRATCH

# APPTAINER_CACHEDIR=/tmp/ \
# APPTAINER_TMPDIR=/tmp/ \
# apptainer build --fakeroot /tmp/$USER/servemodel-1.0.sif $DOCKER_SERVE

# mv /tmp/$USER/servemodel-1.0.sif $VSC_SCRATCH


# Test if images are succesfully build by inspecting what would be run

echo "=== Inspect training image ==="
apptainer inspect --runscript train-model-1.0.sif

echo "=== Inspect serve image ==="
apptainer inspect --runscript serve-model-1.0.sif

# Creating resources report
echo "=== Report resources usage ==="
sacct -j $SLURM_JOBID  --format=jobid,partition,elapsed,state,totalcpu,maxrss,averss
