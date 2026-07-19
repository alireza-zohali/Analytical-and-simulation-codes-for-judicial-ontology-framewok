# ============================================================ #
# Title: Statistical Analysis of Judicial Cases Data           #
# Description: Comparison of Experimental Group and Control    #
#              Group                                           #
# Date: 2025                                                    #
# ============================================================ #

# ============================================================ #
# 1. Load Required Libraries                                   #
# ============================================================ #

# Install packages if needed
# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("effsize")
# install.packages("psych")
# install.packages("car")
# install.packages("MASS")
# install.packages("boot")
# install.packages("gridExtra")
# install.packages("corrplot")
# install.packages("lmtest")
# install.packages("performance")
# install.packages("pwr")
# install.packages("relaimpo")

# Load libraries
library(tidyverse)
library(ggplot2)
library(effsize)
library(psych)
library(car)
library(MASS)
library(boot)
library(gridExtra)
library(corrplot)
library(lmtest)
library(performance)

# ============================================================ #
# 2. Set Working Directory and Load Data                      #
# ============================================================ #

# Set working directory
setwd("C:/Data")

# Load data (assuming CSV file)
df <- read.csv("Judicial_Cases.csv", encoding = "UTF-8")

# Check data structure
str(df)
head(df)
summary(df)

# Convert Group variable to factor
df$Group <- as.factor(df$Group)
levels(df$Group) <- c("Experimental", "Control")

# Convert Case_Type to factor
df$Case_Type <- as.factor(df$Case_Type)
levels(df$Case_Type) <- c("Cyber_Fraud", "Unauthorized_Access", "Digital_Forgery", 
                          "Data_Breach", "Other_Cybercrime")

# Display data summary
cat("\n=== Data Summary ===\n")
summary(df)

# ============================================================ #
# 3. Descriptive Statistics                                    #
# ============================================================ #

cat("\n=== Descriptive Statistics by Group ===\n")
df %>%
  group_by(Group) %>%
  summarise(
    N = n(),
    Cycle_Time_Mean = mean(Cycle_Time, na.rm = TRUE),
    Cycle_Time_SD = sd(Cycle_Time, na.rm = TRUE),
    Cycle_Time_Min = min(Cycle_Time, na.rm = TRUE),
    Cycle_Time_Max = max(Cycle_Time, na.rm = TRUE),
    Auth_Time_Mean = mean(Auth_Time, na.rm = TRUE),
    Auth_Time_SD = sd(Auth_Time, na.rm = TRUE),
    Evidence_Count_Mean = mean(Evidence_Count, na.rm = TRUE),
    Evidence_Count_SD = sd(Evidence_Count, na.rm = TRUE),
    Session_Count_Mean = mean(Session_Count, na.rm = TRUE),
    Session_Count_SD = sd(Session_Count, na.rm = TRUE)
  ) %>%
  print()

# ============================================================ #
# 4. Normality Test (Shapiro-Wilk)                             #
# ============================================================ #

cat("\n=== Shapiro-Wilk Normality Test ===\n")

# 4-1. Normality test for all data
shapiro_cycle <- shapiro.test(df$Cycle_Time)
cat("Cycle Time: W =", shapiro_cycle$statistic, 
    ", p-value =", shapiro_cycle$p.value, "\n")

shapiro_auth <- shapiro.test(df$Auth_Time)
cat("Authentication Time: W =", shapiro_auth$statistic, 
    ", p-value =", shapiro_auth$p.value, "\n")

# 4-2. Normality test by group
shapiro_exp <- shapiro.test(df[df$Group == "Experimental", "Cycle_Time"])
cat("Experimental Group - Cycle Time: W =", shapiro_exp$statistic, 
    ", p-value =", shapiro_exp$p.value, "\n")

shapiro_ctrl <- shapiro.test(df[df$Group == "Control", "Cycle_Time"])
cat("Control Group - Cycle Time: W =", shapiro_ctrl$statistic, 
    ", p-value =", shapiro_ctrl$p.value, "\n")

# 4-3. Q-Q Plots for visualization
par(mfrow = c(2, 2))
qqnorm(df[df$Group == "Experimental", "Cycle_Time"], 
       main = "Q-Q Plot - Experimental Group (Cycle Time)")
qqline(df[df$Group == "Experimental", "Cycle_Time"], col = "red")

