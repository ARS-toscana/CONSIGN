SURVEY_OBSERVATIONS_FISABIO <- fread(paste0(dirinput, "SURVEY_OBSERVATIONS_FISABIO.csv"))

### PERSONS
id_to_att <- unique(SURVEY_OBSERVATIONS_FISABIO[, person_id])

PERSONS <- fread("i_input/PERSONS.csv")

PERSONS_FISABIO <- PERSONS[sample(nrow(PERSONS), 5), ]
PERSONS_FISABIO <- PERSONS_FISABIO[, person_id := id_to_att]

set.seed(5)
PERSONS_FISABIO <- PERSONS_FISABIO[, year_of_birth:= sample(seq(1985, 1990), 1), by = person_id]
PERSONS_FISABIO <- PERSONS_FISABIO[, month_of_birth:= sample(seq(1:12), 1), by = person_id]
PERSONS_FISABIO <- PERSONS_FISABIO[, day_of_birth:= sample(seq(1:28), 1), by = person_id]

PERSONS_FISABIO <- PERSONS_FISABIO[, year_of_death:= NA]
PERSONS_FISABIO <- PERSONS_FISABIO[, month_of_death:=  NA ]
PERSONS_FISABIO <- PERSONS_FISABIO[, day_of_death:=  NA]

PERSONS_FISABIO <- PERSONS_FISABIO[, sex_at_instance_creation:=  as.character("F")]
PERSONS_FISABIO

fwrite(PERSONS_FISABIO, paste0(dirinput, "PERSONS_FISABIO.csv"))

## OBSERVATION PERIOD 
OBSERVATION_PERIODS <- fread("i_input/OBSERVATION_PERIODS.csv")
OBSERVATION_PERIODS_FISABIO <- data.table(person_id = id_to_att)

OBSERVATION_PERIODS_FISABIO <- OBSERVATION_PERIODS_FISABIO[, op_start_date := c(20000215, 19900607, 19951221, 20000101, 19950209) ]
OBSERVATION_PERIODS_FISABIO <- OBSERVATION_PERIODS_FISABIO[, op_end_date :=c(99991231, 99991231, 99991231, 99991231, 99991231) ]

OBSERVATION_PERIODS_FISABIO <- OBSERVATION_PERIODS_FISABIO[, op_meaning := "FISABIO_op_meaning" ]
OBSERVATION_PERIODS_FISABIO <- OBSERVATION_PERIODS_FISABIO[, op_origin := "FISABIO_op_origin" ]

fwrite(OBSERVATION_PERIODS_FISABIO, paste0(dirinput, "OBSERVATION_PERIODS_FISABIO.csv"))

## SURVEY_ID
SURVEY_ID_CAP1 <- fread("i_input/SURVEY_ID_CAP1.csv")
date_to_att <- unique(SURVEY_OBSERVATIONS_FISABIO[, so_date])
SURVEY_ID_FISABIO <- data.table(person_id = id_to_att)
SURVEY_ID_FISABIO <- SURVEY_ID_FISABIO[, survey_id := seq(1,5)]
SURVEY_ID_FISABIO <- SURVEY_ID_FISABIO[, survey_date := date_to_att]
SURVEY_ID_FISABIO <- SURVEY_ID_FISABIO[, survey_meaning := " "]
SURVEY_ID_FISABIO <- SURVEY_ID_FISABIO[, survey_origin := "MDR"]
fwrite(SURVEY_ID_FISABIO, paste0(dirinput, "SURVEY_ID_FISABIO.csv"))
