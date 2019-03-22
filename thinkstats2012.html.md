This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 11  Regression</span>
============================================================

<span style="font-size:medium"> </span><span id="regression"></span>

<span style="font-size:medium">The linear least squares fit in the
previous chapter is an example of <span
style="font-weight:bold">regression</span>, which is the more general
problem of fitting any kind of model to any kind of data. This use of
the term “regression” is a historical accident; it is only indirectly
related to the original meaning of the word. </span><span
id="hevea_default1153"></span><span style="font-size:medium">
</span><span id="hevea_default1154"></span>

<span style="font-size:medium">The goal of regression analysis is to
describe the relationship between one set of variables, called the <span
style="font-weight:bold">dependent variables</span>, and another set of
variables, called independent or <span
style="font-weight:bold">explanatory variables</span>. </span><span
id="hevea_default1155"></span><span style="font-size:medium">
</span><span id="hevea_default1156"></span>

<span style="font-size:medium">In the previous chapter we used mother’s
age as an explanatory variable to predict birth weight as a dependent
variable. When there is only one dependent and one explanatory variable,
that’s <span style="font-weight:bold">simple regression</span>. In this
chapter, we move on to <span style="font-weight:bold">multiple
regression</span>, with more than one explanatory variable. If there is
more than one dependent variable, that’s multivariate regression.
</span><span id="hevea_default1157"></span><span
style="font-size:medium"> </span><span
id="hevea_default1158"></span><span style="font-size:medium">
</span><span id="hevea_default1159"></span><span
style="font-size:medium"> </span><span id="hevea_default1160"></span>

<span style="font-size:medium">If the relationship between the dependent
and explanatory variable is linear, that’s <span
style="font-weight:bold">linear regression</span>. For example, if the
dependent variable is <span style="font-style:italic">y</span> and the
explanatory variables are <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">,
we would write the following linear regression model: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">y</span> = β</span><sub><span style="font-size:medium">0</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> + ε </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where β</span><sub><span
style="font-size:medium">0</span></sub><span style="font-size:medium">
is the intercept, β</span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
is the parameter associated with <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">,
β</span><sub><span style="font-size:medium">2</span></sub><span
style="font-size:medium"> is the parameter associated with <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">,
and ε is the residual due to random variation or other unknown factors.
</span><span id="hevea_default1161"></span><span
style="font-size:medium"> </span><span id="hevea_default1162"></span>