qqnorm(df[df$Group == "Control", "Cycle_Time"], 
       main = "Q-Q Plot - Control Group (Cycle Time)")
qqline(df[df$Group == "Control", "Cycle_Time"], col = "red")

qqnorm(df[df$Group == "Experimental", "Auth_Time"], 
       main = "Q-Q Plot - Experimental Group (Auth Time)")
qqline(df[df$Group == "Experimental", "Auth_Time"], col = "red")

qqnorm(df[df$Group == "Control", "Auth_Time"], 
       main = "Q-Q Plot - Control Group (Auth Time)")
qqline(df[df$Group == "Control", "Auth_Time"], col = "red")

# ============================================================ #
# 5. Independent Samples t-test                                #
# ============================================================ #

cat("\n=== Independent Samples t-test ===\n")

# 5-1. t-test for Cycle Time
t_test_cycle <- t.test(Cycle_Time ~ Group, data = df, var.equal = FALSE)
cat("\n--- Cycle Time ---\n")
print(t_test_cycle)

# 5-2. t-test for Authentication Time
t_test_auth <- t.test(Auth_Time ~ Group, data = df, var.equal = FALSE)
cat("\n--- Authentication Time ---\n")
print(t_test_auth)

# 5-3. t-test for Digital Evidence Count
t_test_evidence <- t.test(Evidence_Count ~ Group, data = df, var.equal = FALSE)
cat("\n--- Digital Evidence Count ---\n")
print(t_test_evidence)

# 5-4. t-test for Session Count
t_test_session <- t.test(Session_Count ~ Group, data = df, var.equal = FALSE)
cat("\n--- Session Count ---\n")
print(t_test_session)

# ============================================================ #
# 6. Effect Size (Cohen's d)                                  #
# ============================================================ #

cat("\n=== Cohen's d Effect Size ===\n")

# 6-1. Effect size for Cycle Time
d_cycle <- cohen.d(df$Cycle_Time ~ df$Group)
cat("Cycle Time: d =", d_cycle$estimate, "\n")

# 6-2. Effect size for Authentication Time
d_auth <- cohen.d(df$Auth_Time ~ df$Group)
cat("Authentication Time: d =", d_auth$estimate, "\n")

# ============================================================ #
# 7. Analysis of Covariance (ANCOVA)                           #
# ============================================================ #

cat("\n=== Analysis of Covariance (ANCOVA) ===\n")

# 7-1. ANCOVA for Cycle Time
ancova_model <- aov(Cycle_Time ~ Group + Evidence_Count + Session_Count, data = df)
cat("\n--- ANCOVA Model ---\n")
summary(ancova_model)

# 7-2. ANCOVA with interaction (Testing homogeneity of slopes)
ancova_interaction <- aov(Cycle_Time ~ Group * Evidence_Count, data = df)
cat("\n--- ANCOVA Model with Interaction ---\n")
summary(ancova_interaction)

# 7-3. Eta-squared calculation
eta_squared <- function(model) {
  ss <- summary(model)[[1]]$`Sum Sq`
  ss_total <- sum(ss)
  ss / ss_total
}
cat("\n--- Eta-squared ---\n")
print(eta_squared(ancova_model))

# ============================================================ #
# 8. Multiple Linear Regression                                 #
# ============================================================ #

cat("\n=== Multiple Linear Regression ===\n")

# 8-1. Full regression model
reg_model <- lm(Cycle_Time ~ Group + Evidence_Count + Session_Count + Auth_Time, data = df)
cat("\n--- Full Regression Model ---\n")
summary(reg_model)

# 8-2. Regression assumptions checking
cat("\n--- Regression Assumptions ---\n")

# Linearity
plot(reg_model$fitted.values, reg_model$residuals, 
     main = "Linearity - Residuals vs Fitted",
     xlab = "Fitted Values", ylab = "Residuals")
abline(h = 0, col = "red")

# Normality of residuals
shapiro.test(reg_model$residuals)

# Independence of residuals (Durbin-Watson)
dw_test <- dwtest(reg_model)
cat("Durbin-Watson test: statistic =", dw_test$statistic, 
    ", p-value =", dw_test$p.value, "\n")

