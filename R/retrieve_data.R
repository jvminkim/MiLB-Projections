library(dplyr)

fg_minors_standard = read.csv('data-raw/fg-minors-standard.csv')
fg_minors_advanced = read.csv('data-raw/fg-minors-advanced.csv')
fg_minors_bb = read.csv('data-raw/fg-minors-bb.csv')

fg_minors_total = fg_minors_standard %>%
  filter(Level == "AAA" | Level == "AA" | Level == "A+" | Level == "A") %>%
  inner_join(select(fg_minors_advanced, -c(Age,
                                           Name,
                                           PA)
                   ), by = c("PlayerId", "Team", "Level", "Season", "AVG")) %>%
  inner_join(select(fg_minors_bb, -c(Name,
                                     Age,
                                     PA))
            , by = c("PlayerId", "Team", "Level", "Season", "BABIP")) %>%
  unique()

saveRDS(fg_minors_total, "data-raw/fg_minors_total.csv")

fg_minors_final = fg_minors_total %>%
  group_by(PlayerId) %>%
  arrange(Season) %>%
  mutate(lag_seasons = ifelse(dplyr::lag(Season, 1) != Season,1,0)) #%>%
 # mutate(One_Y_GP = dplyr::lag(G,lag_seasons))

josh_lester = fg_minors_final %>%
  filter(Name == "Josh Lester") %>%
  select(Name, Season, Team, Level, G, lag_seasons)




