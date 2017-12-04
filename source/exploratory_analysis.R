#### Opening data source
library(readxl)
library(tidyr)
library(dplyr)
analysis_df <- read_xlsx("rawdata/CaseStudy2-data.xlsx") 

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
  facet_grid(Department~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(aes(fill=Satisfaction), stat="identity", position = "dodge", colour = "black") + 
  labs(x= "Job Role", y= "Percentage Satisfaction")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,45)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4") , labels=c("Low", "Medium", "High", "Very High"))
ggsave("job_satisfaction.png", width= 7, height = 3.78)

chisq.test(SatisAnalysis$Satisfaction,SatisAnalysis$Role)

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
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4") , labels=c("Low", "Medium", "High", "Very High"))



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
  geom_bar(aes(fill=Var2), stat="identity", position = "dodge" , colour="black") + 
  labs(x= "Job Role", y= "Percentage Involvement")  + 
  scale_y_continuous(expand = c(0,0), limits = c(0,70)) +
  scale_fill_manual(values=c("yellow", "orange", "red" , "red4"), labels=c("Low", "Medium", "High", "Very High")) +
  facet_grid(Var3~.) +
  coord_flip() +
  facet_grid(Var3~., scales = "free", space = "free") +
  theme(strip.text.x = element_text(angle = 0)) 


####### Monthly income and job satisfaction#######



#YearsInCurrentRole
#Monthly income
#YearsSinceLastPromotion
#WorkLifeBalance
#PerformanceRating
#NumCompaniesWorked

#Salary difference between income by attrition
t.test(MonthlyIncome~Attrition, data=analysis_df)
#Total Working Years and Monthly salary
t.test(MonthlyIncome~PerformanceRating, data=analysis_df)
#Years with Manager and Attrition
t.test(YearsWithCurrManager~Attrition, data = analysis_df)
#Years since promotion and attrition
t.test(YearsSinceLastPromotion~Attrition, data = analysis_df)
#Difference in Working Years and Attrition
t.test(TotalWorkingYears~Attrition, data = analysis_df)
#Difference in companies worked and attrition
t.test(NumCompaniesWorked~Attrition, data = analysis_df)
#Difference in years in current role and attrition
t.test(YearsInCurrentRole~Attrition, data = analysis_df)

t.test(DistanceFromHome~Attrition, data = analysis_df)

t.test(JobLevel~Attrition, data = analysis_df)

