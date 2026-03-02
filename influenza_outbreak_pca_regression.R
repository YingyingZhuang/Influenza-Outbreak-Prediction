# 加载必要的库
library(tidyverse)
library(readr)
library(ggplot2)
library(corrplot)

# 读取数据
flu_data <- read_csv("flu_train_outbreak_counts.csv")

# 提取关键词数据
keyword_data <- flu_data %>% select(starts_with("keyword_"))

# 执行 PCA 降维（主成分分析）
pca_result <- prcomp(keyword_data, scale. = TRUE)

# 查看每个主成分解释的方差比例（可选）
summary(pca_result)

# 提取前 5 个主成分
pca_data <- as.data.frame(pca_result$x[, 1:5])
pca_data$outbreak <- flu_data$outbreak

# 构建回归模型：使用前 5 个主成分预测 outbreak 天数
model <- lm(outbreak ~ ., data = pca_data)

# 查看模型结果
summary(model)

# 可视化第一个主成分与 outbreak 的关系
ggplot(pca_data, aes(x = PC1, y = outbreak)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "steelblue") +
  labs(title = "Relationship Between PC1 and Outbreak Days",
       x = "Principal Component 1 (PC1)", y = "Outbreak Days")
