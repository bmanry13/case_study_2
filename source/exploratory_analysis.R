#### Opening data source
library(readxl)
analysis_df <- read_xlsx("rawdata/CaseStudy2data/CaseStudy2-data.xlsx") 
#### Exploring trends in job role and Job Satisfaction####
library(ggplot2)
SatisAnalysis <- data.frame('Department' = analysis_df$Department, 'JobRole' = analysis_df$JobRole, 'JobSatisfaction' = analysis_df$JobSatisfaction)
#manager overlaps in department, so add department to distinguish 
SatisAnalysis <- transform(SatisAnalysis, JobRole = ifelse(JobRole == 'Manager' , paste(JobRole, Department, sep = ",") , as.character(JobRole)))
#find count of Job Satisfactions within job role
SatisAnalysis <- data.frame(table(SatisAnalysis$JobRole, SatisAnalysis$JobSatisfaction, SatisAnalysis$Department))
colnames(SatisAnalysis) <- c("Role", "Satisfaction", "Department", "Freq")
SatisAnalysis <- SatisAnalysis[ ! SatisAnalysis$Freq==0, ]   
#change counts to percentages
SatisAnalysis$Percentages <- 
SatisAnalysis <- SatisAnalysis %>% 
  group_by(Role,Department) %>% 
  mutate(perc=Freq/sum(Freq))  
#plot counts
ggplot(SatisAnalysis, aes(x= Role, y=perc)) + 
  coord_flip() + 
  ggtitle("Job Satisfaction by Job Role") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity") + 
  labs(x= "Job Role", y= "Percentage")  + 
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))
ggsave("job_satisfaction.png", width= 7, height = 3.78)


#### Exploring trends in Department and Environment####
EnvironAnalysis <- data.frame(table(analysis_df$Department, analysis_df$EnvironmentSatisfaction))
  EnvironAnalysis <- EnvironAnalysis %>% 
  group_by(Var1) %>% 
  mutate(perc=Freq/sum(Freq))
ggplot(EnvironAnalysis, aes(x= Var1, y=perc)) + 
  coord_flip() + 
  ggtitle("Environment Satisfaction by Department") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Var2), stat="identity") + 
  labs(x= "Department", y= "Percentage")  + 
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))

