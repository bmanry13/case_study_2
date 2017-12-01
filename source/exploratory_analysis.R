#### Exploring trends in job role and Job Satisfaction####
library(ggplot2)
SatisAnalysis <- data.frame('Department' = analysis_df$Department, 'JobRole' = analysis_df$JobRole, 'JobSatisfaction' = analysis_df$JobSatisfaction)
#manager overlaps in department, so add department to distinguish 
SatisAnalysis <- transform(SatisAnalysis, JobRole = ifelse(JobRole == 'Manager' , paste(JobRole, Department, sep = ",") , as.character(JobRole)))
#find count of Job Satisfactions within job role
SatisAnalysis <- data.frame(table(SatisAnalysis$JobRole, SatisAnalysis$JobSatisfaction, SatisAnalysis$Department))
colnames(SatisAnalysis) <- c("Role", "Satisfaction", "Department", "Freq")
SatisAnalysis <- SatisAnalysis[ ! SatisAnalysis$Freq==0, ]   
#plot counts
ggplot(SatisAnalysis, aes(x= Role, y=Freq)) + 
  coord_flip() + 
  ggtitle("Job Satisfaction by Job Role") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity") + 
  labs(x= "Job Role", y= "Frequency")  + 
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))


