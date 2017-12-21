library(magrittr)
library(highcharter)
library(dplyr)
library(broom)

data(diamonds, package = "ggplot2")

set.seed(123)
data <- sample_n(diamonds, 300)

modlss <- loess(price ~ carat, data = data)
fit <- arrange(augment(modlss), carat)

head(fit)

highchart() %>% 
  hc_add_series(data, type = "scatter",
                hcaes(x = carat, y = price, size = depth, group = cut)) %>%
  hc_add_series(fit, type = "spline", hcaes(x = carat, y = .fitted),
                name = "Fit", id = "fit") %>% 
  hc_add_series(fit, type = "arearange",
                hcaes(x = carat, low = .fitted - 2*.se.fit,
                      high = .fitted + 2*.se.fit),
                linkedTo = "fit")
