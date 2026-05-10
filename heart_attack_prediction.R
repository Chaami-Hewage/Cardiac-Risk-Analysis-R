#1. Introduction & Variables
#In R, we start by loading the "Tidyverse" (for data) and "Tidymodels" (for the engine).
# This installs the foundation and the missing pieces you encountered
install.packages(c("tidyverse", "tidymodels", "farver", "naniar", "GGally", "corrplot", "vip"))
install.packages("stringi")
install.packages(c("GGally", "corrplot", "ggbeeswarm"))

# ==========================================
# 2. Project Initialization
# ==========================================
# 2.1 Installing/Loading (Run install.packages if needed)
library(tidyverse)   # 2.1.1 Basic libraries (ggplot, dplyr, readr)
library(tidymodels)  # Advanced ML Framework
library(naniar)      # 3.1 Missing value analysis
library(GGally)      # 5.2 Pair-plots
library(corrplot)    # 5.7 Heatmap
library(reshape2)    # 5.4 Melt function)


# 2.2 Load the dataset
heart_data <- read_csv("C:/Users/Asus/Desktop/heart_attack_prediction/heart.csv")

# 2.3 Initial dataset analysis
glimpse(heart_data) 
summary(heart_data)


# 3. Exploratory Data Analysis (Preparation)
# R handles categorical variables as factors. This is a crucial "advanced" step.
# 3.1 & 3.2 Missing and Unique values
res_missing <- miss_var_summary(heart_data)
unique_counts <- map(heart_data, ~length(unique(.x)))

# 3.3 Separating Variables
# In R, we often define lists of column names for easier looping
num_vars <- c("age", "trtbps", "chol", "thalachh", "oldpeak")
cat_vars <- c("sex", "cp", "fbs", "restecg", "exng", "slp", "caa", "thall")

# 4. Uni-variate Analysis
# 4.1.1 Numerical (Density Plots)
heart_data %>%
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) + 
  facet_wrap(~key, scales = "free") + 
  geom_density(fill="midnightblue", alpha=0.5)

# 4.1.2 Categorical (Pie Charts / Bar Charts)
# Note: Pie charts are less common in R; Bar charts are preferred for accuracy
ggplot(heart_data, aes(x = factor(cp))) + geom_bar(fill = "coral")

# 4.1.1 Numerical (Histogram)
par(mfrow=c(2,3)) # Set up a grid for 6 plots
for(var in num_vars) {
  hist(heart_data[[var]], main=var, col="skyblue", xlab=var)
}
par(mfrow=c(1,1)) # Reset grid



# 4.1.2 Categorical (Pie Chart)
target_counts <- table(heart_data$output)
pie(target_counts, labels = c("Low Risk (0)", "High Risk (1)"), 
    main = "Distribution of Target Variable", col = c("green", "red"))







# 3.1 Examine missing values (Base R way)
# This prints a list of how many NAs are in each column
colSums(is.na(heart_data))

# 3.3 Separating variables
num_vars <- c("age", "trtbps", "chol", "thalachh", "oldpeak")


# Heatmap
# Calculate correlation matrix
numeric_data <- heart_data[, num_vars]
res_cor <- cor(numeric_data, use = "complete.obs")

# Generate the Heatmap
# 'Rowv=NA' and 'Colv=NA' keeps the order simple
heatmap(res_cor, 
        Rowv = NA, Colv = NA, 
        col = terrain.colors(256), 
        margins = c(10,10),
        main = "5.7 Correlation Heatmap (Base R)")



# Swarm Plot
library(ggplot2) 

# Boxplot + Data Points (Categorical vs Numerical)
ggplot(heart_data, aes(x = factor(output), y = thalachh, fill = factor(output))) +
  geom_boxplot(outlier.shape = NA) + # The boxplot
  geom_jitter(width = 0.2, alpha = 0.5) + # The "Easy" Swarm effect
  theme_minimal() +
  labs(title = "5.5 Thalachh Distribution", x = "Heart Attack Risk", y = "Max Heart Rate")


# ==========================================
# 6. Outlier Handling & Transformation
# ==========================================
# 6.3 Simple Outlier Removal (Using 1.5 * IQR rule)
clean_data <- heart_data
for(var in num_vars) {
  Q1 <- quantile(clean_data[[var]], 0.25)
  Q3 <- quantile(clean_data[[var]], 0.75)
  IQR_val <- Q3 - Q1
  clean_data <- clean_data[clean_data[[var]] >= (Q1 - 1.5*IQR_val) & 
                             clean_data[[var]] <= (Q3 + 1.5*IQR_val), ]
}

# 8. Log Transformation for skewed data (e.g., oldpeak)
clean_data$oldpeak <- log1p(clean_data$oldpeak)



# ==========================================
# 11. Train/Test Split
# ==========================================
set.seed(123)
indices <- sample(1:nrow(clean_data), 0.8 * nrow(clean_data))
train_data <- clean_data[indices, ]
test_data  <- clean_data[-indices, ]



# ==========================================
# 12. Modeling & Evaluation
# ==========================================
# 12.1 Logistic Regression (Standard R Model)
model <- glm(output ~ ., data = train_data, family = binomial)

# 12.3 Hyperparameter Opt (Simple approach: Threshold Tuning)
# Instead of complex grids, we find the best cut-off for probability
probs <- predict(model, test_data, type = "response")

# 12.2 Accuracy and Metrics
preds <- ifelse(probs > 0.5, 1, 0)
accuracy <- mean(preds == test_data$output)
print(paste("Final Model Accuracy:", round(accuracy * 100, 2), "%"))

# Confusion Matrix
table(Predicted = preds, Actual = test_data$output)

