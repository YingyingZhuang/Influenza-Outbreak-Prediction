library(tidyverse)
library(readr)
library(ggplot2)
library(corrplot)
# read files
flu_data <- read_csv("/Users/zhuangyingying/Desktop/info6105/finalproject/yingyingzhuang_final_project/flu_train_clean_final.csv")
keyword_map <- read_csv("/Users/zhuangyingying/Desktop/info6105/finalproject/yingyingzhuang_final_project/keyword_mapping.csv")

# The outbreak level is added: higher than the median is High, otherwise Low
flu_data$group <- ifelse(flu_data$outbreak > median(flu_data$outbreak), "High", "Low")

# The average keyword frequency is calculated in groups
keyword_totals <- flu_data %>%
  group_by(group) %>%
  summarise(across(starts_with("keyword_"), mean))

# Transpose the keyword matrix
keyword_df <- as.data.frame(t(keyword_totals[-1]))
colnames(keyword_df) <- keyword_totals$group
keyword_df$keyword <- rownames(keyword_df)

# Match the real name of the keyword
top_keywords <- keyword_df %>%
  mutate(diff = High - Low) %>%
  arrange(desc(diff)) %>%
  head(10) %>%
  left_join(keyword_map, by = c("keyword" = "column"))

# Plot bar charts with real names
ggplot(top_keywords, aes(x = reorder(name, diff), y = diff)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(title = "Top 10 Keywords More Common in High-Outbreak Regions",
       x = "Keyword", y = "Mean Frequency Difference")

# The top 20 keywords with the strongest correlation with outbreak were extracted for the correlogram
keyword_data <- flu_data %>% select(starts_with("keyword_"))
cor_with_outbreak <- cor(keyword_data, flu_data$outbreak)
top_corr_indices <- order(abs(cor_with_outbreak), decreasing = TRUE)[1:20]
top_keyword_data <- keyword_data[, top_corr_indices]
#get orginal keyword
top_keyword_cols <- colnames(top_keyword_data)

# Find the real names corresponding to these columns
real_names <- keyword_map %>%
  filter(column %in% top_keyword_cols) %>%
  arrange(match(column, top_keyword_cols)) %>%
  pull(name)

# replace names
colnames(top_keyword_data) <- real_names

# Q1:Which keywords are more frequently associated with regions experiencing flu outbreaks?
#The relevance heatmap of the reduced keywords is calculated and plotted
cor_top <- cor(top_keyword_data)
corrplot(cor_top, method = "color", tl.cex = 0.8)
#Q2:Can keyword frequency data be used to build a simple model to predict the likelihood of an outbreak?
# Perform PCA dimensionality reduction (principal component analysis)
pca_result <- prcomp(keyword_data, scale. = TRUE)

# View the proportion of variance explained by each principal component
summary(pca_result)

# Extract the first five principal components
pca_data <- as.data.frame(pca_result$x[, 1:5])
pca_data$outbreak <- flu_data$outbreak

# Build a regression model: Use the first five principal components to predict outbreak days
model <- lm(outbreak ~ ., data = pca_data)

# View model results
summary(model)

# Visualize the relationship between the first principal component and outbreak
ggplot(pca_data, aes(x = PC1, y = outbreak)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "steelblue") +
  labs(title = "Relationship Between PC1 and Outbreak Days",
       x = "Principal Component 1 (PC1)", y = "Outbreak Days")

# Visualize the relationship between the second principal component and outbreak
ggplot(pca_data, aes(x = PC2, y = outbreak)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "steelblue") +
  labs(title = "Relationship Between PC2 and Outbreak Days",
       x = "Principal Component 3 (PC2)", y = "Outbreak Days")