<span style="font-size:medium">Given a sequence of values for <span
style="font-style:italic">y</span> and sequences for <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">,
we can find the parameters, β</span><sub><span
style="font-size:medium">0</span></sub><span style="font-size:medium">,
β</span><sub><span style="font-size:medium">1</span></sub><span
style="font-size:medium">, and β</span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">,
that minimize the sum of ε</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">.
This process is called <span style="font-weight:bold">ordinary least
squares</span>. The computation is similar to <span
style="font-family:monospace">thinkstats2.LeastSquare</span>, but
generalized to deal with more than one explanatory variable. You can
find the details at </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Ordinary\_least\_squares</span>](https://en.wikipedia.org/wiki/Ordinary_least_squares)<span
style="font-size:medium"> </span><span
id="hevea_default1163"></span><span style="font-size:medium">
</span><span id="hevea_default1164"></span><span
style="font-size:medium"> </span><span id="hevea_default1165"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">regression.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.1  StatsModels</span>
-------------------------------------------------------

<span style="font-size:medium"> </span><span id="statsmodels"></span>

<span style="font-size:medium">In the previous chapter I presented <span
style="font-family:monospace">thinkstats2.LeastSquares</span>, an
implementation of simple linear regression intended to be easy to read.
For multiple regression we’ll switch to StatsModels, a Python package
that provides several forms of regression and other analyses. If you are
using Anaconda, you already have StatsModels; otherwise you might have
to install it. </span><span id="hevea_default1166"></span>

<span style="font-size:medium">As an example, I’ll run the model from
the previous chapter with StatsModels: </span><span
id="hevea_default1167"></span><span style="font-size:medium">
</span><span id="hevea_default1168"></span>

        import statsmodels.formula.api as smf

        live, firsts, others = first.MakeFrames()
        formula = 'totalwgt_lb ~ agepreg'
        model = smf.ols(formula, data=live)
        results = model.fit()

<span style="font-size:medium"><span
style="font-family:monospace">statsmodels</span> provides two interfaces
(APIs); the “formula” API uses strings to identify the dependent and
explanatory variables. It uses a syntax called <span
style="font-family:monospace">patsy</span>; in this example, the `~`
operator separates the dependent variable on the left from the
explanatory variables on the right. </span><span
id="hevea_default1169"></span><span style="font-size:medium">
</span><span id="hevea_default1170"></span><span
style="font-size:medium"> </span><span id="hevea_default1171"></span>

<span style="font-size:medium"><span
style="font-family:monospace">smf.ols</span> takes the formula string
and the DataFrame, <span style="font-family:monospace">live</span>, and
returns an OLS object that represents the model. The name <span
style="font-family:monospace">ols</span> stands for “ordinary least
squares.” </span><span id="hevea_default1172"></span><span
style="font-size:medium"> </span><span
id="hevea_default1173"></span><span style="font-size:medium">
</span><span id="hevea_default1174"></span>

<span style="font-size:medium">The <span
style="font-family:monospace">fit</span> method fits the model to the
data and returns a RegressionResults object that contains the results.
</span><span id="hevea_default1175"></span>

<span style="font-size:medium">The results are also available as
attributes. <span style="font-family:monospace">params</span> is a
Series that maps from variable names to their parameters, so we can get
the intercept and slope like this: </span><span
id="hevea_default1176"></span>

        inter = results.params['Intercept']
        slope = results.params['agepreg']

<span style="font-size:medium">The estimated parameters are 6.83 and
0.0175, the same as from <span
style="font-family:monospace">LeastSquares</span>. </span><span
id="hevea_default1177"></span>

<span style="font-size:medium"><span
style="font-family:monospace">pvalues</span> is a Series that maps from
variable names to the associated p-values, so we can check whether the
estimated slope is statistically significant: </span><span
id="hevea_default1178"></span><span style="font-size:medium">
</span><span id="hevea_default1179"></span><span
style="font-size:medium"> </span><span id="hevea_default1180"></span>

        slope_pvalue = results.pvalues['agepreg']

<span style="font-size:medium">The p-value associated with <span
style="font-family:monospace">agepreg</span> is <span
style="font-family:monospace">5.7e-11</span>, which is less than 0.001,
as expected. </span><span id="hevea_default1181"></span>

<span style="font-size:medium"><span
style="font-family:monospace">results.rsquared</span> contains <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
which is 0.0047. <span style="font-family:monospace">results</span> also
provides `f_pvalue`, which is the p-value associated with the model as a
whole, similar to testing whether <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is statistically significant. </span><span
id="hevea_default1182"></span><span style="font-size:medium">
</span><span id="hevea_default1183"></span><span
style="font-size:medium"> </span><span id="hevea_default1184"></span>

<span style="font-size:medium">And <span
style="font-family:monospace">results</span> provides <span
style="font-family:monospace">resid</span>, a sequence of residuals, and
<span style="font-family:monospace">fittedvalues</span>, a sequence of
fitted values corresponding to <span
style="font-family:monospace">agepreg</span>. </span><span
id="hevea_default1185"></span>

<span style="font-size:medium">The results object provides <span
style="font-family:monospace">summary()</span>, which represents the
results in a readable format. </span>

        print(results.summary())

<span style="font-size:medium">But it prints a lot of information that
is not relevant (yet), so I use a simpler function called <span
style="font-family:monospace">SummarizeResults</span>. Here are the
results of this model:</span>

    Intercept       6.83    (0)
    agepreg         0.0175  (5.72e-11)
    R^2 0.004738
    Std(ys) 1.408
    Std(res) 1.405

<span style="font-size:medium"><span
style="font-family:monospace">Std(ys)</span> is the standard deviation
of the dependent variable, which is the RMSE if you have to guess birth
weights without the benefit of any explanatory variables. <span
style="font-family:monospace">Std(res)</span> is the standard deviation
of the residuals, which is the RMSE if your guesses are informed by the
mother’s age. As we have already seen, knowing the mother’s age provides
no substantial improvement to the predictions. </span><span
id="hevea_default1186"></span><span style="font-size:medium">
</span><span id="hevea_default1187"></span><span
style="font-size:medium"> </span><span
id="hevea_default1188"></span><span style="font-size:medium">
</span><span id="hevea_default1189"></span><span
style="font-size:medium"> </span><span
id="hevea_default1190"></span><span style="font-size:medium">
</span><span id="hevea_default1191"></span><span
style="font-size:medium"> </span><span id="hevea_default1192"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.2  Multiple regression</span>
---------------------------------------------------------------

<span style="font-size:medium"> </span><span id="multiple"></span>

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">4.5</span>](thinkstats2005.html#birth_weights)<span
style="font-size:medium"> we saw that first babies tend to be lighter
than others, and this effect is statistically significant. But it is a
strange result because there is no obvious mechanism that would cause
first babies to be lighter. So we might wonder whether this relationship
is <span style="font-weight:bold">spurious</span>. </span><span
id="hevea_default1193"></span><span style="font-size:medium">
</span><span id="hevea_default1194"></span>

<span style="font-size:medium">In fact, there is a possible explanation
for this effect. We have seen that birth weight depends on mother’s age,
and we might expect that mothers of first babies are younger than
others. </span><span id="hevea_default1195"></span><span
style="font-size:medium"> </span><span id="hevea_default1196"></span>

<span style="font-size:medium">With a few calculations we can check
whether this explanation is plausible. Then we’ll use multiple
regression to investigate more carefully. First, let’s see how big the
difference in weight is:</span>

    diff_weight = firsts.totalwgt_lb.mean() - others.totalwgt_lb.mean()

<span style="font-size:medium">First babies are 0.125 lbs lighter, or 2
ounces. And the difference in ages:</span>

    diff_age = firsts.agepreg.mean() - others.agepreg.mean()

<span style="font-size:medium">The mothers of first babies are 3.59
years younger. Running the linear model again, we get the change in
birth weight as a function of age: </span><span
id="hevea_default1197"></span><span style="font-size:medium">
</span><span id="hevea_default1198"></span>

    results = smf.ols('totalwgt_lb ~ agepreg', data=live).fit()
    slope = results.params['agepreg']

<span style="font-size:medium">The slope is 0.0175 pounds per year. If
we multiply the slope by the difference in ages, we get the expected
difference in birth weight for first babies and others, due to mother’s
age:</span>

    slope * diff_age

<span style="font-size:medium">The result is 0.063, just about half of
the observed difference. So we conclude, tentatively, that the observed
difference in birth weight can be partly explained by the difference in
mother’s age. </span>

<span style="font-size:medium">Using multiple regression, we can explore
these relationships more systematically. </span><span
id="hevea_default1199"></span>

        live['isfirst'] = live.birthord == 1
        formula = 'totalwgt_lb ~ isfirst'
        results = smf.ols(formula, data=live).fit()

<span style="font-size:medium">The first line creates a new column named
<span style="font-family:monospace">isfirst</span> that is True for
first babies and false otherwise. Then we fit a model using <span
style="font-family:monospace">isfirst</span> as an explanatory variable.
</span><span id="hevea_default1200"></span><span
style="font-size:medium"> </span><span id="hevea_default1201"></span>

<span style="font-size:medium">Here are the results:</span>

    Intercept         7.33   (0)
    isfirst[T.True]  -0.125  (2.55e-05)
    R^2 0.00196

<span style="font-size:medium">Because <span
style="font-family:monospace">isfirst</span> is a boolean, <span
style="font-family:monospace">ols</span> treats it as a <span
style="font-weight:bold">categorical variable</span>, which means that
the values fall into categories, like True and False, and should not be
treated as numbers. The estimated parameter is the effect on birth
weight when <span style="font-family:monospace">isfirst</span> is true,
so the result, -0.125 lbs, is the difference in birth weight between
first babies and others. </span><span
id="hevea_default1202"></span><span style="font-size:medium">
</span><span id="hevea_default1203"></span><span
style="font-size:medium"> </span><span
id="hevea_default1204"></span><span style="font-size:medium">
</span><span id="hevea_default1205"></span>

<span style="font-size:medium">The slope and the intercept are
statistically significant, which means that they were unlikely to occur
by chance, but the the <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
value for this model is small, which means that <span
style="font-family:monospace">isfirst</span> doesn’t account for a
substantial part of the variation in birth weight. </span><span
id="hevea_default1206"></span><span style="font-size:medium">
</span><span id="hevea_default1207"></span>

<span style="font-size:medium">The results are similar with <span
style="font-family:monospace">agepreg</span>:</span>

    Intercept       6.83    (0)
    agepreg         0.0175  (5.72e-11)
    R^2 0.004738

<span style="font-size:medium">Again, the parameters are statistically
significant, but <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is low. </span><span id="hevea_default1208"></span><span
style="font-size:medium"> </span><span id="hevea_default1209"></span>

<span style="font-size:medium">These models confirm results we have
already seen. But now we can fit a single model that includes both
variables. With the formula `totalwgt_lb ~ isfirst + agepreg`, we
get:</span>

    Intercept        6.91    (0)
    isfirst[T.True] -0.0698  (0.0253)
    agepreg          0.0154  (3.93e-08)
    R^2 0.005289

<span style="font-size:medium">In the combined model, the parameter for
<span style="font-family:monospace">isfirst</span> is smaller by about
half, which means that part of the apparent effect of <span
style="font-family:monospace">isfirst</span> is actually accounted for
by <span style="font-family:monospace">agepreg</span>. And the p-value
for <span style="font-family:monospace">isfirst</span> is about 2.5%,
which is on the border of statistical significance. </span><span
id="hevea_default1210"></span><span style="font-size:medium">
</span><span id="hevea_default1211"></span>

<span style="font-style:italic;font-size:medium">R</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
for this model is a little higher, which indicates that the two
variables together account for more variation in birth weight than
either alone (but not by much). </span><span
id="hevea_default1212"></span><span style="font-size:medium">
</span><span id="hevea_default1213"></span><span
style="font-size:medium"> </span><span
id="hevea_default1214"></span><span style="font-size:medium">
</span><span id="hevea_default1215"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.3  Nonlinear relationships</span>
-------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="nonlinear"></span>

<span style="font-size:medium">Remembering that the contribution of
<span style="font-family:monospace">agepreg</span> might be nonlinear,
we might consider adding a variable to capture more of this
relationship. One option is to create a column, <span
style="font-family:monospace">agepreg2</span>, that contains the squares
of the ages: </span><span id="hevea_default1216"></span>

        live['agepreg2'] = live.agepreg**2
        formula = 'totalwgt_lb ~ isfirst + agepreg + agepreg2'

<span style="font-size:medium">Now by estimating parameters for <span
style="font-family:monospace">agepreg</span> and <span
style="font-family:monospace">agepreg2</span>, we are effectively
fitting a parabola:</span>

    Intercept        5.69     (1.38e-86)
    isfirst[T.True] -0.0504   (0.109)
    agepreg          0.112    (3.23e-07)
    agepreg2        -0.00185  (8.8e-06)
    R^2 0.007462

<span style="font-size:medium">The parameter of <span
style="font-family:monospace">agepreg2</span> is negative, so the
parabola curves downward, which is consistent with the shape of the
lines in Figure </span>[<span
style="font-size:medium">10.2</span>](thinkstats2011.html#linear2)<span
style="font-size:medium">. </span><span id="hevea_default1217"></span>

<span style="font-size:medium">The quadratic model of <span
style="font-family:monospace">agepreg</span> accounts for more of the
variability in birth weight; the parameter for <span
style="font-family:monospace">isfirst</span> is smaller in this model,
and no longer statistically significant. </span><span
id="hevea_default1218"></span><span style="font-size:medium">
</span><span id="hevea_default1219"></span><span
style="font-size:medium"> </span><span
id="hevea_default1220"></span><span style="font-size:medium">
</span><span id="hevea_default1221"></span><span
style="font-size:medium"> </span><span
id="hevea_default1222"></span><span style="font-size:medium">
</span><span id="hevea_default1223"></span>

<span style="font-size:medium">Using computed variables like <span
style="font-family:monospace">agepreg2</span> is a common way to fit
polynomials and other functions to data. This process is still
considered linear regression, because the dependent variable is a linear
function of the explanatory variables, regardless of whether some
variables are nonlinear functions of others. </span><span
id="hevea_default1224"></span><span style="font-size:medium">
</span><span id="hevea_default1225"></span><span
style="font-size:medium"> </span><span id="hevea_default1226"></span>

<span style="font-size:medium">The following table summarizes the
results of these regressions:</span>

<span style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium"> </span></td>
<td style="text-align: center;"><span style="font-size:medium">isfirst</span></td>
<td style="text-align: center;"><span style="font-size:medium">agepreg</span></td>
<td style="text-align: center;"><span style="font-size:medium">agepreg2</span></td>
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">R</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">Model 1</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.125 *</span></td>
<td style="text-align: center;"><span style="font-size:medium">–</span></td>
<td style="text-align: center;"><span style="font-size:medium">–</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.002 </span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">Model 2</span></td>
<td style="text-align: center;"><span style="font-size:medium">–</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.0175 *</span></td>
<td style="text-align: center;"><span style="font-size:medium">–</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.0047 </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">Model 3</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.0698 (0.025)</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.0154 *</span></td>
<td style="text-align: center;"><span style="font-size:medium">–</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.0053 </span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">Model 4</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.0504 (0.11)</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.112 *</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.00185 *</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.0075 </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">The columns in this table are the
explanatory variables and the coefficient of determination, <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">.
Each entry is an estimated parameter and either a p-value in parentheses
or an asterisk to indicate a p-value less that 0.001. </span><span
id="hevea_default1227"></span><span style="font-size:medium">
</span><span id="hevea_default1228"></span><span
style="font-size:medium"> </span><span
id="hevea_default1229"></span><span style="font-size:medium">
</span><span id="hevea_default1230"></span>

<span style="font-size:medium">We conclude that the apparent difference
in birth weight is explained, at least in part, by the difference in
mother’s age. When we include mother’s age in the model, the effect of
<span style="font-family:monospace">isfirst</span> gets smaller, and the
remaining effect might be due to chance. </span><span
id="hevea_default1231"></span>

<span style="font-size:medium">In this example, mother’s age acts as a
<span style="font-weight:bold">control variable</span>; including <span
style="font-family:monospace">agepreg</span> in the model “controls for”
the difference in age between first-time mothers and others, making it
possible to isolate the effect (if any) of <span
style="font-family:monospace">isfirst</span>. </span><span
id="hevea_default1232"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.4  Data mining</span>
-------------------------------------------------------

<span style="font-size:medium"> </span><span id="mining"></span>

<span style="font-size:medium">So far we have used regression models for
explanation; for example, in the previous section we discovered that an
apparent difference in birth weight is actually due to a difference in
mother’s age. But the <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
values of those models is very low, which means that they have little
predictive power. In this section we’ll try to do better. </span><span
id="hevea_default1233"></span><span style="font-size:medium">
</span><span id="hevea_default1234"></span><span
style="font-size:medium"> </span><span
id="hevea_default1235"></span><span style="font-size:medium">
</span><span id="hevea_default1236"></span><span
style="font-size:medium"> </span><span id="hevea_default1237"></span>

<span style="font-size:medium">Suppose one of your co-workers is
expecting a baby and there is an office pool to guess the baby’s birth
weight (if you are not familiar with betting pools, see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Betting\_pool</span>](https://en.wikipedia.org/wiki/Betting_pool)<span
style="font-size:medium">). </span><span id="hevea_default1238"></span>

<span style="font-size:medium">Now suppose that you *really* want to win
the pool. What could you do to improve your chances? Well, the NSFG
dataset includes 244 variables about each pregnancy and another 3087
variables about each respondent. Maybe some of those variables have
predictive power. To find out which ones are most useful, why not try
them all? </span><span id="hevea_default1239"></span>

<span style="font-size:medium">Testing the variables in the pregnancy
table is easy, but in order to use the variables in the respondent
table, we have to match up each pregnancy with a respondent. In theory
we could iterate through the rows of the pregnancy table, use the <span
style="font-family:monospace">caseid</span> to find the corresponding
respondent, and copy the values from the correspondent table into the
pregnancy table. But that would be slow. </span><span
id="hevea_default1240"></span><span style="font-size:medium">
</span><span id="hevea_default1241"></span>

<span style="font-size:medium">A better option is to recognize this
process as a <span style="font-weight:bold">join</span> operation as
defined in SQL and other relational database languages (see
</span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Join\_(SQL)</span>](https://en.wikipedia.org/wiki/Join_(SQL))<span
style="font-size:medium">). Join is implemented as a DataFrame method,
so we can perform the operation like this: </span><span
id="hevea_default1242"></span>

        live = live[live.prglngth>30]
        resp = chap01soln.ReadFemResp()
        resp.index = resp.caseid
        join = live.join(resp, on='caseid', rsuffix='_r')

<span style="font-size:medium">The first line selects records for
pregnancies longer than 30 weeks, assuming that the office pool is
formed several weeks before the due date. </span><span
id="hevea_default1243"></span>

<span style="font-size:medium">The next line reads the respondent file.
The result is a DataFrame with integer indices; in order to look up
respondents efficiently, I replace <span
style="font-family:monospace">resp.index</span> with <span
style="font-family:monospace">resp.caseid</span>. </span>

<span style="font-size:medium">The <span
style="font-family:monospace">join</span> method is invoked on <span
style="font-family:monospace">live</span>, which is considered the
“left” table, and passed <span
style="font-family:monospace">resp</span>, which is the “right” table.
The keyword argument <span style="font-family:monospace">on</span>
indicates the variable used to match up rows from the two tables.</span>

<span style="font-size:medium">In this example some column names appear
in both tables, so we have to provide <span
style="font-family:monospace">rsuffix</span>, which is a string that
will be appended to the names of overlapping columns from the right
table. For example, both tables have a column named <span
style="font-family:monospace">race</span> that encodes the race of the
respondent. The result of the join contains two columns named <span
style="font-family:monospace">race</span> and `race_r`. </span><span
id="hevea_default1244"></span>

<span style="font-size:medium">The pandas implementation is fast.
Joining the NSFG tables takes less than a second on an ordinary desktop
computer. Now we can start testing variables. </span><span
id="hevea_default1245"></span><span style="font-size:medium">
</span><span id="hevea_default1246"></span>

        t = []
        for name in join.columns:
            try:
                if join[name].var() < 1e-7:
                    continue

                formula = 'totalwgt_lb ~ agepreg + ' + name
                model = smf.ols(formula, data=join)
                if model.nobs < len(join)/2:
                    continue

                results = model.fit()
            except (ValueError, TypeError):
                continue

            t.append((results.rsquared, name))

<span style="font-size:medium">For each variable we construct a model,
compute <span style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
and append the results to a list. The models all include <span
style="font-family:monospace">agepreg</span>, since we already know that
it has some predictive power. </span><span
id="hevea_default1247"></span><span style="font-size:medium">
</span><span id="hevea_default1248"></span><span
style="font-size:medium"> </span><span id="hevea_default1249"></span>

<span style="font-size:medium">I check that each explanatory variable
has some variability; otherwise the results of the regression are
unreliable. I also check the number of observations for each model.
Variables that contain a large number of <span
style="font-family:monospace">nan</span>s are not good candidates for
prediction. </span><span id="hevea_default1250"></span><span
style="font-size:medium"> </span><span id="hevea_default1251"></span>

<span style="font-size:medium">For most of these variables, we haven’t
done any cleaning. Some of them are encoded in ways that don’t work very
well for linear regression. As a result, we might overlook some
variables that would be useful if they were cleaned properly. But maybe
we will find some good candidates. </span><span
id="hevea_default1252"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.5  Prediction</span>
------------------------------------------------------

<span style="font-size:medium">The next step is to sort the results and
select the variables that yield the highest values of <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">.
</span><span id="hevea_default1253"></span>

        t.sort(reverse=True)
        for mse, name in t[:30]:
            print(name, mse)

<span style="font-size:medium">The first variable on the list is
`totalwgt_lb`, followed by `birthwgt_lb`. Obviously, we can’t use birth
weight to predict birth weight. </span><span
id="hevea_default1254"></span><span style="font-size:medium">
</span><span id="hevea_default1255"></span>

<span style="font-size:medium">Similarly <span
style="font-family:monospace">prglngth</span> has useful predictive
power, but for the office pool we assume pregnancy length (and the
related variables) are not known yet. </span><span
id="hevea_default1256"></span><span style="font-size:medium">
</span><span id="hevea_default1257"></span>

<span style="font-size:medium">The first useful predictive variable is
<span style="font-family:monospace">babysex</span> which indicates
whether the baby is male or female. In the NSFG dataset, boys are about
0.3 lbs heavier. So, assuming that the sex of the baby is known, we can
use it for prediction. </span><span id="hevea_default1258"></span>

<span style="font-size:medium">Next is <span
style="font-family:monospace">race</span>, which indicates whether the
respondent is white, black, or other. As an explanatory variable, race
can be problematic. In datasets like the NSFG, race is correlated with
many other variables, including income and other socioeconomic factors.
In a regression model, race acts as a <span
style="font-weight:bold">proxy variable</span>, so apparent correlations
with race are often caused, at least in part, by other factors.
</span><span id="hevea_default1259"></span><span
style="font-size:medium"> </span><span id="hevea_default1260"></span>

<span style="font-size:medium">The next variable on the list is <span
style="font-family:monospace">nbrnaliv</span>, which indicates whether
the pregnancy yielded multiple births. Twins and triplets tend to be
smaller than other babies, so if we know whether our hypothetical
co-worker is expecting twins, that would help. </span><span
id="hevea_default1261"></span>

<span style="font-size:medium">Next on the list is <span
style="font-family:monospace">paydu</span>, which indicates whether the
respondent owns her home. It is one of several income-related variables
that turn out to be predictive. In datasets like the NSFG, income and
wealth are correlated with just about everything. In this example,
income is related to diet, health, health care, and other factors likely
to affect birth weight. </span><span id="hevea_default1262"></span><span
style="font-size:medium"> </span><span
id="hevea_default1263"></span><span style="font-size:medium">
</span><span id="hevea_default1264"></span><span
style="font-size:medium"> </span><span id="hevea_default1265"></span>

<span style="font-size:medium">Some of the other variables on the list
are things that would not be known until later, like <span
style="font-family:monospace">bfeedwks</span>, the number of weeks the
baby was breast fed. We can’t use these variables for prediction, but
you might want to speculate on reasons <span
style="font-family:monospace">bfeedwks</span> might be correlated with
birth weight.</span>

<span style="font-size:medium">Sometimes you start with a theory and use
data to test it. Other times you start with data and go looking for
possible theories. The second approach, which this section demonstrates,
is called <span style="font-weight:bold">data mining</span>. An
advantage of data mining is that it can discover unexpected patterns. A
hazard is that many of the patterns it discovers are either random or
spurious. </span><span id="hevea_default1266"></span><span
style="font-size:medium"> </span><span id="hevea_default1267"></span>

<span style="font-size:medium">Having identified potential explanatory
variables, I tested a few models and settled on this one: </span><span
id="hevea_default1268"></span><span style="font-size:medium">
</span><span id="hevea_default1269"></span>

        formula = ('totalwgt_lb ~ agepreg + C(race) + babysex==1 + '
                   'nbrnaliv>1 + paydu==1 + totincr')
        results = smf.ols(formula, data=join).fit()

<span style="font-size:medium">This formula uses some syntax we have not
seen yet: <span style="font-family:monospace">C(race)</span> tells the
formula parser (Patsy) to treat race as a categorical variable, even
though it is encoded numerically. </span><span
id="hevea_default1270"></span><span style="font-size:medium">
</span><span id="hevea_default1271"></span>

<span style="font-size:medium">The encoding for <span
style="font-family:monospace">babysex</span> is 1 for male, 2 for
female; writing <span style="font-family:monospace">babysex==1</span>
converts it to boolean, True for male and false for female. </span><span
id="hevea_default1272"></span>

<span style="font-size:medium">Similarly <span
style="font-family:monospace">nbrnaliv&gt;1</span> is True for multiple
births and <span style="font-family:monospace">paydu==1</span> is True
for respondents who own their houses.</span>

<span style="font-size:medium"><span
style="font-family:monospace">totincr</span> is encoded numerically from
1-14, with each increment representing about $5000 in annual income. So
we can treat these values as numerical, expressed in units of $5000.
</span><span id="hevea_default1273"></span>

<span style="font-size:medium">Here are the results of the model:</span>

    Intercept               6.63    (0)
    C(race)[T.2]            0.357   (5.43e-29)
    C(race)[T.3]            0.266   (2.33e-07)
    babysex == 1[T.True]    0.295   (5.39e-29)
    nbrnaliv > 1[T.True]   -1.38    (5.1e-37)
    paydu == 1[T.True]      0.12    (0.000114)
    agepreg                 0.00741 (0.0035)
    totincr                 0.0122  (0.00188)

<span style="font-size:medium">The estimated parameters for race are
larger than I expected, especially since we control for income. The
encoding is 1 for black, 2 for white, and 3 for other. Babies of black
mothers are lighter than babies of other races by 0.27–0.36 lbs.
</span><span id="hevea_default1274"></span><span
style="font-size:medium"> </span><span id="hevea_default1275"></span>

<span style="font-size:medium">As we’ve already seen, boys are heavier
by about 0.3 lbs; twins and other multiplets are lighter by 1.4 lbs.
</span><span id="hevea_default1276"></span>

<span style="font-size:medium">People who own their homes have heavier
babies by about 0.12 lbs, even when we control for income. The parameter
for mother’s age is smaller than what we saw in Section </span>[<span
style="font-size:medium">11.2</span>](#multiple)<span
style="font-size:medium">, which suggests that some of the other
variables are correlated with age, probably including <span
style="font-family:monospace">paydu</span> and <span
style="font-family:monospace">totincr</span>. </span><span
id="hevea_default1277"></span>

<span style="font-size:medium">All of these variables are statistically
significant, some with very low p-values, but <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is only 0.06, still quite small. RMSE without using the model is 1.27
lbs; with the model it drops to 1.23. So your chance of winning the pool
is not substantially improved. Sorry! </span><span
id="hevea_default1278"></span><span style="font-size:medium">
</span><span id="hevea_default1279"></span><span
style="font-size:medium"> </span><span
id="hevea_default1280"></span><span style="font-size:medium">
</span><span id="hevea_default1281"></span><span
style="font-size:medium"> </span><span
id="hevea_default1282"></span><span style="font-size:medium">
</span><span id="hevea_default1283"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.6  Logistic regression</span>
---------------------------------------------------------------

<span style="font-size:medium">In the previous examples, some of the
explanatory variables were numerical and some categorical (including
boolean). But the dependent variable was always numerical. </span><span
id="hevea_default1284"></span><span style="font-size:medium">
</span><span id="hevea_default1285"></span><span
style="font-size:medium"> </span><span id="hevea_default1286"></span>

<span style="font-size:medium">Linear regression can be generalized to
handle other kinds of dependent variables. If the dependent variable is
boolean, the generalized model is called <span
style="font-weight:bold">logistic regression</span>. If the dependent
variable is an integer count, it’s called <span
style="font-weight:bold">Poisson regression</span>. </span><span
id="hevea_default1287"></span><span style="font-size:medium">
</span><span id="hevea_default1288"></span><span
style="font-size:medium"> </span><span
id="hevea_default1289"></span><span style="font-size:medium">
</span><span id="hevea_default1290"></span>

<span style="font-size:medium">As an example of logistic regression,
let’s consider a variation on the office pool scenario. Suppose a friend
of yours is pregnant and you want to predict whether the baby is a boy
or a girl. You could use data from the NSFG to find factors that affect
the “sex ratio”, which is conventionally defined to be the probability
of having a boy. </span><span id="hevea_default1291"></span><span
style="font-size:medium"> </span><span id="hevea_default1292"></span>

<span style="font-size:medium">If you encode the dependent variable
numerically, for example 0 for a girl and 1 for a boy, you could apply
ordinary least squares, but there would be problems. The linear model
might be something like this: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">y</span> = β</span><sub><span style="font-size:medium">0</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> + ε </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Where <span
style="font-style:italic">y</span> is the dependent variable, and <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">
are explanatory variables. Then we could find the parameters that
minimize the residuals. </span><span id="hevea_default1293"></span><span
style="font-size:medium"> </span><span
id="hevea_default1294"></span><span style="font-size:medium">
</span><span id="hevea_default1295"></span><span
style="font-size:medium"> </span><span id="hevea_default1296"></span>

<span style="font-size:medium">The problem with this approach is that it
produces predictions that are hard to interpret. Given estimated
parameters and values for <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">,
the model might predict <span style="font-style:italic">y</span>=0.5,
but the only meaningful values of <span
style="font-style:italic">y</span> are 0 and 1. </span><span
id="hevea_default1297"></span>

<span style="font-size:medium">It is tempting to interpret a result like
that as a probability; for example, we might say that a respondent with
particular values of <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">
has a 50% chance of having a boy. But it is also possible for this model
to predict <span style="font-style:italic">y</span>=1.1 or <span
style="font-style:italic">y</span>=−0.1, and those are not valid
probabilities. </span><span id="hevea_default1298"></span>

<span style="font-size:medium">Logistic regression avoids this problem
by expressing predictions in terms of <span
style="font-weight:bold">odds</span> rather than probabilities. If you
are not familiar with odds, “odds in favor” of an event is the ratio of
the probability it will occur to the probability that it will not.
</span><span id="hevea_default1299"></span>

<span style="font-size:medium">So if I think my team has a 75% chance of
winning, I would say that the odds in their favor are three to one,
because the chance of winning is three times the chance of
losing.</span>

<span style="font-size:medium">Odds and probabilities are different
representations of the same information. Given a probability, you can
compute the odds like this:</span>

        o = p / (1-p)

<span style="font-size:medium">Given odds in favor, you can convert to
probability like this:</span>

        p = o / (o+1)

<span style="font-size:medium">Logistic regression is based on the
following model: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">log<span style="font-style:italic">o</span> = β</span><sub><span style="font-size:medium">0</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> + β</span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> + ε </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Where <span
style="font-style:italic">o</span> is the odds in favor of a particular
outcome; in the example, <span style="font-style:italic">o</span> would
be the odds of having a boy. </span><span id="hevea_default1300"></span>

<span style="font-size:medium">Suppose we have estimated the parameters
β</span><sub><span style="font-size:medium">0</span></sub><span
style="font-size:medium">, β</span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">,
and β</span><sub><span style="font-size:medium">2</span></sub><span
style="font-size:medium"> (I’ll explain how in a minute). And suppose we
are given values for <span
style="font-style:italic">x</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
and <span style="font-style:italic">x</span></span><sub><span
style="font-size:medium">2</span></sub><span style="font-size:medium">.
We can compute the predicted value of log<span
style="font-style:italic">o</span>, and then convert to a
probability:</span>

        o = np.exp(log_o)
        p = o / (o+1)

<span style="font-size:medium">So in the office pool scenario we could
compute the predictive probability of having a boy. But how do we
estimate the parameters? </span><span id="hevea_default1301"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.7  Estimating parameters</span>
-----------------------------------------------------------------

<span style="font-size:medium">Unlike linear regression, logistic
regression does not have a closed form solution, so it is solved by
guessing an initial solution and improving it iteratively. </span><span
id="hevea_default1302"></span><span style="font-size:medium">
</span><span id="hevea_default1303"></span>

<span style="font-size:medium">The usual goal is to find the
maximum-likelihood estimate (MLE), which is the set of parameters that
maximizes the likelihood of the data. For example, suppose we have the
following data: </span><span id="hevea_default1304"></span><span
style="font-size:medium"> </span><span id="hevea_default1305"></span>

    >>> y = np.array([0, 1, 0, 1])
    >>> x1 = np.array([0, 0, 0, 1])
    >>> x2 = np.array([0, 1, 1, 1])

<span style="font-size:medium">And we start with the initial guesses
β</span><sub><span style="font-size:medium">0</span></sub><span
style="font-size:medium">=−1.5, β</span><sub><span
style="font-size:medium">1</span></sub><span
style="font-size:medium">=2.8, and β</span><sub><span
style="font-size:medium">2</span></sub><span
style="font-size:medium">=1.1:</span>

    >>> beta = [-1.5, 2.8, 1.1]

<span style="font-size:medium">Then for each row we can compute
`log_o`:</span>

    >>> log_o = beta[0] + beta[1] * x1 + beta[2] * x2 
    [-1.5 -0.4 -0.4  2.4]

<span style="font-size:medium">And convert from log odds to
probabilities: </span><span id="hevea_default1306"></span>

    >>> o = np.exp(log_o)
    [  0.223   0.670   0.670  11.02  ]

    >>> p = o / (o+1)
    [ 0.182  0.401  0.401  0.916 ]

<span style="font-size:medium">Notice that when `log_o` is greater than
0, <span style="font-family:monospace">o</span> is greater than 1 and
<span style="font-family:monospace">p</span> is greater than 0.5.</span>

<span style="font-size:medium">The likelihood of an outcome is <span
style="font-family:monospace">p</span> when <span
style="font-family:monospace">y==1</span> and <span
style="font-family:monospace">1-p</span> when <span
style="font-family:monospace">y==0</span>. For example, if we think the
probability of a boy is 0.8 and the outcome is a boy, the likelihood is
0.8; if the outcome is a girl, the likelihood is 0.2. We can compute
that like this: </span><span id="hevea_default1307"></span>

    >>> likes = y * p + (1-y) * (1-p)
    [ 0.817  0.401  0.598  0.916 ]

<span style="font-size:medium">The overall likelihood of the data is the
product of <span style="font-family:monospace">likes</span>:</span>

    >>> like = np.prod(likes)
    0.18

<span style="font-size:medium">For these values of <span
style="font-family:monospace">beta</span>, the likelihood of the data is
0.18. The goal of logistic regression is to find parameters that
maximize this likelihood. To do that, most statistics packages use an
iterative solver like Newton’s method (see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Logistic\_regression\#Model\_fitting</span>](https://en.wikipedia.org/wiki/Logistic_regression#Model_fitting)<span
style="font-size:medium">). </span><span
id="hevea_default1308"></span><span style="font-size:medium">
</span><span id="hevea_default1309"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.8  Implementation</span>
----------------------------------------------------------

<span style="font-size:medium"> </span><span id="implementation"></span>

<span style="font-size:medium">StatsModels provides an implementation of
logistic regression called <span
style="font-family:monospace">logit</span>, named for the function that
converts from probability to log odds. To demonstrate its use, I’ll look
for variables that affect the sex ratio. </span><span
id="hevea_default1310"></span><span style="font-size:medium">
</span><span id="hevea_default1311"></span><span
style="font-size:medium"> </span><span id="hevea_default1312"></span>

<span style="font-size:medium">Again, I load the NSFG data and select
pregnancies longer than 30 weeks:</span>

        live, firsts, others = first.MakeFrames()
        df = live[live.prglngth>30]

<span style="font-size:medium"><span
style="font-family:monospace">logit</span> requires the dependent
variable to be binary (rather than boolean), so I create a new column
named <span style="font-family:monospace">boy</span>, using <span
style="font-family:monospace">astype(int)</span> to convert to binary
integers: </span><span id="hevea_default1313"></span><span
style="font-size:medium"> </span><span
id="hevea_default1314"></span><span style="font-size:medium">
</span><span id="hevea_default1315"></span>

        df['boy'] = (df.babysex==1).astype(int)

<span style="font-size:medium">Factors that have been found to affect
sex ratio include parents’ age, birth order, race, and social status. We
can use logistic regression to see if these effects appear in the NSFG
data. I’ll start with the mother’s age: </span><span
id="hevea_default1316"></span><span style="font-size:medium">
</span><span id="hevea_default1317"></span>

        import statsmodels.formula.api as smf

        model = smf.logit('boy ~ agepreg', data=df)
        results = model.fit()
        SummarizeResults(results)

<span style="font-size:medium"><span
style="font-family:monospace">logit</span> takes the same arguments as
<span style="font-family:monospace">ols</span>, a formula in Patsy
syntax and a DataFrame. The result is a Logit object that represents the
model. It contains attributes called <span
style="font-family:monospace">endog</span> and <span
style="font-family:monospace">exog</span> that contain the <span
style="font-weight:bold">endogenous variable</span>, another name for
the dependent variable, and the <span style="font-weight:bold">exogenous
variables</span>, another name for the explanatory variables. Since they
are NumPy arrays, it is sometimes convenient to convert them to
DataFrames: </span><span id="hevea_default1318"></span><span
style="font-size:medium"> </span><span
id="hevea_default1319"></span><span style="font-size:medium">
</span><span id="hevea_default1320"></span><span
style="font-size:medium"> </span><span
id="hevea_default1321"></span><span style="font-size:medium">
</span><span id="hevea_default1322"></span><span
style="font-size:medium"> </span><span
id="hevea_default1323"></span><span style="font-size:medium">
</span><span id="hevea_default1324"></span><span
style="font-size:medium"> </span><span id="hevea_default1325"></span>

        endog = pandas.DataFrame(model.endog, columns=[model.endog_names])
        exog = pandas.DataFrame(model.exog, columns=model.exog_names)

<span style="font-size:medium">The result of <span
style="font-family:monospace">model.fit</span> is a BinaryResults
object, which is similar to the RegressionResults object we got from
<span style="font-family:monospace">ols</span>. Here is a summary of the
results:</span>

    Intercept   0.00579   (0.953)
    agepreg     0.00105   (0.783)
    R^2 6.144e-06

<span style="font-size:medium">The parameter of <span
style="font-family:monospace">agepreg</span> is positive, which suggests
that older mothers are more likely to have boys, but the p-value is
0.783, which means that the apparent effect could easily be due to
chance. </span><span id="hevea_default1326"></span><span
style="font-size:medium"> </span><span id="hevea_default1327"></span>

<span style="font-size:medium">The coefficient of determination, <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
does not apply to logistic regression, but there are several
alternatives that are used as “pseudo <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
values.” These values can be useful for comparing models. For example,
here’s a model that includes several factors believed to be associated
with sex ratio: </span><span id="hevea_default1328"></span><span
style="font-size:medium"> </span><span
id="hevea_default1329"></span><span style="font-size:medium">
</span><span id="hevea_default1330"></span><span
style="font-size:medium"> </span><span id="hevea_default1331"></span>

        formula = 'boy ~ agepreg + hpagelb + birthord + C(race)'
        model = smf.logit(formula, data=df)
        results = model.fit()

<span style="font-size:medium">Along with mother’s age, this model
includes father’s age at birth (<span
style="font-family:monospace">hpagelb</span>), birth order (<span
style="font-family:monospace">birthord</span>), and race as a
categorical variable. Here are the results: </span><span
id="hevea_default1332"></span>

    Intercept      -0.0301     (0.772)
    C(race)[T.2]   -0.0224     (0.66)
    C(race)[T.3]   -0.000457   (0.996)
    agepreg        -0.00267    (0.629)
    hpagelb         0.0047     (0.266)
    birthord        0.00501    (0.821)
    R^2 0.000144

<span style="font-size:medium">None of the estimated parameters are
statistically significant. The pseudo-<span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
value is a little higher, but that could be due to chance. </span><span
id="hevea_default1333"></span><span style="font-size:medium">
</span><span id="hevea_default1334"></span><span
style="font-size:medium"> </span><span id="hevea_default1335"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.9  Accuracy</span>
----------------------------------------------------

<span style="font-size:medium"> </span><span id="accuracy"></span>

<span style="font-size:medium">In the office pool scenario, we are most
interested in the accuracy of the model: the number of successful
predictions, compared with what we would expect by chance. </span><span
id="hevea_default1336"></span><span style="font-size:medium">
</span><span id="hevea_default1337"></span>

<span style="font-size:medium">In the NSFG data, there are more boys
than girls, so the baseline strategy is to guess “boy” every time. The
accuracy of this strategy is just the fraction of boys:</span>

        actual = endog['boy']
        baseline = actual.mean()

<span style="font-size:medium">Since <span
style="font-family:monospace">actual</span> is encoded in binary
integers, the mean is the fraction of boys, which is 0.507.</span>

<span style="font-size:medium">Here’s how we compute the accuracy of the
model:</span>

        predict = (results.predict() >= 0.5)
        true_pos = predict * actual
        true_neg = (1 - predict) * (1 - actual)

<span style="font-size:medium"><span
style="font-family:monospace">results.predict</span> returns a NumPy
array of probabilities, which we round off to 0 or 1. Multiplying by
<span style="font-family:monospace">actual</span> yields 1 if we predict
a boy and get it right, 0 otherwise. So, `true_pos` indicates “true
positives”. </span><span id="hevea_default1338"></span><span
style="font-size:medium"> </span><span
id="hevea_default1339"></span><span style="font-size:medium">
</span><span id="hevea_default1340"></span>

<span style="font-size:medium">Similarly, `true_neg` indicates the cases
where we guess “girl” and get it right. Accuracy is the fraction of
correct guesses:</span>

        acc = (sum(true_pos) + sum(true_neg)) / len(actual)

<span style="font-size:medium">The result is 0.512, slightly better than
the baseline, 0.507. But, you should not take this result too seriously.
We used the same data to build and test the model, so the model may not
have predictive power on new data. </span><span
id="hevea_default1341"></span>

<span style="font-size:medium">Nevertheless, let’s use the model to make
a prediction for the office pool. Suppose your friend is 35 years old
and white, her husband is 39, and they are expecting their third
child:</span>

        columns = ['agepreg', 'hpagelb', 'birthord', 'race']
        new = pandas.DataFrame([[35, 39, 3, 2]], columns=columns)
        y = results.predict(new)

<span style="font-size:medium">To invoke <span
style="font-family:monospace">results.predict</span> for a new case, you
have to construct a DataFrame with a column for each variable in the
model. The result in this case is 0.52, so you should guess “boy.” But
if the model improves your chances of winning, the difference is very
small. </span><span id="hevea_default1342"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.10  Exercises</span>
------------------------------------------------------

<span style="font-size:medium">My solution to these exercises is in
`chap11soln.ipynb`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *Suppose one of your
co-workers is expecting a baby and you are participating in an office
pool to predict the date of birth. Assuming that bets are placed during
the 30th week of pregnancy, what variables could you use to make the
best prediction? You should limit yourself to variables that are known
before the birth, and likely to be available to the people in the pool.*
</span><span id="hevea_default1343"></span><span
style="font-size:medium"> </span><span id="hevea_default1344"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *The Trivers-Willard
hypothesis suggests that for many mammals the sex ratio depends on
“maternal condition”; that is, factors like the mother’s age, size,
health, and social status. See* </span>[<span
style="font-family:monospace;font-size:medium">*https://en.wikipedia.org/wiki/Trivers-Willard\_hypothesis*</span>](https://en.wikipedia.org/wiki/Trivers-Willard_hypothesis)<span
style="font-size:medium"> </span><span
id="hevea_default1345"></span><span style="font-size:medium">
</span><span id="hevea_default1346"></span>

<span style="font-size:medium">*Some studies have shown this effect
among humans, but results are mixed. In this chapter we tested some
variables related to these factors, but didn’t find any with a
statistically significant effect on sex ratio.* </span><span
id="hevea_default1347"></span><span style="font-size:medium">
</span><span id="hevea_default1348"></span>

<span style="font-size:medium">*As an exercise, use a data mining
approach to test the other variables in the pregnancy and respondent
files. Can you find any factors with a substantial effect?* </span><span
id="hevea_default1349"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *If the quantity you want
to predict is a count, you can use Poisson regression, which is
implemented in StatsModels with a function called <span
style="font-family:monospace">poisson</span>. It works the same way as
<span style="font-family:monospace">ols</span> and <span
style="font-family:monospace">logit</span>. As an exercise, let’s use it
to predict how many children a woman has born; in the NSFG dataset, this
variable is called <span style="font-family:monospace">numbabes</span>.*
</span><span id="hevea_default1350"></span><span
style="font-size:medium"> </span><span id="hevea_default1351"></span>

<span style="font-size:medium">*Suppose you meet a woman who is 35 years
old, black, and a college graduate whose annual household income exceeds
$75,000. How many children would you predict she has born?* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 4</span>   *If the quantity you want
to predict is categorical, you can use multinomial logistic regression,
which is implemented in StatsModels with a function called <span
style="font-family:monospace">mnlogit</span>. As an exercise, let’s use
it to guess whether a woman is married, cohabitating, widowed, divorced,
separated, or never married; in the NSFG dataset, marital status is
encoded in a variable called <span
style="font-family:monospace">rmarital</span>.* </span><span
id="hevea_default1352"></span><span style="font-size:medium">
</span><span id="hevea_default1353"></span>

<span style="font-size:medium">*Suppose you meet a woman who is 25 years
old, white, and a high school graduate whose annual household income is
about $45,000. What is the probability that she is married,
cohabitating, etc?* </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">11.11  Glossary</span>
-----------------------------------------------------

-   <span style="font-size:medium">regression: One of several related
    processes for estimating parameters that fit a model to data.
    </span><span id="hevea_default1354"></span>
-   <span style="font-size:medium">dependent variables: The variables in
    a regression model we would like to predict. Also known as
    endogenous variables. </span><span
    id="hevea_default1355"></span><span style="font-size:medium">
    </span><span id="hevea_default1356"></span>
-   <span style="font-size:medium">explanatory variables: The variables
    used to predict or explain the dependent variables. Also known as
    independent, or exogenous, variables. </span><span
    id="hevea_default1357"></span><span style="font-size:medium">
    </span><span id="hevea_default1358"></span>
-   <span style="font-size:medium">simple regression: A regression with
    only one dependent and one explanatory variable. </span><span
    id="hevea_default1359"></span>
-   <span style="font-size:medium">multiple regression: A regression
    with multiple explanatory variables, but only one dependent
    variable. </span><span id="hevea_default1360"></span>
-   <span style="font-size:medium">linear regression: A regression based
    on a linear model. </span><span id="hevea_default1361"></span>
-   <span style="font-size:medium">ordinary least squares: A linear
    regression that estimates parameters by minimizing the squared error
    of the residuals. </span><span id="hevea_default1362"></span>
-   <span style="font-size:medium">spurious relationship: A relationship
    between two variables that is caused by a statistical artifact or a
    factor, not included in the model, that is related to both
    variables. </span><span id="hevea_default1363"></span>
-   <span style="font-size:medium">control variable: A variable included
    in a regression to eliminate or “control for” a spurious
    relationship. </span><span id="hevea_default1364"></span>
-   <span style="font-size:medium">proxy variable: A variable that
    contributes information to a regression model indirectly because of
    a relationship with another factor, so it acts as a proxy for that
    factor. </span><span id="hevea_default1365"></span>
-   <span style="font-size:medium">categorical variable: A variable that
    can have one of a discrete set of unordered values. </span><span
    id="hevea_default1366"></span>
-   <span style="font-size:medium">join: An operation that combines data
    from two DataFrames using a key to match up rows in the two frames.
    </span><span id="hevea_default1367"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1368"></span>
-   <span style="font-size:medium">data mining: An approach to finding
    relationships between variables by testing a large number of models.
    </span><span id="hevea_default1369"></span>
-   <span style="font-size:medium">logistic regression: A form of
    regression used when the dependent variable is boolean. </span><span
    id="hevea_default1370"></span>
-   <span style="font-size:medium">Poisson regression: A form of
    regression used when the dependent variable is a non-negative
    integer, usually a count. </span><span
    id="hevea_default1371"></span>
-   <span style="font-size:medium">odds: An alternative way of
    representing a probability, <span
    style="font-style:italic">p</span>, as the ratio of the probability
    and its complement, <span style="font-style:italic">p</span> /
    (1−<span style="font-style:italic">p</span>). </span><span
    id="hevea_default1372"></span>

<span style="font-size:medium"> </span>
