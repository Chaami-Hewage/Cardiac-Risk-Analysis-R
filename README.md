# 🫀 Heart Attack Risk Analysis & Prediction
> **An End-to-End Data Science Project in R**

This repository contains a comprehensive analysis and machine learning pipeline to predict heart attack risk. By leveraging patient health data, this project demonstrates how to move from raw data to a deployable **Logistic Regression** model with high predictive accuracy.

---

## 📋 Table of Contents
* [Project Overview](#-project-overview)
* [Data Insights](#-data-insights)
* [Machine Learning Pipeline](#-machine-learning-pipeline)
* [Key Performance Metrics](#-key-performance-metrics)

---

## 🔍 Project Overview
The primary goal of this project was to identify the most significant clinical features (such as cholesterol, maximum heart rate, and chest pain type) that lead to a high risk of heart attack. 

**Key Achievements:**
* **Accuracy:** 82.46%
* **Robustness:** Handled outliers and skewed data distributions.
* **Clarity:** Developed stable code using Base R and `ggplot2` for maximum compatibility.

---

## 📊 Data Insights

### 1. Feature Correlation
We utilized a **Correlation Heatmap** to visualize the relationships between numeric variables. This step ensures we understand multicollinearity before feeding data into the model.

### 2. Risk Factors
Our **Bivariate Analysis** (Boxplots with Jitter) revealed that **Maximum Heart Rate (`thalachh`)** is a critical differentiator. Patients in the high-risk category consistently showed higher peak heart rates.

---

## ⚙️ Machine Learning Pipeline
I implemented a clean, professional pipeline directly in R:

1. **EDA:** Distribution checks using histograms and pie charts.
2. **Preprocessing:** * Outlier removal using the **1.5 * IQR** rule.
    * Log transformation (`log1p`) for skewed features like `oldpeak`.
3. **Splitting:** 80/20 Train-Test split for unbiased evaluation.
4. **Modeling:** Logistic Regression (`glm`) with a binomial link function.

---

## 📈 Key Performance Metrics
The model was evaluated using a **Confusion Matrix**, showing excellent sensitivity (critical for medical applications):

| Metric | Value |
| :--- | :--- |
| **Accuracy** | **82.46%** |
| **True Positives** | 29 |
| **True Negatives** | 18 |
| **False Negatives** | **Only 2** (High Sensitivity) |

> **Note:** In cardiac prediction, minimizing **False Negatives** is vital to ensure no high-risk patient goes undetected.
