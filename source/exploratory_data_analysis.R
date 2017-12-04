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
SatisAnalysis <- SatisAnalysis %>% 
  group_by(Role) %>% 
  mutate(perc=Freq/sum(Freq))  
SatisAnalysis$perc <- SatisAnalysis$perc*100
#plot counts
ggplot(SatisAnalysis, aes(x= Role, y=perc)) + 
  coord_flip() + 
  ggtitle("Job Satisfaction by Job Role") +
  facet_grid(Department~.) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity") + 
  labs(x= "Job Role", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4")) +





#### Exploring trends in Department and Environment####
EnvironAnalysis <- data.frame(table(analysis_df$Department, analysis_df$EnvironmentSatisfaction))
colnames(EnvironAnalysis) <- c("Department", "Satisfaction", "Freq")
EnvironAnalysis <- EnvironAnalysis %>% 
  group_by(Department) %>% 
  mutate(perc=Freq/sum(Freq))

ggplot(EnvironAnalysis, aes(x= Department, y=perc)) + 
  coord_flip() + 
  ggtitle("Environment Satisfaction by Department") + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity", position = "dodge") + 
  labs(x= "Department", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"))





#### Exploring trends in job involvement and Job role####
InvolvAnalysis <- data.frame(table(analysis_df$JobRole, analysis_df$JobInvolvement, analysis_df$Department))
InvolvAnalysis <- transform(InvolvAnalysis, Var1 = ifelse(Var1 == 'Manager' , paste(Var1, Var3, sep = ",") , as.character(Var1)))
InvolvAnalysis <- InvolvAnalysis[ ! InvolvAnalysis$Freq==0, ]
InvolvAnalysis <- InvolvAnalysis %>% 
group_by(Var1) %>% 
mutate(perc=Freq/sum(Freq))
InvolvAnalysis$perc <- InvolvAnalysis$perc *100
ggplot(InvolvAnalysis, aes(x= Var1, y=perc)) + 
ggtitle("Job Involvement by Job Role") + 
theme(plot.title = element_text(hjust = 0.5)) + 
geom_bar(aes(fill=Var2), stat="identity", position = "dodge") + 
labs(x= "Job Role", y= "Percentage Involvement")  + 
scale_y_continuous(expand = c(0,0)) +
scale_fill_manual(values=c("yellow", "orange", "red" , "red4")) +
facet_grid(Var3~.) +
coord_flip()
