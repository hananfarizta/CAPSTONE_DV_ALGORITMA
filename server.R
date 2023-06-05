
function(input, output) {
  
output$coffee_flavour <- renderPlotly({
    
cof_flav <- coffee_ratings %>% 
      filter(country_of_origin == input$v_country) %>% 
      select(aroma:cupper_points) %>% 
      gather() %>% 
      group_by(key) %>% 
      summarise(value = mean(value)) %>% 
      ungroup() %>% 
      mutate(key = str_replace(key, "_", " ") %>% str_to_title()) %>% 
      mutate(key = fct_reorder(key, value))
plot_flav <- cof_flav %>%      
      ggplot(aes(x = key, y = value, color = key)) + 
      geom_point(size = 5) + 
      geom_segment(aes(x = key, xend = key, y = value, yend = 0)) + 
      theme(legend.position = "none") + 
      ylab("") + 
      xlab("") + 
      coord_flip() + 
      labs(title = "Avg Flavour Profile")
ggplotly(plot_flav, tooltip = "text")

  })
  
output$coffee_variety <- renderPlotly({
    
cof_var <- coffee_ratings %>% 
      filter(country_of_origin == input$v_country) %>% 
      select(variety) %>% 
      drop_na() %>% 
      count(variety) %>% 
      mutate(variety = fct_reorder(variety, n)) 
plot_var <- cof_var %>%      
      ggplot(aes(x = n, y = variety, fill = variety)) + 
      geom_col() + 
      ylab("") + 
      labs(title = "Bean Variety") + 
      theme(legend.position = "none")
ggplotly(plot_var, tooltip = "text")

  })
  
  
output$coffee_dif <- renderPlotly({
      
cof_dif <- coffee_ratings %>% 
      select(country_of_origin, aroma:cupper_points) %>% 
      mutate(highlight = if_else(country_of_origin == input$v_country, "Highlight", "No-Highlight")) %>% 
      select(-country_of_origin) %>% 
      gather(key = "key", value = "value", -highlight) %>% 
      group_by(key) %>% 
      do(t_test = t.test(value~highlight, data = .) %>% tidy()) %>% 
      unnest(t_test) %>% 
      mutate(diffference = case_when(
        conf.low < 0 & conf.high < 0 ~ "Different",
        conf.low > 0 & conf.high > 0 ~ "Different",
        TRUE ~ "Not-Different"
      )) %>% 
      mutate(key = str_replace(key, "_", " ") %>% str_to_title()) %>% 
      mutate(key = fct_reorder(key, -estimate))

plot_dif <- cof_dif %>%
      ggplot(aes(x = key, y = estimate, color = diffference)) + 
      geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) + 
      geom_hline(yintercept = 0, linetype = "dashed") + 
      coord_flip() + 
      theme(legend.position = "none") + 
      xlab("") + 
      labs(title = "How different are the flavour profiles?")
ggplotly(plot_dif,tooltip = "text")
  })
  
  
output$coffee_table <- renderDataTable({
    
      coffee_ratings %>% 
      filter(country_of_origin == input$v_country) %>% 
      select(points = total_cup_points, species, country = country_of_origin, region) %>% 
      group_by(species, region) %>% 
      arrange(desc(points)) %>% 
      slice(1) %>% 
      ungroup() %>% 
      mutate(region = str_trunc(region, 12, "right")) %>% 
      arrange(desc(points))
    
  })
  
output$cof_rate <- renderDataTable({
    DT:: datatable(data = cof_clean, options = list(scrollX=T))
  })
  
}
