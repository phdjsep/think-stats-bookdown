This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 10  Linear least squares</span>
======================================================================

<span style="font-size:medium"> </span><span id="linear"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">linear.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.1  Least squares fit</span>
-------------------------------------------------------------

<span style="font-size:medium">Correlation coefficients measure the
strength and sign of a relationship, but not the slope. There are
several ways to estimate the slope; the most common is a <span
style="font-weight:bold">linear least squares fit</span>. A “linear fit”
is a line intended to model the relationship between variables. A “least
squares” fit is one that minimizes the mean squared error (MSE) between
the line and the data. </span><span id="hevea_default1027"></span><span
style="font-size:medium"> </span><span
id="hevea_default1028"></span><span style="font-size:medium">
</span><span id="hevea_default1029"></span>

<span style="font-size:medium">Suppose we have a sequence of points,
<span style="font-family:monospace">ys</span>, that we want to express
as a function of another sequence <span
style="font-family:monospace">xs</span>. If there is a linear
relationship between <span style="font-family:monospace">xs</span> and
<span style="font-family:monospace">ys</span> with intercept <span
style="font-family:monospace">inter</span> and slope <span
style="font-family:monospace">slope</span>, we expect each <span
style="font-family:monospace">y\[i\]</span> to be <span
style="font-family:monospace">inter + slope \* x\[i\]</span>.
</span><span id="hevea_default1030"></span>

<span style="font-size:medium">But unless the correlation is perfect,
this prediction is only approximate. The vertical deviation from the
line, or <span style="font-weight:bold">residual</span>, is </span><span
id="hevea_default1031"></span>

    res = ys - (inter + slope * xs)

<span style="font-size:medium">The residuals might be due to random
factors like measurement error, or non-random factors that are unknown.
For example, if we are trying to predict weight as a function of height,
unknown factors might include diet, exercise, and body type.
</span><span id="hevea_default1032"></span><span
style="font-size:medium"> </span><span
id="hevea_default1033"></span><span style="font-size:medium">
</span><span id="hevea_default1034"></span>

<span style="font-size:medium">If we get the parameters <span
style="font-family:monospace">inter</span> and <span
style="font-family:monospace">slope</span> wrong, the residuals get
bigger, so it makes intuitive sense that the parameters we want are the
ones that minimize the residuals. </span><span
id="hevea_default1035"></span>

<span style="font-size:medium">We might try to minimize the absolute
value of the residuals, or their squares, or their cubes; but the most
common choice is to minimize the sum of squared residuals, <span
style="font-family:monospace">sum(res\*\*2))</span>.</span>

<span style="font-size:medium">Why? There are three good reasons and one
less important one:</span>

-   <span style="font-size:medium">Squaring has the feature of treating
    positive and negative residuals the same, which is usually what we
    want.</span>
-   <span style="font-size:medium">Squaring gives more weight to large
    residuals, but not so much weight that the largest residual always
    dominates.</span>
