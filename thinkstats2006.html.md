This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 5  Modeling distributions</span>
=======================================================================

<span style="font-size:medium"> </span><span id="modeling"></span>

<span style="font-size:medium">The distributions we have used so far are
called <span style="font-weight:bold">empirical distributions</span>
because they are based on empirical observations, which are necessarily
finite samples. </span><span id="hevea_default316"></span><span
style="font-size:medium"> </span><span
id="hevea_default317"></span><span style="font-size:medium">
</span><span id="hevea_default318"></span><span
style="font-size:medium"> </span><span id="hevea_default319"></span>

<span style="font-size:medium">The alternative is an <span
style="font-weight:bold">analytic distribution</span>, which is
characterized by a CDF that is a mathematical function. Analytic
distributions can be used to model empirical distributions. In this
context, a <span style="font-weight:bold">model</span> is a
simplification that leaves out unneeded details. This chapter presents
common analytic distributions and uses them to model data from a variety
of sources. </span><span id="hevea_default320"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">analytic.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.1  The exponential distribution</span>
-----------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="exponential"></span><span style="font-size:medium"> </span><span
id="hevea_default321"></span><span style="font-size:medium">
</span><span id="hevea_default322"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2014.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.1: CDFs of exponential distributions with various parameters.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_expo_cdf"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">I’ll start with the <span
style="font-weight:bold">exponential distribution</span> because it is
relatively simple. The CDF of the exponential distribution is </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(<span style="font-style:italic">x</span>) = 1 − <span style="font-style:italic">e</span></span><sup><span style="font-size:medium">−λ <span style="font-style:italic">x</span></span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The parameter, λ, determines the shape
of the distribution. Figure </span>[<span
style="font-size:medium">5.1</span>](#analytic_expo_cdf)<span
style="font-size:medium"> shows what this CDF looks like with λ = 0.5,
1, and 2. </span><span id="hevea_default323"></span>

<span style="font-size:medium">In the real world, exponential
distributions come up when we look at a series of events and measure the
times between events, called <span style="font-weight:bold">interarrival
times</span>. If the events are equally likely to occur at any time, the
distribution of interarrival times tends to look like an exponential
distribution. </span><span id="hevea_default324"></span>

<span style="font-size:medium">As an example, we will look at the
interarrival time of births. On December 18, 1997, 44 babies were born
in a hospital in Brisbane,
Australia.</span><sup><a href="#note1" id="text1"><span style="font-size:medium">1</span></a></sup><span
style="font-size:medium"> The time of birth for all 44 babies was
reported in the local paper; the complete dataset is in a file called
<span style="font-family:monospace">babyboom.dat</span>, in the <span
style="font-family:monospace">ThinkStats2</span> repository.
</span><span id="hevea_default325"></span><span
style="font-size:medium"> </span><span
id="hevea_default326"></span><span style="font-size:medium">
</span><span id="hevea_default327"></span>

        df = ReadBabyBoom()
        diffs = df.minutes.diff()
        cdf = thinkstats2.Cdf(diffs, label='actual')

        thinkplot.Cdf(cdf)
        thinkplot.Show(xlabel='minutes', ylabel='CDF')

<span style="font-size:medium"><span
style="font-family:monospace">ReadBabyBoom</span> reads the data file
and returns a DataFrame with columns <span
style="font-family:monospace">time</span>, <span
style="font-family:monospace">sex</span>, `weight_g`, and <span
style="font-family:monospace">minutes</span>, where <span
style="font-family:monospace">minutes</span> is time of birth converted
to minutes since midnight. </span><span
id="hevea_default328"></span><span style="font-size:medium">
</span><span id="hevea_default329"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2015.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.2: CDF of interarrival times (left) and CCDF on a log-y scale (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_interarrival_cdf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">diffs</span> is the difference between
consecutive birth times, and <span
style="font-family:monospace">cdf</span> is the distribution of these
interarrival times. Figure </span>[<span
style="font-size:medium">5.2</span>](#analytic_interarrival_cdf)<span
style="font-size:medium"> (left) shows the CDF. It seems to have the
general shape of an exponential distribution, but how can we
tell?</span>

<span style="font-size:medium">One way is to plot the <span
style="font-weight:bold">complementary CDF</span>, which is 1 − <span
style="font-style:italic">CDF</span>(<span
style="font-style:italic">x</span>), on a log-y scale. For data from an
exponential distribution, the result is a straight line. Let’s see why
that works. </span><span id="hevea_default330"></span><span
style="font-size:medium"> </span><span
id="hevea_default331"></span><span style="font-size:medium">
</span><span id="hevea_default332"></span>

<span style="font-size:medium">If you plot the complementary CDF (CCDF)
of a dataset that you think is exponential, you expect to see a function
like: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">y</span> ≈ <span style="font-style:italic">e</span></span><sup><span style="font-size:medium">−λ <span style="font-style:italic">x</span></span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Taking the log of both sides yields:
</span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">log<span style="font-style:italic">y</span> ≈ −λ <span style="font-style:italic">x</span></span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> So on a log-y scale the CCDF is a
straight line with slope −λ. Here’s how we can generate a plot like
that: </span><span id="hevea_default333"></span><span
style="font-size:medium"> </span><span
id="hevea_default334"></span><span style="font-size:medium">
</span><span id="hevea_default335"></span><span
style="font-size:medium"> </span><span id="hevea_default336"></span>

        thinkplot.Cdf(cdf, complement=True)
        thinkplot.Show(xlabel='minutes',
                       ylabel='CCDF',
                       yscale='log')

<span style="font-size:medium">With the argument <span
style="font-family:monospace">complement=True</span>, <span
style="font-family:monospace">thinkplot.Cdf</span> computes the
complementary CDF before plotting. And with <span
style="font-family:monospace">yscale=’log’</span>, <span
style="font-family:monospace">thinkplot.Show</span> sets the <span
style="font-family:monospace">y</span> axis to a logarithmic scale.
</span><span id="hevea_default337"></span><span
style="font-size:medium"> </span><span id="hevea_default338"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.2</span>](#analytic_interarrival_cdf)<span
style="font-size:medium"> (right) shows the result. It is not exactly
straight, which indicates that the exponential distribution is not a
perfect model for this data. Most likely the underlying assumption—that
a birth is equally likely at any time of day—is not exactly true.
Nevertheless, it might be reasonable to model this dataset with an
exponential distribution. With that simplification, we can summarize the
distribution with a single parameter. </span><span
id="hevea_default339"></span>

<span style="font-size:medium">The parameter, λ, can be interpreted as a
rate; that is, the number of events that occur, on average, in a unit of
time. In this example, 44 babies are born in 24 hours, so the rate is λ
= 0.0306 births per minute. The mean of an exponential distribution is
1/λ, so the mean time between births is 32.7 minutes.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.2  The normal distribution</span>
------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="normal"></span>

<span style="font-size:medium">The <span style="font-weight:bold">normal
distribution</span>, also called Gaussian, is commonly used because it
describes many phenomena, at least approximately. It turns out that
there is a good reason for its ubiquity, which we will get to in
Section </span>[<span
style="font-size:medium">14.4</span>](thinkstats2015.html#CLT)<span
style="font-size:medium">. </span><span
id="hevea_default340"></span><span style="font-size:medium">
</span><span id="hevea_default341"></span><span
style="font-size:medium"> </span><span
id="hevea_default342"></span><span style="font-size:medium">
</span><span id="hevea_default343"></span><span
style="font-size:medium"> </span><span
id="hevea_default344"></span><span style="font-size:medium">
</span><span id="hevea_default345"></span><span
style="font-size:medium"> </span><span
id="hevea_default346"></span><span style="font-size:medium">
</span><span id="hevea_default347"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2016.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.3: CDF of normal distributions with a range of parameters.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_gaussian_cdf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">The normal distribution is characterized
by two parameters: the mean, µ, and standard deviation σ. The normal
distribution with µ=0 and σ=1 is called the <span
style="font-weight:bold">standard normal distribution</span>. Its CDF is
defined by an integral that does not have a closed form solution, but
there are algorithms that evaluate it efficiently. One of them is
provided by SciPy: <span
style="font-family:monospace">scipy.stats.norm</span> is an object that
represents a normal distribution; it provides a method, <span
style="font-family:monospace">cdf</span>, that evaluates the standard
normal CDF: </span><span id="hevea_default348"></span><span
style="font-size:medium"> </span><span id="hevea_default349"></span>

    >>> import scipy.stats
    >>> scipy.stats.norm.cdf(0)
    0.5

<span style="font-size:medium">This result is correct: the median of the
standard normal distribution is 0 (the same as the mean), and half of
the values fall below the median, so <span
style="font-style:italic">CDF</span>(0) is 0.5.</span>

<span style="font-size:medium"><span
style="font-family:monospace">norm.cdf</span> takes optional parameters:
<span style="font-family:monospace">loc</span>, which specifies the
mean, and <span style="font-family:monospace">scale</span>, which
specifies the standard deviation.</span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> makes this function a
little easier to use by providing <span
style="font-family:monospace">EvalNormalCdf</span>, which takes
parameters <span style="font-family:monospace">mu</span> and <span
style="font-family:monospace">sigma</span> and evaluates the CDF at
<span style="font-family:monospace">x</span>: </span><span
id="hevea_default350"></span>

    def EvalNormalCdf(x, mu=0, sigma=1):
        return scipy.stats.norm.cdf(x, loc=mu, scale=sigma)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.3</span>](#analytic_gaussian_cdf)<span
style="font-size:medium"> shows CDFs for normal distributions with a
range of parameters. The sigmoid shape of these curves is a recognizable
characteristic of a normal distribution.</span>

<span style="font-size:medium">In the previous chapter we looked at the
distribution of birth weights in the NSFG. Figure </span>[<span
style="font-size:medium">5.4</span>](#analytic_birthwgt_model)<span
style="font-size:medium"> shows the empirical CDF of weights for all
live births and the CDF of a normal distribution with the same mean and
variance. </span><span id="hevea_default351"></span><span
style="font-size:medium"> </span><span
id="hevea_default352"></span><span style="font-size:medium">
</span><span id="hevea_default353"></span><span
style="font-size:medium"> </span><span id="hevea_default354"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2017.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.4: CDF of birth weights with a normal model.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_birthwgt_model"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">The normal distribution is a good model
for this dataset, so if we summarize the distribution with the
parameters µ = 7.28 and σ = 1.24, the resulting error (difference
between the model and the data) is small. </span><span
id="hevea_default355"></span><span style="font-size:medium">
</span><span id="hevea_default356"></span>

<span style="font-size:medium">Below the 10th percentile there is a
discrepancy between the data and the model; there are more light babies
than we would expect in a normal distribution. If we are specifically
interested in preterm babies, it would be important to get this part of
the distribution right, so it might not be appropriate to use the normal
model.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.3  Normal probability plot</span>
------------------------------------------------------------------

<span style="font-size:medium">For the exponential distribution, and a
few others, there are simple transformations we can use to test whether
an analytic distribution is a good model for a dataset. </span><span
id="hevea_default357"></span><span style="font-size:medium">
</span><span id="hevea_default358"></span><span
style="font-size:medium"> </span><span id="hevea_default359"></span>

<span style="font-size:medium">For the normal distribution there is no
such transformation, but there is an alternative called a <span
style="font-weight:bold">normal probability plot</span>. There are two
ways to generate a normal probability plot: the hard way and the easy
way. If you are interested in the hard way, you can read about it at
</span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Normal\_probability\_plot</span>](https://en.wikipedia.org/wiki/Normal_probability_plot)<span
style="font-size:medium">. Here’s the easy way: </span><span
id="hevea_default360"></span><span style="font-size:medium">
</span><span id="hevea_default361"></span><span
style="font-size:medium"> </span><span
id="hevea_default362"></span><span style="font-size:medium">
</span><span id="hevea_default363"></span><span
style="font-size:medium"> </span><span
id="hevea_default364"></span><span style="font-size:medium">
</span><span id="hevea_default365"></span>

1.  <span style="font-size:medium">Sort the values in the sample.</span>
2.  <span style="font-size:medium">From a standard normal distribution
    (µ=0 and σ=1), generate a random sample with the same size as the
    sample, and sort it. </span><span id="hevea_default366"></span>
3.  <span style="font-size:medium">Plot the sorted values from the
    sample versus the random values.</span>

<span style="font-size:medium">If the distribution of the sample is
approximately normal, the result is a straight line with intercept <span
style="font-family:monospace">mu</span> and slope <span
style="font-family:monospace">sigma</span>. <span
style="font-family:monospace">thinkstats2</span> provides <span
style="font-family:monospace">NormalProbability</span>, which takes a
sample and returns two NumPy arrays: </span><span
id="hevea_default367"></span>

    xs, ys = thinkstats2.NormalProbability(sample)

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2018.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.5: Normal probability plot for random samples from normal distributions.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_normal_prob_example"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">ys</span> contains the sorted values from
<span style="font-family:monospace">sample</span>; <span
style="font-family:monospace">xs</span> contains the random values from
the standard normal distribution.</span>

<span style="font-size:medium">To test <span
style="font-family:monospace">NormalProbability</span> I generated some
fake samples that were actually drawn from normal distributions with
various parameters. Figure </span>[<span
style="font-size:medium">5.5</span>](#analytic_normal_prob_example)<span
style="font-size:medium"> shows the results. The lines are approximately
straight, with values in the tails deviating more than values near the
mean.</span>

<span style="font-size:medium">Now let’s try it with real data. Here’s
code to generate a normal probability plot for the birth weight data
from the previous section. It plots a gray line that represents the
model and a blue line that represents the data. </span><span
id="hevea_default368"></span><span style="font-size:medium">
</span><span id="hevea_default369"></span>

    def MakeNormalPlot(weights):
        mean = weights.mean()
        std = weights.std()

        xs = [-4, 4]
        fxs, fys = thinkstats2.FitLine(xs, inter=mean, slope=std)
        thinkplot.Plot(fxs, fys, color='gray', label='model')

        xs, ys = thinkstats2.NormalProbability(weights)
        thinkplot.Plot(xs, ys, label='birth weights')

<span style="font-size:medium"><span
style="font-family:monospace">weights</span> is a pandas Series of birth
weights; <span style="font-family:monospace">mean</span> and <span
style="font-family:monospace">std</span> are the mean and standard
deviation. </span><span id="hevea_default370"></span><span
style="font-size:medium"> </span><span
id="hevea_default371"></span><span style="font-size:medium">
</span><span id="hevea_default372"></span><span
style="font-size:medium"> </span><span id="hevea_default373"></span>

<span style="font-size:medium"><span
style="font-family:monospace">FitLine</span> takes a sequence of <span
style="font-family:monospace">xs</span>, an intercept, and a slope; it
returns <span style="font-family:monospace">xs</span> and <span
style="font-family:monospace">ys</span> that represent a line with the
given parameters, evaluated at the values in <span
style="font-family:monospace">xs</span>.</span>

<span style="font-size:medium"><span
style="font-family:monospace">NormalProbability</span> returns <span
style="font-family:monospace">xs</span> and <span
style="font-family:monospace">ys</span> that contain values from the
standard normal distribution and values from <span
style="font-family:monospace">weights</span>. If the distribution of
weights is normal, the data should match the model. </span><span
id="hevea_default374"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2019.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.6: Normal probability plot of birth weights.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_birthwgt_normal"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.6</span>](#analytic_birthwgt_normal)<span
style="font-size:medium"> shows the results for all live births, and
also for full term births (pregnancy length greater than 36 weeks). Both
curves match the model near the mean and deviate in the tails. The
heaviest babies are heavier than what the model expects, and the
lightest babies are lighter. </span><span id="hevea_default375"></span>

<span style="font-size:medium">When we select only full term births, we
remove some of the lightest weights, which reduces the discrepancy in
the lower tail of the distribution.</span>

<span style="font-size:medium">This plot suggests that the normal model
describes the distribution well within a few standard deviations from
the mean, but not in the tails. Whether it is good enough for practical
purposes depends on the purposes. </span><span
id="hevea_default376"></span><span style="font-size:medium">
</span><span id="hevea_default377"></span><span
style="font-size:medium"> </span><span
id="hevea_default378"></span><span style="font-size:medium">
</span><span id="hevea_default379"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.4  The lognormal distribution</span>
---------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="brfss"></span><span
style="font-size:medium"> </span><span id="lognormal"></span>

<span style="font-size:medium">If the logarithms of a set of values have
a normal distribution, the values have a <span
style="font-weight:bold">lognormal distribution</span>. The CDF of the
lognormal distribution is the same as the CDF of the normal
distribution, with log<span style="font-style:italic">x</span>
substituted for <span style="font-style:italic">x</span>. </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">CDF</span><sub><span style="font-style:italic;font-size:medium">lognormal</span></sub><span style="font-size:medium">(<span style="font-style:italic">x</span>) = <span style="font-style:italic">CDF</span></span><sub><span style="font-style:italic;font-size:medium">normal</span></sub><span style="font-size:medium">(log<span style="font-style:italic">x</span>)</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The parameters of the lognormal
distribution are usually denoted µ and σ. But remember that these
parameters are *not* the mean and standard deviation; the mean of a
lognormal distribution is exp(µ +σ</span><sup><span
style="font-size:medium">2</span></sup><span
style="font-size:medium">/2) and the standard deviation is ugly (see
</span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Log-normal\_distribution</span>](http://wikipedia.org/wiki/Log-normal_distribution)<span
style="font-size:medium">). </span><span
id="hevea_default380"></span><span style="font-size:medium">
</span><span id="hevea_default381"></span><span
style="font-size:medium"> </span><span
id="hevea_default382"></span><span style="font-size:medium">
</span><span id="hevea_default383"></span><span
style="font-size:medium"> </span><span
id="hevea_default384"></span><span style="font-size:medium">
</span><span id="hevea_default385"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium"> ![](thinkstats2020.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.7: CDF of adult weights on a linear scale (left) and log scale (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="brfss_weight"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">If a sample is approximately lognormal
and you plot its CDF on a log-x scale, it will have the characteristic
shape of a normal distribution. To test how well the sample fits a
lognormal model, you can make a normal probability plot using the log of
the values in the sample. </span><span
id="hevea_default386"></span><span style="font-size:medium">
</span><span id="hevea_default387"></span>

<span style="font-size:medium">As an example, let’s look at the
distribution of adult weights, which is approximately
lognormal.</span><sup><a href="#note2" id="text2"><span style="font-size:medium">2</span></a></sup>

<span style="font-size:medium">The National Center for Chronic Disease
Prevention and Health Promotion conducts an annual survey as part of the
Behavioral Risk Factor Surveillance System
(BRFSS).</span><sup><a href="#note3" id="text3"><span style="font-size:medium">3</span></a></sup><span
style="font-size:medium"> In 2008, they interviewed 414,509 respondents
and asked about their demographics, health, and health risks. Among the
data they collected are the weights in kilograms of 398,484 respondents.
</span><span id="hevea_default388"></span><span
style="font-size:medium"> </span><span id="hevea_default389"></span>

<span style="font-size:medium">The repository for this book contains
<span style="font-family:monospace">CDBRFS08.ASC.gz</span>, a
fixed-width ASCII file that contains data from the BRFSS, and <span
style="font-family:monospace">brfss.py</span>, which reads the file and
analyzes the data.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium"> ![](thinkstats2021.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.8: Normal probability plots for adult weight on a linear scale (left) and log scale (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="brfss_weight_normal"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.7</span>](#brfss_weight)<span
style="font-size:medium"> (left) shows the distribution of adult weights
on a linear scale with a normal model. Figure </span>[<span
style="font-size:medium">5.7</span>](#brfss_weight)<span
style="font-size:medium"> (right) shows the same distribution on a log
scale with a lognormal model. The lognormal model is a better fit, but
this representation of the data does not make the difference
particularly dramatic. </span><span id="hevea_default390"></span><span
style="font-size:medium"> </span><span id="hevea_default391"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.8</span>](#brfss_weight_normal)<span
style="font-size:medium"> shows normal probability plots for adult
weights, <span style="font-style:italic">w</span>, and for their
logarithms, log</span><sub><span
style="font-size:medium">10</span></sub><span style="font-size:medium">
<span style="font-style:italic">w</span>. Now it is apparent that the
data deviate substantially from the normal model. On the other hand, the
lognormal model is a good match for the data. </span><span
id="hevea_default392"></span><span style="font-size:medium">
</span><span id="hevea_default393"></span><span
style="font-size:medium"> </span><span
id="hevea_default394"></span><span style="font-size:medium">
</span><span id="hevea_default395"></span><span
style="font-size:medium"> </span><span
id="hevea_default396"></span><span style="font-size:medium">
</span><span id="hevea_default397"></span><span
style="font-size:medium"> </span><span
id="hevea_default398"></span><span style="font-size:medium">
</span><span id="hevea_default399"></span><span
style="font-size:medium"> </span><span
id="hevea_default400"></span><span style="font-size:medium">
</span><span id="hevea_default401"></span><span
style="font-size:medium"> </span><span id="hevea_default402"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.5  The Pareto distribution</span>
------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default403"></span><span style="font-size:medium">
</span><span id="hevea_default404"></span><span
style="font-size:medium"> </span><span id="hevea_default405"></span>

<span style="font-size:medium">The <span style="font-weight:bold">Pareto
distribution</span> is named after the economist Vilfredo Pareto, who
used it to describe the distribution of wealth (see </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Pareto\_distribution</span>](http://wikipedia.org/wiki/Pareto_distribution)<span
style="font-size:medium">). Since then, it has been used to describe
phenomena in the natural and social sciences including sizes of cities
and towns, sand particles and meteorites, forest fires and earthquakes.
</span><span id="hevea_default406"></span>

<span style="font-size:medium">The CDF of the Pareto distribution is:
</span>

<table style="width:100%;">
<colgroup>
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(<span style="font-style:italic">x</span>) = 1 − </span></td>
<td><span style="font-size:medium">⎛<br />
⎜<br />
⎜<br />
⎝</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">x</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">x</span><sub><span style="font-style:italic;font-size:medium">m</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
<td><span style="font-size:medium">⎞<br />
⎟<br />
⎟<br />
⎠</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">−α</span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium"><br />
<br />
<br />
</span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The parameters <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium"> and α determine the location and shape of the
distribution. <span style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium"> is the minimum possible value.
Figure </span>[<span
style="font-size:medium">5.9</span>](#analytic_pareto_cdf)<span
style="font-size:medium"> shows CDFs of Pareto distributions with <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium"> = 0.5 and different values of α. </span><span
id="hevea_default407"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2022.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.9: CDFs of Pareto distributions with different parameters.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="analytic_pareto_cdf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">There is a simple visual test that
indicates whether an empirical distribution fits a Pareto distribution:
on a log-log scale, the CCDF looks like a straight line. Let’s see why
that works.</span>

<span style="font-size:medium">If you plot the CCDF of a sample from a
Pareto distribution on a linear scale, you expect to see a function
like: </span>

<table style="width:100%;">
<colgroup>
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">y</span> ≈ </span></td>
<td><span style="font-size:medium">⎛<br />
⎜<br />
⎜<br />
⎝</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">x</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">x</span><sub><span style="font-style:italic;font-size:medium">m</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
<td><span style="font-size:medium">⎞<br />
⎟<br />
⎟<br />
⎠</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">−α</span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium"><br />
<br />
<br />
</span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Taking the log of both sides yields:
</span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">log<span style="font-style:italic">y</span> ≈ −α (log<span style="font-style:italic">x</span> − log<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">m</span></sub><span style="font-size:medium">)</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> So if you plot log<span
style="font-style:italic">y</span> versus log<span
style="font-style:italic">x</span>, it should look like a straight line
with slope −α and intercept α log<span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium">.</span>

<span style="font-size:medium">As an example, let’s look at the sizes of
cities and towns. The U.S. Census Bureau publishes the population of
every incorporated city and town in the United States. </span><span
id="hevea_default408"></span><span style="font-size:medium">
</span><span id="hevea_default409"></span><span
style="font-size:medium"> </span><span
id="hevea_default410"></span><span style="font-size:medium">
</span><span id="hevea_default411"></span><span
style="font-size:medium"> </span><span id="hevea_default412"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2023.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.10: CCDFs of city and town populations, on a log-log scale.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="populations_pareto"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">I downloaded their data from
</span>[<span
style="font-family:monospace;font-size:medium">http://www.census.gov/popest/data/cities/totals/2012/SUB-EST2012-3.html</span>](http://www.census.gov/popest/data/cities/totals/2012/SUB-EST2012-3.html)<span
style="font-size:medium">; it is in the repository for this book in a
file named `PEP_2012_PEPANNRES_with_ann.csv`. The repository also
contains <span style="font-family:monospace">populations.py</span>,
which reads the file and plots the distribution of populations.</span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">5.10</span>](#populations_pareto)<span
style="font-size:medium"> shows the CCDF of populations on a log-log
scale. The largest 1% of cities and towns, below 10</span><sup><span
style="font-size:medium">−2</span></sup><span style="font-size:medium">,
fall along a straight line. So we could conclude, as some researchers
have, that the tail of this distribution fits a Pareto model.
</span><span id="hevea_default413"></span>

<span style="font-size:medium">On the other hand, a lognormal
distribution also models the data well. Figure </span>[<span
style="font-size:medium">5.11</span>](#populations_normal)<span
style="font-size:medium"> shows the CDF of populations and a lognormal
model (left), and a normal probability plot (right). Both plots show
good agreement between the data and the model. </span><span
id="hevea_default414"></span>

<span style="font-size:medium">Neither model is perfect. The Pareto
model only applies to the largest 1% of cities, but it is a better fit
for that part of the distribution. The lognormal model is a better fit
for the other 99%. Which model is appropriate depends on which part of
the distribution is relevant.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2024.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 5.11: CDF of city and town populations on a log-x scale (left), and normal probability plot of log-transformed populations (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="populations_normal"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.6  Generating random numbers</span>
--------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default415"></span><span style="font-size:medium">
</span><span id="hevea_default416"></span><span
style="font-size:medium"> </span><span
id="hevea_default417"></span><span style="font-size:medium">
</span><span id="hevea_default418"></span><span
style="font-size:medium"> </span><span
id="hevea_default419"></span><span style="font-size:medium">
</span><span id="hevea_default420"></span><span
style="font-size:medium"> </span><span id="hevea_default421"></span>

<span style="font-size:medium">Analytic CDFs can be used to generate
random numbers with a given distribution function, <span
style="font-style:italic">p</span> = <span
style="font-style:italic">CDF</span>(<span
style="font-style:italic">x</span>). If there is an efficient way to
compute the inverse CDF, we can generate random values with the
appropriate distribution by choosing <span
style="font-style:italic">p</span> from a uniform distribution between 0
and 1, then choosing <span style="font-style:italic">x</span> = <span
style="font-style:italic">ICDF</span>(<span
style="font-style:italic">p</span>). </span><span
id="hevea_default422"></span><span style="font-size:medium">
</span><span id="hevea_default423"></span>

<span style="font-size:medium">For example, the CDF of the exponential
distribution is </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">p</span> = 1 − <span style="font-style:italic">e</span></span><sup><span style="font-size:medium">−λ <span style="font-style:italic">x</span></span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Solving for <span
style="font-style:italic">x</span> yields: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">x</span> = −log(1 − <span style="font-style:italic">p</span>) / λ </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> So in Python we can write </span>

    def expovariate(lam):
        p = random.random()
        x = -math.log(1-p) / lam
        return x

<span style="font-size:medium"><span
style="font-family:monospace">expovariate</span> takes <span
style="font-family:monospace">lam</span> and returns a random value
chosen from the exponential distribution with parameter <span
style="font-family:monospace">lam</span>.</span>

<span style="font-size:medium">Two notes about this implementation: I
called the parameter `lam` because `lambda` is a Python keyword. Also,
since log0 is undefined, we have to be a little careful. The
implementation of <span
style="font-family:monospace">random.random</span> can return 0 but not
1, so 1 − <span style="font-style:italic">p</span> can be 1 but not 0,
so <span style="font-family:monospace">log(1-p)</span> is always
defined. </span><span id="hevea_default424"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.7  Why model?</span>
-----------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default425"></span>

<span style="font-size:medium">At the beginning of this chapter, I said
that many real world phenomena can be modeled with analytic
distributions. “So,” you might ask, “what?” </span><span
id="hevea_default426"></span>

<span style="font-size:medium">Like all models, analytic distributions
are abstractions, which means they leave out details that are considered
irrelevant. For example, an observed distribution might have measurement
errors or quirks that are specific to the sample; analytic models smooth
out these idiosyncrasies. </span><span id="hevea_default427"></span>

<span style="font-size:medium">Analytic models are also a form of data
compression. When a model fits a dataset well, a small set of parameters
can summarize a large amount of data. </span><span
id="hevea_default428"></span><span style="font-size:medium">
</span><span id="hevea_default429"></span>

<span style="font-size:medium">It is sometimes surprising when data from
a natural phenomenon fit an analytic distribution, but these
observations can provide insight into physical systems. Sometimes we can
explain why an observed distribution has a particular form. For example,
Pareto distributions are often the result of generative processes with
positive feedback (so-called preferential attachment processes: see
</span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Preferential\_attachment</span>](http://wikipedia.org/wiki/Preferential_attachment)<span
style="font-size:medium">.). </span><span
id="hevea_default430"></span><span style="font-size:medium">
</span><span id="hevea_default431"></span><span
style="font-size:medium"> </span><span
id="hevea_default432"></span><span style="font-size:medium">
</span><span id="hevea_default433"></span><span
style="font-size:medium"> </span><span id="hevea_default434"></span>

<span style="font-size:medium">Also, analytic distributions lend
themselves to mathematical analysis, as we will see in
Chapter </span>[<span
style="font-size:medium">14</span>](thinkstats2015.html#analysis)<span
style="font-size:medium">.</span>

<span style="font-size:medium">But it is important to remember that all
models are imperfect. Data from the real world never fit an analytic
distribution perfectly. People sometimes talk as if data are generated
by models; for example, they might say that the distribution of human
heights is normal, or the distribution of income is lognormal. Taken
literally, these claims cannot be true; there are always differences
between the real world and mathematical models.</span>

<span style="font-size:medium">Models are useful if they capture the
relevant aspects of the real world and leave out unneeded details. But
what is “relevant” or “unneeded” depends on what you are planning to use
the model for.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.8  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">For the following exercises, you can
start with `chap05ex.ipynb`. My solution is in
`chap05soln.ipynb`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *In the BRFSS (see
Section *</span>[<span
style="font-size:medium">*5.4*</span>](#lognormal)<span
style="font-size:medium">*), the distribution of heights is roughly
normal with parameters* µ = 178 *cm and* σ = 7.7 *cm for men, and* µ =
163 *cm and* σ = 7.3 *cm for women.* </span><span
id="hevea_default435"></span><span style="font-size:medium">
</span><span id="hevea_default436"></span><span
style="font-size:medium"> </span><span
id="hevea_default437"></span><span style="font-size:medium">
</span><span id="hevea_default438"></span><span
style="font-size:medium"> </span><span
id="hevea_default439"></span><span style="font-size:medium">
</span><span id="hevea_default440"></span><span
style="font-size:medium"> </span><span id="hevea_default441"></span>

<span style="font-size:medium">*In order to join Blue Man Group, you
have to be male between 5’10” and 6’1” (see* </span>[<span
style="font-family:monospace;font-size:medium">*http://bluemancasting.com*</span>](http://bluemancasting.com)<span
style="font-size:medium">*). What percentage of the U.S. male population
is in this range? Hint: use <span
style="font-family:monospace">scipy.stats.norm.cdf</span>.* </span><span
id="hevea_default442"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *To get a feel for the
Pareto distribution, let’s see how different the world would be if the
distribution of human height were Pareto. With the parameters* <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium"> = 1 *m and* α = 1.7*, we get a distribution
with a reasonable minimum, 1 m, and median, 1.5 m.* </span><span
id="hevea_default443"></span><span style="font-size:medium">
</span><span id="hevea_default444"></span><span
style="font-size:medium"> </span><span id="hevea_default445"></span>

<span style="font-size:medium">*Plot this distribution. What is the mean
human height in Pareto world? What fraction of the population is shorter
than the mean? If there are 7 billion people in Pareto world, how many
do we expect to be taller than 1 km? How tall do we expect the tallest
person to be?* </span><span id="hevea_default446"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   </span><span
id="weibull"></span>

<span style="font-size:medium">*The Weibull distribution is a
generalization of the exponential distribution that comes up in failure
analysis (see* </span>[<span
style="font-family:monospace;font-size:medium">*http://wikipedia.org/wiki/Weibull\_distribution*</span>](http://wikipedia.org/wiki/Weibull_distribution)<span
style="font-size:medium">*). Its CDF is* </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(<span style="font-style:italic">x</span>) = 1 − <span style="font-style:italic">e</span></span><sup><span style="font-size:medium">−(<span style="font-style:italic">x</span> / λ)</span><sup><span style="font-style:italic;font-size:medium">k</span></sup></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> *Can you find a transformation that
makes a Weibull distribution look like a straight line? What do the
slope and intercept of the line indicate?* </span><span
id="hevea_default447"></span><span style="font-size:medium">
</span><span id="hevea_default448"></span><span
style="font-size:medium"> </span><span
id="hevea_default449"></span><span style="font-size:medium">
</span><span id="hevea_default450"></span><span
style="font-size:medium"> </span><span id="hevea_default451"></span>

<span style="font-size:medium">*Use <span
style="font-family:monospace">random.weibullvariate</span> to generate a
sample from a Weibull distribution and use it to test your
transformation.*</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 4</span>   *For small values of* <span
style="font-style:italic">n</span>*, we don’t expect an empirical
distribution to fit an analytic distribution exactly. One way to
evaluate the quality of fit is to generate a sample from an analytic
distribution and see how well it matches the data.* </span><span
id="hevea_default452"></span><span style="font-size:medium">
</span><span id="hevea_default453"></span><span
style="font-size:medium"> </span><span id="hevea_default454"></span>

<span style="font-size:medium">*For example, in Section *</span>[<span
style="font-size:medium">*5.1*</span>](#exponential)<span
style="font-size:medium"> *we plotted the distribution of time between
births and saw that it is approximately exponential. But the
distribution is based on only 44 data points. To see whether the data
might have come from an exponential distribution, generate 44 values
from an exponential distribution with the same mean as the data, about
33 minutes between births.*</span>

<span style="font-size:medium">*Plot the distribution of the random
values and compare it to the actual distribution. You can use <span
style="font-family:monospace">random.expovariate</span> to generate the
values.*</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 5</span>   *In the repository for this
book, you’ll find a set of data files called <span
style="font-family:monospace">mystery0.dat</span>, <span
style="font-family:monospace">mystery1.dat</span>, and so on. Each
contains a sequence of random numbers generated from an analytic
distribution.* </span><span id="hevea_default455"></span>

<span style="font-size:medium">*You will also find `test_models.py`, a
script that reads data from a file and plots the CDF under a variety of
transforms. You can run it like this:*</span>

    $ python test_models.py mystery0.dat

<span style="font-size:medium">*Based on these plots, you should be able
to infer what kind of distribution generated each file. If you are
stumped, you can look in <span
style="font-family:monospace">mystery.py</span>, which contains the code
that generated the files.*</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 6</span>   </span><span
id="income"></span>

<span style="font-size:medium">*The distributions of wealth and income
are sometimes modeled using lognormal and Pareto distributions. To see
which is better, let’s look at some data.* </span><span
id="hevea_default456"></span><span style="font-size:medium">
</span><span id="hevea_default457"></span><span
style="font-size:medium"> </span><span
id="hevea_default458"></span><span style="font-size:medium">
</span><span id="hevea_default459"></span>

<span style="font-size:medium">*The Current Population Survey (CPS) is a
joint effort of the Bureau of Labor Statistics and the Census Bureau to
study income and related variables. Data collected in 2013 is available
from* </span>[<span
style="font-family:monospace;font-size:medium">*http://www.census.gov/hhes/www/cpstables/032013/hhinc/toc.htm*</span>](http://www.census.gov/hhes/www/cpstables/032013/hhinc/toc.htm)<span
style="font-size:medium">*. I downloaded <span
style="font-family:monospace">hinc06.xls</span>, which is an Excel
spreadsheet with information about household income, and converted it to
<span style="font-family:monospace">hinc06.csv</span>, a CSV file you
will find in the repository for this book. You will also find <span
style="font-family:monospace">hinc.py</span>, which reads this
file.*</span>

<span style="font-size:medium">*Extract the distribution of incomes from
this dataset. Are any of the analytic distributions in this chapter a
good model of the data? A solution to this exercise is in* </span>[<span
style="font-family:monospace;font-size:medium">*hinc\_soln.py*</span>](hinc_soln.py)<span
style="font-size:medium">*.* </span><span id="hevea_default460"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">5.9  Glossary</span>
---------------------------------------------------

-   <span style="font-size:medium">empirical distribution: The
    distribution of values in a sample. </span><span
    id="hevea_default461"></span><span style="font-size:medium">
    </span><span id="hevea_default462"></span>
-   <span style="font-size:medium">analytic distribution: A distribution
    whose CDF is an analytic function. </span><span
    id="hevea_default463"></span><span style="font-size:medium">
    </span><span id="hevea_default464"></span>
-   <span style="font-size:medium">model: A useful simplification.
    Analytic distributions are often good models of more complex
    empirical distributions. </span><span id="hevea_default465"></span>
-   <span style="font-size:medium">interarrival time: The elapsed time
    between two events. </span><span id="hevea_default466"></span>
-   <span style="font-size:medium">complementary CDF: A function that
    maps from a value, <span style="font-style:italic">x</span>, to the
    fraction of values that exceed <span
    style="font-style:italic">x</span>, which is 1 − <span
    style="font-style:italic">CDF</span>(<span
    style="font-style:italic">x</span>). </span><span
    id="hevea_default467"></span><span style="font-size:medium">
    </span><span id="hevea_default468"></span><span
    style="font-size:medium"> </span><span id="hevea_default469"></span>
-   <span style="font-size:medium">standard normal distribution: The
    normal distribution with mean 0 and standard deviation 1.
    </span><span id="hevea_default470"></span>
-   <span style="font-size:medium">normal probability plot: A plot of
    the values in a sample versus random values from a standard normal
    distribution. </span><span id="hevea_default471"></span><span
    style="font-size:medium"> </span><span id="hevea_default472"></span>

<span style="font-size:medium"> </span>

------------------------------------------------------------------------

 <span style="font-size:medium"> </span><a href="#text1" id="note1"><span style="font-size:medium">1</span></a>   
<span style="font-size:medium"></span>

This example is based on information and data from Dunn, “A Simple
Dataset for Demonstrating Common Distributions,” Journal of Statistics
Education v.7, n.3 (1999).

<a href="#text2" id="note2"><span style="font-size:medium">2</span></a>  
<span style="font-size:medium"></span>

I was tipped off to this possibility by a comment (without citation) at
[<span
style="font-family:monospace">http://mathworld.wolfram.com/LogNormalDistribution.html</span>](http://mathworld.wolfram.com/LogNormalDistribution.html).
Subsequently I found a paper that proposes the log transform and
suggests a cause: Penman and Johnson, “The Changing Shape of the Body
Mass Index Distribution Curve in the Population,” Preventing Chronic
Disease, 2006 July; 3(3): A74. Online at [<span
style="font-family:monospace">http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1636707</span>](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC1636707).

<a href="#text3" id="note3"><span style="font-size:medium">3</span></a>  
<span style="font-size:medium"></span>

Centers for Disease Control and Prevention (CDC). Behavioral Risk Factor
Surveillance System Survey Data. Atlanta, Georgia: U.S. Department of
Health and Human Services, Centers for Disease Control and
Prevention, 2008.
