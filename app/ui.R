library(shiny)
library(markdown)
library(rmarkdown)
library(shinythemes)
library(ggplot2)  # for the diamonds dataset
library(shinycssloaders)

# set Shiny theme
shinytheme("sandstone")

ui <- 

navbarPage("CCLE Genome Browser and Expression Analysis Tool",

tabPanel("Overview",
fluidPage(
mainPanel(
    includeHTML("www/project_overview.html"),
    #includeHTML("introduction.html"),
    #uiOutput("shawlablayout")
)
)
),

tabPanel("(Single Sample) Genome Browser",

  fluidPage(
     title = "(Single Sample) Genome Browser",
     sidebarLayout(
       sidebarPanel(
	   # display a data table in the UI (top left side panel)
	   div(DT::dataTableOutput("sample_name_table"),style = "font-size:75%"),

	   # JD: here you can add the following
	   # display a data table in the UI (bottom left side panel)
	   # see above an example
	   div(DT::dataTableOutput("position_table"),style = "font-size:75%"),

       ),

       mainPanel(
           id = 'dataset',
	   uiOutput('GenomeProteinPaint'),
	   #uiOutput("GenomeProteinPaint")  %>% withSpinner(color="#0dc5c1")
       )
     )
  )
  
),

tabPanel("(Multi-sample) Genome Browser",

  fluidPage(
    title = "Genome Browser",
    sidebarLayout(
      sidebarPanel(
          div(DT::dataTableOutput("position2_table"),style = "font-size:75%"),
	
      ),

      mainPanel(
          id = 'dataset',
	  uiOutput('MultiGenomeProteinPaint'),	
      )
      
    )
  ),
  tabPanel("Questions/Feedback",
    fluidPage(
       mainPanel(
           uiOutput("comment")
       )
    ) 
  )
)

) # navBar
