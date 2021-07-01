# load D3_included_pregnancies  
load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# load D3_Stream_CONCEPTSETS 
for (conceptvar in concept_set_our_study_pre){
  load(paste0(dirtemp,conceptvar,".RData")) 
}

# Keep the highest quality record for each group of pregnancy

# ordering 
D3_gop<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]
# keeping the first record 
D3_pregnancy_outcomes<-D3_gop[n==1, .(person_id, 
                                      pers_group_id, 
                                      survey_id, 
                                      highest_quality, 
                                      PROMPT, 
                                      pregnancy_start_date, 
                                      pregnancy_end_date, 
                                      type_of_pregnancy_end )]
    
### Creating trimesters
#Trimester 1: from Last Menstrual Period (LMP) to day < 98 after LMP; or end of pregnancy, whichever earlier
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, trim1_start := pregnancy_start_date]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date > (trim1_start + 97), 
                                               trim1_end := (trim1_start + 97)]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date <= (trim1_start + 97), 
                                               trim1_end := pregnancy_end_date]

# Trimester 2: from day 98 after LMP to day  <196 after LMP; or end of pregnancy, whichever earlier
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date > trim1_end,
                                               trim2_start := trim1_end + 1 ]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date > (trim1_start + 195), 
                                               trim2_end := (trim1_start + 195)]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date <= (trim1_start + 195) &
                                                  pregnancy_end_date > trim1_end, 
                                               trim2_end := pregnancy_end_date]

# Trimester 3: from day 196 after LMP onwards until end of pregnancy
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[pregnancy_end_date > trim2_end,
                                               `:=` (trim3_start = trim2_end + 1 , trim3_end =  pregnancy_end_date )]




# Melting 
D3_pregnancy_trimester = melt(D3_pregnancy_outcomes, 
                              id.vars = c("person_id", "pers_group_id", 
                                          "survey_id", "highest_quality", 
                                          "PROMPT", "pregnancy_start_date",
                                          "pregnancy_end_date", "type_of_pregnancy_end"),
                              measure.vars = list(c("trim1_start", "trim2_start", "trim3_start"), 
                                               c("trim1_end", "trim2_end", "trim3_end")))
setnames(D3_pregnancy_trimester, 
         c("variable", "value1", "value2"),
         c("trim", "start_trim", "end_trim"))

D3_pregnancy_trimester <- D3_pregnancy_trimester[!is.na(start_trim)]

# keeping only the trimesters in wich start_trim > 1 march 2020
D3_pregnancy_trimester <- D3_pregnancy_trimester[start_trim > as.Date("2020-03-01"),
                                                 prior_to_COVID:=0][is.na(prior_to_COVID), prior_to_COVID:=1]

# adding age 
load(paste0(dirtemp, "D3_PERSONS.RData"))
D3_pregnancy_trimester <- merge(D3_pregnancy_trimester, D3_PERSONS[,.(person_id, date_of_birth)], 
                                all.x = T, by = "person_id")

D3_pregnancy_trimester <- D3_pregnancy_trimester[, age:= as.integer((pregnancy_start_date - date_of_birth) / 365)]
D3_pregnancy_trimester <- D3_pregnancy_trimester[, -c("date_of_birth")]

D3_pregnancy_trimester <- D3_pregnancy_trimester[age>=12 & age<=34, age_category := 1]
D3_pregnancy_trimester <- D3_pregnancy_trimester[age>=35 & age<=55, age_category := 2]
D3_pregnancy_trimester[is.na(age_category)]                                                                                      
