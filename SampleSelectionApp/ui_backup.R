####----Install and load packages----####

packages <- c("shiny","shinythemes","shinyjqui","pheatmap","RColorBrewer","clusterProfiler",
              "dplyr","DT","enrichplot","ggplot2","ggpubr","msigdbr","reshape2","tibble","plotly",
              "readr","limma","enrichR","ggrepel","tidyr","GSVA","tools","shinycssloaders","stringr")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages])
}

invisible(lapply(packages, library, character.only = TRUE))


####----File Input----####

#Master Meta
meta_file <- 'MasterMeta_v2.tsv'
#expression
expr_file <- 'expression.csv'


####----Read Files----####

#read meta
meta <- as.data.frame(read_tsv(meta_file))
#read expression
expr <- as.data.frame(read_csv(expr_file))


####----Selection Generation----####

#lineage selection
lineage_choice <- "NoneSelected"
lineage_choice <- c(lineage_choice, unique(meta$lineage))
#lineage_choice <- c(lineage_choice,"All")

genecols <- colnames(meta)[c(12:ncol(meta))]
geneList <- "NoneSelected"
geneList <- c(geneList,gsub("_.*","",genecols))

disease_choice <- "NoneSelected"
disease_choice <- c(disease_choice, unique(meta$primary_disease))




####----UI----####

ui <- 
    
    navbarPage("CCLE Genome Browser and Expression Analysis Tool",
               tabPanel("Sample Selection",
                   fluidPage(
                       mainPanel(
                           fluidRow(
                               column(6,
                                      h4("Subset CCLE Samples by Lineage or Disease type:"),
                                      radioButtons("linordischeck","",
                                                         choices = list("Lineage" = 1,
                                                                        "Disease Type" = 2)),
                                      uiOutput("subsetselec")
                                      #uiOutput("subLineageselec"),
                                      #uiOutput("primdiseaseselec")
                                      ),
                                      #selectInput("LinageChoice","",choices = lineage_choice,
                                      #            multiple = F, selected = lineage_choice[1])),
                               #column(2,
                               #       h4("Sub-Lineage Selection:"),
                               #       uiOutput("SubLineageChoice")),
                               column(6,
                                      h4("Condition Selection:"),
                                      radioButtons("condseleccheck","",
                                                         choices = list("Sex" = 1,
                                                                        #"Sample Source" = 2,
                                                                        "Sample Collection Site" = 3,
                                                                        "Primary or Metastasis" = 4,
                                                                        "Choose Gene of Interest" = 5)),
                                      uiOutput("condselec")
                                      #selectInput("geneselection","",
                                      #            choices = geneList, selected = geneList[1])
                                      )
                               #column(4,
                               #       h4("Variant Type:"))
                           ),
                           fluidRow(
                               column(6,
                                      textInput("exprFileName","Expression File Download Name:",value = "ExpressionData"),
                                      downloadButton("downloadEXPR","Download Expression Matrix")),
                               column(6,
                                      textInput("metaFileName","Meta File Download Name:",value = "MetaData"),
                                      downloadButton("downloadMETA","Download Meta Data")
                               )
                                      
                           )
                       )
                       )
                   )
               )













