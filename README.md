# ![nf-core/mitomine](docs/images/nf-core-mitomine_logo_light.png#gh-light-mode-only) ![nf-core/mitomine](docs/images/nf-core-mitomine_logo_dark.png#gh-dark-mode-only)

[![AWS CI](https://img.shields.io/badge/CI%20tests-full%20size-FF9900?labelColor=000000&logo=Amazon%20AWS)](https://nf-co.re/mitomine/results)[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.XXXXXXX-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.XXXXXXX)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Nextflow Tower](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Nextflow%20Tower-%234256e7)](https://tower.nf/launch?pipeline=https://github.com/nf-core/mitomine)

[![Get help on Slack](http://img.shields.io/badge/slack-nf--core%20%23mitomine-4A154B?labelColor=000000&logo=slack)](https://nfcore.slack.com/channels/mitomine)[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)[![Follow on Mastodon](https://img.shields.io/badge/mastodon-nf__core-6364ff?labelColor=FFFFFF&logo=mastodon)](https://mstdn.science/@nf_core)[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core)

## Introduction

**mitomine** is a bioinformatics pipeline for mitochondrial genome assembly from next-generation sequencing (NGS) data.  

The pipeline performs the following main steps:

1. **Mitochondrial Genome DENOVO Assembly (NovoPlasty)**
2. **Mitochondrial Genome Ref Assembly (MitoZ)**  
3. **Annotation**  

## Usage

> **Note**
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how
> to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline)
> with `-profile test` before running the workflow on actual data.

### Running a test

To run a quick test and verify that everything is set up correctly, execute:

```bash
nextflow run mitomine/ -profile <singularity,docker,...>,test --outdir test
```

### Running with your data

First, prepare a samplesheet with your input data that looks as follows:

`samplesheet.csv`:

```csv
sample,fastq_1,fastq_2
CONTROL_REP1,AEG588A1_S1_L002_R1_001.fastq.gz,AEG588A1_S1_L002_R2_001.fastq.gz
```

Each row represents a fastq file (single-end) or a pair of fastq files (paired end).

Now, you can run the pipeline using:

<!-- TODO nf-core: update the following command to include all required parameters for a minimal example -->

```bash
nextflow run nf-core/mitomine \
   -profile <docker/singularity/.../institute> \
   --input samplesheet.csv \
   --outdir <OUTDIR>
```

> **Warning:**
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those
> provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_;
> see [docs](https://nf-co.re/usage/configuration#custom-configuration-files).

For more details and further functionality, please refer to the [usage documentation](https://nf-co.re/mitomine/usage) and the [parameter documentation](https://nf-co.re/mitomine/parameters).