-   <span style="font-size:medium">If the residuals are uncorrelated and
    normally distributed with mean 0 and constant (but unknown)
    variance, then the least squares fit is also the maximum likelihood
    estimator of <span style="font-family:monospace">inter</span> and
    <span style="font-family:monospace">slope</span>. See </span>[<span
    style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Linear\_regression</span>](https://en.wikipedia.org/wiki/Linear_regression)<span
    style="font-size:medium">. </span><span
    id="hevea_default1036"></span><span style="font-size:medium">
    </span><span id="hevea_default1037"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1038"></span>
-   <span style="font-size:medium">The values of <span
    style="font-family:monospace">inter</span> and <span
    style="font-family:monospace">slope</span> that minimize the squared
    residuals can be computed efficiently.</span>

<span style="font-size:medium">The last reason made sense when
computational efficiency was more important than choosing the method
most appropriate to the problem at hand. That’s no longer the case, so
it is worth considering whether squared residuals are the right thing to
minimize. </span><span id="hevea_default1039"></span><span
style="font-size:medium"> </span><span id="hevea_default1040"></span>

<span style="font-size:medium">For example, if you are using <span
style="font-family:monospace">xs</span> to predict values of <span
style="font-family:monospace">ys</span>, guessing too high might be
better (or worse) than guessing too low. In that case you might want to
compute some cost function for each residual, and minimize total cost,
<span style="font-family:monospace">sum(cost(res))</span>. However,
computing a least squares fit is quick, easy and often good enough.
</span><span id="hevea_default1041"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.2  Implementation</span>
----------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> provides simple
functions that demonstrate linear least squares: </span><span
id="hevea_default1042"></span>

    def LeastSquares(xs, ys):
        meanx, varx = MeanVar(xs)
        meany = Mean(ys)

        slope = Cov(xs, ys, meanx, meany) / varx
        inter = meany - slope * meanx

        return inter, slope

<span style="font-size:medium"><span
style="font-family:monospace">LeastSquares</span> takes sequences <span
style="font-family:monospace">xs</span> and <span
style="font-family:monospace">ys</span> and returns the estimated
parameters <span style="font-family:monospace">inter</span> and <span
style="font-family:monospace">slope</span>. For details on how it works,
see </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Numerical\_methods\_for\_linear\_least\_squares</span>](http://wikipedia.org/wiki/Numerical_methods_for_linear_least_squares)<span
style="font-size:medium">. </span><span id="hevea_default1043"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> also provides <span
style="font-family:monospace">FitLine</span>, which takes <span
style="font-family:monospace">inter</span> and <span
style="font-family:monospace">slope</span> and returns the fitted line
for a sequence of <span style="font-family:monospace">xs</span>.
</span><span id="hevea_default1044"></span>

    def FitLine(xs, inter, slope):
        fit_xs = np.sort(xs)
        fit_ys = inter + slope * fit_xs
        return fit_xs, fit_ys

<span style="font-size:medium">We can use these functions to compute the
least squares fit for birth weight as a function of mother’s age.
</span><span id="hevea_default1045"></span><span
style="font-size:medium"> </span><span
id="hevea_default1046"></span><span style="font-size:medium">
</span><span id="hevea_default1047"></span>

        live, firsts, others = first.MakeFrames()
        live = live.dropna(subset=['agepreg', 'totalwgt_lb'])
        ages = live.agepreg
        weights = live.totalwgt_lb

        inter, slope = thinkstats2.LeastSquares(ages, weights)
        fit_xs, fit_ys = thinkstats2.FitLine(ages, inter, slope)

<span style="font-size:medium">The estimated intercept and slope are 6.8
lbs and 0.017 lbs per year. These values are hard to interpret in this
form: the intercept is the expected weight of a baby whose mother is 0
years old, which doesn’t make sense in context, and the slope is too
small to grasp easily. </span><span id="hevea_default1048"></span><span
style="font-size:medium"> </span><span
id="hevea_default1049"></span><span style="font-size:medium">
</span><span id="hevea_default1050"></span><span
style="font-size:medium"> </span><span id="hevea_default1051"></span>

<span style="font-size:medium">Instead of presenting the intercept at
<span style="font-style:italic">x</span>=0, it is often helpful to
present the intercept at the mean of <span
style="font-style:italic">x</span>. In this case the mean age is about
25 years and the mean baby weight for a 25 year old mother is 7.3
pounds. The slope is 0.27 ounces per year, or 0.17 pounds per
decade.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2035.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 10.1: Scatter plot of birth weight and mother’s age with a linear fit.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="linear1"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">10.1</span>](#linear1)<span
style="font-size:medium"> shows a scatter plot of birth weight and age
along with the fitted line. It’s a good idea to look at a figure like
this to assess whether the relationship is linear and whether the fitted
line seems like a good model of the relationship. </span><span
id="hevea_default1052"></span><span style="font-size:medium">
</span><span id="hevea_default1053"></span><span
style="font-size:medium"> </span><span
id="hevea_default1054"></span><span style="font-size:medium">
</span><span id="hevea_default1055"></span><span
style="font-size:medium"> </span><span id="hevea_default1056"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.3  Residuals</span>
-----------------------------------------------------

<span style="font-size:medium"> </span><span id="residuals"></span>

<span style="font-size:medium">Another useful test is to plot the
residuals. <span style="font-family:monospace">thinkstats2</span>
provides a function that computes residuals: </span><span
id="hevea_default1057"></span>

    def Residuals(xs, ys, inter, slope):
        xs = np.asarray(xs)
        ys = np.asarray(ys)
        res = ys - (inter + slope * xs)
        return res

<span style="font-size:medium"><span
style="font-family:monospace">Residuals</span> takes sequences <span
style="font-family:monospace">xs</span> and <span
style="font-family:monospace">ys</span> and estimated parameters <span
style="font-family:monospace">inter</span> and <span
style="font-family:monospace">slope</span>. It returns the differences
between the actual values and the fitted line.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2036.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 10.2: Residuals of the linear fit.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="linear2"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">To visualize the residuals, I group
respondents by age and compute percentiles in each group, as we saw in
Section </span>[<span
style="font-size:medium">7.2</span>](thinkstats2008.html#characterizing)<span
style="font-size:medium">. Figure </span>[<span
style="font-size:medium">10.2</span>](#linear2)<span
style="font-size:medium"> shows the 25th, 50th and 75th percentiles of
the residuals for each age group. The median is near zero, as expected,
and the interquartile range is about 2 pounds. So if we know the
mother’s age, we can guess the baby’s weight within a pound, about 50%
of the time. </span><span id="hevea_default1058"></span>

<span style="font-size:medium">Ideally these lines should be flat,
indicating that the residuals are random, and parallel, indicating that
the variance of the residuals is the same for all age groups. In fact,
the lines are close to parallel, so that’s good; but they have some
curvature, indicating that the relationship is nonlinear. Nevertheless,
the linear fit is a simple model that is probably good enough for some
purposes. </span><span id="hevea_default1059"></span><span
style="font-size:medium"> </span><span id="hevea_default1060"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.4  Estimation</span>
------------------------------------------------------

<span style="font-size:medium"> </span><span id="regest"></span>

<span style="font-size:medium">The parameters <span
style="font-family:monospace">slope</span> and <span
style="font-family:monospace">inter</span> are estimates based on a
sample; like other estimates, they are vulnerable to sampling bias,
measurement error, and sampling error. As discussed in
Chapter </span>[<span
style="font-size:medium">8</span>](thinkstats2009.html#estimation)<span
style="font-size:medium">, sampling bias is caused by non-representative
sampling, measurement error is caused by errors in collecting and
recording data, and sampling error is the result of measuring a sample
rather than the entire population. </span><span
id="hevea_default1061"></span><span style="font-size:medium">
</span><span id="hevea_default1062"></span><span
style="font-size:medium"> </span><span
id="hevea_default1063"></span><span style="font-size:medium">
</span><span id="hevea_default1064"></span><span
style="font-size:medium"> </span><span id="hevea_default1065"></span>

<span style="font-size:medium">To assess sampling error, we ask, “If we
run this experiment again, how much variability do we expect in the
estimates?” We can answer this question by running simulated experiments
and computing sampling distributions of the estimates. </span><span
id="hevea_default1066"></span><span style="font-size:medium">
</span><span id="hevea_default1067"></span>

<span style="font-size:medium">I simulate the experiments by resampling
the data; that is, I treat the observed pregnancies as if they were the
entire population and draw samples, with replacement, from the observed
sample. </span><span id="hevea_default1068"></span><span
style="font-size:medium"> </span><span id="hevea_default1069"></span>

    def SamplingDistributions(live, iters=101):
        t = []
        for _ in range(iters):
            sample = thinkstats2.ResampleRows(live)
            ages = sample.agepreg
            weights = sample.totalwgt_lb
            estimates = thinkstats2.LeastSquares(ages, weights)
            t.append(estimates)

        inters, slopes = zip(*t)
        return inters, slopes

<span style="font-size:medium"><span
style="font-family:monospace">SamplingDistributions</span> takes a
DataFrame with one row per live birth, and <span
style="font-family:monospace">iters</span>, the number of experiments to
simulate. It uses <span
style="font-family:monospace">ResampleRows</span> to resample the
observed pregnancies. We’ve already seen <span
style="font-family:monospace">SampleRows</span>, which chooses random
rows from a DataFrame. <span
style="font-family:monospace">thinkstats2</span> also provides <span
style="font-family:monospace">ResampleRows</span>, which returns a
sample the same size as the original: </span><span
id="hevea_default1070"></span><span style="font-size:medium">
</span><span id="hevea_default1071"></span>

    def ResampleRows(df):
        return SampleRows(df, len(df), replace=True)

<span style="font-size:medium">After resampling, we use the simulated
sample to estimate parameters. The result is two sequences: the
estimated intercepts and estimated slopes. </span><span
id="hevea_default1072"></span>

<span style="font-size:medium">I summarize the sampling distributions by
printing the standard error and confidence interval: </span><span
id="hevea_default1073"></span>

    def Summarize(estimates, actual=None):
        mean = thinkstats2.Mean(estimates)
        stderr = thinkstats2.Std(estimates, mu=actual)
        cdf = thinkstats2.Cdf(estimates)
        ci = cdf.ConfidenceInterval(90)
        print('mean, SE, CI', mean, stderr, ci)

<span style="font-size:medium"><span
style="font-family:monospace">Summarize</span> takes a sequence of
estimates and the actual value. It prints the mean of the estimates, the
standard error and a 90% confidence interval. </span><span
id="hevea_default1074"></span><span style="font-size:medium">
</span><span id="hevea_default1075"></span>

<span style="font-size:medium">For the intercept, the mean estimate is
6.83, with standard error 0.07 and 90% confidence interval (6.71, 6.94).
The estimated slope, in more compact form, is 0.0174, SE 0.0028, CI
(0.0126, 0.0220). There is almost a factor of two between the low and
high ends of this CI, so it should be considered a rough
estimate.</span>

<span style="font-size:medium">To visualize the sampling error of the
estimate, we could plot all of the fitted lines, or for a less cluttered
representation, plot a 90% confidence interval for each age. Here’s the
code:</span>

    def PlotConfidenceIntervals(xs, inters, slopes,
                                percent=90, **options):
        fys_seq = []
        for inter, slope in zip(inters, slopes):
            fxs, fys = thinkstats2.FitLine(xs, inter, slope)
            fys_seq.append(fys)

        p = (100 - percent) / 2
        percents = p, 100 - p
        low, high = thinkstats2.PercentileRows(fys_seq, percents)
        thinkplot.FillBetween(fxs, low, high, **options)

<span style="font-size:medium"><span
style="font-family:monospace">xs</span> is the sequence of mother’s age.
<span style="font-family:monospace">inters</span> and <span
style="font-family:monospace">slopes</span> are the estimated parameters
generated by <span
style="font-family:monospace">SamplingDistributions</span>. <span
style="font-family:monospace">percent</span> indicates which confidence
interval to plot.</span>

<span style="font-size:medium"><span
style="font-family:monospace">PlotConfidenceIntervals</span> generates a
fitted line for each pair of <span
style="font-family:monospace">inter</span> and <span
style="font-family:monospace">slope</span> and stores the results in a
sequence, `fys_seq`. Then it uses <span
style="font-family:monospace">PercentileRows</span> to select the upper
and lower percentiles of <span style="font-family:monospace">y</span>
for each value of <span style="font-family:monospace">x</span>. For a
90% confidence interval, it selects the 5th and 95th percentiles. <span
style="font-family:monospace">FillBetween</span> draws a polygon that
fills the space between two lines. </span><span
id="hevea_default1076"></span><span style="font-size:medium">
</span><span id="hevea_default1077"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2037.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 10.3: 50% and 90% confidence intervals showing variability in the fitted line due to sampling error of <span style="font-family:monospace">inter</span> and <span style="font-family:monospace">slope</span>.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="linear3"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">10.3</span>](#linear3)<span
style="font-size:medium"> shows the 50% and 90% confidence intervals for
curves fitted to birth weight as a function of mother’s age. The
vertical width of the region represents the effect of sampling error;
the effect is smaller for values near the mean and larger for the
extremes.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.5  Goodness of fit</span>
-----------------------------------------------------------

<span style="font-size:medium"> </span><span id="goodness"></span><span
style="font-size:medium"> </span><span id="hevea_default1078"></span>

<span style="font-size:medium">There are several ways to measure the
quality of a linear model, or <span style="font-weight:bold">goodness of
fit</span>. One of the simplest is the standard deviation of the
residuals. </span><span id="hevea_default1079"></span><span
style="font-size:medium"> </span><span id="hevea_default1080"></span>

<span style="font-size:medium">If you use a linear model to make
predictions, <span style="font-family:monospace">Std(res)</span> is the
root mean squared error (RMSE) of your predictions. For example, if you
use mother’s age to guess birth weight, the RMSE of your guess would be
1.40 lbs. </span><span id="hevea_default1081"></span><span
style="font-size:medium"> </span><span id="hevea_default1082"></span>

<span style="font-size:medium">If you guess birth weight without knowing
the mother’s age, the RMSE of your guess is <span
style="font-family:monospace">Std(ys)</span>, which is 1.41 lbs. So in
this example, knowing a mother’s age does not improve the predictions
substantially. </span><span id="hevea_default1083"></span>

<span style="font-size:medium">Another way to measure goodness of fit is
the <span style="font-weight:bold">coefficient of determination</span>,
usually denoted <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
and called “R-squared”: </span><span id="hevea_default1084"></span><span
style="font-size:medium"> </span><span id="hevea_default1085"></span>

    def CoefDetermination(ys, res):
        return 1 - Var(res) / Var(ys)

<span style="font-size:medium"><span
style="font-family:monospace">Var(res)</span> is the MSE of your guesses
using the model, <span style="font-family:monospace">Var(ys)</span> is
the MSE without it. So their ratio is the fraction of MSE that remains
if you use the model, and <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is the fraction of MSE the model eliminates. </span><span
id="hevea_default1086"></span>

<span style="font-size:medium">For birth weight and mother’s age, <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is 0.0047, which means that mother’s age predicts about half of 1% of
variance in birth weight.</span>

<span style="font-size:medium">There is a simple relationship between
the coefficient of determination and Pearson’s coefficient of
correlation: <span style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium"> =
ρ</span><sup><span style="font-size:medium">2</span></sup><span
style="font-size:medium">. For example, if ρ is 0.8 or -0.8, <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium"> =
0.64. </span><span id="hevea_default1087"></span>

<span style="font-size:medium">Although ρ and <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
are often used to quantify the strength of a relationship, they are not
easy to interpret in terms of predictive power. In my opinion, <span
style="font-family:monospace">Std(res)</span> is the best representation
of the quality of prediction, especially if it is presented in relation
to <span style="font-family:monospace">Std(ys)</span>. </span><span
id="hevea_default1088"></span><span style="font-size:medium">
</span><span id="hevea_default1089"></span>

<span style="font-size:medium">For example, when people talk about the
validity of the SAT (a standardized test used for college admission in
the U.S.) they often talk about correlations between SAT scores and
other measures of intelligence. </span><span
id="hevea_default1090"></span><span style="font-size:medium">
</span><span id="hevea_default1091"></span>

<span style="font-size:medium">According to one study, there is a
Pearson correlation of ρ=0.72 between total SAT scores and IQ scores,
which sounds like a strong correlation. But <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium"> =
ρ</span><sup><span style="font-size:medium">2</span></sup><span
style="font-size:medium"> = 0.52, so SAT scores account for only 52% of
variance in IQ.</span>

<span style="font-size:medium">IQ scores are normalized with <span
style="font-family:monospace">Std(ys) = 15</span>, so</span>

    >>> var_ys = 15**2
    >>> rho = 0.72
    >>> r2 = rho**2
    >>> var_res = (1 - r2) * var_ys
    >>> std_res = math.sqrt(var_res)
    10.4096

<span style="font-size:medium">So using SAT score to predict IQ reduces
RMSE from 15 points to 10.4 points. A correlation of 0.72 yields a
reduction in RMSE of only 31%.</span>

<span style="font-size:medium">If you see a correlation that looks
impressive, remember that <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is a better indicator of reduction in MSE, and reduction in RMSE is a
better indicator of predictive power. </span><span
id="hevea_default1092"></span><span style="font-size:medium">
</span><span id="hevea_default1093"></span><span
style="font-size:medium"> </span><span id="hevea_default1094"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.6  Testing a linear model</span>
------------------------------------------------------------------

<span style="font-size:medium">The effect of mother’s age on birth
weight is small, and has little predictive power. So is it possible that
the apparent relationship is due to chance? There are several ways we
might test the results of a linear fit. </span><span
id="hevea_default1095"></span><span style="font-size:medium">
</span><span id="hevea_default1096"></span><span
style="font-size:medium"> </span><span
id="hevea_default1097"></span><span style="font-size:medium">
</span><span id="hevea_default1098"></span>

<span style="font-size:medium">One option is to test whether the
apparent reduction in MSE is due to chance. In that case, the test
statistic is <span style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
and the null hypothesis is that there is no relationship between the
variables. We can simulate the null hypothesis by permutation, as in
Section </span>[<span
style="font-size:medium">9.5</span>](thinkstats2010.html#corrtest)<span
style="font-size:medium">, when we tested the correlation between
mother’s age and birth weight. In fact, because <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium"> =
ρ</span><sup><span style="font-size:medium">2</span></sup><span
style="font-size:medium">, a one-sided test of <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is equivalent to a two-sided test of ρ. We’ve already done that test,
and found <span style="font-style:italic">p</span> &lt; 0.001, so we
conclude that the apparent relationship between mother’s age and birth
weight is statistically significant. </span><span
id="hevea_default1099"></span><span style="font-size:medium">
</span><span id="hevea_default1100"></span><span
style="font-size:medium"> </span><span
id="hevea_default1101"></span><span style="font-size:medium">
</span><span id="hevea_default1102"></span><span
style="font-size:medium"> </span><span
id="hevea_default1103"></span><span style="font-size:medium">
</span><span id="hevea_default1104"></span>

<span style="font-size:medium">Another approach is to test whether the
apparent slope is due to chance. The null hypothesis is that the slope
is actually zero; in that case we can model the birth weights as random
variations around their mean. Here’s a HypothesisTest for this model:
</span><span id="hevea_default1105"></span><span
style="font-size:medium"> </span><span id="hevea_default1106"></span>

    class SlopeTest(thinkstats2.HypothesisTest):

        def TestStatistic(self, data):
            ages, weights = data
            _, slope = thinkstats2.LeastSquares(ages, weights)
            return slope

        def MakeModel(self):
            _, weights = self.data
            self.ybar = weights.mean()
            self.res = weights - self.ybar

        def RunModel(self):
            ages, _ = self.data
            weights = self.ybar + np.random.permutation(self.res)
            return ages, weights

<span style="font-size:medium">The data are represented as sequences of
ages and weights. The test statistic is the slope estimated by <span
style="font-family:monospace">LeastSquares</span>. The model of the null
hypothesis is represented by the mean weight of all babies and the
deviations from the mean. To generate simulated data, we permute the
deviations and add them to the mean. </span><span
id="hevea_default1107"></span><span style="font-size:medium">
</span><span id="hevea_default1108"></span><span
style="font-size:medium"> </span><span id="hevea_default1109"></span>

<span style="font-size:medium">Here’s the code that runs the hypothesis
test:</span>

        live, firsts, others = first.MakeFrames()
        live = live.dropna(subset=['agepreg', 'totalwgt_lb'])
        ht = SlopeTest((live.agepreg, live.totalwgt_lb))
        pvalue = ht.PValue()

<span style="font-size:medium">The p-value is less than 0.001, so
although the estimated slope is small, it is unlikely to be due to
chance. </span><span id="hevea_default1110"></span><span
style="font-size:medium"> </span><span
id="hevea_default1111"></span><span style="font-size:medium">
</span><span id="hevea_default1112"></span>

<span style="font-size:medium">Estimating the p-value by simulating the
null hypothesis is strictly correct, but there is a simpler alternative.
Remember that we already computed the sampling distribution of the
slope, in Section </span>[<span
style="font-size:medium">10.4</span>](#regest)<span
style="font-size:medium">. To do that, we assumed that the observed
slope was correct and simulated experiments by resampling. </span><span
id="hevea_default1113"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">10.4</span>](#linear4)<span
style="font-size:medium"> shows the sampling distribution of the slope,
from Section </span>[<span
style="font-size:medium">10.4</span>](#regest)<span
style="font-size:medium">, and the distribution of slopes generated
under the null hypothesis. The sampling distribution is centered about
the estimated slope, 0.017 lbs/year, and the slopes under the null
hypothesis are centered around 0; but other than that, the distributions
are identical. The distributions are also symmetric, for reasons we will
see in Section </span>[<span
style="font-size:medium">14.4</span>](thinkstats2015.html#CLT)<span
style="font-size:medium">. </span><span
id="hevea_default1114"></span><span style="font-size:medium">
</span><span id="hevea_default1115"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2038.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 10.4: The sampling distribution of the estimated slope and the distribution of slopes generated under the null hypothesis. The vertical lines are at 0 and the observed slope, 0.017 lbs/year.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="linear4"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">So we could estimate the p-value two
ways: </span><span id="hevea_default1116"></span>

-   <span style="font-size:medium">Compute the probability that the
    slope under the null hypothesis exceeds the observed slope.
    </span><span id="hevea_default1117"></span>
-   <span style="font-size:medium">Compute the probability that the
    slope in the sampling distribution falls below 0. (If the estimated
    slope were negative, we would compute the probability that the slope
    in the sampling distribution exceeds 0.)</span>

<span style="font-size:medium">The second option is easier because we
normally want to compute the sampling distribution of the parameters
anyway. And it is a good approximation unless the sample size is small
*and* the distribution of residuals is skewed. Even then, it is usually
good enough, because p-values don’t have to be precise. </span><span
id="hevea_default1118"></span><span style="font-size:medium">
</span><span id="hevea_default1119"></span>

<span style="font-size:medium">Here’s the code that estimates the
p-value of the slope using the sampling distribution: </span><span
id="hevea_default1120"></span>

        inters, slopes = SamplingDistributions(live, iters=1001)
        slope_cdf = thinkstats2.Cdf(slopes)
        pvalue = slope_cdf[0]

<span style="font-size:medium">Again, we find <span
style="font-style:italic">p</span> &lt; 0.001. </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.7  Weighted resampling</span>
---------------------------------------------------------------

<span style="font-size:medium"> </span><span id="weighted"></span>

<span style="font-size:medium">So far we have treated the NSFG data as
if it were a representative sample, but as I mentioned in
Section </span>[<span
style="font-size:medium">1.2</span>](thinkstats2002.html#nsfg)<span
style="font-size:medium">, it is not. The survey deliberately
oversamples several groups in order to improve the chance of getting
statistically significant results; that is, in order to improve the
power of tests involving these groups. </span><span
id="hevea_default1121"></span><span style="font-size:medium">
</span><span id="hevea_default1122"></span>

<span style="font-size:medium">This survey design is useful for many
purposes, but it means that we cannot use the sample to estimate values
for the general population without accounting for the sampling
process.</span>

<span style="font-size:medium">For each respondent, the NSFG data
includes a variable called <span
style="font-family:monospace">finalwgt</span>, which is the number of
people in the general population the respondent represents. This value
is called a <span style="font-weight:bold">sampling weight</span>, or
just “weight.” </span><span id="hevea_default1123"></span><span
style="font-size:medium"> </span><span
id="hevea_default1124"></span><span style="font-size:medium">
</span><span id="hevea_default1125"></span><span
style="font-size:medium"> </span><span id="hevea_default1126"></span>

<span style="font-size:medium">As an example, if you survey 100,000
people in a country of 300 million, each respondent represents 3,000
people. If you oversample one group by a factor of 2, each person in the
oversampled group would have a lower weight, about 1500.</span>

<span style="font-size:medium">To correct for oversampling, we can use
resampling; that is, we can draw samples from the survey using
probabilities proportional to sampling weights. Then, for any quantity
we want to estimate, we can generate sampling distributions, standard
errors, and confidence intervals. As an example, I will estimate mean
birth weight with and without sampling weights. </span><span
id="hevea_default1127"></span><span style="font-size:medium">
</span><span id="hevea_default1128"></span><span
style="font-size:medium"> </span><span
id="hevea_default1129"></span><span style="font-size:medium">
</span><span id="hevea_default1130"></span><span
style="font-size:medium"> </span><span
id="hevea_default1131"></span><span style="font-size:medium">
</span><span id="hevea_default1132"></span>

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">10.4</span>](#regest)<span
style="font-size:medium">, we saw <span
style="font-family:monospace">ResampleRows</span>, which chooses rows
from a DataFrame, giving each row the same probability. Now we need to
do the same thing using probabilities proportional to sampling weights.
<span style="font-family:monospace">ResampleRowsWeighted</span> takes a
DataFrame, resamples rows according to the weights in <span
style="font-family:monospace">finalwgt</span>, and returns a DataFrame
containing the resampled rows: </span><span
id="hevea_default1133"></span><span style="font-size:medium">
</span><span id="hevea_default1134"></span>

    def ResampleRowsWeighted(df, column='finalwgt'):
        weights = df[column]
        cdf = Cdf(dict(weights))
        indices = cdf.Sample(len(weights))
        sample = df.loc[indices]
        return sample

<span style="font-size:medium"><span
style="font-family:monospace">weights</span> is a Series; converting it
to a dictionary makes a map from the indices to the weights. In <span
style="font-family:monospace">cdf</span> the values are indices and the
probabilities are proportional to the weights.</span>

<span style="font-size:medium"><span
style="font-family:monospace">indices</span> is a sequence of row
indices; <span style="font-family:monospace">sample</span> is a
DataFrame that contains the selected rows. Since we sample with
replacement, the same row might appear more than once. </span><span
id="hevea_default1135"></span><span style="font-size:medium">
</span><span id="hevea_default1136"></span>

<span style="font-size:medium">Now we can compare the effect of
resampling with and without weights. Without weights, we generate the
sampling distribution like this: </span><span
id="hevea_default1137"></span>

        estimates = [ResampleRows(live).totalwgt_lb.mean()
                     for _ in range(iters)]

<span style="font-size:medium">With weights, it looks like this:</span>

        estimates = [ResampleRowsWeighted(live).totalwgt_lb.mean()
                     for _ in range(iters)]

<span style="font-size:medium">The following table summarizes the
results:</span>

<span style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium"> </span></td>
<td style="text-align: center;"><span style="font-size:medium">mean birth</span></td>
<td style="text-align: center;"><span style="font-size:medium">standard</span></td>
<td style="text-align: center;"><span style="font-size:medium">90% CI </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium"> </span></td>
<td style="text-align: center;"><span style="font-size:medium">weight (lbs)</span></td>
<td style="text-align: center;"><span style="font-size:medium">error</span></td>
<td style="text-align: center;"><span style="font-size:medium"> </span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">Unweighted</span></td>
<td style="text-align: center;"><span style="font-size:medium">7.27</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.014</span></td>
<td style="text-align: center;"><span style="font-size:medium">(7.24, 7.29) </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">Weighted</span></td>
<td style="text-align: center;"><span style="font-size:medium">7.35</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.014</span></td>
<td style="text-align: center;"><span style="font-size:medium">(7.32, 7.37) </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">In this example, the effect of weighting
is small but non-negligible. The difference in estimated means, with and
without weighting, is about 0.08 pounds, or 1.3 ounces. This difference
is substantially larger than the standard error of the estimate, 0.014
pounds, which implies that the difference is not due to chance.
</span><span id="hevea_default1138"></span><span
style="font-size:medium"> </span><span id="hevea_default1139"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.8  Exercises</span>
-----------------------------------------------------

<span style="font-size:medium">A solution to this exercise is in
`chap10soln.ipynb`</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>  </span>

<span style="font-size:medium">*Using the data from the BRFSS, compute
the linear least squares fit for log(weight) versus height. How would
you best present the estimated parameters for a model like this where
one of the variables is log-transformed? If you were trying to guess
someone’s weight, how much would it help to know their height?*
</span><span id="hevea_default1140"></span><span
style="font-size:medium"> </span><span
id="hevea_default1141"></span><span style="font-size:medium">
</span><span id="hevea_default1142"></span>

<span style="font-size:medium">*Like the NSFG, the BRFSS oversamples
some groups and provides a sampling weight for each respondent. In the
BRFSS data, the variable name for these weights is <span
style="font-family:monospace">finalwt</span>. Use resampling, with and
without weights, to estimate the mean height of respondents in the
BRFSS, the standard error of the mean, and a 90% confidence interval.
How much does correct weighting affect the estimates?* </span><span
id="hevea_default1143"></span><span style="font-size:medium">
</span><span id="hevea_default1144"></span><span
style="font-size:medium"> </span><span
id="hevea_default1145"></span><span style="font-size:medium">
</span><span id="hevea_default1146"></span><span
style="font-size:medium"> </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">10.9  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">linear fit: a line intended to model
    the relationship between variables. </span><span
    id="hevea_default1147"></span>
-   <span style="font-size:medium">least squares fit: A model of a
    dataset that minimizes the sum of squares of the residuals.
    </span><span id="hevea_default1148"></span>
-   <span style="font-size:medium">residual: The deviation of an actual
    value from a model. </span><span id="hevea_default1149"></span>
-   <span style="font-size:medium">goodness of fit: A measure of how
    well a model fits data. </span><span id="hevea_default1150"></span>
-   <span style="font-size:medium">coefficient of determination: A
    statistic intended to quantify goodness of fit. </span><span
    id="hevea_default1151"></span>
-   <span style="font-size:medium">sampling weight: A value associated
    with an observation in a sample that indicates what part of the
    population it represents. </span><span
    id="hevea_default1152"></span>

<span style="font-size:medium"> </span>
