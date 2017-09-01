library(ggmap)
library(viridisLite)
library(viridis)
library(dplyr)
library(ggplot2)

# Para onde os deputados do Distrito Federal estão viajando?
airports <- read_csv(".\datasets\airports.csv")
head(airports, n = 5)

viagem_df_summ <- deputados %>%
  filter(sgUF == "DF" & 
           origem == "BSB" & 
           origem != '' & 
           destino_1 != 'BSB')

summary(viagem_df_summ)
is(viagem_df_summ)
f <- data.frame(ori = viagem_df_summ$origem, 
                des = viagem_df_summ$destino_1)

f_summ <- f %>%
  group_by(ori = viagem_df_summ$origem, 
           des = viagem_df_summ$destino_1) %>%
  summarise(
    f_cnt = n()
  ) %>%
  ungroup()

# flights summary
f_summ <- f %>%
  group_by(ori = viagem_df_summ$origem, 
           des = viagem_df_summ$destino_1) %>%
  summarise(
    f_cnt = n()
  ) %>%
  ungroup()

f_summ
# A tibble: 4 × 3
#     ori    des f_cnt
#  <fctr> <fctr> <int>
#1    BSB    AJU     3
#2    BSB    CGH     9
#3    BSB    GRU     2
#4    BSB    SDU     3

dt <- f_summ %>% 
  dplyr::left_join(airports, c("des" = "iata_faa")) %>%
  dplyr::rename(dest = des, 
                dest_lat = latitude, 
                dest_lon = longitude)
				
dt
# A tibble: 4 × 13
#     ori  dest f_cnt airport_id                                name           city country  iaco  dest_lat
#  <fctr> <chr> <int>      <int>                               <chr>          <chr>   <chr> <chr>     <dbl>
#1    BSB   AJU     3       2522                         Santa Maria        Aracaju  Brazil  SBAR -10.98400
#2    BSB   CGH     9       2618                           Congonhas      Sao Paulo  Brazil  SBSP -23.62669
#3    BSB   GRU     2       2564 Guarulhos Gov Andre Franco Montouro      Sao Paulo  Brazil  SBGR -23.43208
#4    BSB   SDU     3       2612                       Santos Dumont Rio De Janeiro  Brazil  SBRJ -22.91046

str(dt)
#Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	4 obs. of  13 variables:
# $ ori       : Factor w/ 112 levels "","AAX","AEP",..: 12 12 12 12
# $ dest      : chr  "AJU" "CGH" "GRU" "SDU"
# $ f_cnt     : int  3 9 2 3
# $ airport_id: int  2522 2618 2564 2612
# $ name      : chr  "Santa Maria" "Congonhas" "Guarulhos Gov Andre Franco Montouro" "Santos Dumont"
# $ city      : chr  "Aracaju" "Sao Paulo" "Sao Paulo" "Rio De Janeiro"
# $ country   : chr  "Brazil" "Brazil" "Brazil" "Brazil"
# $ iaco      : chr  "SBAR" "SBSP" "SBGR" "SBRJ"
# $ dest_lat  : num  -11 -23.6 -23.4 -22.9
# $ dest_lon  : num  -37.1 -46.7 -46.5 -43.2
# $ altitude  : int  23 2631 2459 11
# $ zone      : num  -3 -3 -3 -3
# $ dst       : chr  "S" "S" "S" "S"

map <- ggmap::get_map(location = c(lon = -43.955833, lat = -19.816944),
                      zoom = 5, 
                      maptype = "terrain", 
                      scale = 2, 
                      color = "color")

g <- ggmap::ggmap(map, darken = 0.5) +
  geom_curve(aes(x = -47.91862, y = -15.87110, xend = dest_lon, yend = dest_lat),
             data = dt, size = 1, curvature = 0.7) +
  geom_point(aes(x = dest_lon, y = dest_lat), data = dt, color = "red") +
  geom_text(data = dt, aes(x = dest_lon, y = dest_lat, label = dest), col = "black", 
            size = 3, nudge_x = .5, nudge_y = .5, fontface = "bold") +
  coord_cartesian() +
  viridis::scale_color_viridis(name = "Quantidade de viagens", option = "B", direction = -1) +
  guides(color = guide_colorbar(barwidth = 15, barheight = 0.5)) +
  theme(legend.position = "bottom")

plot(g)
