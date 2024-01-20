# USArrests data
# load packages
library(dplyr)
mydata<-USArrests
# structure
mydata %>% 
  str()
# summary
mydata %>% 
  summary()
# first few observation
mydata %>% 
  head()
# assigning row names to object
states=rownames(mydata)
mydata1<-mydata %>% 
  mutate(state=states)
str(mydata1)
mydata1%>% 
  head()
# second menuitem
# creatin histogram and boxplot for distribution
p1=mydata1 %>% 
  plot_ly() %>% 
  add_histogram(~Rape) %>% 
  layout(xaxis=list(title='Rape'))
# boxplot
p2=mydata1 %>% 
  plot_ly() %>% 
  add_boxplot(~Rape) %>% 
  layout(yaxis=list(showticklabels=F))
# stacking plots 
subplot(p2,p1, nrows=2) %>% 
hide_legend() %>% 
  layout(title='Distribution chart- Histogram and boxplot',
         yaxis=list(title='frequency'))
#choice for select input without states column
str(mydata1)
ch<-mydata1 %>% 
  select(-state) %>% 
  names()
# relationship betwween variable
p=mydata1%>% 
  ggplot(aes(x=Rape, y=Assault))+
  geom_point()+
  geom_smooth(method = 'lm')+
  labs(title = 'Relationship betwween rape and assualt arrest',
       x='Rape',
       y='Assault')+
  theme(plot.title = element_textbox_simple(size=10,
                                         halign = 0.5))
ggplotly(p)
# compute a matrix of correlation p-value

#choice for select input without states column
c1=mydata1 %>% 
  select(-state) %>% 
  names()
c2=mydata1 %>% 
  select(-state,-UrbanPop) %>% 
  names()
# top 5 states with high rates
mydata1 %>% 
  select(state,Rape) %>% 
  arrange(desc(Rape)) %>% 
  head(5)
# top 5 states with low rates
mydata1 %>% 
  select(state,Rape) %>% 
  arrange(Rape) %>% 
  head(5)

state_map <- map_data("state") 
my_data1 = mydata1 %>% 
  mutate(State = tolower(state))  
merged =right_join(my_data1, state_map,  by=c("State" = "region"))
st = data.frame(abb = state.abb, stname=tolower(state.name), 
                x=state.center$x, y=state.center$y)
new_join = left_join(merged, st, by=c("State" = "stname"))
