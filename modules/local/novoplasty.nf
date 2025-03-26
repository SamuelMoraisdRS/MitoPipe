process NOVOPLASTY {
    tag "$meta.id"
    label 'process_high'

    conda "conda-forge/packages/perl"

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/perl' :
        'quay.io/biocontainers/perl:5.22.2.1' }"

    input:
    tuple val(meta), path(reads)
    path(seed)
    path run

    output:

    tuple val(meta), path('contigs*.txt')                   , emit: tmp
    tuple val(meta), path('C*.fasta'), optional: true       , emit: contigs
    tuple val(meta), path('log*.txt')                       , emit: log
    tuple val(meta), path('*_1.fa*', includeInputs:true)    , emit: fastq1
    tuple val(meta), path('*_2.fa*', includeInputs:true)    , emit: fastq2
    path "versions.yml"                            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    echo "
Project:
-----------------------
Project name          = ${prefix}_${run}
Type                  = mito
Genome Range          = 13000-18000
K-mer                 = 33
Max memory            = 120
Extended log          = 0
Save assembled reads  = no
Seed Input            = $seed
Extend seed directly  = no
Reference sequence    =
Variance detection    =
Chloroplast sequence  =

Dataset 1:
-----------------------
Read Length           = 151
Insert size           = 525
Platform              = illumina
Single/Paired         = PE
Combined reads        =
Forward reads         = ${reads[0]}
Reverse reads         = ${reads[1]}
Store Hash            =

Heteroplasmy:
-----------------------
MAF                   =
HP exclude list       =
PCR-free              =

Optional:
-----------------------
Insert size auto      = yes
Use Quality Scores    = no
Reduce ambigious N's  =
Output path           =
" > config.txt && perl $run -c config.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl --version | sed -n '2p' | sed 's/.*v\\(.*\\)).*/\\1/')
        novoplasty: \$(perl $run --version | sed 's/.*v\\(.*\\)/\\1/')
    END_VERSIONS
    """
}


