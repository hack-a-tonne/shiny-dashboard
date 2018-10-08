  
if(!eval(parse(text="require(pacman)"))) 
{ 
  install.packages("pacman")
  eval(parse(text="require(pacman)"))
}
pacman::p_load(
    jsonlite, httr, httpuv,
    ggplot2, ggthemes,
    lubridate
  )

df  <- GET(url = "https://hackertonne.azurewebsites.net/api/GetValuesByDevice?device_id=14")

if(status_code(df) == 200)
{
  content <- jsonlite::fromJSON(content(df))
  sensor <- data.frame("time" = as.POSIXct(content$labels, format = "%d.%m.%Y %H:%M:%S"))
  sensor$temperature <- content$datasets$data[[1]]
  
  # Temperature over time
  ggplot(sensor, aes(x=time, y=temperature))+
    geom_line()+
    geom_point()+
    theme_pander()+
    scale_x_datetime(date_labels = "%d.%m.%Y %H:%M:%S")+
    geom_smooth()
} 