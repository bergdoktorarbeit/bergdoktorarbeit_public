# Remove all stuff in Environment
rm(list = ls()) 

# start time
start_time <- Sys.time()
cat("Start Script:", format(start_time, "%H:%M:%S"), "\n")










# set working dirctory
#setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path))) # set wd if you want
cat("Working directory:", getwd(), "\n")

source("init_v0.6.R")


# This is code is coming mostly from SociSurvey!
# This script reads a CSV file in GNU R.
# While reading this file, comments will be created for all variables.
# The comments for values will be stored as attributes (attr) as well.

input_data <- paste0(paths$interview_data, "/221027_Save Data/")

cat("Data load from: ", input_data, "\n")


# input column name and questions
df_file <- paste0(input_data, "230127_quest_group_bergdoktorarbeit.xlsx")

df_quest_raw <- read.xlsx(df_file)


# input traceinterview data
ds_file <- paste0(input_data, "rdata_bergdokotorarbeit_2023-01-06_13-35.csv")

ds = read.table(
  file=ds_file, encoding="UTF-8", fileEncoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".", row.names = "CASE",
  col.names = c(
    "CASE","SERIAL","REF","QUESTNNR","MODE","STARTED","DE02_01","DE03_01","DE03_02",
    "DE03_03","DE03_04","DE03_05","DE03_06","DE03_07","DE03_08","DE04_01","DE05",
    "DE06","DE07_01","DE08","DE09","DE09_38","DE20_01","DE12_01","DE13_01","DE14",
    "DE14_01","DE14_02","DE14_03","DE14_04","DE14_05","DE14_06","DE14_07","DE14_08",
    "DE14_09","DE14_09a","DE15_01","DE15_02","DE15_03","DE16","DE16_01","DE16_02",
    "DE16_03","DE16_04","DE16_05","DE16_06","DE16_07","DE16_08","DE16_08a","DE17",
    "DE19_01","DE21_01","DE22","DE23_01","DE25_01","EI01","EI01_01","EI01_02",
    "EI01_03","EI01_04","EI01_05","EI01_06","EI01_07","EI01_08","EI01_09","EI01_10",
    "EI01_11","EI01_12","EI01_13","EI01_14","EI01_15","EI01_16","EI06","EI02_01",
    "EI03_01","EI04","EI05_01","EI05_02","EI05_03","EI05_04","EI05_05","EI05_06",
    "EI05_07","EI05_08","EI05_09","EI05_10","EI07","EI08_01","EI08_02","EI08_03",
    "EI08_04","EI08_05","EI08_06","EI09","EI10_01","EI10_02","EI10_03","EI10_04",
    "EI10_05","EI10_06","IP02","IP51","IP53","IP55","IP14_01","IP14_09","IP14_29",
    "IP14_30","IP14_33","IP14_35","IP14_38","IP52_10","IP52_13","IP52_16","IP52_26",
    "IP52_32","IP52_33","IP54_07","IP54_19","IP54_26","IP56_01","IP56_05","IP56_10",
    "IP56_11","IP56_18","IP56_23","IP56_28","IP56_33","IP17","IP01","IP04_01",
    "IP05_01","IP06_01","IP07_01","IP08_01","IP35_pts","IP35_rgs","IP35_01",
    "IP35_01x01","IP35_01x02","IP35_01x03","IP35_01x04","IP35_01x05","IP35_01x06",
    "IP35_01x07","IP35_01x08","IP35_01x09","IP35_01x10","IP35_01x11","IP35_01x12",
    "IP35_01x13","IP35_01x14","IP35_01x15","IP35_01x16","IP35_01x17","IP35_01x18",
    "IP35_01x19","IP35_01x20","IP35_01x21","IP35_01x22","IP35_01x23","IP35_01x24",
    "IP35_01x25","IP35_01x26","IP35_01x27","IP35_01x28","IP35_01x29","IP35_01x30",
    "IP35_02","IP35_02x01","IP35_02x02","IP35_02x03","IP35_02x04","IP35_02x05",
    "IP35_02x06","IP35_02x07","IP35_02x08","IP35_02x09","IP35_02x10","IP35_02x11",
    "IP35_02x12","IP35_02x13","IP35_02x14","IP35_02x15","IP35_02x16","IP35_02x17",
    "IP35_02x18","IP35_02x19","IP35_02x20","IP35_02x21","IP35_02x22","IP35_02x23",
    "IP35_02x24","IP35_02x25","IP35_02x26","IP35_02x27","IP35_02x28","IP35_02x29",
    "IP35_02x30","IP11","IP11s","IP12_01","IP13","IP18","IP57","IP19_04","IP19_09",
    "IP19_10","IP19_16","IP58_02","IP58_23","IP20","IP21","IP23_01","IP24_01",
    "IP25_01","IP26_01","IP27","IP59_pts","IP59_rgs","IP59_01","IP59_01x01",
    "IP59_01x02","IP59_01x03","IP59_01x04","IP59_01x05","IP59_01x06","IP59_01x07",
    "IP59_01x08","IP59_01x09","IP59_01x10","IP59_01x11","IP59_01x12","IP59_01x13",
    "IP59_01x14","IP59_01x15","IP59_01x16","IP59_01x17","IP59_01x18","IP59_01x19",
    "IP59_01x20","IP59_01x21","IP59_01x22","IP59_01x23","IP59_01x24","IP59_01x25",
    "IP59_01x26","IP59_01x27","IP59_01x28","IP59_01x29","IP59_02","IP59_02x01",
    "IP59_02x02","IP59_02x03","IP59_02x04","IP59_02x05","IP59_02x06","IP59_02x07",
    "IP59_02x08","IP59_02x09","IP59_02x10","IP59_02x11","IP59_02x12","IP59_02x13",
    "IP59_02x14","IP59_02x15","IP59_02x16","IP59_02x17","IP59_02x18","IP59_02x19",
    "IP59_02x20","IP59_02x21","IP59_02x22","IP59_02x23","IP59_02x24","IP59_02x25",
    "IP59_02x26","IP59_02x27","IP59_02x28","IP59_02x29","IP30","IP30s","IP31_01",
    "IP32_01","IP36","IP37_19","IP38","IP39","IP40_01","IP41_01","IP42_01",
    "IP43_01","IP44","IP45_01","IP47","IP47s","IP48_01","IP49","IP50_01","IT01_01",
    "IT01_02","IT01_03","IT01_04","IT01_05","IT01_06","IT02_01","IT02_02","IT02_03",
    "IT03_01","IT03_02","IT03_03","IT03_04","IT04","IT05_01","IT05_02","IT06_01",
    "IT07","IT08_01","IT08_02","IT08_03","IT08_04","IT08_05","IT08_06","IT08_07",
    "IT08_08","IT08_09","IT08_10","IT08_11","IT09","IT09_05","IT10_01","IT10_02",
    "IT10_03","IT10_04","IT10_05","IT10_06","IT10_07","IT15_01","IT15_02","IT15_03",
    "IT15_04","IT15_05","IT15_06","IT15_07","IT13","IT14","IT16","IT17","IT18_01",
    "IT19_01","IT19_02","IT19_03","IT19_04","IT19_05","IT19_06","IT20","IT20_01",
    "IT20_02","IT20_03","IT20_04","IT21_01","IT21_02","IT22_01","IT24_01","IT24_02",
    "IT24_03","IT24_04","IT24_05","IT24_06","IT24_07","IT25_01","IT25_02","IT25_03",
    "IT25_04","IT25_05","IT25_06","IT25_07","IT26_01","IT27_01","IT27_02","IT27_03",
    "IT27_04","IT28_01","IT29_01","IT33_01","IT33_02","IT33_03","IT33_04","IT33_05",
    "IT33_06","IT33_07","IT30_01","IT30_02","IT30_03","IT30_04","IT30_05","IT30_06",
    "IT30_07","IT31_01","IT32_01","SO02","SO10","SO11","SO12","SO12s","SO06",
    "SO06s","SO13","SO09","TIME001","TIME002","TIME003","TIME004","TIME005",
    "TIME006","TIME007","TIME008","TIME009","TIME010","TIME011","TIME012","TIME013",
    "TIME014","TIME015","TIME016","TIME017","TIME_SUM","MAILSENT","LASTDATA",
    "FINISHED","Q_VIEWER","LASTPAGE","MAXPAGE","MISSING","MISSREL","TIME_RSI",
    "DEG_TIME"
  ),
  as.is = TRUE,
  colClasses = c(
    CASE="numeric", SERIAL="character", REF="character", QUESTNNR="character",
    MODE="factor", STARTED="POSIXct", DE02_01="character", DE03_01="numeric",
    DE03_02="numeric", DE03_03="numeric", DE03_04="numeric", DE03_05="numeric",
    DE03_06="numeric", DE03_07="numeric", DE03_08="numeric",
    DE04_01="character", DE05="numeric", DE06="numeric", DE07_01="numeric",
    DE08="numeric", DE09="numeric", DE09_38="character", DE20_01="character",
    DE12_01="character", DE13_01="character", DE14="numeric", DE14_01="logical",
    DE14_02="logical", DE14_03="logical", DE14_04="logical", DE14_05="logical",
    DE14_06="logical", DE14_07="logical", DE14_08="logical", DE14_09="logical",
    DE14_09a="character", DE15_01="numeric", DE15_02="numeric",
    DE15_03="numeric", DE16="numeric", DE16_01="logical", DE16_02="logical",
    DE16_03="logical", DE16_04="logical", DE16_05="logical", DE16_06="logical",
    DE16_07="logical", DE16_08="logical", DE16_08a="character", DE17="numeric",
    DE19_01="character", DE21_01="numeric", DE22="numeric", DE23_01="character",
    DE25_01="character", EI01="numeric", EI01_01="logical", EI01_02="logical",
    EI01_03="logical", EI01_04="logical", EI01_05="logical", EI01_06="logical",
    EI01_07="logical", EI01_08="logical", EI01_09="logical", EI01_10="logical",
    EI01_11="logical", EI01_12="logical", EI01_13="logical", EI01_14="logical",
    EI01_15="logical", EI01_16="logical", EI06="numeric", EI02_01="numeric",
    EI03_01="numeric", EI04="numeric", EI05_01="numeric", EI05_02="numeric",
    EI05_03="numeric", EI05_04="numeric", EI05_05="numeric", EI05_06="numeric",
    EI05_07="numeric", EI05_08="numeric", EI05_09="numeric", EI05_10="numeric",
    EI07="numeric", EI08_01="numeric", EI08_02="numeric", EI08_03="numeric",
    EI08_04="numeric", EI08_05="numeric", EI08_06="numeric", EI09="numeric",
    EI10_01="numeric", EI10_02="numeric", EI10_03="numeric", EI10_04="numeric",
    EI10_05="numeric", EI10_06="numeric", IP02="numeric", IP51="numeric",
    IP53="numeric", IP55="numeric", IP14_01="numeric", IP14_09="numeric",
    IP14_29="numeric", IP14_30="numeric", IP14_33="numeric", IP14_35="numeric",
    IP14_38="numeric", IP52_10="numeric", IP52_13="numeric", IP52_16="numeric",
    IP52_26="numeric", IP52_32="numeric", IP52_33="numeric", IP54_07="numeric",
    IP54_19="numeric", IP54_26="numeric", IP56_01="numeric", IP56_05="numeric",
    IP56_10="numeric", IP56_11="numeric", IP56_18="numeric", IP56_23="numeric",
    IP56_28="numeric", IP56_33="numeric", IP17="numeric", IP01="numeric",
    IP04_01="character", IP05_01="character", IP06_01="character",
    IP07_01="character", IP08_01="character", IP35_pts="character",
    IP35_rgs="character", IP35_01="numeric", IP35_01x01="numeric",
    IP35_01x02="numeric", IP35_01x03="numeric", IP35_01x04="numeric",
    IP35_01x05="numeric", IP35_01x06="numeric", IP35_01x07="numeric",
    IP35_01x08="numeric", IP35_01x09="numeric", IP35_01x10="numeric",
    IP35_01x11="numeric", IP35_01x12="numeric", IP35_01x13="numeric",
    IP35_01x14="numeric", IP35_01x15="numeric", IP35_01x16="numeric",
    IP35_01x17="numeric", IP35_01x18="numeric", IP35_01x19="numeric",
    IP35_01x20="numeric", IP35_01x21="numeric", IP35_01x22="numeric",
    IP35_01x23="numeric", IP35_01x24="numeric", IP35_01x25="numeric",
    IP35_01x26="numeric", IP35_01x27="numeric", IP35_01x28="numeric",
    IP35_01x29="numeric", IP35_01x30="numeric", IP35_02="numeric",
    IP35_02x01="numeric", IP35_02x02="numeric", IP35_02x03="numeric",
    IP35_02x04="numeric", IP35_02x05="numeric", IP35_02x06="numeric",
    IP35_02x07="numeric", IP35_02x08="numeric", IP35_02x09="numeric",
    IP35_02x10="numeric", IP35_02x11="numeric", IP35_02x12="numeric",
    IP35_02x13="numeric", IP35_02x14="numeric", IP35_02x15="numeric",
    IP35_02x16="numeric", IP35_02x17="numeric", IP35_02x18="numeric",
    IP35_02x19="numeric", IP35_02x20="numeric", IP35_02x21="numeric",
    IP35_02x22="numeric", IP35_02x23="numeric", IP35_02x24="numeric",
    IP35_02x25="numeric", IP35_02x26="numeric", IP35_02x27="numeric",
    IP35_02x28="numeric", IP35_02x29="numeric", IP35_02x30="numeric",
    IP11="numeric", IP11s="character", IP12_01="Date", IP13="numeric",
    IP18="numeric", IP57="numeric", IP19_04="numeric", IP19_09="numeric",
    IP19_10="numeric", IP19_16="numeric", IP58_02="numeric", IP58_23="numeric",
    IP20="numeric", IP21="numeric", IP23_01="character", IP24_01="character",
    IP25_01="character", IP26_01="character", IP27="numeric",
    IP59_pts="character", IP59_rgs="character", IP59_01="numeric",
    IP59_01x01="numeric", IP59_01x02="numeric", IP59_01x03="numeric",
    IP59_01x04="numeric", IP59_01x05="numeric", IP59_01x06="numeric",
    IP59_01x07="numeric", IP59_01x08="numeric", IP59_01x09="numeric",
    IP59_01x10="numeric", IP59_01x11="numeric", IP59_01x12="numeric",
    IP59_01x13="numeric", IP59_01x14="numeric", IP59_01x15="numeric",
    IP59_01x16="numeric", IP59_01x17="numeric", IP59_01x18="numeric",
    IP59_01x19="numeric", IP59_01x20="numeric", IP59_01x21="numeric",
    IP59_01x22="numeric", IP59_01x23="numeric", IP59_01x24="numeric",
    IP59_01x25="numeric", IP59_01x26="numeric", IP59_01x27="numeric",
    IP59_01x28="numeric", IP59_01x29="numeric", IP59_02="numeric",
    IP59_02x01="numeric", IP59_02x02="numeric", IP59_02x03="numeric",
    IP59_02x04="numeric", IP59_02x05="numeric", IP59_02x06="numeric",
    IP59_02x07="numeric", IP59_02x08="numeric", IP59_02x09="numeric",
    IP59_02x10="numeric", IP59_02x11="numeric", IP59_02x12="numeric",
    IP59_02x13="numeric", IP59_02x14="numeric", IP59_02x15="numeric",
    IP59_02x16="numeric", IP59_02x17="numeric", IP59_02x18="numeric",
    IP59_02x19="numeric", IP59_02x20="numeric", IP59_02x21="numeric",
    IP59_02x22="numeric", IP59_02x23="numeric", IP59_02x24="numeric",
    IP59_02x25="numeric", IP59_02x26="numeric", IP59_02x27="numeric",
    IP59_02x28="numeric", IP59_02x29="numeric", IP30="numeric",
    IP30s="character", IP31_01="Date", IP32_01="numeric", IP36="numeric",
    IP37_19="numeric", IP38="numeric", IP39="numeric", IP40_01="character",
    IP41_01="character", IP42_01="character", IP43_01="character",
    IP44="numeric", IP45_01="character", IP47="numeric", IP47s="character",
    IP48_01="Date", IP49="numeric", IP50_01="numeric", IT01_01="numeric",
    IT01_02="numeric", IT01_03="numeric", IT01_04="numeric", IT01_05="numeric",
    IT01_06="numeric", IT02_01="numeric", IT02_02="numeric", IT02_03="numeric",
    IT03_01="numeric", IT03_02="numeric", IT03_03="numeric", IT03_04="numeric",
    IT04="numeric", IT05_01="Date", IT05_02="Date", IT06_01="character",
    IT07="numeric", IT08_01="numeric", IT08_02="numeric", IT08_03="numeric",
    IT08_04="numeric", IT08_05="numeric", IT08_06="numeric", IT08_07="numeric",
    IT08_08="numeric", IT08_09="numeric", IT08_10="numeric", IT08_11="numeric",
    IT09="numeric", IT09_05="character", IT10_01="numeric", IT10_02="numeric",
    IT10_03="numeric", IT10_04="numeric", IT10_05="numeric", IT10_06="numeric",
    IT10_07="numeric", IT15_01="numeric", IT15_02="numeric", IT15_03="numeric",
    IT15_04="numeric", IT15_05="numeric", IT15_06="numeric", IT15_07="numeric",
    IT13="numeric", IT14="numeric", IT16="numeric", IT17="numeric",
    IT18_01="character", IT19_01="numeric", IT19_02="numeric",
    IT19_03="numeric", IT19_04="numeric", IT19_05="numeric", IT19_06="numeric",
    IT20="numeric", IT20_01="logical", IT20_02="logical", IT20_03="logical",
    IT20_04="logical", IT21_01="numeric", IT21_02="numeric", IT22_01="numeric",
    IT24_01="numeric", IT24_02="numeric", IT24_03="numeric", IT24_04="numeric",
    IT24_05="numeric", IT24_06="numeric", IT24_07="numeric", IT25_01="numeric",
    IT25_02="numeric", IT25_03="numeric", IT25_04="numeric", IT25_05="numeric",
    IT25_06="numeric", IT25_07="numeric", IT26_01="character",
    IT27_01="numeric", IT27_02="numeric", IT27_03="numeric", IT27_04="numeric",
    IT28_01="character", IT29_01="character", IT33_01="numeric",
    IT33_02="numeric", IT33_03="numeric", IT33_04="numeric", IT33_05="numeric",
    IT33_06="numeric", IT33_07="numeric", IT30_01="numeric", IT30_02="numeric",
    IT30_03="numeric", IT30_04="numeric", IT30_05="numeric", IT30_06="numeric",
    IT30_07="numeric", IT31_01="character", IT32_01="numeric", SO02="numeric",
    SO10="numeric", SO11="numeric", SO12="numeric", SO12s="character",
    SO06="numeric", SO06s="character", SO13="numeric", SO09="numeric",
    TIME001="integer", TIME002="integer", TIME003="integer", TIME004="integer",
    TIME005="integer", TIME006="integer", TIME007="integer", TIME008="integer",
    TIME009="integer", TIME010="integer", TIME011="integer", TIME012="integer",
    TIME013="integer", TIME014="integer", TIME015="integer", TIME016="integer",
    TIME017="integer", TIME_SUM="integer", MAILSENT="POSIXct",
    LASTDATA="POSIXct", FINISHED="logical", Q_VIEWER="logical",
    LASTPAGE="numeric", MAXPAGE="numeric", MISSING="numeric", MISSREL="numeric",
    TIME_RSI="numeric", DEG_TIME="numeric"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(ds_file)

attr(ds, "project") = "bergdokotorarbeit"
attr(ds, "description") = "#Bergdoktorarbeit"
attr(ds, "date") = "2023-01-06 13:35:07"
attr(ds, "server") = "https://www.soscisurvey.de"

# Variable und Value Labels
ds$DE05 = factor(ds$DE05, levels=c("1","2","3","4","5","6","7","-9"), labels=c("Einzelgebäude ohne Anbindung","Ländliche Gemeinschaft","Vorstadtgemeinde","Stadt oder Stadtgemeinde","Großstadt","Metropole","Andere, bitte spezifizieren:","[NA] Not answered"), ordered=FALSE)
ds$DE06 = factor(ds$DE06, levels=c("1","2","3","4","5","6","7","-9"), labels=c("Mittelschule","Hochschulreife","Berufsausbildung","Bachelor","Master","Promotion","Andere, bitte spezifizieren:","[NA] Not answered"), ordered=FALSE)
ds$DE08 = factor(ds$DE08, levels=c("1","2","3","4","5","6","-9"), labels=c("ledig","Beziehung","verheiratet","verwitwet","geschieden","eingetragene Lebenspartnerschaft","[NA] Not answered"), ordered=FALSE)
ds$DE09 = factor(ds$DE09, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","-9"), labels=c("Berufe in Unternehmensführung, -organisation (Büro)","Medizinische Gesundheitsberufe","Verkaufsberufe","Verkehr, Logistik (außer Fahrzeugführung)","Erziehung, soz., hauswirt. Berufe, Theologie","Maschinen- und Fahrzeugtechnikberufe","Reinigungsberufe","FührerInnen von Fahrzeug- und Transportgeräten","Berufe in Finanzdienstleistungen, Rechnungswesen und Steuerberatung","Tourismus-, Hotel- und Gaststättenberufe","Metallerzeugung, -bearbeitung, Metallbau","Berufe in Recht und Verwaltung","Technische Forschungs-, Entwicklungs-, Konstruktions- und Produktionssteuerungsberufe","Mechatronik-, Energie- und Elektroberufe","Nichtmed. Gesundheits-, Körperpflege-/ Wellnessberufe, Medizintechnik","Einkaufs-, Vertriebs- und Handelsberufe","Lebensmittelherstellung und -verarbeitung","Gebäude- und versorgungstechnische Berufe","Informatik- und andere IKT-Berufe","Lehrende und ausbildende Berufe","Hoch- und Tiefbauberufe","Werbung, Marketing, kaufmännische und redaktionelle Medienberufe","Kunststoff- und Holz- herstellung, -verarbeitung","Schutz-, Sicherheits-, Überwachungsberufe","<25>","Mathematik-, Biologie-, Chemie-, Physikberufe","(Innen-) Ausbauberufe","Land-, Tier-, Forstwirtschaftsberufe","Gartenbauberufe, Floristik","Papier-, Druckberufe, tech. Mediengestaltung","Bauplanung, Architektur, Vermessungsberufe","Darstellende, unterhaltende Berufe","Textil- und Lederberufe","Rohstoffgewinnung, Glas-, Keramikverarbeitung","Sprach-/ Literatur-/ Geistes-/ Gesellschafts-/ Wirtschaftswissenschaften","Produktdesign, Kunsthandwerk","Geologie-, Geografie-, Umweltschutzberufe","Andere, bitte spezifizieren:","[NA] Not answered"), ordered=FALSE)
ds$DE17 = factor(ds$DE17, levels=c("1","2","3","4","5","-1","-9"), labels=c("1 Tag (Tagestouristen)","2 bis 3 Tage","Bis zu 7 Tage","Bis zu 14 Tage","Länger als 14 Tage","[NA] Das kann ich nicht beantworten","[NA] Not answered"), ordered=FALSE)
ds$DE22 = factor(ds$DE22, levels=c("1","2","3","4","5","6","7","-9"), labels=c("Schauspieler:in","Kreativ-Crew (Regisseur, Kamermann:frau etc.)","Technische Crew (Beleuchtung, Setbau, Make-up, etc.)","Redakteur:in (ZDF, ORF etc.)","Drehbuch","Backoffice (NDF etc.)","Sonstiges, bitte spezifizieren:","[NA] Not answered"), ordered=FALSE)
ds$EI06 = factor(ds$EI06, levels=c("1","2","3","4","5","6","7","-9"), labels=c("Keine Folge","Eine Folge","2 bis 5 Folgen","6 bis 10 Folgen","10 bis 20 Folgen","21 bis 50 Folgen","Mehr als 50 Folgen","[NA] Not answered"), ordered=FALSE)
ds$EI04 = factor(ds$EI04, levels=c("1","2","3","4","5","6","-9"), labels=c("Gar nicht","1/2 Stunde","1 Stunde","2 Stunden","3 Stunden","Mehr als 3 Stunden","[NA] Not answered"), ordered=FALSE)
ds$EI07 = factor(ds$EI07, levels=c("1","2","3","4","5","6","7","-9"), labels=c("Keine Folge","Eine Folge","2 bis 5 Folgen","6 bis 10 Folgen","10 bis 20 Folgen","21 bis 50 Folgen","Mehr als 50 Folgen","[NA] Not answered"), ordered=FALSE)
ds$EI09 = factor(ds$EI09, levels=c("1","2","3","4","5","6","-9"), labels=c("Gar nicht","1/2 Stunde","1 Stunde","2 Stunden","3 Stunden","Mehr als 3 Stunden","[NA] Not answered"), ordered=FALSE)
ds$IP02 = factor(ds$IP02, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-9"), labels=c("https://www.instagram.com/p/BjFpI0CgwTl/","https://www.instagram.com/p/B62WBxrqybr/","https://www.instagram.com/p/ByKkrvLoQTv/","https://www.instagram.com/p/B2JjnYZJbwJ/","https://www.instagram.com/p/B6tHCJUn0KW/","https://www.instagram.com/p/B8CLEJRqesi/","https://www.instagram.com/p/B8wjLzKn4pA/","https://www.instagram.com/p/CDEuAt_opTV/","https://www.instagram.com/p/CDataSXBhvF/","https://www.instagram.com/p/B_zDsBZla-I/","https://www.instagram.com/p/CHHuA_PAyjd/","https://www.instagram.com/p/B-fIBEMFpnv/","https://www.instagram.com/p/CG2IfzKMrrz/","https://www.instagram.com/p/CGCI911M03x/","https://www.instagram.com/p/CGKnTXdnpZ2/","https://www.instagram.com/p/CF60S8-lT39/","https://www.instagram.com/p/CGMx7oJs1BP/","https://www.instagram.com/p/CFoPmOZgFWi/","https://www.instagram.com/p/B2olwmfIrs6/","https://www.instagram.com/p/CF7GjtkJ-KU/","https://www.instagram.com/p/CF2VkyLHhJ0/","https://www.instagram.com/p/CGInNiOKvta/","https://www.instagram.com/p/Bjk0xvJFx2c/","https://www.instagram.com/p/ByqZlhCoMKS/","https://www.instagram.com/p/BlBMrgXhgi7/","https://www.instagram.com/p/CE9-jgmHOUd/","https://www.instagram.com/p/CF_VoHgsdRe/","https://www.instagram.com/p/CF_UGq5HoQb/","https://www.instagram.com/p/B1g4Eh8ijwp/","https://www.instagram.com/p/CF45-iylHlL/","https://www.instagram.com/p/CF6o_SZhU1P/","https://www.instagram.com/p/CD05svkgdoI/","https://www.instagram.com/p/CEuAlz3pKk4/","https://www.instagram.com/p/CGX9zszJDMv/","https://www.instagram.com/p/CGw14x-hST1/","https://www.instagram.com/p/CGaTbGrgrxB/","https://www.instagram.com/p/CGc-PF0FcPy/","https://www.instagram.com/p/CGFu_vIJOzq/","https://www.instagram.com/p/CGfba0DMBRs/","https://www.instagram.com/p/CFbvDo5jv3z/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP51 = factor(ds$IP51, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-9"), labels=c("https://www.instagram.com/p/CDojJXaDMTm/","https://www.instagram.com/p/CFfcg10I1iz/","https://www.instagram.com/p/CEw1VMRp8eh/","https://www.instagram.com/p/CFe6nGKipf2/","https://www.instagram.com/p/CEejbdUnMyv/","https://www.instagram.com/p/CETROcUHoXr/","https://www.instagram.com/p/CH0AVT6notf/","https://www.instagram.com/p/CFu6YLACRnS/","https://www.instagram.com/p/CGAPYb4swpT/","https://www.instagram.com/p/CF11D-Ggkay/","https://www.instagram.com/p/B0BOG7QiD8n/","https://www.instagram.com/p/Ba15cyxAyAI/","https://www.instagram.com/p/CH7GJo0FNZO/","https://www.instagram.com/p/CG8Hp1gniY8/","https://www.instagram.com/p/CHMxv_5ocqe/","https://www.instagram.com/p/CHU-pLyM0pk/","https://www.instagram.com/p/CHZ2Dcqpf3S/","https://www.instagram.com/p/CDjpp-jnl1p/","https://www.instagram.com/p/CJGJzsUl3dG/","https://www.instagram.com/p/CJtdgPnJHMW/","https://www.instagram.com/p/CDMyx-sFLBx/","https://www.instagram.com/p/B8PEawfoTXa/","https://www.instagram.com/p/CJAhiFXM0Kc/","https://www.instagram.com/p/CJY81CEFRFq/","https://www.instagram.com/p/CJLh0pvhNGt/","https://www.instagram.com/p/CJHhDPEJI3Y/","https://www.instagram.com/p/CJJ-7OSFMbM/","https://www.instagram.com/p/CKT7IYtFiPQ/","https://www.instagram.com/p/CL4Pn9PMFsX/","https://www.instagram.com/p/BpFeSg-AX-K/","https://www.instagram.com/p/CKXGEtjHDyi/","https://www.instagram.com/p/CLpgH8Ahzgw/","https://www.instagram.com/p/CL9l5rmKEsB/","https://www.instagram.com/p/CL9lUYFMx2y/","https://www.instagram.com/p/CJ24NHrLpWM/","https://www.instagram.com/p/CKYtrBhDsLi/","https://www.instagram.com/p/CM_wCEpBIJE/","https://www.instagram.com/p/CMSk_6oBGIB/","https://www.instagram.com/p/CMrVeInBCAD/","https://www.instagram.com/p/CMxLQvHD9dH/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP53 = factor(ds$IP53, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-9"), labels=c("https://www.instagram.com/p/COgBdngnsyh/","https://www.instagram.com/p/COaqw5gMvDS/","https://www.instagram.com/p/COSRE5MDD8E/","https://www.instagram.com/p/COX3k7QMixg/","https://www.instagram.com/p/COOTKwLHvsd/","https://www.instagram.com/p/COOOGorH8cE/","https://www.instagram.com/p/CN2W7AWFEHf/","https://www.instagram.com/p/CNzV8GFhqFl/","https://www.instagram.com/p/CP3KJ1VBuz1/","https://www.instagram.com/p/CPf_Y6Drq6A/","https://www.instagram.com/p/CPa3fyirl5F/","https://www.instagram.com/p/CPVqpwelVWv/","https://www.instagram.com/p/CPRPUhglx2H/","https://www.instagram.com/p/CPL7FT0tQ-y/","https://www.instagram.com/p/CPLllnMDtkk/","https://www.instagram.com/p/CCiw_83IlrZ/","https://www.instagram.com/p/CPASgDxFa-d/","https://www.instagram.com/p/CO5vUkiBPqs/","https://www.instagram.com/p/CB_YtMmqjah/","https://www.instagram.com/p/CQG1WU0seXB/","https://www.instagram.com/p/CQeHJ1lnfGo/","https://www.instagram.com/p/CQd11vknP6r/","https://www.instagram.com/p/CQby1arFNr0/","https://www.instagram.com/p/CQYL_6kMPwD/","https://www.instagram.com/p/CQVtT-Dtufk/","https://www.instagram.com/p/CQTuN1NMLdh/","https://www.instagram.com/p/CQWIc6ugPcb/","https://www.instagram.com/p/CQVgnCdDiqC/","https://www.instagram.com/p/CQRb31ZNrcc/","https://www.instagram.com/p/CQN47JKBcl4/","https://www.instagram.com/p/B_cWlluIVeI/","https://www.instagram.com/p/CQEUYwmp35o/","https://www.instagram.com/p/CQFivfsBg9s/","https://www.instagram.com/p/CQGOTAzhfhW/","https://www.instagram.com/p/CP-pbWhlmrw/","https://www.instagram.com/p/By-n8DhIYMh/","https://www.instagram.com/p/CP6CHMPFvK_/","https://www.instagram.com/p/CPylmNQlqFs/","https://www.instagram.com/p/CPyhTempz4J/","https://www.instagram.com/p/CPxayIZBb7b/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP55 = factor(ds$IP55, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","-9"), labels=c("https://www.instagram.com/p/CPtTEdqnvh4/","https://www.instagram.com/p/BmYMHmsAXjU/","https://www.instagram.com/p/BXDGtCKg9Ky/","https://www.instagram.com/p/BT0UQrglqJ0/","https://www.instagram.com/p/BSeBTgLDNCy/","https://www.instagram.com/p/BPvUz2ADXqc/","https://www.instagram.com/p/BdNZItIF9rI/","https://www.instagram.com/p/Bj2uxekAOAv/","https://www.instagram.com/p/BnG-llSAx4o/","https://www.instagram.com/p/Bo9oARsHzIu/","https://www.instagram.com/p/Bn5hlJ1Bf9q/","https://www.instagram.com/p/BnqUL5XBCIs/","https://www.instagram.com/p/Br-lLIXnDoA/","https://www.instagram.com/p/BtBrbNzAkYk/","https://www.instagram.com/p/Bsv7Nh9hnFM/","https://www.instagram.com/p/BxxqxmCoY-P/","https://www.instagram.com/p/BznfLpAhkRd/","https://www.instagram.com/p/Bz7X95xo3IA/","https://www.instagram.com/p/B0YkTqMC1WB/","https://www.instagram.com/p/B0WECSdC2Cp/","https://www.instagram.com/p/B0xe9viHZHM/","https://www.instagram.com/p/B1d7OWfikXe/","https://www.instagram.com/p/B24EWo4ihK1/","https://www.instagram.com/p/B2UMBPOI4TU/","https://www.instagram.com/p/B6qaxxyo7Ny/","https://www.instagram.com/p/B6oAeTNHgvr/","https://www.instagram.com/p/B7JWWvDCrr0/","https://www.instagram.com/p/B9Ri2GSo_9J/","https://www.instagram.com/p/CDRlimzCvgh/","https://www.instagram.com/p/CDEqq4Tnc-I/","https://www.instagram.com/p/CDazmvaHsrf/","https://www.instagram.com/p/CDisY07lWTd/","https://www.instagram.com/p/CD0tAKQh3wx/","https://www.instagram.com/p/CD1z3fPlkBW/","https://www.instagram.com/p/CEPZ2EEhsXb/","https://www.instagram.com/p/CExEqOsqmxx/","https://www.instagram.com/p/CFUNoGqh2pO/","https://www.instagram.com/p/CFE30fenwab/","https://www.instagram.com/p/CFCc9l1AAEX/","https://www.instagram.com/p/CIJZnGIDiph/","https://www.instagram.com/p/CKI6mqGJy0g/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP17 = factor(ds$IP17, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP01 = factor(ds$IP01, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP11 = factor(ds$IP11, levels=c("1","2","3","4","5","6","7","8","-1","-2","-9"), labels=c("Gruberhof","Praxis des Bergdoktors","Gasthof zum Wilden Kaiser","Krankenhaus","Dorfplatz und Kirche","Apotheke","Hintersteiner See","Sonstiger Drehort","[NA] Es handelt sich um keinen Drehort","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$IP13 = factor(ds$IP13, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP18 = factor(ds$IP18, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-9"), labels=c("https://www.instagram.com/p/B3Zck-PD5ad/","https://www.instagram.com/p/B0OUbGqo9ak/","https://www.instagram.com/p/B_7ZnwFpKou/","https://www.instagram.com/p/B-pEIxgDExJ/","https://www.instagram.com/p/B2T5T-EoCtu/","https://www.instagram.com/p/B1yFtnWg2n6/","https://www.instagram.com/p/B1x7zi-glF6/","https://www.instagram.com/p/ByW-V3hiUnJ/","https://www.instagram.com/p/B_SeQyzlPop/","https://www.instagram.com/p/CE_81ZajsBl/","https://www.instagram.com/p/CF6j8YrioG3/","https://www.instagram.com/p/CGfTbR8lbGo/","https://www.instagram.com/p/CGfP6BTpXvE/","https://www.instagram.com/p/CC-P7UXCLmE/","https://www.instagram.com/p/B-8s-5BD3F0/","https://www.instagram.com/p/CB1GM6HDkXI/","https://www.instagram.com/p/CFcUKeSokQs/","https://www.instagram.com/p/CHTNmfOL0DO/","https://www.instagram.com/p/BcT-rRInqS6/","https://www.instagram.com/p/CI-HxgfDvkr/","https://www.instagram.com/p/CLbnqQJnAP9/","https://www.instagram.com/p/CL3tvA_FR65/","https://www.instagram.com/p/CLUdd57F5fH/","https://www.instagram.com/p/B_kb1i2jkPU/","https://www.instagram.com/p/B-4jOYuDGg6/","https://www.instagram.com/p/CM2RtzuLNg8/","https://www.instagram.com/p/BPyG30ZD0w_/","https://www.instagram.com/p/CDBoRNOD4Vo/","https://www.instagram.com/p/CMpUQEWDY28/","https://www.instagram.com/p/COKthgIDdHU/","https://www.instagram.com/p/CO7PSPZBZgq/","https://www.instagram.com/p/B-6UV9eJaoP/","https://www.instagram.com/p/CBVVx5kDtex/","https://www.instagram.com/p/CPpy6Icjf24/","https://www.instagram.com/p/CFPENxqDrYW/","https://www.instagram.com/p/CPVbII3jG6A/","https://www.instagram.com/p/CPD7AiInoPm/","https://www.instagram.com/p/CO7ukjGqhOP/","https://www.instagram.com/p/COiI-TXjij7/","https://www.instagram.com/p/CQfshXGKl9p/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP57 = factor(ds$IP57, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","-9"), labels=c("https://www.instagram.com/p/B1N_NEOIrTC/","https://www.instagram.com/p/CQeDwZxjHtP/","https://www.instagram.com/p/CQdpS-WFnGs/","https://www.instagram.com/p/CPgb7upD8EJ/","https://www.instagram.com/p/B0nPxD7o4_M/","https://www.instagram.com/p/BX5zQ8Rlsr8/","https://www.instagram.com/p/BSI4VNvh28U/","https://www.instagram.com/p/B2eZibkIQUt/","https://www.instagram.com/p/Bhl5v59gWcR/","https://www.instagram.com/p/BpJXasSlUID/","https://www.instagram.com/p/CIu5ryDD9R-/","https://www.instagram.com/p/B9HlntZD7nH/","https://www.instagram.com/p/BxmNKm-oMAb/","https://www.instagram.com/p/BzdNj_eIfGJ/","https://www.instagram.com/p/B1oZmpRInb8/","https://www.instagram.com/p/B8JslrVjWPd/","https://www.instagram.com/p/CBpaQxvjduP/","https://www.instagram.com/p/CFM6sUuiWbD/","https://www.instagram.com/p/CG9dRXtpGm2/","https://www.instagram.com/p/CT7qYoFs4dW/","https://www.instagram.com/p/Bawl6x9A_zg/","https://www.instagram.com/p/BgOzx1fhkBK/","https://www.instagram.com/p/Bmu3VOdngGL/","https://www.instagram.com/p/CK4nJnIDvRO/","[NA] Not answered"), ordered=FALSE)
ds$IP20 = factor(ds$IP20, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP21 = factor(ds$IP21, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP27 = factor(ds$IP27, levels=c("1","2","-1","-9"), labels=c("Nein","Ja","[NA] Das weiß ich nicht","[NA] Not answered"), ordered=FALSE)
ds$IP30 = factor(ds$IP30, levels=c("1","2","3","4","5","6","7","8","-1","-2","-9"), labels=c("Gruberhof","Praxis des Bergdoktors","Gasthof zum Wilden Kaiser","Krankenhaus","Dorfplatz und Kirche","Apotheke","Hintersteiner See","Sonstiger Drehort","[NA] Es handelt sich um keinen Drehort","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$IP36 = factor(ds$IP36, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","-9"), labels=c("https://www.instagram.com/p/ByNa4kqIbA1/","https://www.instagram.com/p/B6DHTCqqVWz/","https://www.instagram.com/p/B5pSq3lqacN/","https://www.instagram.com/p/B2hKcoKo8Xw/","https://www.instagram.com/p/B2-4ikLIl_0/","https://www.instagram.com/p/B4ufApKHwT8/","https://www.instagram.com/p/B60fi04CiYY/","https://www.instagram.com/p/BcR1NmcBszr/","https://www.instagram.com/p/B21vwZTgrz0/","https://www.instagram.com/p/B0ffl-IIXAR/","https://www.instagram.com/p/B75_hw5K9JK/","https://www.instagram.com/p/CAAy_nngU0Z/","https://www.instagram.com/p/CDBVbEeIgAc/","https://www.instagram.com/p/B0qm_6TqYuE/","https://www.instagram.com/p/CHf5PCIJpY6/","https://www.instagram.com/p/CPz3dg_hMEN/","https://www.instagram.com/p/B7tVP4nq93K/","https://www.instagram.com/p/CQbqMf9BfZI/","https://www.instagram.com/p/CQY7iJDppAE/","https://www.instagram.com/p/BaB-eZsAv2P/","https://www.instagram.com/p/BPKdHilgSzR/","https://www.instagram.com/p/BfRDa4wA9Qt/","https://www.instagram.com/p/BfbE103BH2r/","https://www.instagram.com/p/BkXyzKwhp-5/","https://www.instagram.com/p/BocCgEFBTLg/","https://www.instagram.com/p/BrnI1RBAybf/","https://www.instagram.com/p/B8hGINUpfsp/","https://www.instagram.com/p/CT7qYoFs4dW/","[NA] Not answered"), ordered=FALSE)
ds$IP38 = factor(ds$IP38, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IP39 = factor(ds$IP39, levels=c("1","2","-9"), labels=c("Ja","Nein","[NA] Not answered"), ordered=FALSE)
ds$IP44 = factor(ds$IP44, levels=c("1","2","-1","-9"), labels=c("Ja","Nein","[NA] Das weiß ich nicht","[NA] Not answered"), ordered=FALSE)
ds$IP47 = factor(ds$IP47, levels=c("1","2","3","4","5","6","7","8","-1","-2","-9"), labels=c("Gruberhof","Praxis des Bergdoktors","Gasthof zum Wilden Kaiser","Krankenhaus","Dorfplatz und Kirche","Apotheke","Hintersteiner See","Sonstiger Drehort","[NA] Es handelt sich um keinen Drehort","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$IP49 = factor(ds$IP49, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IT04 = factor(ds$IT04, levels=c("1","2","3","4","5","-9"), labels=c("Bisher kein Fantag","1 Fantag","2 Fantage","Mehr als 3 Fantage","3 Fantage","[NA] Not answered"), ordered=FALSE)
ds$IT07 = factor(ds$IT07, levels=c("1","2","3","-9"), labels=c("Die Serie \'Der Bergdoktor\' war kein Grund an den Wilden Kaiser zu reisen.","Die Serie \'Der Bergdoktor\' war ein Grund von vielen an den Wilden Kaiser zu reisen.","Die Serie \'Der Bergdoktor\' war der Hauptgrund an den Wilden Kaiser zu reisen.","[NA] Not answered"), ordered=FALSE)
ds$IT09 = factor(ds$IT09, levels=c("1","2","3","4","5","6","-9"), labels=c("Ich habe erst im Nachhinein verstanden, dass es ein Drehort war.","Ich bin zufällig dran vorbeigelaufen.","Ich habe sie gezielt aufgesucht.","Es war Teil einer geführten Tour.","Ein anderer Grund:","Meine Reisebgleitung hat mich hingeführt.","[NA] Not answered"), ordered=FALSE)
ds$IT13 = factor(ds$IT13, levels=c("1","2","3","4","5","6","-9"), labels=c("1 mal","2 mal","3 mal","4 mal","Mehr als 4 mal","Kein mal","[NA] Not answered"), ordered=FALSE)
ds$IT14 = factor(ds$IT14, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$IT16 = factor(ds$IT16, levels=c("1","2","3","-9"), labels=c("Die Bergdoktor-Filmtouristen an den Wilden Kaiser.","Die Vermarktung des Wilden Kaiser als Bergdoktor-Drehstandort.","Vermarktung und Filmtouristen kamen ungefähr zur gleichen Zeit.","[NA] Not answered"), ordered=FALSE)
ds$IT17 = factor(ds$IT17, levels=c("1","2","-9"), labels=c("Nein","Ja","[NA] Not answered"), ordered=FALSE)
ds$SO02 = factor(ds$SO02, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-2","-9"), labels=c("astrid_marschall_","run_munich_run","littlenibbles.bigbites","pianthr","its_l_i_s_i__","simon_stosic","piecesofmara","ingoanderbruegge","landgefluestermomente","mutausbrueche","dachshund_rex_bence","freizeitundnatur","schwemmbotz1963","_lein.picture","akobinger","bavariatommy","binaa_2004","carolinmarie1988","chriswi50","da_momentnsammler","danzikathy","heiketilli01","i_am_frank_my_life_experiences","jochen1077","juli__a1","kathrin__a","langstrumpfpipilottaviktualia","mathidaniela","mein_augen_blick","nic.schr81","nikol_1980_","nscho_tschi87","reiseprofi_c_now_at_home","sandra.biever","seefahrer2805","smntel","susanne_ortmann_photographie","theri.geser","veronikaneumaier","jackbauer2411","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO10 = factor(ds$SO10, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-2","-9"), labels=c("jen_kay_21","judithsworldthings","parejnagy","richteruschi","viktorialeitner","katka.buk","henter_nina_","imhof.peter2018","isaa___s","jesserich82","laura.bstern","marcus.heinzmann","marion.stadler76","nicki_janosch","sabrina.haake","sz_muc","varga.erzsike","victoria_goebl","austrian_paramedic","berge_meere_waelder","bommelcologne","curly_sue_1601","fsefoxy","indijana.jones","jakobvanlife","jmk23812","narlas_ww_welt","al0ne_photographie","b.e.r.n.d_c.o.c.o.s","berg_maedl","di_ana_s_16.10","ginale_mountain","holgers_videotreff","motyka33","mountainlionheart","urlaubs.knipser","alex_kausche_","brini.a.kiwi","daniel.hebding","munich17germany","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO11 = factor(ds$SO11, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-2","-9"), labels=c("moin_ole","travelling_world3","run.to.the._hills","nice.places.to.visit","missmcwood","blickpunkt_lichtbildmanufaktur","nadudvariferi","angie_fekete","judithsnaturethings","angeladezeeuw","marty.official92","franzislifestyle","tante_annie","susanne.fiedler_dirmitmk","jenner76de","derdoktorundderberg","rainer.spies","hanskerrie","anja_nie","lavendelduft","frank__pohl","kene_1971","chris_v____","chrissiob","toni_lastra","kathringul","nxthx","eggetsberger","_magdii_lenii_","peko_muc","desiretotravel23","frau_kleinods_welt","piggy_kermitontour","navizwerg","mel_la80","langikati09","jasmin.stine","schwabenmom","tatjana181078","manuelmay1801","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO12 = factor(ds$SO12, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","-2","-9"), labels=c("_.official._kiki","clemensunterreiner","beccibmx","lady_50plus","horst_falk","frankstoehr_fotografie","be_abell","andreaackermann_","clautzkie310169","schoenwild","katjadinkel","katharina_muck","ueberbach.dirk","wellspaportal","munichmountaingirls","meiermarilyn","chrissilgr","thorschafer","sindyhoehne","lodge1968","roberta.bieling","d.foto.s__","narlas_welt","kathrintarricone","chrisfan3","a_n_d_r_e_a_insta","salupics_","trishi089","torben_klein_official","reisebuerotussi","thomasboecher","jurgensodl","1980_angelus","tanja_bogner","bonfireworker","simone__musial","julesworld_1.0","jfrljak","dietmar71er","laras.littleworld","infreierwildbahn","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO06 = factor(ds$SO06, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","-2","-9"), labels=c("das_kaiserblick","stanglwirt","bodenseecampus","koasamandl","skiweltwilderkaiserbrixental","stadttheater_klagenfurt","visittirol","visitaustria","wilder.kaiser","auwirt_aurach","mehr_reith","tirolerstyle","bwf_gstrein_michaela","green_kitz","hotel_garni_tirol","jodlhof","schatzkiste_scharfenbaum","hannisenfter","hotel.hochfilzer","zefi.immobilien","beautifultyrol","post.alte","wohnblogat","cafe_beim_schuster","fbh.niedermuehlbichler","fokusncyan","landhaus_strasser","pensionhartkaiser","sojerhof","_hagenhof_","hubenhof","immobilien_raiffeisen_going","hotelderbaer","regalm_harassen_jaegerhof","hotel_leitenhof","bergsportprofis","bezirk.salzburg","sport_hotel_ellmau","landhof_ellmau","bergundradl","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO13 = factor(ds$SO13, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","-2","-9"), labels=c("brantlhof","hinterholzer_appartements","bergdoktorhaus","zirbenecke.at","kraeuterrebellen_suedtirol","alpegg_chalets","wsg_swarovski_tirol","vitalhotelsonnenhof","peterfalksports","discoveraustria","memoryellmau","hotel.greil","kitzbuehelerbergfuehrer","going_aaa_apartment","cumlaudeimmobilia","tirol_lodge","enzianmark","tyrol.hotel","engelvoelkerstirol","1A_testxy","scherm_air","topskischule","hexenwasser","[NA] other text response","[NA] Not answered"), ordered=FALSE)
ds$SO09 = factor(ds$SO09, levels=c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","-2","-9"), labels=c("mrsmalich","lennartbetzgen","natalieohara_official","oliver_bender","rebeccaimmanuel.official","ronjaforcher","simon.boer","simonehanselmann","zdfmediathek","andreagerhard_tall_area","orf","lilianezillner","thedanielerizzo","markkeller_official","claudiaploeckl","sigl_hans","claudia.wenzel.official","petrageissler712","davidlindermeier","nicolebeutler_official","benbraun.official","benblaskovic","sinatkotsch","leoniebrill_official","angelaroyactress_official","yekaterina.nesytowa","schlag_agentur","1A_testxy","[NA] other text response","[NA] Not answered"), ordered=FALSE)
attr(ds$DE03_01,"1") = "Rank 1"
attr(ds$DE03_01,"2") = "Rank 2"
attr(ds$DE03_01,"3") = "Rank 3"
attr(ds$DE03_01,"4") = "Rank 4"
attr(ds$DE03_01,"5") = "Rank 5"
attr(ds$DE03_01,"6") = "Rank 6"
attr(ds$DE03_01,"7") = "Rank 7"
attr(ds$DE03_01,"8") = "Rank 8"
attr(ds$DE03_02,"1") = "Rank 1"
attr(ds$DE03_02,"2") = "Rank 2"
attr(ds$DE03_02,"3") = "Rank 3"
attr(ds$DE03_02,"4") = "Rank 4"
attr(ds$DE03_02,"5") = "Rank 5"
attr(ds$DE03_02,"6") = "Rank 6"
attr(ds$DE03_02,"7") = "Rank 7"
attr(ds$DE03_02,"8") = "Rank 8"
attr(ds$DE03_03,"1") = "Rank 1"
attr(ds$DE03_03,"2") = "Rank 2"
attr(ds$DE03_03,"3") = "Rank 3"
attr(ds$DE03_03,"4") = "Rank 4"
attr(ds$DE03_03,"5") = "Rank 5"
attr(ds$DE03_03,"6") = "Rank 6"
attr(ds$DE03_03,"7") = "Rank 7"
attr(ds$DE03_03,"8") = "Rank 8"
attr(ds$DE03_04,"1") = "Rank 1"
attr(ds$DE03_04,"2") = "Rank 2"
attr(ds$DE03_04,"3") = "Rank 3"
attr(ds$DE03_04,"4") = "Rank 4"
attr(ds$DE03_04,"5") = "Rank 5"
attr(ds$DE03_04,"6") = "Rank 6"
attr(ds$DE03_04,"7") = "Rank 7"
attr(ds$DE03_04,"8") = "Rank 8"
attr(ds$DE03_05,"1") = "Rank 1"
attr(ds$DE03_05,"2") = "Rank 2"
attr(ds$DE03_05,"3") = "Rank 3"
attr(ds$DE03_05,"4") = "Rank 4"
attr(ds$DE03_05,"5") = "Rank 5"
attr(ds$DE03_05,"6") = "Rank 6"
attr(ds$DE03_05,"7") = "Rank 7"
attr(ds$DE03_05,"8") = "Rank 8"
attr(ds$DE03_06,"1") = "Rank 1"
attr(ds$DE03_06,"2") = "Rank 2"
attr(ds$DE03_06,"3") = "Rank 3"
attr(ds$DE03_06,"4") = "Rank 4"
attr(ds$DE03_06,"5") = "Rank 5"
attr(ds$DE03_06,"6") = "Rank 6"
attr(ds$DE03_06,"7") = "Rank 7"
attr(ds$DE03_06,"8") = "Rank 8"
attr(ds$DE03_07,"1") = "Rank 1"
attr(ds$DE03_07,"2") = "Rank 2"
attr(ds$DE03_07,"3") = "Rank 3"
attr(ds$DE03_07,"4") = "Rank 4"
attr(ds$DE03_07,"5") = "Rank 5"
attr(ds$DE03_07,"6") = "Rank 6"
attr(ds$DE03_07,"7") = "Rank 7"
attr(ds$DE03_07,"8") = "Rank 8"
attr(ds$DE03_08,"1") = "Rank 1"
attr(ds$DE03_08,"2") = "Rank 2"
attr(ds$DE03_08,"3") = "Rank 3"
attr(ds$DE03_08,"4") = "Rank 4"
attr(ds$DE03_08,"5") = "Rank 5"
attr(ds$DE03_08,"6") = "Rank 6"
attr(ds$DE03_08,"7") = "Rank 7"
attr(ds$DE03_08,"8") = "Rank 8"
attr(ds$DE14,"-1") = "Das kann ich nicht beantworten"
attr(ds$DE14_01,"F") = "Not checked"
attr(ds$DE14_01,"T") = "Checked"
attr(ds$DE14_02,"F") = "Not checked"
attr(ds$DE14_02,"T") = "Checked"
attr(ds$DE14_03,"F") = "Not checked"
attr(ds$DE14_03,"T") = "Checked"
attr(ds$DE14_04,"F") = "Not checked"
attr(ds$DE14_04,"T") = "Checked"
attr(ds$DE14_05,"F") = "Not checked"
attr(ds$DE14_05,"T") = "Checked"
attr(ds$DE14_06,"F") = "Not checked"
attr(ds$DE14_06,"T") = "Checked"
attr(ds$DE14_07,"F") = "Not checked"
attr(ds$DE14_07,"T") = "Checked"
attr(ds$DE14_08,"F") = "Not checked"
attr(ds$DE14_08,"T") = "Checked"
attr(ds$DE14_09,"F") = "Not checked"
attr(ds$DE14_09,"T") = "Checked"
attr(ds$DE15_01,"1") = "Individualreisen"
attr(ds$DE15_01,"101") = "Veranstalterreisen"
attr(ds$DE15_02,"1") = "Exklusivtourismus"
attr(ds$DE15_02,"101") = "Massentourismus"
attr(ds$DE15_03,"1") = "Fremdenverkehr"
attr(ds$DE15_03,"101") = "Binnentourismus"
attr(ds$DE16,"-1") = "Das kann ich nicht beantworten"
attr(ds$DE16_01,"F") = "Not checked"
attr(ds$DE16_01,"T") = "Checked"
attr(ds$DE16_02,"F") = "Not checked"
attr(ds$DE16_02,"T") = "Checked"
attr(ds$DE16_03,"F") = "Not checked"
attr(ds$DE16_03,"T") = "Checked"
attr(ds$DE16_04,"F") = "Not checked"
attr(ds$DE16_04,"T") = "Checked"
attr(ds$DE16_05,"F") = "Not checked"
attr(ds$DE16_05,"T") = "Checked"
attr(ds$DE16_06,"F") = "Not checked"
attr(ds$DE16_06,"T") = "Checked"
attr(ds$DE16_07,"F") = "Not checked"
attr(ds$DE16_07,"T") = "Checked"
attr(ds$DE16_08,"F") = "Not checked"
attr(ds$DE16_08,"T") = "Checked"
attr(ds$EI01,"-1") = "Ich weiß es nicht"
attr(ds$EI01_01,"F") = "Not checked"
attr(ds$EI01_01,"T") = "Checked"
attr(ds$EI01_02,"F") = "Not checked"
attr(ds$EI01_02,"T") = "Checked"
attr(ds$EI01_03,"F") = "Not checked"
attr(ds$EI01_03,"T") = "Checked"
attr(ds$EI01_04,"F") = "Not checked"
attr(ds$EI01_04,"T") = "Checked"
attr(ds$EI01_05,"F") = "Not checked"
attr(ds$EI01_05,"T") = "Checked"
attr(ds$EI01_06,"F") = "Not checked"
attr(ds$EI01_06,"T") = "Checked"
attr(ds$EI01_07,"F") = "Not checked"
attr(ds$EI01_07,"T") = "Checked"
attr(ds$EI01_08,"F") = "Not checked"
attr(ds$EI01_08,"T") = "Checked"
attr(ds$EI01_09,"F") = "Not checked"
attr(ds$EI01_09,"T") = "Checked"
attr(ds$EI01_10,"F") = "Not checked"
attr(ds$EI01_10,"T") = "Checked"
attr(ds$EI01_11,"F") = "Not checked"
attr(ds$EI01_11,"T") = "Checked"
attr(ds$EI01_12,"F") = "Not checked"
attr(ds$EI01_12,"T") = "Checked"
attr(ds$EI01_13,"F") = "Not checked"
attr(ds$EI01_13,"T") = "Checked"
attr(ds$EI01_14,"F") = "Not checked"
attr(ds$EI01_14,"T") = "Checked"
attr(ds$EI01_15,"F") = "Not checked"
attr(ds$EI01_15,"T") = "Checked"
attr(ds$EI01_16,"F") = "Not checked"
attr(ds$EI01_16,"T") = "Checked"
attr(ds$EI02_01,"1") = "gar kein Fan"
attr(ds$EI02_01,"101") = "großer Fan"
attr(ds$EI03_01,"1") = "Nein"
attr(ds$EI03_01,"2") = "Ja"
attr(ds$EI05_01,"1") = "gar nicht"
attr(ds$EI05_01,"5") = "sehr viel"
attr(ds$EI05_02,"1") = "gar nicht"
attr(ds$EI05_02,"5") = "sehr viel"
attr(ds$EI05_03,"1") = "gar nicht"
attr(ds$EI05_03,"5") = "sehr viel"
attr(ds$EI05_04,"1") = "gar nicht"
attr(ds$EI05_04,"5") = "sehr viel"
attr(ds$EI05_05,"1") = "gar nicht"
attr(ds$EI05_05,"5") = "sehr viel"
attr(ds$EI05_06,"1") = "gar nicht"
attr(ds$EI05_06,"5") = "sehr viel"
attr(ds$EI05_07,"1") = "gar nicht"
attr(ds$EI05_07,"5") = "sehr viel"
attr(ds$EI05_08,"1") = "gar nicht"
attr(ds$EI05_08,"5") = "sehr viel"
attr(ds$EI05_09,"1") = "gar nicht"
attr(ds$EI05_09,"5") = "sehr viel"
attr(ds$EI05_10,"1") = "gar nicht"
attr(ds$EI05_10,"5") = "sehr viel"
attr(ds$EI08_01,"1") = "gar nicht"
attr(ds$EI08_01,"5") = "sehr"
attr(ds$EI08_02,"1") = "gar nicht"
attr(ds$EI08_02,"5") = "sehr"
attr(ds$EI08_03,"1") = "gar nicht"
attr(ds$EI08_03,"5") = "sehr"
attr(ds$EI08_04,"1") = "gar nicht"
attr(ds$EI08_04,"5") = "sehr"
attr(ds$EI08_05,"1") = "gar nicht"
attr(ds$EI08_05,"5") = "sehr"
attr(ds$EI08_06,"1") = "gar nicht"
attr(ds$EI08_06,"5") = "sehr"
attr(ds$EI10_01,"1") = "gar nicht"
attr(ds$EI10_01,"5") = "sehr"
attr(ds$EI10_02,"1") = "gar nicht"
attr(ds$EI10_02,"5") = "sehr"
attr(ds$EI10_03,"1") = "gar nicht"
attr(ds$EI10_03,"5") = "sehr"
attr(ds$EI10_04,"1") = "gar nicht"
attr(ds$EI10_04,"5") = "sehr"
attr(ds$EI10_05,"1") = "gar nicht"
attr(ds$EI10_05,"5") = "sehr"
attr(ds$EI10_06,"1") = "gar nicht"
attr(ds$EI10_06,"5") = "sehr"
attr(ds$IP14_01,"1") = "Nein"
attr(ds$IP14_01,"2") = "Ja"
attr(ds$IP14_09,"1") = "Nein"
attr(ds$IP14_09,"2") = "Ja"
attr(ds$IP14_29,"1") = "Nein"
attr(ds$IP14_29,"2") = "Ja"
attr(ds$IP14_30,"1") = "Nein"
attr(ds$IP14_30,"2") = "Ja"
attr(ds$IP14_33,"1") = "Nein"
attr(ds$IP14_33,"2") = "Ja"
attr(ds$IP14_35,"1") = "Nein"
attr(ds$IP14_35,"2") = "Ja"
attr(ds$IP14_38,"1") = "Nein"
attr(ds$IP14_38,"2") = "Ja"
attr(ds$IP52_10,"1") = "Nein"
attr(ds$IP52_10,"2") = "Ja"
attr(ds$IP52_13,"1") = "Nein"
attr(ds$IP52_13,"2") = "Ja"
attr(ds$IP52_16,"1") = "Nein"
attr(ds$IP52_16,"2") = "Ja"
attr(ds$IP52_26,"1") = "Nein"
attr(ds$IP52_26,"2") = "Ja"
attr(ds$IP52_32,"1") = "Nein"
attr(ds$IP52_32,"2") = "Ja"
attr(ds$IP52_33,"1") = "Nein"
attr(ds$IP52_33,"2") = "Ja"
attr(ds$IP54_07,"1") = "Nein"
attr(ds$IP54_07,"2") = "Ja"
attr(ds$IP54_19,"1") = "Nein"
attr(ds$IP54_19,"2") = "Ja"
attr(ds$IP54_26,"1") = "Nein"
attr(ds$IP54_26,"2") = "Ja"
attr(ds$IP56_01,"1") = "Nein"
attr(ds$IP56_01,"2") = "Ja"
attr(ds$IP56_05,"1") = "Nein"
attr(ds$IP56_05,"2") = "Ja"
attr(ds$IP56_10,"1") = "Nein"
attr(ds$IP56_10,"2") = "Ja"
attr(ds$IP56_11,"1") = "Nein"
attr(ds$IP56_11,"2") = "Ja"
attr(ds$IP56_18,"1") = "Nein"
attr(ds$IP56_18,"2") = "Ja"
attr(ds$IP56_23,"1") = "Nein"
attr(ds$IP56_23,"2") = "Ja"
attr(ds$IP56_28,"1") = "Nein"
attr(ds$IP56_28,"2") = "Ja"
attr(ds$IP56_33,"1") = "Nein"
attr(ds$IP56_33,"2") = "Ja"
attr(ds$IP19_04,"1") = "Nein"
attr(ds$IP19_04,"2") = "Ja"
attr(ds$IP19_09,"1") = "Nein"
attr(ds$IP19_09,"2") = "Ja"
attr(ds$IP19_10,"1") = "Nein"
attr(ds$IP19_10,"2") = "Ja"
attr(ds$IP19_16,"1") = "Nein"
attr(ds$IP19_16,"2") = "Ja"
attr(ds$IP58_02,"1") = "Nein"
attr(ds$IP58_02,"2") = "Ja"
attr(ds$IP58_23,"1") = "Nein"
attr(ds$IP58_23,"2") = "Ja"
attr(ds$IP32_01,"1") = "wie vorgefunden"
attr(ds$IP32_01,"101") = "stark verändert"
attr(ds$IP37_19,"1") = "Ja"
attr(ds$IP37_19,"2") = "Nein"
attr(ds$IP50_01,"1") = "wie vorgefunden"
attr(ds$IP50_01,"101") = "stark verändert"
attr(ds$IT01_01,"1") = "trifft nicht zu"
attr(ds$IT01_01,"5") = "trifft vollständig zu"
attr(ds$IT01_02,"1") = "trifft nicht zu"
attr(ds$IT01_02,"5") = "trifft vollständig zu"
attr(ds$IT01_03,"1") = "trifft nicht zu"
attr(ds$IT01_03,"5") = "trifft vollständig zu"
attr(ds$IT01_04,"1") = "trifft nicht zu"
attr(ds$IT01_04,"5") = "trifft vollständig zu"
attr(ds$IT01_05,"1") = "trifft nicht zu"
attr(ds$IT01_05,"5") = "trifft vollständig zu"
attr(ds$IT01_06,"1") = "trifft nicht zu"
attr(ds$IT01_06,"5") = "trifft vollständig zu"
attr(ds$IT02_01,"1") = "nicht beeinflusst"
attr(ds$IT02_01,"5") = "stark beeinflusst"
attr(ds$IT02_02,"1") = "nicht beeinflusst"
attr(ds$IT02_02,"5") = "stark beeinflusst"
attr(ds$IT02_03,"1") = "nicht beeinflusst"
attr(ds$IT02_03,"5") = "stark beeinflusst"
attr(ds$IT03_01,"1") = "trifft nicht zu"
attr(ds$IT03_01,"5") = "trifft vollständig zu"
attr(ds$IT03_02,"1") = "trifft nicht zu"
attr(ds$IT03_02,"5") = "trifft vollständig zu"
attr(ds$IT03_03,"1") = "trifft nicht zu"
attr(ds$IT03_03,"5") = "trifft vollständig zu"
attr(ds$IT03_04,"1") = "trifft nicht zu"
attr(ds$IT03_04,"5") = "trifft vollständig zu"
attr(ds$IT08_01,"1") = "trifft nicht zu"
attr(ds$IT08_01,"5") = "trifft vollständig zu"
attr(ds$IT08_02,"1") = "trifft nicht zu"
attr(ds$IT08_02,"5") = "trifft vollständig zu"
attr(ds$IT08_03,"1") = "trifft nicht zu"
attr(ds$IT08_03,"5") = "trifft vollständig zu"
attr(ds$IT08_04,"1") = "trifft nicht zu"
attr(ds$IT08_04,"5") = "trifft vollständig zu"
attr(ds$IT08_05,"1") = "trifft nicht zu"
attr(ds$IT08_05,"5") = "trifft vollständig zu"
attr(ds$IT08_06,"1") = "trifft nicht zu"
attr(ds$IT08_06,"5") = "trifft vollständig zu"
attr(ds$IT08_07,"1") = "trifft nicht zu"
attr(ds$IT08_07,"5") = "trifft vollständig zu"
attr(ds$IT08_08,"1") = "trifft nicht zu"
attr(ds$IT08_08,"5") = "trifft vollständig zu"
attr(ds$IT08_09,"1") = "trifft nicht zu"
attr(ds$IT08_09,"5") = "trifft vollständig zu"
attr(ds$IT08_10,"1") = "trifft nicht zu"
attr(ds$IT08_10,"5") = "trifft vollständig zu"
attr(ds$IT08_11,"1") = "trifft nicht zu"
attr(ds$IT08_11,"5") = "trifft vollständig zu"
attr(ds$IT10_01,"1") = "Rank 1"
attr(ds$IT10_01,"2") = "Rank 2"
attr(ds$IT10_01,"3") = "Rank 3"
attr(ds$IT10_01,"4") = "Rank 4"
attr(ds$IT10_01,"5") = "Rank 5"
attr(ds$IT10_01,"6") = "Rank 6"
attr(ds$IT10_01,"7") = "Rank 7"
attr(ds$IT10_02,"1") = "Rank 1"
attr(ds$IT10_02,"2") = "Rank 2"
attr(ds$IT10_02,"3") = "Rank 3"
attr(ds$IT10_02,"4") = "Rank 4"
attr(ds$IT10_02,"5") = "Rank 5"
attr(ds$IT10_02,"6") = "Rank 6"
attr(ds$IT10_02,"7") = "Rank 7"
attr(ds$IT10_03,"1") = "Rank 1"
attr(ds$IT10_03,"2") = "Rank 2"
attr(ds$IT10_03,"3") = "Rank 3"
attr(ds$IT10_03,"4") = "Rank 4"
attr(ds$IT10_03,"5") = "Rank 5"
attr(ds$IT10_03,"6") = "Rank 6"
attr(ds$IT10_03,"7") = "Rank 7"
attr(ds$IT10_04,"1") = "Rank 1"
attr(ds$IT10_04,"2") = "Rank 2"
attr(ds$IT10_04,"3") = "Rank 3"
attr(ds$IT10_04,"4") = "Rank 4"
attr(ds$IT10_04,"5") = "Rank 5"
attr(ds$IT10_04,"6") = "Rank 6"
attr(ds$IT10_04,"7") = "Rank 7"
attr(ds$IT10_05,"1") = "Rank 1"
attr(ds$IT10_05,"2") = "Rank 2"
attr(ds$IT10_05,"3") = "Rank 3"
attr(ds$IT10_05,"4") = "Rank 4"
attr(ds$IT10_05,"5") = "Rank 5"
attr(ds$IT10_05,"6") = "Rank 6"
attr(ds$IT10_05,"7") = "Rank 7"
attr(ds$IT10_06,"1") = "Rank 1"
attr(ds$IT10_06,"2") = "Rank 2"
attr(ds$IT10_06,"3") = "Rank 3"
attr(ds$IT10_06,"4") = "Rank 4"
attr(ds$IT10_06,"5") = "Rank 5"
attr(ds$IT10_06,"6") = "Rank 6"
attr(ds$IT10_06,"7") = "Rank 7"
attr(ds$IT10_07,"1") = "Rank 1"
attr(ds$IT10_07,"2") = "Rank 2"
attr(ds$IT10_07,"3") = "Rank 3"
attr(ds$IT10_07,"4") = "Rank 4"
attr(ds$IT10_07,"5") = "Rank 5"
attr(ds$IT10_07,"6") = "Rank 6"
attr(ds$IT10_07,"7") = "Rank 7"
attr(ds$IT15_01,"1") = "keine Nähe"
attr(ds$IT15_01,"101") = "sehr nahe"
attr(ds$IT15_02,"1") = "keine Nähe"
attr(ds$IT15_02,"101") = "sehr nahe"
attr(ds$IT15_03,"1") = "keine Nähe"
attr(ds$IT15_03,"101") = "sehr nahe"
attr(ds$IT15_04,"1") = "keine Nähe"
attr(ds$IT15_04,"101") = "sehr nahe"
attr(ds$IT15_05,"1") = "keine Nähe"
attr(ds$IT15_05,"101") = "sehr nahe"
attr(ds$IT15_06,"1") = "keine Nähe"
attr(ds$IT15_06,"101") = "sehr nahe"
attr(ds$IT15_07,"1") = "keine Nähe"
attr(ds$IT15_07,"101") = "sehr nahe"
attr(ds$IT19_01,"1") = "keinerlei Annäherung"
attr(ds$IT19_01,"101") = "starke Annäherung"
attr(ds$IT19_02,"1") = "keinerlei Annäherung"
attr(ds$IT19_02,"101") = "starke Annäherung"
attr(ds$IT19_03,"1") = "keinerlei Annäherung"
attr(ds$IT19_03,"101") = "starke Annäherung"
attr(ds$IT19_04,"1") = "keinerlei Annäherung"
attr(ds$IT19_04,"101") = "starke Annäherung"
attr(ds$IT19_05,"1") = "keinerlei Annäherung"
attr(ds$IT19_05,"101") = "starke Annäherung"
attr(ds$IT19_06,"1") = "keinerlei Annäherung"
attr(ds$IT19_06,"101") = "starke Annäherung"
attr(ds$IT20_01,"F") = "Not checked"
attr(ds$IT20_01,"T") = "Checked"
attr(ds$IT20_02,"F") = "Not checked"
attr(ds$IT20_02,"T") = "Checked"
attr(ds$IT20_03,"F") = "Not checked"
attr(ds$IT20_03,"T") = "Checked"
attr(ds$IT20_04,"F") = "Not checked"
attr(ds$IT20_04,"T") = "Checked"
attr(ds$IT21_01,"1") = "Nein"
attr(ds$IT21_01,"2") = "Ja"
attr(ds$IT21_02,"1") = "Nein"
attr(ds$IT21_02,"2") = "Ja"
attr(ds$IT22_01,"1") = "gar nicht"
attr(ds$IT22_01,"101") = "sehr stark"
attr(ds$IT24_01,"1") = "Rank 1"
attr(ds$IT24_01,"2") = "Rank 2"
attr(ds$IT24_01,"3") = "Rank 3"
attr(ds$IT24_01,"4") = "Rank 4"
attr(ds$IT24_01,"5") = "Rank 5"
attr(ds$IT24_01,"6") = "Rank 6"
attr(ds$IT24_01,"7") = "Rank 7"
attr(ds$IT24_02,"1") = "Rank 1"
attr(ds$IT24_02,"2") = "Rank 2"
attr(ds$IT24_02,"3") = "Rank 3"
attr(ds$IT24_02,"4") = "Rank 4"
attr(ds$IT24_02,"5") = "Rank 5"
attr(ds$IT24_02,"6") = "Rank 6"
attr(ds$IT24_02,"7") = "Rank 7"
attr(ds$IT24_03,"1") = "Rank 1"
attr(ds$IT24_03,"2") = "Rank 2"
attr(ds$IT24_03,"3") = "Rank 3"
attr(ds$IT24_03,"4") = "Rank 4"
attr(ds$IT24_03,"5") = "Rank 5"
attr(ds$IT24_03,"6") = "Rank 6"
attr(ds$IT24_03,"7") = "Rank 7"
attr(ds$IT24_04,"1") = "Rank 1"
attr(ds$IT24_04,"2") = "Rank 2"
attr(ds$IT24_04,"3") = "Rank 3"
attr(ds$IT24_04,"4") = "Rank 4"
attr(ds$IT24_04,"5") = "Rank 5"
attr(ds$IT24_04,"6") = "Rank 6"
attr(ds$IT24_04,"7") = "Rank 7"
attr(ds$IT24_05,"1") = "Rank 1"
attr(ds$IT24_05,"2") = "Rank 2"
attr(ds$IT24_05,"3") = "Rank 3"
attr(ds$IT24_05,"4") = "Rank 4"
attr(ds$IT24_05,"5") = "Rank 5"
attr(ds$IT24_05,"6") = "Rank 6"
attr(ds$IT24_05,"7") = "Rank 7"
attr(ds$IT24_06,"1") = "Rank 1"
attr(ds$IT24_06,"2") = "Rank 2"
attr(ds$IT24_06,"3") = "Rank 3"
attr(ds$IT24_06,"4") = "Rank 4"
attr(ds$IT24_06,"5") = "Rank 5"
attr(ds$IT24_06,"6") = "Rank 6"
attr(ds$IT24_06,"7") = "Rank 7"
attr(ds$IT24_07,"1") = "Rank 1"
attr(ds$IT24_07,"2") = "Rank 2"
attr(ds$IT24_07,"3") = "Rank 3"
attr(ds$IT24_07,"4") = "Rank 4"
attr(ds$IT24_07,"5") = "Rank 5"
attr(ds$IT24_07,"6") = "Rank 6"
attr(ds$IT24_07,"7") = "Rank 7"
attr(ds$IT25_01,"1") = "Rank 1"
attr(ds$IT25_01,"2") = "Rank 2"
attr(ds$IT25_01,"3") = "Rank 3"
attr(ds$IT25_01,"4") = "Rank 4"
attr(ds$IT25_01,"5") = "Rank 5"
attr(ds$IT25_01,"6") = "Rank 6"
attr(ds$IT25_01,"7") = "Rank 7"
attr(ds$IT25_02,"1") = "Rank 1"
attr(ds$IT25_02,"2") = "Rank 2"
attr(ds$IT25_02,"3") = "Rank 3"
attr(ds$IT25_02,"4") = "Rank 4"
attr(ds$IT25_02,"5") = "Rank 5"
attr(ds$IT25_02,"6") = "Rank 6"
attr(ds$IT25_02,"7") = "Rank 7"
attr(ds$IT25_03,"1") = "Rank 1"
attr(ds$IT25_03,"2") = "Rank 2"
attr(ds$IT25_03,"3") = "Rank 3"
attr(ds$IT25_03,"4") = "Rank 4"
attr(ds$IT25_03,"5") = "Rank 5"
attr(ds$IT25_03,"6") = "Rank 6"
attr(ds$IT25_03,"7") = "Rank 7"
attr(ds$IT25_04,"1") = "Rank 1"
attr(ds$IT25_04,"2") = "Rank 2"
attr(ds$IT25_04,"3") = "Rank 3"
attr(ds$IT25_04,"4") = "Rank 4"
attr(ds$IT25_04,"5") = "Rank 5"
attr(ds$IT25_04,"6") = "Rank 6"
attr(ds$IT25_04,"7") = "Rank 7"
attr(ds$IT25_05,"1") = "Rank 1"
attr(ds$IT25_05,"2") = "Rank 2"
attr(ds$IT25_05,"3") = "Rank 3"
attr(ds$IT25_05,"4") = "Rank 4"
attr(ds$IT25_05,"5") = "Rank 5"
attr(ds$IT25_05,"6") = "Rank 6"
attr(ds$IT25_05,"7") = "Rank 7"
attr(ds$IT25_06,"1") = "Rank 1"
attr(ds$IT25_06,"2") = "Rank 2"
attr(ds$IT25_06,"3") = "Rank 3"
attr(ds$IT25_06,"4") = "Rank 4"
attr(ds$IT25_06,"5") = "Rank 5"
attr(ds$IT25_06,"6") = "Rank 6"
attr(ds$IT25_06,"7") = "Rank 7"
attr(ds$IT25_07,"1") = "Rank 1"
attr(ds$IT25_07,"2") = "Rank 2"
attr(ds$IT25_07,"3") = "Rank 3"
attr(ds$IT25_07,"4") = "Rank 4"
attr(ds$IT25_07,"5") = "Rank 5"
attr(ds$IT25_07,"6") = "Rank 6"
attr(ds$IT25_07,"7") = "Rank 7"
attr(ds$IT27_01,"1") = "Nein"
attr(ds$IT27_01,"2") = "Ja"
attr(ds$IT27_02,"1") = "Nein"
attr(ds$IT27_02,"2") = "Ja"
attr(ds$IT27_03,"1") = "Nein"
attr(ds$IT27_03,"2") = "Ja"
attr(ds$IT27_04,"1") = "Nein"
attr(ds$IT27_04,"2") = "Ja"
attr(ds$IT33_01,"1") = "Rank 1"
attr(ds$IT33_01,"2") = "Rank 2"
attr(ds$IT33_01,"3") = "Rank 3"
attr(ds$IT33_01,"4") = "Rank 4"
attr(ds$IT33_01,"5") = "Rank 5"
attr(ds$IT33_01,"6") = "Rank 6"
attr(ds$IT33_01,"7") = "Rank 7"
attr(ds$IT33_02,"1") = "Rank 1"
attr(ds$IT33_02,"2") = "Rank 2"
attr(ds$IT33_02,"3") = "Rank 3"
attr(ds$IT33_02,"4") = "Rank 4"
attr(ds$IT33_02,"5") = "Rank 5"
attr(ds$IT33_02,"6") = "Rank 6"
attr(ds$IT33_02,"7") = "Rank 7"
attr(ds$IT33_03,"1") = "Rank 1"
attr(ds$IT33_03,"2") = "Rank 2"
attr(ds$IT33_03,"3") = "Rank 3"
attr(ds$IT33_03,"4") = "Rank 4"
attr(ds$IT33_03,"5") = "Rank 5"
attr(ds$IT33_03,"6") = "Rank 6"
attr(ds$IT33_03,"7") = "Rank 7"
attr(ds$IT33_04,"1") = "Rank 1"
attr(ds$IT33_04,"2") = "Rank 2"
attr(ds$IT33_04,"3") = "Rank 3"
attr(ds$IT33_04,"4") = "Rank 4"
attr(ds$IT33_04,"5") = "Rank 5"
attr(ds$IT33_04,"6") = "Rank 6"
attr(ds$IT33_04,"7") = "Rank 7"
attr(ds$IT33_05,"1") = "Rank 1"
attr(ds$IT33_05,"2") = "Rank 2"
attr(ds$IT33_05,"3") = "Rank 3"
attr(ds$IT33_05,"4") = "Rank 4"
attr(ds$IT33_05,"5") = "Rank 5"
attr(ds$IT33_05,"6") = "Rank 6"
attr(ds$IT33_05,"7") = "Rank 7"
attr(ds$IT33_06,"1") = "Rank 1"
attr(ds$IT33_06,"2") = "Rank 2"
attr(ds$IT33_06,"3") = "Rank 3"
attr(ds$IT33_06,"4") = "Rank 4"
attr(ds$IT33_06,"5") = "Rank 5"
attr(ds$IT33_06,"6") = "Rank 6"
attr(ds$IT33_06,"7") = "Rank 7"
attr(ds$IT33_07,"1") = "Rank 1"
attr(ds$IT33_07,"2") = "Rank 2"
attr(ds$IT33_07,"3") = "Rank 3"
attr(ds$IT33_07,"4") = "Rank 4"
attr(ds$IT33_07,"5") = "Rank 5"
attr(ds$IT33_07,"6") = "Rank 6"
attr(ds$IT33_07,"7") = "Rank 7"
attr(ds$IT30_01,"1") = "Rank 1"
attr(ds$IT30_01,"2") = "Rank 2"
attr(ds$IT30_01,"3") = "Rank 3"
attr(ds$IT30_01,"4") = "Rank 4"
attr(ds$IT30_01,"5") = "Rank 5"
attr(ds$IT30_01,"6") = "Rank 6"
attr(ds$IT30_01,"7") = "Rank 7"
attr(ds$IT30_02,"1") = "Rank 1"
attr(ds$IT30_02,"2") = "Rank 2"
attr(ds$IT30_02,"3") = "Rank 3"
attr(ds$IT30_02,"4") = "Rank 4"
attr(ds$IT30_02,"5") = "Rank 5"
attr(ds$IT30_02,"6") = "Rank 6"
attr(ds$IT30_02,"7") = "Rank 7"
attr(ds$IT30_03,"1") = "Rank 1"
attr(ds$IT30_03,"2") = "Rank 2"
attr(ds$IT30_03,"3") = "Rank 3"
attr(ds$IT30_03,"4") = "Rank 4"
attr(ds$IT30_03,"5") = "Rank 5"
attr(ds$IT30_03,"6") = "Rank 6"
attr(ds$IT30_03,"7") = "Rank 7"
attr(ds$IT30_04,"1") = "Rank 1"
attr(ds$IT30_04,"2") = "Rank 2"
attr(ds$IT30_04,"3") = "Rank 3"
attr(ds$IT30_04,"4") = "Rank 4"
attr(ds$IT30_04,"5") = "Rank 5"
attr(ds$IT30_04,"6") = "Rank 6"
attr(ds$IT30_04,"7") = "Rank 7"
attr(ds$IT30_05,"1") = "Rank 1"
attr(ds$IT30_05,"2") = "Rank 2"
attr(ds$IT30_05,"3") = "Rank 3"
attr(ds$IT30_05,"4") = "Rank 4"
attr(ds$IT30_05,"5") = "Rank 5"
attr(ds$IT30_05,"6") = "Rank 6"
attr(ds$IT30_05,"7") = "Rank 7"
attr(ds$IT30_06,"1") = "Rank 1"
attr(ds$IT30_06,"2") = "Rank 2"
attr(ds$IT30_06,"3") = "Rank 3"
attr(ds$IT30_06,"4") = "Rank 4"
attr(ds$IT30_06,"5") = "Rank 5"
attr(ds$IT30_06,"6") = "Rank 6"
attr(ds$IT30_06,"7") = "Rank 7"
attr(ds$IT30_07,"1") = "Rank 1"
attr(ds$IT30_07,"2") = "Rank 2"
attr(ds$IT30_07,"3") = "Rank 3"
attr(ds$IT30_07,"4") = "Rank 4"
attr(ds$IT30_07,"5") = "Rank 5"
attr(ds$IT30_07,"6") = "Rank 6"
attr(ds$IT30_07,"7") = "Rank 7"
attr(ds$IT32_01,"1") = "kein Grund"
attr(ds$IT32_01,"101") = "starker Grund"
attr(ds$FINISHED,"F") = "Canceled"
attr(ds$FINISHED,"T") = "Finished"
attr(ds$Q_VIEWER,"F") = "Respondent"
attr(ds$Q_VIEWER,"T") = "Spectator"
comment(ds$SERIAL) = "Serial number (if provided)"
comment(ds$REF) = "Reference (if provided in link)"
comment(ds$QUESTNNR) = "Questionnaire that has been used in the interview"
comment(ds$MODE) = "Interview mode"
comment(ds$STARTED) = "Time the interview has started (Europe/Berlin)"
comment(ds$DE02_01) = "st_117_andere_serien: [01]"
comment(ds$DE03_01) = "st_118_Formate: Dokumentation"
comment(ds$DE03_02) = "st_118_Formate: Sport"
comment(ds$DE03_03) = "st_118_Formate: Serien"
comment(ds$DE03_04) = "st_118_Formate: Filme"
comment(ds$DE03_05) = "st_118_Formate: Spielshows"
comment(ds$DE03_06) = "st_118_Formate: Magazine"
comment(ds$DE03_07) = "st_118_Formate: Nachrichten"
comment(ds$DE03_08) = "st_118_Formate: Live-Events"
comment(ds$DE04_01) = "st_109_wohnort: [01]"
comment(ds$DE05) = "st_109_Gemeinschaft"
comment(ds$DE06) = "st_112_bildung"
comment(ds$DE07_01) = "st_110_alter: [01]"
comment(ds$DE08) = "st_113_familienstand"
comment(ds$DE09) = "st_116_beruf"
comment(ds$DE09_38) = "st_116_beruf: Andere, bitte spezifizieren"
comment(ds$DE20_01) = "st_letzte Frage: [01]"
comment(ds$DE12_01) = "de_117_andere_serien: [01]"
comment(ds$DE13_01) = "de_110_alter: [01]"
comment(ds$DE14) = "de_114_tourismus arten1: Residual option (negative) or number of selected options"
comment(ds$DE14_01) = "de_114_tourismus arten1: Kulturtouristen"
comment(ds$DE14_02) = "de_114_tourismus arten1: Bildungstouristen"
comment(ds$DE14_03) = "de_114_tourismus arten1: Naturtouristen"
comment(ds$DE14_04) = "de_114_tourismus arten1: Sporttouristen"
comment(ds$DE14_05) = "de_114_tourismus arten1: Gesundheitstouristen"
comment(ds$DE14_06) = "de_114_tourismus arten1: Erholungstouristen"
comment(ds$DE14_07) = "de_114_tourismus arten1: Wellnestouristen"
comment(ds$DE14_08) = "de_114_tourismus arten1: Rucksacktouristen"
comment(ds$DE14_09) = "de_114_tourismus arten1: Andere, bitte spezifizieren"
comment(ds$DE14_09a) = "de_114_tourismus arten1: Andere, bitte spezifizieren (free text)"
comment(ds$DE15_01) = "de_114_tourismus arten2: Individualreisen/Veranstalterreisen"
comment(ds$DE15_02) = "de_114_tourismus arten2: Exklusivtourismus/Massentourismus"
comment(ds$DE15_03) = "de_114_tourismus arten2: Fremdenverkehr/Binnentourismus"
comment(ds$DE16) = "de_114_tourismus arten3: Residual option (negative) or number of selected options"
comment(ds$DE16_01) = "de_114_tourismus arten3: Auto"
comment(ds$DE16_02) = "de_114_tourismus arten3: Wohnwagen"
comment(ds$DE16_03) = "de_114_tourismus arten3: Bus"
comment(ds$DE16_04) = "de_114_tourismus arten3: Bahn"
comment(ds$DE16_05) = "de_114_tourismus arten3: Flugzeug"
comment(ds$DE16_06) = "de_114_tourismus arten3: Schiff/Boot"
comment(ds$DE16_07) = "de_114_tourismus arten3: zu Fuß"
comment(ds$DE16_08) = "de_114_tourismus arten3: Anderes, bitte spezifizieren"
comment(ds$DE16_08a) = "de_114_tourismus arten3: Anderes, bitte spezifizieren (free text)"
comment(ds$DE17) = "de_114_tourismus arten4"
comment(ds$DE19_01) = "de_letzte Frage: [01]"
comment(ds$DE21_01) = "pr_111_jahre BD: [01]"
comment(ds$DE22) = "pr_115_Rolle"
comment(ds$DE23_01) = "pr_117_andere_produktionen: [01]"
comment(ds$DE25_01) = "pr_letzte Frage: [01]"
comment(ds$EI01) = "st_03_staffel: Residual option (negative) or number of selected options"
comment(ds$EI01_01) = "st_03_staffel: Staffel 1"
comment(ds$EI01_02) = "st_03_staffel: Staffel 2"
comment(ds$EI01_03) = "st_03_staffel: Staffel 3"
comment(ds$EI01_04) = "st_03_staffel: Staffel 4"
comment(ds$EI01_05) = "st_03_staffel: Staffel 5"
comment(ds$EI01_06) = "st_03_staffel: Staffel 6"
comment(ds$EI01_07) = "st_03_staffel: Staffel 7"
comment(ds$EI01_08) = "st_03_staffel: Staffel 8"
comment(ds$EI01_09) = "st_03_staffel: Staffel 9"
comment(ds$EI01_10) = "st_03_staffel: Staffel 10"
comment(ds$EI01_11) = "st_03_staffel: Staffel 11"
comment(ds$EI01_12) = "st_03_staffel: Staffel 12"
comment(ds$EI01_13) = "st_03_staffel: Staffel 13"
comment(ds$EI01_14) = "st_03_staffel: Staffel 14"
comment(ds$EI01_15) = "st_03_staffel: Staffel 15"
comment(ds$EI01_16) = "st_03_staffel: Keine Staffel"
comment(ds$EI06) = "st_03_folgen"
comment(ds$EI02_01) = "st_04_fan: [No Description] 01"
comment(ds$EI03_01) = "st_05_fandom: Beschäftigen Sie sich auch über das wöchentlichen Schauen der neusten Folgen der Serie \"Der Bergdoktor\" hinaus mit der Serie oder ihren Charakteren?"
comment(ds$EI04) = "st_12_SoMe_time"
comment(ds$EI05_01) = "st_13_themen_insta: Reisen & Destination"
comment(ds$EI05_02) = "st_13_themen_insta: Mode & Beauty"
comment(ds$EI05_03) = "st_13_themen_insta: Sport & gesundes Leben"
comment(ds$EI05_04) = "st_13_themen_insta: Kunst & Kultur"
comment(ds$EI05_05) = "st_13_themen_insta: Stars & Sternchen"
comment(ds$EI05_06) = "st_13_themen_insta: Kochen & Backen"
comment(ds$EI05_07) = "st_13_themen_insta: Neuigkeiten & News"
comment(ds$EI05_08) = "st_13_themen_insta: Freunde & Verwandte"
comment(ds$EI05_09) = "st_13_themen_insta: Comedy & Memes"
comment(ds$EI05_10) = "st_13_themen_insta: Heimwerken & Basteln"
comment(ds$EI07) = "de_03_folgen"
comment(ds$EI08_01) = "de_17_stil: Aktiv"
comment(ds$EI08_02) = "de_17_stil: Interessant"
comment(ds$EI08_03) = "de_17_stil: Bescheiden"
comment(ds$EI08_04) = "de_17_stil: Locker"
comment(ds$EI08_05) = "de_17_stil: Formell"
comment(ds$EI08_06) = "de_17_stil: Ehrlich"
comment(ds$EI09) = "pr_12_SoMe_time"
comment(ds$EI10_01) = "pr_17_stil: Aktiv"
comment(ds$EI10_02) = "pr_17_stil: Interessant"
comment(ds$EI10_03) = "pr_17_stil: Bescheiden"
comment(ds$EI10_04) = "pr_17_stil: Locker"
comment(ds$EI10_05) = "pr_17_stil: Formell"
comment(ds$EI10_06) = "pr_17_stil: Ehrlich"
comment(ds$IP02) = "st_check_display_Scr87-126"
comment(ds$IP51) = "st_check_display_Scr127-166"
comment(ds$IP53) = "st_check_display_Scr167-206"
comment(ds$IP55) = "st_check_display_Scr207-247"
comment(ds$IP14_01) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/BjFpI0CgwTl/"
comment(ds$IP14_09) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/CDataSXBhvF/"
comment(ds$IP14_29) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/B1g4Eh8ijwp/"
comment(ds$IP14_30) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/CF45-iylHlL/"
comment(ds$IP14_33) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/CEuAlz3pKk4/"
comment(ds$IP14_35) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/CGw14x-hST1/"
comment(ds$IP14_38) = "st_check_sehen_Scr87-126: https://www.instagram.com/p/CGFu_vIJOzq/"
comment(ds$IP52_10) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CF11D-Ggkay/"
comment(ds$IP52_13) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CH7GJo0FNZO/"
comment(ds$IP52_16) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CHU-pLyM0pk/"
comment(ds$IP52_26) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CJHhDPEJI3Y/"
comment(ds$IP52_32) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CLpgH8Ahzgw/"
comment(ds$IP52_33) = "st_check_sehen_Scr127-166: https://www.instagram.com/p/CL9l5rmKEsB/"
comment(ds$IP54_07) = "st_check_sehen_Scr167-206: https://www.instagram.com/p/CN2W7AWFEHf/"
comment(ds$IP54_19) = "st_check_sehen_Scr167-206: https://www.instagram.com/p/CB_YtMmqjah/"
comment(ds$IP54_26) = "st_check_sehen_Scr167-206: https://www.instagram.com/p/CQTuN1NMLdh/"
comment(ds$IP56_01) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/CPtTEdqnvh4/"
comment(ds$IP56_05) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/BSeBTgLDNCy/"
comment(ds$IP56_10) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/Bo9oARsHzIu/"
comment(ds$IP56_11) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/Bn5hlJ1Bf9q/"
comment(ds$IP56_18) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/Bz7X95xo3IA/"
comment(ds$IP56_23) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/B24EWo4ihK1/"
comment(ds$IP56_28) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/B9Ri2GSo_9J/"
comment(ds$IP56_33) = "st_check_sehen_Scr207-247: https://www.instagram.com/p/CD0tAKQh3wx/"
comment(ds$IP17) = "st_check_meiner"
comment(ds$IP01) = "st_84_reshare"
comment(ds$IP04_01) = "st_86_motivation_hashtag: [01]"
comment(ds$IP05_01) = "st_87_motivation_mention: [01]"
comment(ds$IP06_01) = "st_88_motivation_text: [01]"
comment(ds$IP07_01) = "st_90_motivation_foto: [01]"
comment(ds$IP08_01) = "st_97_situation: [01]"
comment(ds$IP35_pts) = "Markers (position x1,y1,m1 x2,y2,m2 ...)"
comment(ds$IP35_rgs) = "Regions of the markers"
comment(ds$IP35_01) = "st/de/pr_98+99_motiv&Ort: Fotomotiv (1.) (total count)"
comment(ds$IP35_01x01) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x02) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x03) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x04) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x05) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x06) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x07) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x08) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x09) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x10) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x11) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x12) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x13) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x14) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x15) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x16) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x17) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x18) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x19) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x20) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x21) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x22) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x23) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x24) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x25) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x26) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x27) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x28) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x29) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_01x30) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02) = "st/de/pr_98+99_motiv&Ort: Standort Fotograf:in (2.) (total count)"
comment(ds$IP35_02x01) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x02) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x03) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x04) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x05) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x06) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x07) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x08) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x09) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x10) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x11) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x12) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x13) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x14) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x15) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x16) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x17) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x18) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x19) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x20) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x21) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x22) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x23) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x24) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x25) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x26) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x27) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x28) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x29) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP35_02x30) = "st/de/pr_98+99_motiv&Ort: ERROR"
comment(ds$IP11) = "st_100_ort_foto_drehort"
comment(ds$IP11s) = "st_100_ort_foto_drehort (free text)"
comment(ds$IP12_01) = "st_102_post_date: Das Foto/Bild ist am ... am Wilden Kaiser entstanden."
comment(ds$IP13) = "st_103_tbt_foto"
comment(ds$IP18) = "de_check_display_des1-40"
comment(ds$IP57) = "de_check_display_des41-59"
comment(ds$IP19_04) = "de_check_sehen_des1-40: https://www.instagram.com/p/B-pEIxgDExJ/"
comment(ds$IP19_09) = "de_check_sehen_des1-40: https://www.instagram.com/p/B_SeQyzlPop/"
comment(ds$IP19_10) = "de_check_sehen_des1-40: https://www.instagram.com/p/CE_81ZajsBl/"
comment(ds$IP19_16) = "de_check_sehen_des1-40: https://www.instagram.com/p/CB1GM6HDkXI/"
comment(ds$IP58_02) = "de_check_sehen_des41-59: https://www.instagram.com/p/CQeDwZxjHtP/"
comment(ds$IP58_23) = "de_check_sehen_des41-59: https://www.instagram.com/p/Bmu3VOdngGL/"
comment(ds$IP20) = "de_check_meiner"
comment(ds$IP21) = "de_84_reshare"
comment(ds$IP23_01) = "de_86_motivation_hashtag: [01]"
comment(ds$IP24_01) = "de_87_motivation_mention: [01]"
comment(ds$IP25_01) = "de_88_motivation_text: [01]"
comment(ds$IP26_01) = "de_90_motivation_foto: [01]"
comment(ds$IP27) = "de_95_kommerz foto"
comment(ds$IP59_pts) = "Markers (position x1,y1,m1 x2,y2,m2 ...)"
comment(ds$IP59_rgs) = "Regions of the markers"
comment(ds$IP59_01) = "de_98+99_motiv&Ort: Fotomotiv (1.) (total count)"
comment(ds$IP59_01x01) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x02) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x03) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x04) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x05) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x06) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x07) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x08) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x09) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x10) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x11) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x12) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x13) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x14) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x15) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x16) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x17) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x18) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x19) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x20) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x21) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x22) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x23) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x24) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x25) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x26) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x27) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x28) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_01x29) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02) = "de_98+99_motiv&Ort: Standort Fotograf:in (2.) (total count)"
comment(ds$IP59_02x01) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x02) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x03) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x04) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x05) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x06) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x07) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x08) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x09) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x10) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x11) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x12) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x13) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x14) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x15) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x16) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x17) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x18) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x19) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x20) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x21) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x22) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x23) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x24) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x25) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x26) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x27) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x28) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP59_02x29) = "de_98+99_motiv&Ort: ERROR"
comment(ds$IP30) = "de_100_ort_foto_drehort"
comment(ds$IP30s) = "de_100_ort_foto_drehort (free text)"
comment(ds$IP31_01) = "de_102_post_date: Das Foto/Bild ist am ... am Wilden Kaiser entstanden."
comment(ds$IP32_01) = "de_105_authent drehort: Haben Sie den Drehort so fotografiert wie Sie Ihn vor Ort vorgefunden haben?"
comment(ds$IP36) = "pr_check_display_Pro60-86"
comment(ds$IP37_19) = "pr_check_sehen_Pro60-86: https://www.instagram.com/p/CQY7iJDppAE/"
comment(ds$IP38) = "pr_check_meiner"
comment(ds$IP39) = "pr_84_reshare"
comment(ds$IP40_01) = "pr_86_motivation_hashtag: [01]"
comment(ds$IP41_01) = "pr_87_motivation_mention: [01]"
comment(ds$IP42_01) = "pr_88_motivation_text: [01]"
comment(ds$IP43_01) = "pr_90_motivation_foto: [01]"
comment(ds$IP44) = "pr_95_kommerz foto"
comment(ds$IP45_01) = "pr_97_situation: [01]"
comment(ds$IP47) = "pr_100_ort_foto_drehort"
comment(ds$IP47s) = "pr_100_ort_foto_drehort (free text)"
comment(ds$IP48_01) = "pr_102_post_date: Das Foto/Bild ist am ... am Wilden Kaiser entstanden."
comment(ds$IP49) = "pr_103_tbt_foto"
comment(ds$IP50_01) = "pr_105_authent drehort: [No Description] 01"
comment(ds$IT01_01) = "st_20-26_some_recherche: Ich habe vor dem Urlaub bei Instagram über den Wilden Kaiser recherchiert."
comment(ds$IT01_02) = "st_20-26_some_recherche: Ich habe vor oder während meines Urlaubs andere Tourismusbeiträge vom Wilden Kaiser auf Instagram wahrgnommen."
comment(ds$IT01_03) = "st_20-26_some_recherche: Ich habe mir Beiträge von Accounts der Destination angesehen (Bsp.: Visit Tirol)."
comment(ds$IT01_04) = "st_20-26_some_recherche: Ich folge den offiziellen Tourismusaccounts der Destination auf Instagram (Bsp.: Wilder Kaiser, Love Austria oder andere)"
comment(ds$IT01_05) = "st_20-26_some_recherche: Ich habe mir Beiträge von Schauspieler:innen und der Filmcrew am Wilden Kaiser angesehen."
comment(ds$IT01_06) = "st_20-26_some_recherche: Ich habe Instagram nicht genutzt, um mich über den Wilden Kaiser zu informieren."
comment(ds$IT02_01) = "st_28_some_beeinflussung: Beiträge von anderen Touristen im Urlaub am Wilden Kaiser"
comment(ds$IT02_02) = "st_28_some_beeinflussung: Beiträge von Schauspieler:innen und der Filmcrew am Wilden Kaiser"
comment(ds$IT02_03) = "st_28_some_beeinflussung: Beiträge der lokalen Tourismussaccounts (Bsp.: Visit Tirol)"
comment(ds$IT03_01) = "st_34_situation_vor_ort: Der Wilde Kaiser erschien mir vor Ort so, wie ich das auf Instagram wahrgenommen habe."
comment(ds$IT03_02) = "st_34_situation_vor_ort: Es war vor Ort am Wilden Kaiser schöner als die Instagram-Bilder es zeigen konnten."
comment(ds$IT03_03) = "st_34_situation_vor_ort: Meine Erwartungen durch die Instagram-Beiträge konnte der Wilde Kaiser vor Ort nicht erfüllen."
comment(ds$IT03_04) = "st_34_situation_vor_ort: Ich habe mir vor dem Urlaub keine Instagram-Beiträge vom Wilden Kaiser angesehen."
comment(ds$IT04) = "st_63_Fantage"
comment(ds$IT05_01) = "st_64_reisedatum: Ich war vom ... "
comment(ds$IT05_02) = "st_64_reisedatum: bis zum ... "
comment(ds$IT06_01) = "st_65_motivation: [01]"
comment(ds$IT07) = "st_66_bd_induced"
comment(ds$IT08_01) = "st_68_motivation_serie: Ich wollte in die Fußstapfen meiner Lieblingsschauspieler:innen treten."
comment(ds$IT08_02) = "st_68_motivation_serie: Ich wollte selbst einmal an dem Drehort der Serie \"Der Bergdoktor\" stehen."
comment(ds$IT08_03) = "st_68_motivation_serie: Mich interessiert der reale Ort; nicht die relevanz des Ortes als Drehort in der Serie \"Der Bergdoktor\"."
comment(ds$IT08_04) = "st_68_motivation_serie: Ich bin ein loyaler Fan und wollte das zum Ausdruck bringen."
comment(ds$IT08_05) = "st_68_motivation_serie: Ich finde die Landschaft einfach beeindruckend und wollte sie selbst sehen."
comment(ds$IT08_06) = "st_68_motivation_serie: Ich habe das Gefühl durch die Serie den Wilden Kaiser zu kennen."
comment(ds$IT08_07) = "st_68_motivation_serie: Ich wollte einfach Spaß haben und mich entertainen lassen."
comment(ds$IT08_08) = "st_68_motivation_serie: Ich wollte etwas Besonderes machen in meinem Urlaub."
comment(ds$IT08_09) = "st_68_motivation_serie: Ich wollte etwas Neues und Ungewöhnliches wagen."
comment(ds$IT08_10) = "st_68_motivation_serie: Ich war auf der Suche nach einer einzigartigen Erfahrung."
comment(ds$IT08_11) = "st_68_motivation_serie: Es war nicht meine Idee, sondern die meiner Reisebegleitung."
comment(ds$IT09) = "st_69_orte_entdeckt"
comment(ds$IT09_05) = "st_69_orte_entdeckt: Ein anderer Grund"
comment(ds$IT10_01) = "st_71_welche Orte: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT10_02) = "st_71_welche Orte: Praxis des Bergdoktors"
comment(ds$IT10_03) = "st_71_welche Orte: Gasthof zum Wilden Kaiser"
comment(ds$IT10_04) = "st_71_welche Orte: Krankenhaus"
comment(ds$IT10_05) = "st_71_welche Orte: Dorfplatz und Kirche"
comment(ds$IT10_06) = "st_71_welche Orte: Apotheke"
comment(ds$IT10_07) = "st_71_welche Orte: Hintersteiner See"
comment(ds$IT15_01) = "st_73_orte_nahe: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT15_02) = "st_73_orte_nahe: Praxis des Bergdoktors"
comment(ds$IT15_03) = "st_73_orte_nahe: Gasthof zum Wilden Kaiser"
comment(ds$IT15_04) = "st_73_orte_nahe: Krankenhaus"
comment(ds$IT15_05) = "st_73_orte_nahe: Dorfplatz und Kirche"
comment(ds$IT15_06) = "st_73_orte_nahe: Apotheke"
comment(ds$IT15_07) = "st_73_orte_nahe: Hintersteiner See"
comment(ds$IT13) = "st_74_Wk-anzahl"
comment(ds$IT14) = "st_75_andere_filmorte"
comment(ds$IT16) = "de_40_als erstes"
comment(ds$IT17) = "de_42_strategie"
comment(ds$IT18_01) = "de_43_vorgaben de: [01]"
comment(ds$IT19_01) = "de_44_stil annäherung: Screentouristen"
comment(ds$IT19_02) = "de_44_stil annäherung: Allgemeine Touristen"
comment(ds$IT19_03) = "de_44_stil annäherung: TV-Produktion"
comment(ds$IT19_04) = "de_44_stil annäherung: Eigener allgemeiner Social Media-Stil"
comment(ds$IT19_05) = "de_44_stil annäherung: Aktuellen Trends"
comment(ds$IT19_06) = "de_44_stil annäherung: Anderes"
comment(ds$IT20) = "de_45_Jahreszeiten: Residual option (negative) or number of selected options"
comment(ds$IT20_01) = "de_45_Jahreszeiten: Frühling"
comment(ds$IT20_02) = "de_45_Jahreszeiten: Sommer"
comment(ds$IT20_03) = "de_45_Jahreszeiten: Herbst"
comment(ds$IT20_04) = "de_45_Jahreszeiten: Winter"
comment(ds$IT21_01) = "de_53_ermutigen: Ermutigen Sie Ihre Touristen dazu Fotos bzw. Beiträge von den Drehorten der Serie \"Der Bergdoktor\" zu machen und sie auf Instagram zu veröffentlichen?"
comment(ds$IT21_02) = "de_53_ermutigen: Ermutigen Sie die Film-Produktion und ihre Mitarbeiter:innen dazu Fotos bzw. Beiträge von den Drehorten der Serie \"Der Bergdoktor\" zu machen und sie auf Instagram zu veröffentlichen?"
comment(ds$IT22_01) = "de_55_image wk: [No Description] 01"
comment(ds$IT24_01) = "de_60_beliebte Drehorte: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT24_02) = "de_60_beliebte Drehorte: Praxis des Bergdoktors"
comment(ds$IT24_03) = "de_60_beliebte Drehorte: Gasthof zum Wilden Kaiser"
comment(ds$IT24_04) = "de_60_beliebte Drehorte: Krankenhaus"
comment(ds$IT24_05) = "de_60_beliebte Drehorte: Dorfplatz und Kirche"
comment(ds$IT24_06) = "de_60_beliebte Drehorte: Apotheke"
comment(ds$IT24_07) = "de_60_beliebte Drehorte: Hintersteiner See"
comment(ds$IT25_01) = "de_62_beliebte Drehorte SoMe: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT25_02) = "de_62_beliebte Drehorte SoMe: Praxis des Bergdoktors"
comment(ds$IT25_03) = "de_62_beliebte Drehorte SoMe: Gasthof zum Wilden Kaiser"
comment(ds$IT25_04) = "de_62_beliebte Drehorte SoMe: Krankenhaus"
comment(ds$IT25_05) = "de_62_beliebte Drehorte SoMe: Dorfplatz und Kirche"
comment(ds$IT25_06) = "de_62_beliebte Drehorte SoMe: Apotheke"
comment(ds$IT25_07) = "de_62_beliebte Drehorte SoMe: Hintersteiner See"
comment(ds$IT26_01) = "de_63_Fantage: [01]"
comment(ds$IT27_01) = "de_82_vr/ar: Es gab Überlegungen in der Vergangenheit."
comment(ds$IT27_02) = "de_82_vr/ar: Es gibt aktuell aktive Projekte."
comment(ds$IT27_03) = "de_82_vr/ar: Es gibt Pläne für die Zukunft."
comment(ds$IT27_04) = "de_82_vr/ar: Darüber haben wir uns keinerlei Gedanken gemacht."
comment(ds$IT28_01) = "pr_38_vorgaben de: [01]"
comment(ds$IT29_01) = "pr_47_vorgaben pr: [01]"
comment(ds$IT33_01) = "pr_61_beliebte Drehorte: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT33_02) = "pr_61_beliebte Drehorte: Praxis des Bergdoktors"
comment(ds$IT33_03) = "pr_61_beliebte Drehorte: Gasthof zum Wilden Kaiser"
comment(ds$IT33_04) = "pr_61_beliebte Drehorte: Krankenhaus"
comment(ds$IT33_05) = "pr_61_beliebte Drehorte: Dorfplatz und Kirche"
comment(ds$IT33_06) = "pr_61_beliebte Drehorte: Apotheke"
comment(ds$IT33_07) = "pr_61_beliebte Drehorte: Hintersteiner See"
comment(ds$IT30_01) = "pr_70_genutzte Drehorte: Gruberhof (Elternhaus/Bauernhof)"
comment(ds$IT30_02) = "pr_70_genutzte Drehorte: Praxis des Bergdoktors"
comment(ds$IT30_03) = "pr_70_genutzte Drehorte: Gasthof zum Wilden Kaiser"
comment(ds$IT30_04) = "pr_70_genutzte Drehorte: Krankenhaus"
comment(ds$IT30_05) = "pr_70_genutzte Drehorte: Dorfplatz und Kirche"
comment(ds$IT30_06) = "pr_70_genutzte Drehorte: Apotheke"
comment(ds$IT30_07) = "pr_70_genutzte Drehorte: Hintersteiner See"
comment(ds$IT31_01) = "pr_63_Fantage: [01]"
comment(ds$IT32_01) = "pr_67_WK grund: [No Description] 01"
comment(ds$SO02) = "st_sort_quest_Scr87-126"
comment(ds$SO10) = "st_sort_quest_Scr127-166"
comment(ds$SO11) = "st_sort_quest_Scr167-206"
comment(ds$SO12) = "st_sort_quest_Scr207-247"
comment(ds$SO12s) = "st_sort_quest_Scr207-247 (free text)"
comment(ds$SO06) = "de_sort_quest_Des1-40"
comment(ds$SO06s) = "de_sort_quest_Des1-40 (free text)"
comment(ds$SO13) = "de_sort_quest_Des41-59"
comment(ds$SO09) = "pr_sort_quest_Pro60-86"
comment(ds$TIME001) = "Time spent on page 1"
comment(ds$TIME002) = "Time spent on page 2"
comment(ds$TIME003) = "Time spent on page 3"
comment(ds$TIME004) = "Time spent on page 4"
comment(ds$TIME005) = "Time spent on page 5"
comment(ds$TIME006) = "Time spent on page 6"
comment(ds$TIME007) = "Time spent on page 7"
comment(ds$TIME008) = "Time spent on page 8"
comment(ds$TIME009) = "Time spent on page 9"
comment(ds$TIME010) = "Time spent on page 10"
comment(ds$TIME011) = "Time spent on page 11"
comment(ds$TIME012) = "Time spent on page 12"
comment(ds$TIME013) = "Time spent on page 13"
comment(ds$TIME014) = "Time spent on page 14"
comment(ds$TIME015) = "Time spent on page 15"
comment(ds$TIME016) = "Time spent on page 16"
comment(ds$TIME017) = "Time spent on page 17"
comment(ds$TIME_SUM) = "Time spent overall (except outliers)"
comment(ds$MAILSENT) = "Time when the invitation mailing was sent (personally identifiable recipients, only)"
comment(ds$LASTDATA) = "Time when the data was most recently updated"
comment(ds$FINISHED) = "Has the interview been finished (reached last page)?"
comment(ds$Q_VIEWER) = "Did the respondent only view the questionnaire, omitting mandatory questions?"
comment(ds$LASTPAGE) = "Last page that the participant has handled in the questionnaire"
comment(ds$MAXPAGE) = "Hindmost page handled by the participant"
comment(ds$MISSING) = "Missing answers in percent"
comment(ds$MISSREL) = "Missing answers (weighted by relevance)"
comment(ds$TIME_RSI) = "Degradation points for being very fast"
comment(ds$DEG_TIME) = "Degradation points for being very fast"



