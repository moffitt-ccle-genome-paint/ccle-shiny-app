# ccle-shiny-app

The cancer cell line encyclopedia resource is a well characterized dataset with significant potential for therapeutic discoveries. However, the exploration of the dataset is hard and often requires significant computational resource to perform these analysis. Therefore, we have developed a shiny app in attempt to harmonize existing resource to allow users to access various details on its genome and gene expression data.

For the genome browser, we implemented an html page that leverages St Jude's protein paint API to display big wig tracks downloaded from the recount3 server. 
Given the rich dataset from CCLE, we plan to develop a series of R script to extract CCLE mutation information followed by gene expression analysis by our previously developed application: DRPPM-EASY Expression Analysis with ShinY.

Our pilot project provides a proof of concept of feasibility with opportunity to expand features that further integrate additional information such as splicing events, proteomics data, Chip-seq profiles, drug treatment information, and genetic screens. Our project also provides a model for federated data sharing that has high potential for collaboration and discovery.

http://biostools/4472414/Shiny/CCLE_Data_Hackathon/app/
