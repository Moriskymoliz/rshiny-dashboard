function(input,output,session){
  # structure
  output$structure<-renderPrint(
    mydata %>% 
      str()
  )
  #summary
  output$summary<-renderPrint(
    mydata %>% 
      summary()
  )
  #DataTable
  output$dataT<-renderDataTable(
    mydata
  )
  # stacked histogram and boxplot
  output$histplot<-renderPlotly({
    p1=mydata1 %>% 
      plot_ly() %>% 
      add_histogram(~get(input$var1)) %>% 
      layout(xaxis=list(title=input$var1))
    # boxplot
    p2=mydata1 %>% 
      plot_ly() %>% 
      add_boxplot(~get(input$var1)) %>% 
      layout(yaxis=list(showticklabels=F))
    # stacking plots 
    subplot(p2,p1, nrows=2) %>% 
      hide_legend() %>% 
      layout(title='Distribution chart- Histogram and boxplot',
             yaxis=list(title='frequency'))
  })
  output$scatter<-renderPlotly({
    p=mydata1%>% 
      ggplot(aes(x=get(input$var2), y=get(input$var3)))+
      geom_point()+
      geom_smooth(method = get(input$fit))+
      labs(title = paste("Relationship betwween", input$var2, "and " ,input$var3, "arrest"),
           x=input$var2,
           y=input$var3)+
      theme(plot.title = element_textbox_simple(size=10,
                                                halign = 0.5))
    ggplotly(p)
 } )
  output$cor<-renderPlotly({
    my_df<-mydata1 %>% 
      select(-state)
    #compute a correlation matrix
    corr<-round(cor(my_df),1)
    #compute a matrix of correlation p values
    p.mat<-cor_pmat(my_df)
    corr.plot<-ggcorrplot(
      corr,
      hc.order=TRUE,
      lab = TRUE,
      outline.color = 'white',
      p.mat = p.mat
    )
    ggplotly(corr.plot)
  })
  output$bar<-renderPlotly({
    mydata1 %>% 
      plot_ly() %>% 
      add_bars(x=~state,y= ~get(input$var4)) %>% 
      layout(title=paste('statewisw arrests for', input$var4),
             xaxis=list(title=input$var4),
             yaxis=list(title=paste(input$var4,'arresr are 100,000 residents')))
  })
  # box header
  output$head1<-renderText({
    paste('5 states with high rate of',input$var4,'arrests')
  })
  output$head2<-renderText({
    paste('5 states with low rate of',input$var4,'arrests')
  })
  # tables
  # table high arrest for specific crime type
  output$top5<-renderTable({
    mydata1 %>% 
      select(state,input$var4) %>% 
      arrange(desc(get(input$var4))) %>% 
      head(5)
  })
  # table low arrest for specific crime type
  output$low5<-renderTable({
    mydata1 %>% 
      select(state,input$var4) %>% 
      arrange(get(input$var4)) %>% 
      head(5)
  })
  # Choropleth map
  output$map_plot <- renderPlot({
    new_join %>% 
      ggplot(aes(x=long, y=lat,fill=get(input$crimetype) , group = group)) +
      geom_polygon(color="black", size=0.4) +
      scale_fill_gradient(low="#73A5C6", high="#001B3A", name = paste(input$crimetype, "Arrest rate")) +
      theme_void() +
      labs(title = paste("Choropleth map of", input$crimetype , " Arrests per 100,000 residents by state in 1973")) +
      theme(
        plot.title = element_textbox_simple(face="bold", 
                                            size=18,
                                            halign=0.5),
        
        legend.position = c(0.2, 0.1),
        legend.direction = "horizontal"
        
      ) +
      geom_text(aes(x=x, y=y, label=abb), size = 4, color="white")
    
    
    
  })
}