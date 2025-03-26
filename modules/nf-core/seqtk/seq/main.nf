process SEQTK_SEQ {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqtk:1.4--he4a0461_1' :
        'biocontainers/seqtk:1.4--he4a0461_1' }"

    input:
    tuple val(meta), path(fastx)

    output:
    tuple val(meta), path("*seqtk-seq.*")     , emit: fastx
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: "-F '#'"
    def prefix = task.ext.prefix ?: "${meta.id}"

    def extension = "fastq"
    
    """
    seqtk \\
        seq \\
        $fastx \\
        $args \\
        > ${prefix}.seqtk-seq.${extension}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$(echo \$(seqtk 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"

    def extension = "fastq"
    if ("$fastx" ==~ /.+\.fasta|.+\.fasta.gz|.+\.fa|.+\.fa.gz|.+\.fas|.+\.fas.gz|.+\.fna|.+\.fna.gz/ || "$args" ==~ /\-[aA]/ ) {
        extension = "fasta"
    }
    """
    echo "" | gzip > ${prefix}.seqtk-seq.${extension}.gz

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$(echo \$(seqtk 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
