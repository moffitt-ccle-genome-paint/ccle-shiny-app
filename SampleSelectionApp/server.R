####----Install and load packages----####

packages <- c("shiny","shinythemes","shinyjqui","dplyr","DT","reshape2",
              "readr","tidyr","tools","shinycssloaders","stringr")
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
rownames(expr) <- expr[,1]
expr <- expr[,-1]


####----Selection Generation----####

#lineage selection
#lineage_choice <- "NoneSelected"
lineage_choice <- unique(meta$lineage)
#lineage_choice <- c(lineage_choice,"All")

genecols <- colnames(meta)[c(15:ncol(meta))]
geneList <- "NoneSelected"
geneList <- c(geneList,gsub("_.*","",genecols))

#disease_choice <- "NoneSelected"
disease_choice <- unique(meta$primary_disease)




server <- function(input, output, session) {
    
    
    observe({
        if (input$linordischeck == 1) {
            output$subsetselec <- renderUI({
                
                selectInput("firstChoice","Select Lineage:",choices = lineage_choice,
                            multiple = F, selected = lineage_choice[1])
                
            })
        }
        if (input$linordischeck == 2) {
            output$subsetselec <- renderUI({
                
                selectInput("firstChoice","Select Primary Disease:",
                            choices = disease_choice, multiple = F,
                            selected = disease_choice[1])
                
            })
        }
    })
    
    output$sublinselec <- renderUI({
        
        if (input$linordischeck == 1) {
            
            firstChoice <- input$firstChoice
            meta.u <- meta[which(meta$lineage == firstChoice),]
            subLin_choices <- "All_Sub_Lineages"
            subLin_choices <- c(subLin_choices,unique(meta.u[,"lineage_subtype"]))
            selectInput("secondChoice","Select Sub-Lineage:",
                        choices = subLin_choices)
        }
        
    })
    
    
    #observe({
    #    
    #    if (input$linordischeck == 1) {
    #        output$subsetselec <- renderUI({
    #            
    #            selectInput("firstChoice","Select Lineage:",choices = lineage_choice,
    #                        multiple = F, selected = lineage_choice[1])
    #            
    #        })
    #    }
    #    
    #})
    
    observe({
        if (input$condseleccheck == 5) {
            output$condselec <- renderUI({
                
                selectInput("geneselection","Select Gene of Interest:",
                            choices = geneList, selected = geneList[1])
                
                })
        }
    })
    
    output$downloadMETA <- downloadHandler(
        filename = function() {
            paste(input$metaFileName,".tsv", sep = '')
        },
        content = function(file) {
            
            firstChoice <- input$firstChoice
            secondChoice <- input$secondChoice
            if (firstChoice %in% lineage_choice) {
                
                #subset meta based on lineage
                if (secondChoice == "All_Sub_Lineages"){
                    meta.u <- meta[which(meta$lineage == firstChoice),]
                }
                else if (secondChoice != "All_Sub_Lineages"){
                    meta.u <- meta[which(meta$lineage == firstChoice & meta$lineage_subtype == secondChoice),]
                }
                
                cond <- input$condseleccheck
                
                #user chooses gene of interest
                if (cond == 5){
                    
                    if (input$geneselection != geneList[1]) {
                        gene <- input$geneselection
                        #assign NULL in case column not found
                        genecold <- NULL
                        genecolo <- NULL
                        genecold <- paste(gene,"_damagingVariant",sep = "")
                        genecolo <- paste(gene,"_otherVariant",sep = "")
                        meta_sub <- meta.u[,c("DepMap_ID",genecold,genecolo)]
                        meta_sub[,c(2,3)] <- lapply(meta_sub[,c(2,3)],as.character)
                        #rename 
                        #if (ncol(meta_sub) == 3) {
                        meta_sub2 <- meta_sub %>%
                            mutate(Condition = case_when(
                                meta_sub[,2] == "FALSE" & meta_sub[,3] == "FALSE" ~ "WT",
                                meta_sub[,2] == "FALSE" & meta_sub[,3] == "TRUE" ~ "NonDamagingVariant",
                                meta_sub[,2] == "TRUE" & meta_sub[,3] == "FALSE" ~ "DamagingVariant"
                            ))
                        #}
                        meta_sub3 <- meta_sub2[,c(1,4)]
                        colnames(meta_sub3)[1] <- "SampleName"
                        meta_sub <- meta_sub3
                    }
                    
                }
                
                #user chooses sex condition
                if (cond == 1) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,sex)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                ##user chooses sample source
                #if (cond == 2) {
                #    
                #    meta.u2 <- meta.u %>%
                #        select(DepMap_ID,source)
                #    colnames(meta.u2) <- c("SampleName","Condition")
                #    meta_sub <- meta.u2
                #    
                #}
                #user chooses Sample Collection Site
                if (cond == 3) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,sample_collection_site)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                #user chooses Primary or metastasis
                if (cond == 4) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,primary_or_metastasis)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                
            }
            
            if (firstChoice %in% disease_choice) {
                
                meta.u <- meta[which(meta$primary_disease == firstChoice),]
                cond <- input$condseleccheck
                
                #if user chooses gene of interest
                if (cond == 5) {
                    
                    if (input$geneselection != geneList[1]) {
                        gene <- input$geneselection
                        #assign NULL in case column not found
                        genecold <- NULL
                        genecolo <- NULL
                        genecold <- paste(gene,"_damagingVariant",sep = "")
                        genecolo <- paste(gene,"_otherVariant",sep = "")
                        meta_sub <- meta.u[,c("DepMap_ID",genecold,genecolo)]
                        meta_sub[,c(2,3)] <- lapply(meta_sub[,c(2,3)],as.character)
                        #rename 
                        #if (ncol(meta_sub) == 3) {
                        meta_sub2 <- meta_sub %>%
                            mutate(Condition = case_when(
                                meta_sub[,2] == "FALSE" & meta_sub[,3] == "FALSE" ~ "WT",
                                meta_sub[,2] == "FALSE" & meta_sub[,3] == "TRUE" ~ "NonDamagingVariant",
                                meta_sub[,2] == "TRUE" & meta_sub[,3] == "FALSE" ~ "DamagingVariant"
                            ))
                        #}
                        meta_sub3 <- meta_sub2[,c(1,4)]
                        colnames(meta_sub3)[1] <- "SampleName"
                        meta_sub <- meta_sub3
                    
                    }
                }
                #user chooses sex condition
                if (cond == 1) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,sex)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                ##user chooses sample source
                #if (cond == 2) {
                #    
                #    meta.u2 <- meta.u %>%
                #        select(DepMap_ID,source)
                #    colnames(meta.u2) <- c("SampleName","Condition")
                #    meta_sub <- meta.u2
                #    
                #}
                #user chooses Sample Collection Site
                if (cond == 3) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,sample_collection_site)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                #user chooses Primary or metastasis
                if (cond == 4) {
                    
                    meta.u2 <- meta.u %>%
                        select(DepMap_ID,primary_or_metastasis)
                    colnames(meta.u2) <- c("SampleName","Condition")
                    meta_sub <- meta.u2
                    
                }
                
            }
            
            write_tsv(meta_sub,file)
        }
    )
    
    output$downloadEXPR <- downloadHandler(
        filename = function() {
            paste(input$exprFileName,".tsv", sep = '')
        },
        content = function(file) {
            
            firstChoice <- input$firstChoice
            secondChoice <- input$secondChoice
            
            if (firstChoice %in% disease_choice) {
                
                samples <- unlist(meta[which(meta$primary_disease == firstChoice),1], use.names = F)
                expr_sub <- expr[,which(colnames(expr) %in% samples), drop = F]
                expr_sub$gene <- rownames(expr_sub)
                expr_sub <- expr_sub %>%
                    relocate(gene)
            }
            if (firstChoice %in% lineage_choice) {
                
                if (secondChoice == "All_Sub_Lineages"){
                    samples <- unlist(meta[which(meta$lineage == firstChoice),1], use.names = F)
                }
                else if (secondChoice != "All_Sub_Lineages"){
                    samples <- unlist(meta[which(meta$lineage == firstChoice & meta$lineage_subtype == secondChoice),1], use.names = F)
                }
                expr_sub <- expr[,which(colnames(expr) %in% samples), drop = F]
                expr_sub$gene <- rownames(expr_sub)
                expr_sub <- expr_sub %>%
                    relocate(gene)
            }
            write_tsv(expr_sub,file)
            
        }
    )
    
    
    
    
}