# Homoscedasticity (Breusch-Pagan)
bp_test <- bptest(reg_model)
cat("Breusch-Pagan test: statistic =", bp_test$statistic, 
    ", p-value =", bp_test$p.value, "\n")

# 8-3. R-squared
cat("\n--- R-squared ---\n")
cat("R-squared =", summary(reg_model)$r.squared, "\n")
cat("Adjusted R-squared =", summary(reg_model)$adj.r.squared, "\n")

# 8-4. Standardized coefficients
cat("\n--- Standardized Coefficients ---\n")
lm.beta <- function(model) {
  b <- summary(model)$coefficients[-1, 1]
  sx <- sapply(model$model[-1], sd)
  sy <- sd(model$model[, 1])
  b * sx / sy
}
print(lm.beta(reg_model))

# 8-5. Relative importance of predictors
cat("\n--- Relative Importance (lmg) ---\n")
if (require(relaimpo)) {
  calc.relimp(reg_model, type = "lmg")
} else {
  cat("Package 'relaimpo' not installed. Run: install.packages('relaimpo')\n")
}

# ============================================================ #
# 9. Multivariate Analysis of Variance (MANOVA)               #
# ============================================================ #

cat("\n=== Multivariate Analysis of Variance (MANOVA) ===\n")

manova_model <- manova(cbind(Cycle_Time, Auth_Time) ~ Group, data = df)
summary(manova_model)

# ============================================================ #
# 10. Bootstrap Analysis                                       #
# ============================================================ #

cat("\n=== Bootstrap Analysis ===\n")

# 10-1. Bootstrap function for mean difference
boot_diff <- function(data, indices) {
  d <- data[indices, ]
  return(mean(d$Cycle_Time[d$Group == "Experimental"]) - 
         mean(d$Cycle_Time[d$Group == "Control"]))
}

# 10-2. Run bootstrap with 1000 replications
set.seed(123)
boot_results <- boot(df, boot_diff, R = 1000)

cat("Mean Difference:", boot_results$t0, "\n")
cat("Standard Error:", sd(boot_results$t), "\n")
cat("95% Confidence Interval (BCa):", 
    boot.ci(boot_results, type = "bca")$bca[4:5], "\n")

# 10-3. Bootstrap distribution
hist(boot_results$t, breaks = 30, 
     main = "Bootstrap Distribution - Mean Difference",
     xlab = "Mean Cycle Time Difference (Days)")
abline(v = boot_results$t0, col = "red", lwd = 2)

# ============================================================ #
# 11. Sensitivity Analysis                                     #
# ============================================================ #

cat("\n=== Sensitivity Analysis ===\n")

# 11-1. Sensitivity analysis removing outliers
z_scores <- scale(df$Cycle_Time)
outliers <- abs(z_scores) > 3
df_clean <- df[!outliers, ]

cat("Number of outliers removed:", sum(outliers), "\n")

# 11-2. Re-run t-test without outliers
t_test_clean <- t.test(Cycle_Time ~ Group, data = df_clean, var.equal = FALSE)
cat("t-test without outliers:\n")
print(t_test_clean)

# 11-3. Sensitivity analysis by case type
cat("\n--- Sensitivity Analysis by Case Type ---\n")
df %>%
  group_by(Case_Type) %>%
  summarise(
    Cycle_Time_Mean_Experimental = mean(Cycle_Time[Group == "Experimental"]),
    Cycle_Time_Mean_Control = mean(Cycle_Time[Group == "Control"]),
    Difference = Cycle_Time_Mean_Experimental - Cycle_Time_Mean_Control,
    N_Experimental = sum(Group == "Experimental"),
    N_Control = sum(Group == "Control")
  ) %>%
  print()

# ============================================================ #
# 12. Charts and Graphs                                        #
# ============================================================ #

# 12-1. Boxplot for Cycle Time
p1 <- ggplot(df, aes(x = Group, y = Cycle_Time, fill = Group)) +
  geom_boxplot() +
  labs(title = "Comparison of Cycle Time Between Groups",
       x = "Group", y = "Cycle Time (Days)") +
  theme_minimal() +
  scale_fill_manual(values = c("Experimental" = "#2E86C1", "Control" = "#E74C3C"))

