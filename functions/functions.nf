/*
    Script with several functions that any Nextflow pipeline benefits from:

    - checkNfVersion:   checks that the the minimum Nextflow version as defined in
                        params.minimum_nfversion is satisfied. If not then throw an error and exit.

    - introMessage:     Print a couple of pipeline parameters such as the name of the name and version,
                        the container engine and image version, Github URL etc.

    - validateParams:   Validate that params are valid, e.g. that command-line parameters have been 
                        defined in nextflow.config. If not throws an error, lists the invalid param
                        and exits. For example if params.length was defined in the config but the user
                        tries to overwrite with --lenght then an error would be thrown.
                        Technically it first lists all params via the in-built $params variable,
                        then parses all allowed params from nextflow.config, and then compares the two
                        lists. If the outersect of both is > 0 then throws the error.
                        Also prints all valid params with its values to log if validation was successful.                       
                        
*/

// ------------------------------------------------------------------------------------------------------
// ANSI escape codes to color terminal output
ANSI_RESET   = "\u001B[0m"
ANSI_BLACK   = "\u001B[30m"
ANSI_RED     = "\u001B[31m"
ANSI_GREEN   = "\u001B[32m"
ANSI_YELLOW  = "\u001B[33m"
ANSI_BLUE    = "\u001B[34m"
ANSI_PURPLE  = "\u001B[35m"
ANSI_CYAN    = "\u001B[36m"
ANSI_WHITE   = "\u001B[37m"

// ------------------------------------------------------------------------------------------------------
// require a minimum Nextflow version
def checkNfVersion() {

    if(!nextflow.version.matches(">= $params.minimum_nfversion")) {
        println("$ANSI_RED")
        println("-----------------------------------------------------------------------------------------------")
        println("[Error] Nextflow version must >= $params.minimum_nfversion")
        println("-----------------------------------------------------------------------------------------------")
        println("$ANSI_RESET")
        exit 1
    }
}

// ------------------------------------------------------------------------------------------------------
def introMessage() {

    def repo = workflow.repository
      
    // [INTRODUCTION MESSAGE]
    // summarizing some core parameters about pipeline and the run:
    println("$ANSI_YELLOW")
    println("-----------------------------------------------------------------------------------------------")
    println("[RUN]              $workflow.runName")
    println("[PIPELINE]         $params.pipeline_name")
    println("[VERSION]          $params.pipeline_version")
    println("[NEXTFLOW]         $nextflow.version")
    if(repo==null) { 
        println("[HOSTED]           $params.pipeline_url") 
    } else { println("[HOSTED]           $workflow.repository") }
    if(repo!=null){ println("[EXECUTED COMMIT]  $workflow.commitId") }
    if(repo!=null){ println("[EXECUTED RELEASE] $workflow.revision") }
    println("[START]            $workflow.start")
    println("[CL]               $workflow.commandLine")
    println("[CONTAINER ENGINE] $workflow.containerEngine")
    println("[CONTAINER IMAGE]  $workflow.container")
    println("[PARAMS]           $params")
    println("-----------------------------------------------------------------------------------------------")
    println("$ANSI_RESET")

}