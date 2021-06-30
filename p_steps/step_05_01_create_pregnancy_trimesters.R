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
D3_pregnancy_trimester_melt = melt(D3_pregnancy_outcomes, 
                                   id.vars = c("person_id", "pers_group_id", 
                                                "survey_id", "highest_quality", 
                                                "PROMPT", "pregnancy_start_date",
                                                "pregnancy_end_date", "type_of_pregnancy_end",
                                               "trim1_start", "trim2_start", "trim3_start"),
                                   measure.vars = c("trim1_end", "trim2_end", "trim3_end"))



D3_pregnancy_trimester <- D3_pregnancy_trimester_melt[variable == "trim1_end",
                                                      `:=` (trimester = 1, 
                                                            trimester_start =  trim1_start,
                                                            trimester_end =  value)]

D3_pregnancy_trimester <- D3_pregnancy_trimester[variable == "trim2_end",
                                                 `:=` (trimester = 2, 
                                                       trimester_start =  trim2_start,
                                                       trimester_end =  value)]

D3_pregnancy_trimester <- D3_pregnancy_trimester[variable == "trim3_end",
                                                 `:=` (trimester = 3, 
                                                       trimester_start =  trim3_start,
                                                       trimester_end =  value)]

D3_pregnancy_trimester <- D3_pregnancy_trimester[, -c("trim1_start", "trim2_start", 
                                                      "trim3_start", "variable", "value")]



# set obs 10
# gen id = _n
# gen data_i_1 = mdy(1,1,2020)
# gen data_f_1 = mdy(1,31,2020)
# gen data_i_2 = mdy(2,1,2020)
# gen data_f_2 = mdy(2,28,2020)
# reshape long data_i_ data_f_,i(id) j(trimestre)
# format data* %td
