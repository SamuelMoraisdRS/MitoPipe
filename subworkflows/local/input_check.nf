//
// Check input samplesheet and get read channels
//

include { SAMPLESHEET_CHECK } from '../../modules/local/samplesheet_check'

workflow INPUT_CHECK {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    SAMPLESHEET_CHECK ( samplesheet )
        .csv
        .splitCsv ( header:true, sep:',' )
        .map { create_fastq_channel(it) }
        .set { reads }

    emit:
    reads                                     // channel: [ val(meta), [ reads ] ]
    versions = SAMPLESHEET_CHECK.out.versions // channel: [ versions.yml ]
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_fastq_channel(LinkedHashMap row) {
    def meta = [
        id        : row.sample,
        single_end: row.single_end.toBoolean()
    ]

    def fastq_1 = file(row.fastq_1)
    if (!fastq_1.exists()) {
        exit 1, "ERROR: Read 1 FastQ file does not exist!\n${row.fastq_1}"
    }

    if (meta.single_end) {
        return [ meta, [ fastq_1 ] ]
    }

    def fastq_2 = file(row.fastq_2)
    if (!fastq_2.exists()) {
        exit 1, "ERROR: Read 2 FastQ file does not exist!\n${row.fastq_2}"
    }

    return [ meta, [ fastq_1, fastq_2 ] ]
}