library(shiny)
library(ggplot2)  # for the diamonds dataset

#library(survival);
#library(survminer);
library(gtsummary);
library(gridExtra);
library(pwr);
library(purrr);
library(exact2x2);
library(powerSurvEpi);


library(stringr)
library(ggpubr);
library(cowplot);
library(gridExtra);
library(patchwork)
library(circlize)
library(dplyr)
library(pheatmap)
library(reshape2)
library(htmlwidgets)

sample_table <- read.table("ccle_meta.txt", sep="\t", header=T);

## JD add a read table function here (gene_coords.tsv)
gene_coords = read.table("gene_coords_chrOnly.tsv", sep = "\t", header = T)


server <- function(input, output, session) {
  observeEvent(input$surfTF, {
})

  # render the data table for the samples
  output$sample_name_table <- DT::renderDataTable({
    EntireCandidates2 = sample_table
    DT::datatable(sample_table, options = list(lengthMenu = c(10, 20, 100, 1000), pageLength = 10, columnDefs = list(list(className = 'dt-center'))), filter="top", selection=list(mode = "single", selected = c(1)))
  })

  # here we will add the data table for the gene - position
  output$position_table <- DT::renderDataTable({
    DT::datatable(gene_coords, options = list(lengthMenu = c(10, 20, 100, 1000), pageLength = 10, columnDefs = list(list(className = 'dt-center'))), 
	filter="top", selection=list(mode = "single", selected = c(1)))
  })
  output$position2_table <- DT::renderDataTable({
    DT::datatable(gene_coords, options = list(lengthMenu = c(10, 20, 100, 1000), pageLength = 10, columnDefs = list(list(className = 'dt-center'))),
        filter="top", selection=list(mode = "single", selected = c(1)))
  })

###

  output$GenomeProteinPaint <- renderUI({

     sra <- as.matrix(sample_table[input$sample_name_table_rows_selected,1])[1]
     cell_line <- as.matrix(sample_table[input$sample_name_table_rows_selected,2])[1]
     
     # need to replace the following line with -- position <- as.matrix(%position_table%[input$%position_table_rows_selected, 2])[1]
     position = as.matrix(gene_coords[input$position_table_rows_selected, 2])[1]

     urllink = paste("http://biostools/4472414/Shiny/CCLE_Data_Hackathon/genomepaint/ccle_genomepaint_jn.html?sample_name=", cell_line, "&bigwig_file=sra.base_sums.SRP186687_", sra, ".ALL.bw&position=", position, sep="")
     #urllink = paste("http://biostools/4472414/Shiny/CCLE_Data_Hackathon/genomepaint/ccle_genomepaint_jn.html?sample_name=", cell_line, "&bigwig_file=sra.base_sums.SRP186687_", sra, ".ALL.bw", sep="")
     my_test <- tags$iframe(src=urllink, frameBorder="0", height=2000, width=2035)
     #print(cell_line)
     print(my_test)

  })


  output$MultiGenomeProteinPaint <- renderUI({

     
     position = as.matrix(gene_coords[input$position2_table_rows_selected, 2])[1]
     urllink = paste("https://proteinpaint.stjude.org/F/hg38/tim/cart_CCLE.html?position=", position, sep="")
     #urllink = paste("http://biostools/4472414/Shiny/CCLE_Data_Hackathon/genomepaint/ccle_genomepaint_jn.html?sample_name=", cell_line, "&bigwig_file=sra.base_sums.SRP186687_", sra, ".ALL.bw", sep="")
     my_test <- tags$iframe(src=urllink, frameBorder="0", height=2000, width=2035)
     #print(cell_line)
     print(my_test)

  })

}
#shinyApp(ui, server)
