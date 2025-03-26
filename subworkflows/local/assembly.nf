//Modules to ASSEMBLY subworkflow
include { CREATE_FILE                  } from '../../modules/local/createfile.nf'
include { POLISH_FILE                  } from '../../modules/local/polishfile.nf'
include { NOVOPLASTY as NOVOPLASTY_RUN } from '../../modules/local/novoplasty.nf'
include { NOVOPLASTY as POLISH         } from '../../modules/local/novoplasty.nf'
include { NOVOPLASTYSET                } from '../../modules/local/novoplastyset.nf'
include { MITOZ                        } from '../../modules/local/mitoz.nf'
include { ISCIRC                       } from '../../modules/local/iscirc.nf'
include { SEQTK_SEQ                    } from '../../modules/nf-core/seqtk/seq/main'                  
include { UNICYCLER                    } from '../../modules/nf-core/unicycler/main'                  



workflow ASSEMBLY {

    take:
    ch_reads // channel: [ val(meta), [ fasta ] ]

    main:

    //
    // NOVOPlasty
    //

    NOVOPLASTY_RUN (
        ch_reads,
        params.seed,
        params.np_pl
    )

    ch_polish_runs = NOVOPLASTY_RUN.out.fastq1
        .join(NOVOPLASTY_RUN.out.fastq2)
        .join(NOVOPLASTY_RUN.out.contigs)
        .map { meta, fastq1, fastq2, contigs ->
            [ meta, [ fastq1, fastq2 ], contigs ]
        }


    POLISH (
        ch_polish_runs.map{ it -> [it[0], it[1]] },  // meta and reads
        ch_polish_runs.map{ it -> it[2] },           // contigs as seed
        params.np_pl
    )

    if (POLISH.out.contigs) {

        ISCIRC (
            POLISH.out.contigs
        )

    //
    // Unicycler
    //

        SEQTK_SEQ (
            ISCIRC.out.fasta_for_annotation
        )

        UNICYCLER (
            SEQTK_SEQ.out.fastx    
        )

    }
     //ch_versions = ch_versions.mix(NOVOPLASTY.out.versions)

    //
    // MitoZ
    //

    MITOZ (
        ch_reads,
        'Chordata', //params
        '2',        //params
        'Chordata', //params
        'assemble'  //params
    )



}

