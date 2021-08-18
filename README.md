This repository is intended to be used as a Snakemake workflow template.
It provides all the necessary files and inline documentation to assist with generating your own customise workflow.

# Running the Workflow

To run a Snakemake workflow, you will first need to have gone through the [Snakemake One-Time Setup] to install Snakemake in a conda environment.

```bash
SNAKEMAKE_VERSION='6.7.0'

# Activate the conda environment to make Snakemake
# available to you on the command line
conda activate \
  "snakemake_${SNAKEMAKE_VERSION}"

# Run the workflow using the sahmri-hpc profile
# in order to have jobs submitted to Slurm
snakemake \
  --profile profiles/sahmri-hpc
```

# Snakemake One-Time Setup

```bash
SNAKEMAKE_VERSION='6.7.0'

# Create an empty environment
conda create \
  --yes \
  --name "snakemake_v${SNAKEMAKE_VERSION}"

# Activate the new, empty environment
conda activate \
  "snakemake_v${SNAKEMAKE_VERSION}"

# Install mamba - a faster/better version of the conda executable
conda install \
  --yes \
  --channel conda-forge \
  mamba

# Install Snakemake
mamba install \
  --yes \
  --channel bioconda \
  --channel conda-forge \
  snakemake=${SNAKEMAKE_VERSION}
```
