* ============================================================ *
* Title: Statistical Analysis of Judicial Cases Data           *
* Description: Comparison of Experimental Group and Control    *
*              Group                                           *
* Date: 2025                                                    *
* ============================================================ *.

* ============================================================ *
* 1. Define Path and Open Data File                            *
* ============================================================ *.

FILE HANDLE data /NAME = "C:\Data\Judicial_Cases.sav".
GET FILE = data.

* ============================================================ *
* 2. Display Data Structure                                    *
* ============================================================ *.

DISPLAY DICTIONARY.

* Variables:
* - Group: Group (1 = Experimental, 2 = Control)
* - Cycle_Time: Case Processing Time (Days)
* - Auth_Time: Authentication Time (Hours)
* - Evidence_Count: Number of Digital Evidence Items
* - Session_Count: Number of Court Sessions
* - Case_Type: Type of Crime (1=Fraud, 2=Unauthorized Access, 3=Forgery, 4=Data Breach, 5=Other).

* ============================================================ *
* 3. Descriptive Statistics                                    *
* ============================================================ *.

* 3-1. Descriptive Statistics for All Data.
DESCRIPTIVES VARIABLES = Cycle_Time Auth_Time Evidence_Count Session_Count
  /STATISTICS = MEAN STDDEV MIN MAX.

* 3-2. Descriptive Statistics by Group.
MEANS TABLES = Cycle_Time Auth_Time Evidence_Count Session_Count BY Group
  /CELLS = MEAN STDDEV MIN MAX COUNT.

* ============================================================ *
* 4. Normality Test (Shapiro-Wilk)                             *
* ============================================================ *.

* 4-1. Normality Test for All Data.
EXAMINE VARIABLES = Cycle_Time Auth_Time Evidence_Count Session_Count
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /MISSING LISTWISE.

* 4-2. Normality Test by Group.
EXAMINE VARIABLES = Cycle_Time BY Group
  /PLOT NONE
  /STATISTICS DESCRIPTIVES.

* ============================================================ *
* 5. Independent Samples t-test                                *
* ============================================================ *.

* 5-1. t-test for Cycle Time.
T-TEST GROUPS = Group(1 2)
  /MISSING = ANALYSIS
  /VARIABLES = Cycle_Time
  /CRITERIA = CI(.95).

* 5-2. t-test for Authentication Time.
T-TEST GROUPS = Group(1 2)
  /MISSING = ANALYSIS
  /VARIABLES = Auth_Time
  /CRITERIA = CI(.95).

* 5-3. t-test for Digital Evidence Count.
T-TEST GROUPS = Group(1 2)
  /MISSING = ANALYSIS
  /VARIABLES = Evidence_Count
  /CRITERIA = CI(.95).

* 5-4. t-test for Session Count.
T-TEST GROUPS = Group(1 2)
  /MISSING = ANALYSIS
  /VARIABLES = Session_Count
  /CRITERIA = CI(.95).

* ============================================================ *
* 6. Analysis of Covariance (ANCOVA)                           *
* ============================================================ *.

* 6-1. ANCOVA for Cycle Time Controlling Confounding Variables.
UNIANOVA Cycle_Time BY Group WITH Evidence_Count Session_Count
  /METHOD = SSTYPE(3)
  /INTERCEPT = INCLUDE
  /CRITERIA = ALPHA(.05)
  /DESIGN = Evidence_Count Session_Count Group.

* 6-2. ANCOVA with Interaction (Testing Homogeneity of Slopes).
UNIANOVA Cycle_Time BY Group WITH Evidence_Count
  /METHOD = SSTYPE(3)
  /INTERCEPT = INCLUDE
  /CRITERIA = ALPHA(.05)
  /DESIGN = Evidence_Count Group Evidence_Count*Group.

* ============================================================ *
* 7. Multiple Linear Regression                                 *
* ============================================================ *.

* 7-1. Multiple Linear Regression for Predicting Cycle Time.
REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA = PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Cycle_Time
  /METHOD = ENTER Group Evidence_Count Session_Count Auth_Time.

