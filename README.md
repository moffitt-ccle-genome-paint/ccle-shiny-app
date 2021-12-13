# ccle-shiny-app

The cancer cell line encyclopedia (CCLE) project is a well-characterized multi-omics dataset with significant potential for therapeutic discoveries. However, the exploration of the dataset is often complex and requires significant expertise and computational power to perform these analyses. Therefore, we have developed a shiny app to harmonize existing resources to allow users to access details of the mutation, RNA sequencing coverage, and expression data.
Team 1 implemented an interactive web page for the genome browser that leverages St Jude's protein paint API to display big wig tracks downloaded from the recount3 server. Link to JD's code https://github.com/jdLikesPlants/jd_code

Team 2 developed a series of R scripts to extract CCLE cell line meta-information, SNV/Indel of genetic drivers, and gene expression.
The harmonized data can then be ported into our previously developed application: DRPPM-EASY, an app for performing Expression Analysis with Shiny. https://github.com/shawlab-moffitt/DRPPM-EASY-ExprAnalysisShinY

Our pilot project provides a proof of concept of feasibility with the opportunity to expand toward integrating additional information such as splicing events, proteomics data, Chip-seq profiles, drug treatment information, and genetic screens. Our project also provides a model for federated data sharing that has a high potential for collaboration and discovery.

Moffitt's link (needs to be inside Moffitt's internal network for access)
http://biostools/4472414/Shiny/CCLE_Data_Hackathon/app/

http://biostools/4472414/Shiny/CCLE_Data_Hackathon/SampleSelectionApp/

http://biostools/4472414/Shiny/CCLE_Data_Hackathon/EASY_LungCancerTP53/






