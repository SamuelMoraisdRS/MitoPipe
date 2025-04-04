//
// This file holds several functions specific to the main.nf workflow in the nf-core/mitomine pipeline
//

import nextflow.Nextflow

class WorkflowMain {

    def workflow
    def params

    //
    // Returns citation string for pipeline
    //
    public String getCitation() {
        return "If you use ${workflow.manifest.name} for your analysis please cite:\n\n" +
            // TODO nf-core: Add Zenodo DOI for pipeline after first release
            //"* The pipeline\n" +
            //"  https://doi.org/10.5281/zenodo.XXXXXXX\n\n" +
            "* The nf-core framework\n" +
            "  https://doi.org/10.1038/s41587-020-0439-x\n\n" +
            "* Software dependencies\n" +
            "  https://github.com/${workflow.manifest.name}/blob/master/CITATIONS.md"
    }

    public String getHelpString() {
        def logo = NfcoreTemplate.logo(workflow, params.monochrome_logs)
        def citation = '\n' + WorkflowMain.getCitation(workflow) + '\n'
        String command = "nextflow run ${workflow.manifest.name} --input samplesheet.csv --genome GRCh37 -profile docker"
        return logo + paramsHelp(command) + citation + NfcoreTemplate.dashedLine(params.monochrome_logs)
    }

    public String getVersionString() {
        String workflow_version = NfcoreTemplate.version(workflow)
        return "${workflow.manifest.name} ${workflow_version}"
    }

    //
    // Validate pipeline parameters
    //
    public void initialise(log) {
        // Check that a -profile or Nextflow config has been provided to run the pipeline
        NfcoreTemplate.checkConfigProvided(workflow, log)

        // Check that conda channels are set-up correctly
        if (workflow.profile.contains('conda') || workflow.profile.contains('mamba')) {
            Utils.checkCondaChannels(log)
        }

        // Check AWS batch settings
        NfcoreTemplate.awsBatch(workflow, params)

        // Check input has been provided
        if (!params.input) {
            Nextflow.error("Please provide an input samplesheet to the pipeline e.g. '--input samplesheet.csv'")
        }
    }
    //
    // Get attribute from genome config file e.g. fasta
    //
    public Object getGenomeAttribute(attribute) {
        return params?.genomes?.get(params?.genome)?.get(attribute)
    }
}
