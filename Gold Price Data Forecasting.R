install.packages("forecast")
install.packages("lmtest")
library(lmtest)
library(forecast)
Gold_Data<-read.csv("C:/Users/Lenovo/Downloads/Average Price of Gold in India 1971-2024.csv")
head(Gold_Data)
str(Gold_Data)
colnames(Gold_Data) <- c("Year", "GoldPrice")
head(Gold_Data)
gold_ts <- ts(Gold_Data$GoldPrice, start = min(Gold_Data$Year), end = max(Gold_Data$Year), frequency = 1)
ts.plot(gold_ts, main = "Gold Price Over Years", ylab = "Gold Price (Rs. per kg)", xlab = "Year")
acf(gold_ts, main = "ACF of Gold Prices")
pacf(gold_ts, main = "PACF of Gold Prices")
time <- seq_along(Gold_Data$GoldPrice)
model <- lm(Gold_Data$GoldPrice ~ time)
dwtest(model)

# Difference the series to make it stationary
gold_diff <- diff(gold_ts)

# Plotting the differenced series to check for stationarity
ts.plot(gold_diff, main = "Differenced Gold Price Series", ylab = "Differenced Gold Price", xlab = "Year")

# Checking ACF and PACF plots for the differenced series
acf(gold_diff, main = "ACF of Differenced Gold Prices")
pacf(gold_diff, main = "PACF of Differenced Gold Prices")
time_diff <- seq_along(gold_diff)  # Creating a time variable for differenced series
model_diff <- lm(gold_diff ~ time_diff)
dwtest(model_diff)


#########################
#### ARIMA MODELING #######
for (lag in 1:5){
  # For ARIMA wit ar
  ar_model<-arima(gold_diff,order = c(lag,0,0))
  # For Moving Average
  ma_model<-arima(gold_diff,order = c(0,0,lag))
  print(paste("Lag:",lag))
  print(paste( "AR model AIC:",AIC(ar_model)))
  print(paste( "AR model BIC:",BIC(ar_model)))
  print(paste( "MA model AIC:",AIC(ma_model)))
  print(paste( "MA model BIC:",BIC(ma_model)))
}

# Results as list 
results_list<-list()
for (lag in 1:5){
  # For ARIMA wit ar
  ar_model<-arima(gold_diff,order = c(lag,0,0))
  # For Moving Average
  ma_model<-arima(gold_diff,order = c(0,0,lag))
  results_list[[lag]]<-list(LAG=lag,
                            AIC_AR=AIC(ar_model),
                            BIC_AR=BIC(ar_model),
                            AIC_MA=AIC(ma_model),
                            BIC_MA=BIC(ma_model))
}
# list to data frame
result_df<-do.call(rbind,lapply(results_list, as.data.frame))
print(result_df)  
# Results to csv
write.csv(result_df,"gold_diff_AIC_BIC_Results.csv",row.names = F)
getwd()

###########################
##### Co-Efficient ######
results_list1<-list()
for (lag in 1:5){
  # For ARIMA wit ar
  ar_model<-arima(gold_diff,order = c(lag,0,0))
  # For Moving Average
  ma_model<-arima(gold_diff,order = c(0,0,lag))
  results_list1[[lag]]<-list(LAG=lag,
                             Coefficients_AR = ar_model$coef,
                             Coefficients_MA = ma_model$coef)
}
# list to data frame
result_df1<-do.call(rbind,lapply(results_list1, as.data.frame))
custom_row_names<-paste0(c("ar1","intercept1","ar11","ar2","intercept2","ar12","ar21","ar3","intercept3","ar13","ar22","ar31","ar4","intercept4","ar14","ar23","ar32","ar41","ar5","intercept5"))
rownames(result_df1) <- custom_row_names
print(result_df1) 


# Results to csv
write.csv(result_df1,"gold_diff_Coef_&Intercept_Results1.csv",row.names = T)
getwd()

###########################################################
# Modelling using inbuilt function
Model <- auto.arima(gold_diff)
summary(Model)

#AIC
Model$aic
#BIC
Model$bic
# Coefficients
Model$coef

# Model Diagnostics
residual_series<-residuals(Model)
plot(residual_series)
Acf(residual_series, main="ACF of Residuals")
Pacf(residual_series, main="PACF of Residuals")
qqnorm(residual_series)
qqline(residual_series, col = "RED")

# Dickey Fuller test
library(tseries)
df<-adf.test(gold_diff)
df

# Box test
box<-Box.test(residual_series)
box


#Forecasted Values
h <- 10  # Number of periods to forecast
f1 <- forecast(Model, h, level = c(95, 90))
f1
plot(f1, main = "Gold Price Forecast", ylab = "Differenced Gold Price")