# 12-2. Boxplot for Authentication Time
p2 <- ggplot(df, aes(x = Group, y = Auth_Time, fill = Group)) +
  geom_boxplot() +
  labs(title = "Comparison of Authentication Time Between Groups",
       x = "Group", y = "Authentication Time (Hours)") +
  theme_minimal() +
  scale_fill_manual(values = c("Experimental" = "#2E86C1", "Control" = "#E74C3C"))

# 12-3. Histogram of Cycle Time by Group
p3 <- ggplot(df, aes(x = Cycle_Time, fill = Group)) +
  geom_histogram(alpha = 0.6, position = "identity", bins = 20) +
  labs(title = "Distribution of Cycle Time by Group",
       x = "Cycle Time (Days)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = c("Experimental" = "#2E86C1", "Control" = "#E74C3C"))

# 12-4. Scatterplot
p4 <- ggplot(df, aes(x = Evidence_Count, y = Cycle_Time, color = Group)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Relationship Between Evidence Count and Cycle Time",
       x = "Digital Evidence Count", y = "Cycle Time (Days)") +
  theme_minimal() +
  scale_color_manual(values = c("Experimental" = "#2E86C1", "Control" = "#E74C3C"))

# Display plots in one grid
grid.arrange(p1, p2, p3, p4, nrow = 2, ncol = 2)

# Save plots
ggsave("Cycle_Time_Boxplot.png", p1, width = 8, height = 6, dpi = 300)
ggsave("Auth_Time_Boxplot.png", p2, width = 8, height = 6, dpi = 300)
ggsave("Cycle_Time_Histogram.png", p3, width = 8, height = 6, dpi = 300)
ggsave("Evidence_Cycle_Scatter.png", p4, width = 8, height = 6, dpi = 300)

# ============================================================ #
# 13. Correlation Matrix                                       #
# ============================================================ #

cat("\n=== Correlation Matrix ===\n")

cor_matrix <- df %>%
  select(Cycle_Time, Auth_Time, Evidence_Count, Session_Count) %>%
  cor()

print(cor_matrix)

# Correlation matrix visualization
corrplot(cor_matrix, method = "number", type = "upper", 
         title = "Correlation Matrix", mar = c(0, 0, 2, 0))

# ============================================================ #
# 14. Reliability Analysis                                     #
# ============================================================ #

cat("\n=== Reliability Analysis (Cronbach's Alpha) ===\n")

# 14-1. Cronbach's Alpha for performance metrics
alpha_data <- df[, c("Cycle_Time", "Auth_Time")]
alpha_result <- psych::alpha(alpha_data)
print(alpha_result)

# ============================================================ #
# 15. Power Analysis                                           #
# ============================================================ #

cat("\n=== Power Analysis ===\n")

# 15-1. Power analysis for t-test
if (require(pwr)) {
  power_result <- pwr.t.test(n = 210, d = 1.84, sig.level = 0.05, type = "two.sample")
  cat("Statistical Power:", power_result$power, "\n")
} else {
  cat("Package 'pwr' not installed.\n")
}

# ============================================================ #
# 16. Final Results Report                                      #
# ============================================================ #

cat("\n=== Final Results Summary ===\n")

# Collect results in a table
results_table <- data.frame(
  Indicator = c("Cycle Time (Days)", "Authentication Time (Hours)", 
                "Digital Evidence Count", "Session Count"),
  Experimental_Group = c(mean(df[df$Group == "Experimental", "Cycle_Time"]),
                         mean(df[df$Group == "Experimental", "Auth_Time"]),
                         mean(df[df$Group == "Experimental", "Evidence_Count"]),
                         mean(df[df$Group == "Experimental", "Session_Count"])),
  Control_Group = c(mean(df[df$Group == "Control", "Cycle_Time"]),
                    mean(df[df$Group == "Control", "Auth_Time"]),
                    mean(df[df$Group == "Control", "Evidence_Count"]),
                    mean(df[df$Group == "Control", "Session_Count"])),
  Improvement_Percent = c((1 - mean(df[df$Group == "Experimental", "Cycle_Time"]) / 
                           mean(df[df$Group == "Control", "Cycle_Time"])) * 100,
                         (1 - mean(df[df$Group == "Experimental", "Auth_Time"]) / 
                           mean(df[df$Group == "Control", "Auth_Time"])) * 100,
                         NA, NA)
)

print(results_table)

cat("\n=== Analysis Complete ===\n")