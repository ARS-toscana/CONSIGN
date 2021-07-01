# load pregnancies dataset
load(paste0(dirtemp,"D3_pregnancy_risk_trimester.RData"))
#load concepts datasets
for (conceptvar in concept_sets_of_our_study_medications){
  load(paste0(dirtemp,conceptvar,".RData")) 
}

# create dummy for medication
D3_medication_in_pregnancy <- D3_pregnancy_risk_trimester
for (concept in concept_sets_of_our_study_medications) {
  print(paste0("Creating dummy for medication: ", concept))
  MFC_medication <- MergeFilterAndCollapse( listdatasetL = list(get(concept)),
                                            datasetS = D3_pregnancy_risk_trimester, 
                                            typemerge = 2,
                                            key = c("person_id"), 
                                            condition = "date >= start_trim & date <= end_trim",
                                            strata=c("pers_group_id", "trim"),
                                            summarystat = list(list(c("exist"), "date" , concept)))
  
  D3_medication_in_pregnancy <- merge(D3_medication_in_pregnancy, 
                                      MFC_medication, 
                                      by = c("pers_group_id", "trim"), 
                                      all.x = T)
  
  setnames(D3_medication_in_pregnancy, concept, "risk_to_be_renamed")
  D3_medication_in_pregnancy <- D3_medication_in_pregnancy[is.na(risk_to_be_renamed), risk_to_be_renamed := 0]
  setnames(D3_medication_in_pregnancy, "risk_to_be_renamed", concept)
  
}                

save(D3_medication_in_pregnancy, file=paste0(dirtemp,"D3_medication_in_pregnancy.RData"))
rm(D3_medication_in_pregnancy)

for (conceptvar in concept_sets_of_our_study_medications){
  rm(list = conceptvar) 
}