# Assure that the comments are retained in subsets
as.data.frame.avector = as.data.frame.vector
`[.avector` <- function(x,i,...) {
  r <- NextMethod("[")
  mostattributes(r) <- attributes(x)
  r
}
ds_tmp = data.frame(
  lapply(ds, function(x) {
    structure( x, class = c("avector", class(x) ) )
  } )
)
mostattributes(ds_tmp) = attributes(ds)
df_raw = ds_tmp
rm(ds_tmp, ds)



### ETL process

  # load variables
  traceinterview_folder <- "/221027_Save Data/" 
  
  files_csv <- list.files(
    paste0(paths$interview_data, traceinterview_folder),
    pattern = ".csv",
    full.names = TRUE)

  traceinterview_var_file <- files_csv[grepl("variables_bergdokotorarbeit_", files_csv)]
  df_1.2_traceinterview_var_raw <- read.csv(traceinterview_var_file,
                                            stringsAsFactors = FALSE,
                                            sep = ";",
                                            encoding="UTF-8") %>% 
    as.data.frame()
  
  # select main cols
  df_2_traceinterview_var_a <- df_1.2_traceinterview_var_raw %>% 
    filter(!VAR %in% delet_traceinterview_ip_rows#, # Filter out Soci-survey standart rows and defined in init
           #!str_detect(VAR, "TIME") 
           ) %>%
    as.data.frame()
  
  list_traceinterview_var_a <- df_2_traceinterview_var_a %>% # answer list
    select(VAR) %>% 
    filter(VAR != "CASE")
  
  df_1 <- df_raw %>%
    select(QUESTNNR,
           list_traceinterview_var_a$VAR)
  
  
  # split geoloc columns
  df_2 <- df_1 %>% 
    mutate(IP35_01_pts = str_extract(IP35_pts, "[:graph:]{7}(?=,1)"),
           IP35_02_pts = str_extract(IP35_pts, "[:graph:]{7}(?=,2)"),
           IP35_01_rgs = if_else(str_detect(IP35_pts, "[:graph:]{7}(?=,1)") == TRUE, 
                                 str_extract(IP35_rgs, "^\\d{2}"), 
                                 NULL),
           IP35_02_rgs = if_else(str_detect(IP35_pts, "[:graph:]{7}(?=,2)") == TRUE, 
                                 str_extract(IP35_rgs, "\\d{2}$"), 
                                 NULL),
           IP59_01_pts = str_extract(IP59_pts, "[:graph:]{7}(?=,1)"),
           IP59_02_pts = str_extract(IP59_pts, "[:graph:]{7}(?=,2)"),
           IP59_01_rgs = if_else(str_detect(IP59_pts, "[:graph:]{7}(?=,1)") == TRUE, 
                                 str_extract(IP59_rgs, "^\\d{2}"), 
                                 NULL),
           IP59_02_rgs = if_else(str_detect(IP59_pts, "[:graph:]{7}(?=,2)") == TRUE, 
                                 str_extract(IP59_rgs, "\\d{2}$"), 
                                 NULL)  
           )
    
    # Unite the columns:
      # that are the same question in the 3 different questionairs (ST,DE,PR)
    df_2 <- df_2 %>% 
    unite(col = "username", all_of(unique_username_cols), na.rm = TRUE) %>%           # Unite username
    unite(col = "url", all_of(unique_url_cols), na.rm = TRUE) %>%                     # unite url
    unite(col = "last_comment", c("DE19_01", "DE20_01", "DE25_01"), na.rm = TRUE) %>% # Unite the comment
    unite(col = "DE09", c("DE09", "DE09_38"), na.rm = TRUE) %>%               # Beruf?
    unite(col = "EI04_EI09", c("EI04", "EI09"), na.rm = TRUE) %>%             # Zeit auf Instagram?
    unite(col = "EI06_EI07", c("EI06", "EI07"), na.rm = TRUE) %>%             # Gesehene Folgen?
    unite(col = "EI08_01_EI10_01", c("EI08_01", "EI10_01"), na.rm = TRUE) %>% # Auftritt Instagram?
    unite(col = "EI08_02_EI10_02", c("EI08_02", "EI10_02"), na.rm = TRUE) %>% # Auftritt Instagram? 
    unite(col = "EI08_03_EI10_03", c("EI08_03", "EI10_03"), na.rm = TRUE) %>% # Auftritt Instagram? 
    unite(col = "EI08_04_EI10_04", c("EI08_04", "EI10_04"), na.rm = TRUE) %>% # Auftritt Instagram? 
    unite(col = "EI08_05_EI10_05", c("EI08_05", "EI10_05"), na.rm = TRUE) %>% # Auftritt Instagram? 
    unite(col = "EI08_06_EI10_06", c("EI08_06", "EI10_06"), na.rm = TRUE) %>% # Auftritt Instagram?
    unite(col = "IT09", c("IT09", "IT09_05"), na.rm = TRUE) %>%               # Drehorte entdeckt?
    unite(col = "IT24_01_IT33_01", c("IT24_01", "IT33_01"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte?
    unite(col = "IT24_02_IT33_02", c("IT24_02", "IT33_02"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte? 
    unite(col = "IT24_03_IT33_03", c("IT24_03", "IT33_03"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte? 
    unite(col = "IT24_04_IT33_04", c("IT24_04", "IT33_04"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte? 
    unite(col = "IT24_05_IT33_05", c("IT24_05", "IT33_05"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte? 
    unite(col = "IT24_06_IT33_06", c("IT24_06", "IT33_06"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte?
    unite(col = "IT24_07_IT33_07", c("IT24_07", "IT33_07"), na.rm = TRUE) %>% # Beliebtesten Filmtourismusorte?
    unite(col = "IT26_IT31", c("IT26_01", "IT31_01"), na.rm = TRUE) %>%                 # Einschätzung Fantage?
    unite(col = "IP01_IP21_IP39", c("IP01", "IP21", "IP39"), na.rm = TRUE) %>%          # Repost?
    unite(col = "IP04_IP23_IP40", c("IP04_01", "IP23_01", "IP40_01"), na.rm = TRUE) %>% # Hashtags?
    unite(col = "IP05_IP24_IP41", c("IP05_01", "IP24_01", "IP41_01"), na.rm = TRUE) %>% # Mentions?
    unite(col = "IP06_IP25_IP42", c("IP06_01", "IP25_01", "IP42_01"), na.rm = TRUE) %>% # Text?
    unite(col = "IP07_IP26_IP43", c("IP07_01", "IP26_01", "IP43_01"), na.rm = TRUE) %>% # Foto?
    unite(col = "IP08_IP45", c("IP08_01", "IP45_01"), na.rm = TRUE) %>%                 # Situation vor Ort?
    unite(col = "IP11_IP30_IP47", c("IP11", "IP11s", "IP30", "IP30s", "IP47", "IP47s"), na.rm = TRUE) %>% # Fiktionaler Ort?
    unite(col = "IP12_IP31_IP48", c("IP12_01", "IP31_01", "IP48_01"), na.rm = TRUE) %>%                   # Wann aufgenommen?
    unite(col = "IP13_IP49", c("IP13", "IP49"), na.rm = TRUE) %>%                       # Direkt gepostet?
    unite(col = "IP14_52_54_56_58", c("IP14_01", "IP14_09", "IP14_29", "IP14_30", "IP14_33", "IP14_35", "IP14_38", #st
                                      "IP19_04", "IP19_09", "IP19_10", "IP19_16", #de
                                      "IP37_19", #pr
                                      "IP52_10", "IP52_13", "IP52_16", "IP52_26", "IP52_32", "IP52_33", #st
                                      "IP54_07", "IP54_19", "IP54_26",  #st
                                      "IP56_01", "IP56_05", "IP56_10", "IP56_11", "IP56_18", "IP56_23", "IP56_28", "IP56_33", #st
                                      "IP58_02", "IP58_23"), na.rm = TRUE) %>%  # Looked at Insta-Link?
    unite(col = "IP17_IP20_IP38", c("IP17", "IP20", "IP38"), na.rm = TRUE) %>%  # My link?      
    unite(col = "IP27_IP44", c("IP27", "IP44"), na.rm = TRUE) %>%                       # Kommerziell?
    unite(col = "IP32_IP50", c("IP32_01", "IP50_01"), na.rm = TRUE) %>%                 # Veränderungen für Foto?
    unite(col = "IP35_IP59_pts", c("IP35_pts", "IP59_pts"), na.rm = TRUE) %>%           # Orte Foto (Motiv + Fotograf)?
    unite(col = "IP35_IP59_rgs", c("IP35_rgs", "IP59_rgs"), na.rm = TRUE) %>%           # Regionen Foto (Motiv + Fotograf)?
    unite(col = "IP35_IP59_m_pts", c("IP35_01_pts", "IP59_01_pts"), na.rm = TRUE) %>%   # Ort Fotomotiv?
    unite(col = "IP35_IP59_m_rgs", c("IP35_01_rgs", "IP59_01_rgs"), na.rm = TRUE) %>%   # Regionen Fotomotiv?
    unite(col = "IP35_IP59_m", c("IP35_01", "IP59_01"), na.rm = TRUE) %>%               # Ort Motiv vorhanden?
    unite(col = "IP35_IP59_f_pts", c("IP35_02_pts", "IP59_02_pts"), na.rm = TRUE) %>%   # Ort Fotograf?
    unite(col = "IP35_IP59_f_rgs", c("IP35_02_rgs", "IP59_02_rgs"), na.rm = TRUE) %>%   # Regionen Fotograf?
    unite(col = "IP35_IP59_f", c("IP35_02", "IP59_02"), na.rm = TRUE)                   # Ort Fotograf vorhanden?
    
    
    
    # mutate NA answers
    df_2 <- df_2 %>% 
      mutate(username = str_remove(username, "\\[NA\\] other text response_[:blank:]?"),
             username = if_else(str_detect(username, "test") == TRUE, "", username),
             url = str_remove(url, "\\[NA\\] Not answered"),
             DE17 = str_replace(DE17, "\\[NA\\] Das kann ich nicht beantworten",""),
             EI06_EI07 = str_replace(EI06_EI07, "\\[NA\\] Not answered", ""),
             IP11_IP30_IP47 = str_replace(IP11_IP30_IP47, "\\[NA\\] other text response_", ""), 
             IP11_IP30_IP47 = str_replace(IP11_IP30_IP47, "\\[NA\\] ", ""), 
             IP27_IP44 = str_replace(IP27_IP44, "\\[NA\\] Das weiß ich nicht", "")
             )
    
    
    # make corners for the picture triangle with vector functions
    df_2 <- df_2 %>%
      rowwise() %>%
      mutate(pts_corner_1 = paste0(find_corner_1(c(as.numeric(str_extract(
                                    IP35_IP59_f_pts, "\\d+(?=,)") ),
                                    as.numeric(str_extract(
                                      IP35_IP59_f_pts, "(?<=,)\\d+") ) ),
                                    c(as.numeric(str_extract(
                                      IP35_IP59_m_pts, "\\d+(?=,)") ),
                                      as.numeric(str_extract(
                                        IP35_IP59_m_pts, "(?<=,)\\d+") ) ) )
      ),
      pts_corner_2 = paste0(find_corner_2(c(as.numeric(str_extract(
                              IP35_IP59_f_pts, "\\d+(?=,)") ),
                              as.numeric(str_extract(
                                IP35_IP59_f_pts, "(?<=,)\\d+") ) ),
                              c(as.numeric(str_extract(
                                IP35_IP59_m_pts, "\\d+(?=,)") ),
                                as.numeric(str_extract(
                                  IP35_IP59_m_pts, "(?<=,)\\d+") ) ) )
      ) ) %>%
      ungroup() %>% # because of rowise!
      mutate(pts_corner_1 = str_replace(pts_corner_1, "NA,NA", ""),
             pts_corner_2 = str_replace(pts_corner_2, "NA,NA", "") )
  
    
    # build bucket columns and fan_level
    df_2 <- df_2 %>% 
      mutate(
        age_buckets = case_when( # Create buckets
          DE07_01 >= 2000                  ~ ">1999",
          DE07_01 > 1990 & DE07_01 <= 1999 ~ "90-99",
          DE07_01 > 1980 & DE07_01 <= 1989 ~ "80-89",
          DE07_01 > 1970 & DE07_01 <= 1979 ~ "70-79",
          DE07_01 > 1960 & DE07_01 <= 1969 ~ "60-69",
          DE07_01 > 1950 & DE07_01 <= 1959 ~ "50-59",
          DE07_01 > 1940 & DE07_01 <= 1949 ~ "40-49",
          DE07_01 <= 1939                  ~ "<1940" ),
        age_buckets = factor( # Convert to factor
          age_buckets,
          level = c(">1999", "90-99", "80-89", "70-79", "60-69", "50-59", "40-49", "<1940") ),
        fan_buckets = case_when( 
          EI02_01 >= 100               ~ ">99",
          EI02_01 > 80 & EI02_01 <= 99 ~ "80-99",
          EI02_01 > 60 & EI02_01 <= 79 ~ "60-79",
          EI02_01 > 40 & EI02_01 <= 59 ~ "40-59",
          EI02_01 > 20 & EI02_01 <= 39 ~ "20-39",
          EI02_01 <= 19                ~ "<20"  ),
        fan_buckets = factor( 
          fan_buckets,
          level = c(">99", "80-99", "60-79", "40-59", "20-39", "<20") ),
        fan_lvl = if_else(fan_buckets %in% c(">99", "80-99"), 1.5, 0), # create a lvl out of every question for indicating fandom
        fan_lvl = if_else(EI01 >= 8, fan_lvl+1, fan_lvl), # season of bd
        fan_lvl = if_else(EI03_01 == 1, fan_lvl+2, fan_lvl), # fandom
        fan_lvl = if_else(IT04 == "1 Fantag", fan_lvl+1, # Fanday
                          if_else(IT04 %in% c("2 Fantage", "3 Fantage", "Mehr als 3 Fantage"), 
                                  fan_lvl+2, fan_lvl) ),
        fan_lvl = if_else(IT07 %in% c("Die Serie 'Der Bergdoktor' war ein Grund von vielen an den Wilden Kaiser zu reisen.", 
                                      "Die Serie 'Der Bergdoktor' war der Hauptgrund an den Wilden Kaiser zu reisen."), 
                          fan_lvl+1, fan_lvl), # motivation
        fan_ultra = if_else(fan_lvl >= 3, TRUE, FALSE)
      )
  
  
  # filter table of bad interviews and duplicates
  df_3 <- df_2 %>%
    filter(username != "") %>%                                 # filter out empty usernames
    filter(as.numeric(MAXPAGE) > 6)  %>%                       # filter unfinished interviews
    mutate(empty_values = rowSums(is.na(.)),                   # count empty rows
           group = str_sub(QUESTNNR, start = 4, end = 6) ) %>% # extract groups: Scr, Des, Pro
    filter(!(group == "Scr" & empty_values > 140) ) %>%   # sort out profiles from Scr with over 140 missing answers
    arrange(empty_values, DEG_TIME) %>%   # this arranges the Data that rows with more NAs and 
                                          # a high Degredation are filtered out by distinct below
    distinct(username, .keep_all = TRUE) %>% # this filters out all the double values
                                             # If there are multiple rows for a given combination of inputs, 
                                             # only the first row will be preserved.
    mutate(fan_filter = if_else(EI06_EI07 == "Keine Folge", 1, 0),
           fan_filter = if_else(EI01 == 0, fan_filter+1, fan_filter),
           fan_filter = if_else(EI02_01 <= 26, fan_filter+1.5, fan_filter),
           fan_filter = if_else(EI03_01 == 1, fan_filter+1, fan_filter) ) %>% 
    filter(!(fan_filter >= 2.5 & group == "Scr") ) %>% # filter for not fans in Scr group
    mutate(instalink_filter = if_else(IP14_52_54_56_58 == 1, 1, 0),
           instalink_filter = if_else(IP17_IP20_IP38 == 1, instalink_filter+1.5, instalink_filter)) %>% 
    filter(instalink_filter < 2.5 ) %>% # filter for people that did not look at the insta post
    select(-fan_filter,
           -instalink_filter)
    

  # clean up data: building logical values and convert to numeric
  df_4 <- df_3 %>% 
    mutate(index = row_number() ) %>% # add index
    mutate(EI03_01 = str_replace(EI03_01, "2", "TRUE"),
           EI03_01 = as.logical(str_replace(EI03_01, "1", "FALSE") ),
           IP01_IP21_IP39 = str_replace(IP01_IP21_IP39, "Ja", "TRUE"),
           IP01_IP21_IP39 = as.logical(str_replace(IP01_IP21_IP39, "Nein", "FALSE") ), 
           IP13_IP49 = str_replace(IP13_IP49, "Ja", "TRUE"),
           IP13_IP49 = as.logical(str_replace(IP13_IP49, "Nein", "FALSE") ),
           IP14_52_54_56_58 = str_replace(IP14_52_54_56_58, "2", "TRUE"),
           IP14_52_54_56_58 = as.logical(str_replace(IP14_52_54_56_58, "1", "FALSE") ),
           IP17_IP20_IP38 = str_replace(IP17_IP20_IP38, "Ja", "TRUE"),
           IP17_IP20_IP38 = as.logical(str_replace(IP17_IP20_IP38, "Nein", "FALSE") ),
           IP27_IP44 = str_replace(IP27_IP44, "Ja", "TRUE"),
           IP27_IP44 = as.logical(str_replace(IP27_IP44, "Nein", "FALSE") ),
           IP35_IP59_m = str_replace(IP35_IP59_m, "1", "TRUE"),
           IP35_IP59_m = replace_na(IP35_IP59_m, "FALSE"),
           IP35_IP59_m = as.logical(str_replace(IP35_IP59_m, "0", "FALSE") ),
           IP35_IP59_f = str_replace(IP35_IP59_f, "1", "TRUE"),
           IP35_IP59_f = replace_na(IP35_IP59_f, "FALSE"),
           IP35_IP59_f = as.logical(str_replace(IP35_IP59_f, "0", "FALSE") ),
           IT14 = str_replace(IT14, "Ja", "TRUE"),
           IT14 = as.logical(str_replace(IT14, "Nein", "FALSE") ),
           IT17 = str_replace(IT17, "Ja", "TRUE"),
           IT17 = as.logical(str_replace(IT17, "Nein", "FALSE") ),
           IT21_01 = str_replace(IT21_01, "2", "TRUE"),
           IT21_01 = as.logical(str_replace(IT21_01, "1", "FALSE") ),
           IT21_02 = str_replace(IT21_02, "2", "TRUE"),
           IT21_02 = as.logical(str_replace(IT21_02, "1", "FALSE") ),
           IT27_01 = str_replace(IT27_01, "2", "TRUE"),
           IT27_01 = str_replace(IT27_01, "-9", "NULL"),
           IT27_01 = as.logical(str_replace(IT27_01, "1", "FALSE") ),
           IT27_02 = str_replace(IT27_02, "2", "TRUE"),
           IT27_02 = str_replace(IT27_02, "-9", "NULL"),
           IT27_02 = as.logical(str_replace(IT27_02, "1", "FALSE") ),
           IT27_03 = str_replace(IT27_03, "2", "TRUE"),
           IT27_03 = str_replace(IT27_03, "-9", "NULL"),
           IT27_03 = as.logical(str_replace(IT27_03, "1", "FALSE") ),
           IT27_04 = str_replace(IT27_04, "2", "TRUE"),
           IT27_04 = str_replace(IT27_04, "-9", "NULL"),
           IT27_04 = as.logical(str_replace(IT27_04, "1", "FALSE") ) 
           ) %>% 
    mutate(IT24_01_IT33_01 = as.numeric(IT24_01_IT33_01) ) %>% 
    mutate(IT24_02_IT33_02 = as.numeric(IT24_02_IT33_02) ) %>% 
    mutate(IT24_03_IT33_03 = as.numeric(IT24_03_IT33_03) ) %>% 
    mutate(IT24_04_IT33_04 = as.numeric(IT24_04_IT33_04) ) %>% 
    mutate(IT24_05_IT33_05 = as.numeric(IT24_05_IT33_05) ) %>% 
    mutate(IT24_06_IT33_06 = as.numeric(IT24_06_IT33_06) ) %>% 
    mutate(IT24_07_IT33_07 = as.numeric(IT24_07_IT33_07) ) %>% 
    select(index,
           group,
           username,
           url,
           age_buckets,
           fan_buckets,
           fan_lvl,
           fan_ultra,
           select_colum_traceinterview,
           pts_corner_1,
           pts_corner_2,
           last_comment
    )
  
  # get rid of all the 9 and -1
  df_4[df_4 == -9] <- NA
  df_4[df_4 == -1] <- NA
  #TODO: Checken ob die wirklich rausfliegen müssen oder einen Sinn ergeben?
  
  
  # naming the columns
  # name the columns automatically
  df_5 <- df_4
  for (n in 1:length(df_5)){
    names(df_5)[n] = col_name_funct(n) #NOTE: col_name_function from sourced script!
  }
  
  
  # name some additional columns by hand
  df_5 <- df_5 %>% 
    rename(
          DE09_st_job = DE09_st_, 
          DE14_de_tourkind_nb = `DE14_de_residual_option_(negative)_or_number_of_selected_options`,
          DE14_09_de_otherscrt = `DE14_09a_de_andere,_bitte_spezifizieren_(free_text)`,
          DE16_de_tourtravel_nb= `DE16_de_residual_option_(negative)_or_number_of_selected_options`, 
          DE16_de_othervehicle_nb  = `DE16_08a_de_anderes,_bitte_spezifizieren_(free_text)`, 
          DE17_de_scrtimewk= DE17_de_, 
          DE21_pr_prtimebd= DE21_01_pr_bd, 
          EI01_st_seasonbd_nb = `EI01_st_residual_option_(negative)_or_number_of_selected_options`, 
          EI02_st_fan = `EI02_01_st_[no_description]_01`, 
          EI03_st_fandom = EI03_01_st_, 
          EI04_EI09_st_pr_timeinsta = EI04_EI09_, 
          EI06_EI07_st_episodesbd = EI06_EI07_, 
          EI08_EI10_01_de_aktiv = EI08_01_EI10_01_, 
          EI08_EI10_02_de_interessant = EI08_02_EI10_02_, 
          EI08_EI10_03_de_bescheiden = EI08_03_EI10_03_, 
          EI08_EI10_04_de_locker = EI08_04_EI10_04_, 
          EI08_EI10_05_de_formell = EI08_05_EI10_05_, 
          EI08_EI10_06_de_ehrlich= EI08_06_EI10_06_, 
          IP01_IP21_IP39_st_de_pr_repost = IP01_IP21_IP39_, 
          IP04_IP23_IP40_st_de_pr_hashtag = IP04_IP23_IP40_, 
          IP05_IP24_IP41_st_de_pr_mention = IP05_IP24_IP41_, 
          IP06_IP25_IP42_st_de_pr_text = IP06_IP25_IP42_, 
          IP07_IP26_IP43_st_de_pr_foto = IP07_IP26_IP43_, 
          IP08_IP45_st_pr_situation = IP08_IP45_, 
          IP11_IP30_IP47_st_de_pr_scrloc = IP11_IP30_IP47_, 
          IP12_IP31_IP48_st_de_pr_timefoto = IP12_IP31_IP48_,
          IP13_IP49_st_pr_directfoto = IP13_IP49_, 
          IP14_52_54_56_58_st_de_pr_instalinkseen = IP14_52_54_56_58_,
          IP17_IP20_IP38_st_de_pr_instalinkmy = IP17_IP20_IP38_,
          IP27_IP44_de_pr_commercial = IP27_IP44_, 
          IP32_IP50_de_pr_change = IP32_IP50_, 
          motiv_st_de_pr = IP35_IP59_m_, 
          motiv_koordinate_st_de_pr = IP35_IP59_m_pts_, 
          motiv_region_st_de_pr = IP35_IP59_m_rgs_, 
          corner_koordinate_1 = pts_corner_1_,
          corner_koordinate_2 =  pts_corner_2_,
          fotograf_st_de_pr  = IP35_IP59_f_, 
          fotograf_koordinate_st_de_pr = IP35_IP59_f_pts_, 
          fotograf_region_st_de_pr = IP35_IP59_f_rgs_, 
          IT05_01_st_urlstart = IT05_01_st_ich_war_vom_..._, 
          IT05_02_st_urlEnd  = IT05_02_st_bis_zum_..._, 
          IT09_st_locentdeckt = IT09_st_, 
          IT14_st_andere_filmorte = IT14_st_, 
          IT17_de_strategie = IT17_de_, 
          IT18_de_vorgaben = IT18_01_de_de, 
          IT20_de_season_nb = `IT20_de_residual_option_(negative)_or_number_of_selected_options`, 
          IT21_de_encouragescrt = IT21_01_de_, 
          IT21_de_encouragepro  = IT21_02_de_, 
          IT22_de_imagechange  = `IT22_01_de_[no_description]_01`, 
          IT24_IT33_01_de_pr_gruberhof = IT24_01_IT33_01_, 
          IT24_IT33_02_de_pr_praxis = IT24_02_IT33_02_, 
          IT24_IT33_03_de_pr_gasthof = IT24_03_IT33_03_, 
          IT24_IT33_04_de_pr_krankenhaus = IT24_04_IT33_04_, 
          IT24_IT33_05_de_pr_dorfplatz = IT24_05_IT33_05_, 
          IT24_IT33_06_de_pr_apotheke = IT24_06_IT33_06_, 
          IT24_IT33_07_de_pr_see = IT24_07_IT33_07_, 
          IT26_IT31_de_pr_fantage = IT26_IT31_, 
          IT27_de_vrpast  = IT27_01_de_, 
          IT27_de_vractive = IT27_02_de_, 
          IT27_de_vrfuture  = IT27_03_de_, 
          IT27_de_vrnothought  = IT27_04_de_, 
          IT28_pr_vorgabende = IT28_01_pr_de, # vielleicht mit IT28 zusammen führen?
          IT29_pr_vorgabenpr = IT29_01_pr_pr,
          QUESTNNR = QUESTNNR_interview, 
          LASTDATA = LASTDATA_updated,
          LASTPAGE = LASTPAGE_questionnaire, 
          MAXPAGE = MAXPAGE_participant, 
          MISSING = MISSING_percent,
          TIME_RSI = TIME_RSI_fast, 
          DEG_TIME = DEG_TIME_fast
    ) %>% 
    relocate(c(corner_koordinate_1, corner_koordinate_2), .after = motiv_region_st_de_pr)
  
  # clean up: replace all the "_" at the end of every column  
  for (n in 1:length(df_5)){
    names(df_5)[n] = str_replace(colnames(df_5[n]), "_$", "") 
  }
  

# between massage
print("I am doing shit, what are you doing?")


  
  
# buidling tables to save
  df_meta <- df_5 %>% 
    select(index,
           group,
           username,
           url,
           last_comment,
           QUESTNNR, 
           STARTED, FINISHED,
           TIME_SUM, 
           MAILSENT, 
           LASTDATA,
           Q_VIEWER, 
           LASTPAGE, MAXPAGE, 
           MISSING, MISSREL, 
           TIME_RSI, DEG_TIME)
  
  
  df_all <- df_5 %>% 
    select(index,
           group,
           username,
           url,
           everything(),
           -last_comment,
           -QUESTNNR, 
           -STARTED, -FINISHED,
           -TIME_SUM, 
           -MAILSENT, 
           -LASTDATA,
           -Q_VIEWER, 
           -LASTPAGE, -MAXPAGE, 
           -MISSING, -MISSREL, 
           -TIME_RSI, -DEG_TIME)
  
  
  df_st <- df_all %>% #build st table
    filter(str_detect(group, "Scr")) %>% 
    select_if(~!(all(is.na(.)) | all(. == "")))
  
  df_de <- df_all %>% #build de table
    filter(str_detect(group, "Des")) %>% 
    select_if(~!(all(is.na(.)) | all(. == "")))
  
  df_pr <- df_all %>% #build pr table
    filter(str_detect(group, "Pro")) %>% 
    select_if(~!(all(is.na(.)) | all(. == "")))

  
  
  

# save data
write.csv2(df_meta,
           file = paste0(paths$data_processed, 
                         "/", 
                         Sys.Date(),  
                         "_traceinterview_all_meta.csv"),
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_all,
           file = paste0(paths$data_processed, 
                         "/", 
                         Sys.Date(),  
                         "_traceinterview_all.csv"),
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_st,
           file = paste0(paths$data_processed, 
                         "/", 
                         Sys.Date(),  
                         "_traceinterview_st.csv"),
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_de,
           file = paste0(paths$data_processed, 
                         "/", 
                         Sys.Date(),  
                         "_traceinterview_de.csv"),
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")

write.csv2(df_pr,
           file = paste0(paths$data_processed, 
                         "/", 
                         Sys.Date(),  
                         "_traceinterview_pr.csv"),
           na = "",
           row.names = FALSE,
           fileEncoding = "UTF-8")


# Remove stuff
rm(df_1,
   df_1.2_traceinterview_var_raw,
   df_2,
   df_2_traceinterview_var_a,
   df_3,
   df_4,
   df_5,
   list_traceinterview_var_a)


# last message
print(paste0("Everything Done. Find Data here: ", paths$data_processed))













# end this shit
end_time <- Sys.time()
cat("End Script:", format(Sys.time(), "%H:%M:%S"), "\n", 
    "Differenz: ", difftime(end_time, start_time, units = "secs"), "Sekunden", "\n") 
