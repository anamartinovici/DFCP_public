rm(list=ls())

library(tidyverse)
library(RDCOMClient)

load("send_emails_from_R/student_list.RDAta")
load("send_emails_from_R/GDPR_IA2.RDAta")

n_students <- nrow(BMME129)

# random assignment of presenter number
BMME129$Presenter <- sample(c(1:n_students), n_students, replace = FALSE)

# check if everyone has a presenter number
table(BMME129$Presenter)
length(table(BMME129$Presenter))
max(table(BMME129$Presenter))

# get name and email address
IA2 <- IA2 %>% left_join(BMME129, by = "Presenter")
# concatenate page numbers
IA2$pages <- paste(IA2$Page1, ", ", IA2$Page2, ", and ", IA2$Page3, sep = "")

# for every student
for(i in 1:n_students) {
    # create an Outlook application
    # note that if you want to use gmail or another email client, you need to make adjustments
  OutApp <- COMCreate("Outlook.Application")
  
  ## create an email object
  outMail = OutApp$CreateItem(0)
  
  ## configure email parameter
  ## get the email address
  outMail[["To"]] <- paste0(IA2 %>% filter(Presenter == i) %>% select(email))
  ## cc if needed
  outMail[["CC"]] <- "not_a_real_email@test.com"
  outMail[["subject"]] <- paste("Individual Assignment 2 - DGPR page numbers for presenter number ", i, sep = "")
  outMail[["HTMLbody"]] <- paste(paste("Dear ", IA2 %>% filter(Presenter == i) %>% select(Roepnaam), ", <br>", sep = ""),
                                 paste("The page numbers assigned to you are: ", IA2 %>% filter(Presenter == i) %>% select(pages), ". <br>", sep = ""),
                                 paste("You cand find more information about the assignment on Canvas.<br>Best regards,<br>Ana"))
  
  ## send it
  outMail$Send()
}
