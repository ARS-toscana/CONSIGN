#-------------------------------
# CONSIGN
# v0.1 - 29 June 2021
# authors: Claudia Bartolini, Rosa Gini, Giorgio Limoncella, Olga Paoletti, Davide Messina
# based on ConcePTIONAlgorithmPregnancies https://github.com/ARS-toscana/ConcePTIONAlgorithmPregnancies
# -----------------------------


rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))


#load parameters
source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/03_concept_sets.R"))
source(paste0(thisdir,"/p_parameters/04_prompts.R"))
source(paste0(thisdir,"/p_parameters/05_subpopulations_restricting_meanings.R"))
source(paste0(thisdir,"/p_parameters/06_algorithms.R"))
source(paste0(thisdir,"/p_parameters/07_itemsets.R"))
source(paste0(thisdir,"/p_parameters/08_check_coding_system.R"))



#run scripts

# 01 RETRIEVE RECORDS FRM CDM

system.time(source(paste0(thisdir,"/p_steps/step_01_1_T2.1_create_conceptset_datasets.R")))
system.time(source(paste0(thisdir,"/p_steps/step_01_2_T2.1_create_spells.R")))
system.time(source(paste0(thisdir,"/p_steps/step_01_3_T2.1_create_dates_in_PERSONS.R"))) 
system.time(source(paste0(thisdir,"/p_steps/step_01_4_T2.1_create_prompt_datasets.R")))
system.time(source(paste0(thisdir,"/p_steps/step_01_5_T2.1_create_itemsets_datasets.R"))) # -->fare prove con TEST!!

# 02 COUNT CODES 
#system.time(source(paste0(thisdir,"/p_steps/step_02_T2.2_count_codes.R")))
  
# 03 CREATE PREGNANCIES 
source(paste0(thisdir,"/p_steps/step_03_01_T2.2_create_pregnancies_from_prompts.R")) #--> D3_Stream_PROMPTS
source(paste0(thisdir,"/p_steps/step_03_02_T2.2_create_pregnancies_from_conceptsets.R")) #--> D3_Stream_CONCEPTSETS
source(paste0(thisdir,"/p_steps/step_03_03_T2.2_create_pregnancies_from_EUROCAT.R")) #--> D3_Stream_EUROCAT
source(paste0(thisdir,"/p_steps/step_03_04_T2.2_create_pregnancies_from_itemsets.R")) #--> D3_Stream_ITEMSETS 

source(paste0(thisdir,"/p_steps/step_03_05a_T2.2_internal_consistency_for_prompts.R")) 
source(paste0(thisdir,"/p_steps/step_03_05b_T2.2_internal_consistency_for_conceptsets.R")) 
source(paste0(thisdir,"/p_steps/step_03_05c_T2.2_internal_consistency_for_EUROCAT.R")) 
source(paste0(thisdir,"/p_steps/step_03_05d_T2.2_internal_consistency_for_itemsets.R")) 

source(paste0(thisdir,"/p_steps/step_03_06_1_T2.2_process_pregnancies_excluded.R")) 
source(paste0(thisdir,"/p_steps/step_03_06_2_T2.3_merge_stream_of_same_person.R")) 

# # 04 CREATE PREGNANCIES outcomes
# source(paste0(thisdir,"/p_steps/step_04_01_T2_create_pregnancy_outcomes.R")) 
# source(paste0(thisdir,"/p_steps/step_04_02_create_aggregated_outcomes.R"))
# source(paste0(thisdir,"/p_steps/step_04_03_distance_description.R"))

# 05 MEDICATION in pregnancies
source(paste0(thisdir,"/p_steps/step_05_01_create_risk_in_pregnancy.R")) 
source(paste0(thisdir,"/p_steps/step_05_02_create_pregnancy_trimesters.R"))
source(paste0(thisdir,"/p_steps/step_05_03_create_medication_in_pregnancy.R"))