* 7-2. Stepwise Regression for Identifying Important Predictors.
REGRESSION
  /DESCRIPTIVES MEAN STDDEV CORR SIG N
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /CRITERIA = PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT Cycle_Time
  /METHOD = STEPWISE Group Evidence_Count Session_Count Auth_Time.

* ============================================================ *
* 8. Multivariate Analysis of Variance (MANOVA)               *
* ============================================================ *.

MANOVA Cycle_Time Auth_Time BY Group(1 2)
  /MISSING = LISTWISE
  /PRINT = SIGNIF(MULTIV UNIV).

* ============================================================ *
* 9. Non-Parametric Tests (Validation)                         *
* ============================================================ *.

* 9-1. Mann-Whitney Test for Cycle Time.
NPAR TESTS
  /M-W = Cycle_Time BY Group(1 2)
  /STATISTICS = DESCRIPTIVES.

* 9-2. Kruskal-Wallis Test.
NPAR TESTS
  /K-W = Cycle_Time BY Group(1 2)
  /STATISTICS = DESCRIPTIVES.

* ============================================================ *
* 10. Sensitivity Analysis                                     *
* ============================================================ *.

* 10-1. Sensitivity Analysis by Arrival Rate (Categorized).
* Assume variable Arrival_Rate exists (1=Low, 2=Medium, 3=High).
UNIANOVA Backlog_Rate BY Group Arrival_Rate
  /METHOD = SSTYPE(3)
  /INTERCEPT = INCLUDE
  /CRITERIA = ALPHA(.05)
  /DESIGN = Group Arrival_Rate Group*Arrival_Rate.

* ============================================================ *
* 11. Charts and Graphs                                        *
* ============================================================ *.

* 11-1. Boxplot for Group Comparison.
GRAPH
  /BOXPLOT Group BY Cycle_Time.

* 11-2. Boxplot by Case Type.
GRAPH
  /BOXPLOT Case_Type BY Cycle_Time.

* 11-3. Histogram with Normal Curve.
GGRAPH
  /GRAPHDATASET NAME = "graphdataset" VARIABLES = Cycle_Time Group
  /GRAPHSPEC SOURCE = INLINE.
BEGIN GPL
  SOURCE: s = userSource(id("graphdataset"))
  DATA: Cycle_Time = col(source(s), name("Cycle_Time"))
  DATA: Group = col(source(s), name("Group"), unit.category())
  TRANS: Cycle_Time_lab = eval("Cycle Time (Days)")
  GUIDE: axis(dim(1), label(Cycle_Time_lab))
  GUIDE: axis(dim(2), label("Frequency"))
  ELEMENT: interval(position(summary.Count, bin.hex(Cycle_Time)), color.interior(Group), shape.interior(shape.polygon))
END GPL.

* 11-4. Scatterplot for Relationship Analysis.
GRAPH
  /SCATTERPLOT(BIVAR) = Evidence_Count WITH Cycle_Time BY Group.

* ============================================================ *
* 12. Effect Size Calculation                                  *
* ============================================================ *.

* 12-1. Glass's Delta.
* First calculate the control group standard deviation.
* Then use manual calculation.

* 12-2. Cohen's d Effect Size from t-test.
* Effect size is reported in t-test output.

* 12-3. Eta-squared for ANCOVA.
* Eta-squared is reported in UNIANOVA output.

* ============================================================ *
* 13. Reliability Analysis                                     *
* ============================================================ *.

* 13-1. Cronbach's Alpha for Performance Metrics.
RELIABILITY
  /VARIABLES = Cycle_Time Auth_Time Backlog_Rate
  /SCALE('ALL VARIABLES') ALL
  /MODEL = ALPHA.

* ============================================================ *
* 14. Hypothesis Testing                                       *
* ============================================================ *.

* Hypothesis H1: Proposed model reduces cycle time.
* → t-test for mean comparison (already performed).

* Hypothesis H2: Proposed model increases accuracy and interoperability.
* → Regression analysis to examine contribution of each component.

* Hypothesis H3: Proposed model performs better than traditional system.
* → MANOVA for simultaneous performance indicators.

* ============================================================ *
* 15. Save Output                                              *
* ============================================================ *.

OUTPUT SAVE
  /OUTFILE = "C:\Data\Judicial_Analysis_Output.spv".

* End of SPSS Code.