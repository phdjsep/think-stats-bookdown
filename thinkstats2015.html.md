This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 14  Analytic methods</span>
==================================================================

<span style="font-size:medium"> </span><span id="analysis"></span>

<span style="font-size:medium">This book has focused on computational
methods like simulation and resampling, but some of the problems we
solved have analytic solutions that can be much faster. </span><span
id="hevea_default1650"></span><span style="font-size:medium">
</span><span id="hevea_default1651"></span><span
style="font-size:medium"> </span><span id="hevea_default1652"></span>

<span style="font-size:medium">I present some of these methods in this
chapter, and explain how they work. At the end of the chapter, I make
suggestions for integrating computational and analytic methods for
exploratory data analysis.</span>

<span style="font-size:medium">The code in this chapter is in <span
style="font-family:monospace">normal.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.1  Normal distributions</span>
----------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="why_normal"></span><span style="font-size:medium"> </span><span
id="hevea_default1653"></span><span style="font-size:medium">
</span><span id="hevea_default1654"></span><span
style="font-size:medium"> </span><span
id="hevea_default1655"></span><span style="font-size:medium">
</span><span id="hevea_default1656"></span>

<span style="font-size:medium">As a motivating example, let’s review the
problem from Section </span>[<span
style="font-size:medium">8.3</span>](thinkstats2009.html#gorilla)<span
style="font-size:medium">: </span><span id="hevea_default1657"></span>

> <span style="font-size:medium"> Suppose you are a scientist studying
> gorillas in a wildlife preserve. Having weighed 9 gorillas, you find
> sample mean <span style="text-decoration:overline">x</span>=90 kg and
> sample standard deviation, <span
> style="font-style:italic">S</span>=7.5 kg. If you use <span
> style="text-decoration:overline">x</span> to estimate the population
> mean, what is the standard error of the estimate? </span>

<span style="font-size:medium">To answer that question, we need the
sampling distribution of <span
style="text-decoration:overline">x</span>. In Section </span>[<span
style="font-size:medium">8.3</span>](thinkstats2009.html#gorilla)<span
style="font-size:medium"> we approximated this distribution by
simulating the experiment (weighing 9 gorillas), computing <span
style="text-decoration:overline">x</span> for each simulated experiment,
and accumulating the distribution of estimates. </span><span
id="hevea_default1658"></span><span style="font-size:medium">
</span><span id="hevea_default1659"></span>

<span style="font-size:medium">The result is an approximation of the
sampling distribution. Then we use the sampling distribution to compute
standard errors and confidence intervals: </span><span
id="hevea_default1660"></span><span style="font-size:medium">
</span><span id="hevea_default1661"></span>

1.  <span style="font-size:medium">The standard deviation of the
    sampling distribution is the standard error of the estimate; in the
    example, it is about 2.5 kg.</span>
2.  <span style="font-size:medium">The interval between the 5th and 95th
    percentile of the sampling distribution is a 90% confidence
    interval. If we run the experiment many times, we expect the
    estimate to fall in this interval 90% of the time. In the example,
    the 90% CI is (86, 94) kg.</span>

<span style="font-size:medium">Now we’ll do the same calculation
analytically. We take advantage of the fact that the weights of adult
female gorillas are roughly normally distributed. Normal distributions
have two properties that make them amenable for analysis: they are
“closed” under linear transformation and addition. To explain what that
means, I need some notation. </span><span
id="hevea_default1662"></span><span style="font-size:medium">
</span><span id="hevea_default1663"></span><span
style="font-size:medium"> </span><span id="hevea_default1664"></span>

<span style="font-size:medium">If the distribution of a quantity, <span
style="font-style:italic">X</span>, is normal with parameters µ and σ,
you can write </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">X</span> ∼ <span style="font-style:italic;color:red">N</span> (µ, σ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">)</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where the symbol ∼ means “is
distributed” and the script letter <span
style="font-style:italic;color:red">N</span> stands for “normal.”</span>

<span style="font-size:medium">A linear transformation of <span
style="font-style:italic">X</span> is something like <span
style="font-style:italic">X</span>′ = <span style="font-style:italic">a
X</span> + <span style="font-style:italic">b</span>, where <span
style="font-style:italic">a</span> and <span
style="font-style:italic">b</span> are real numbers.</span><span
id="hevea_default1665"></span><span style="font-size:medium"> A family
of distributions is closed under linear transformation if <span
style="font-style:italic">X</span>′ is in the same family as <span
style="font-style:italic">X</span>. The normal distribution has this
property; if <span style="font-style:italic">X</span> ∼ <span
style="font-style:italic;color:red">N</span> (µ, σ</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">),
</span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">X</span>′ ∼ <span style="font-style:italic;color:red">N</span> (<span style="font-style:italic">a</span> µ + <span style="font-style:italic">b</span>, <span style="font-style:italic">a</span></span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> σ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">)  </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Normal distributions are also closed
under addition. If <span style="font-style:italic">Z</span> = <span
style="font-style:italic">X</span> + <span
style="font-style:italic">Y</span> and <span
style="font-style:italic">X</span> ∼ <span
style="font-style:italic;color:red">N</span> (µ</span><sub><span
style="font-style:italic;font-size:medium">X</span></sub><span
style="font-size:medium">, σ</span><sub><span
style="font-style:italic;font-size:medium">X</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">)
and <span style="font-style:italic">Y</span> ∼ <span
style="font-style:italic;color:red">N</span> (µ</span><sub><span
style="font-style:italic;font-size:medium">Y</span></sub><span
style="font-size:medium">, σ</span><sub><span
style="font-style:italic;font-size:medium">Y</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">)
then </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Z</span> ∼ <span style="font-style:italic;color:red">N</span> (µ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><span style="font-size:medium"> + µ</span><sub><span style="font-style:italic;font-size:medium">Y</span></sub><span style="font-size:medium">, σ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> + σ</span><sub><span style="font-style:italic;font-size:medium">Y</span></sub><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">)  </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> In the special case <span
style="font-style:italic">Z</span> = <span
style="font-style:italic">X</span> + <span
style="font-style:italic">X</span>, we have </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Z</span> ∼ <span style="font-style:italic;color:red">N</span> (2 µ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><span style="font-size:medium">, 2 σ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">) </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> and in general if we draw <span
style="font-style:italic">n</span> values of <span
style="font-style:italic">X</span> and add them up, we have </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Z</span> ∼ <span style="font-style:italic;color:red">N</span> (<span style="font-style:italic">n</span> µ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><span style="font-size:medium">, <span style="font-style:italic">n</span> σ</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">)  </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.2  Sampling distributions</span>
------------------------------------------------------------------

<span style="font-size:medium">Now we have everything we need to compute
the sampling distribution of <span
style="text-decoration:overline">x</span>. Remember that we compute
<span style="text-decoration:overline">x</span> by weighing <span
style="font-style:italic">n</span> gorillas, adding up the total weight,
and dividing by <span style="font-style:italic">n</span>. </span><span
id="hevea_default1666"></span><span style="font-size:medium">
</span><span id="hevea_default1667"></span><span
style="font-size:medium"> </span><span id="hevea_default1668"></span>

<span style="font-size:medium">Assume that the distribution of gorilla
weights, <span style="font-style:italic">X</span>, is approximately
normal: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">X</span> ∼ <span style="font-style:italic;color:red">N</span> (µ, σ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">)</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> If we weigh <span
style="font-style:italic">n</span> gorillas, the total weight, <span
style="font-style:italic">Y</span>, is distributed </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Y</span> ∼ <span style="font-style:italic;color:red">N</span> (<span style="font-style:italic">n</span> µ, <span style="font-style:italic">n</span> σ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">) </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> using Equation 3. And if we divide by
<span style="font-style:italic">n</span>, the sample mean, <span
style="font-style:italic">Z</span>, is distributed </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Z</span> ∼ <span style="font-style:italic;color:red">N</span> (µ, σ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium">/<span style="font-style:italic">n</span>) </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> using Equation 1 with <span
style="font-style:italic">a</span> = 1/<span
style="font-style:italic">n</span>.</span>

<span style="font-size:medium">The distribution of <span
style="font-style:italic">Z</span> is the sampling distribution of <span
style="text-decoration:overline">x</span>. The mean of <span
style="font-style:italic">Z</span> is µ, which shows that <span
style="text-decoration:overline">x</span> is an unbiased estimate of µ.
The variance of the sampling distribution is σ</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium"> /
<span style="font-style:italic">n</span>. </span><span
id="hevea_default1669"></span><span style="font-size:medium">
</span><span id="hevea_default1670"></span>

<span style="font-size:medium">So the standard deviation of the sampling
distribution, which is the standard error of the estimate, is σ / √<span
style="text-decoration:overline"><span
style="font-style:italic">n</span></span>. In the example, σ is 7.5 kg
and <span style="font-style:italic">n</span> is 9, so the standard error
is 2.5 kg. That result is consistent with what we estimated by
simulation, but much faster to compute! </span><span
id="hevea_default1671"></span><span style="font-size:medium">
</span><span id="hevea_default1672"></span>

<span style="font-size:medium">We can also use the sampling distribution
to compute confidence intervals. A 90% confidence interval for <span
style="text-decoration:overline">x</span> is the interval between the
5th and 95th percentiles of <span style="font-style:italic">Z</span>.
Since <span style="font-style:italic">Z</span> is normally distributed,
we can compute percentiles by evaluating the inverse CDF. </span><span
id="hevea_default1673"></span><span style="font-size:medium">
</span><span id="hevea_default1674"></span><span
style="font-size:medium"> </span><span id="hevea_default1675"></span>

<span style="font-size:medium">There is no closed form for the CDF of
the normal distribution or its inverse, but there are fast numerical
methods and they are implemented in SciPy, as we saw in
Section </span>[<span
style="font-size:medium">5.2</span>](thinkstats2006.html#normal)<span
style="font-size:medium">. <span
style="font-family:monospace">thinkstats2</span> provides a wrapper
function that makes the SciPy function a little easier to use:
</span><span id="hevea_default1676"></span><span
style="font-size:medium"> </span><span
id="hevea_default1677"></span><span style="font-size:medium">
</span><span id="hevea_default1678"></span><span
style="font-size:medium"> </span><span id="hevea_default1679"></span>

    def EvalNormalCdfInverse(p, mu=0, sigma=1):
        return scipy.stats.norm.ppf(p, loc=mu, scale=sigma)

<span style="font-size:medium">Given a probability, <span
style="font-family:monospace">p</span>, it returns the corresponding
percentile from a normal distribution with parameters <span
style="font-family:monospace">mu</span> and <span
style="font-family:monospace">sigma</span>. For the 90% confidence
interval of <span style="text-decoration:overline">x</span>, we compute
the 5th and 95th percentiles like this: </span><span
id="hevea_default1680"></span>

    >>> thinkstats2.EvalNormalCdfInverse(0.05, mu=90, sigma=2.5)
    85.888

    >>> thinkstats2.EvalNormalCdfInverse(0.95, mu=90, sigma=2.5)
    94.112

<span style="font-size:medium">So if we run the experiment many times,
we expect the estimate, <span style="text-decoration:overline">x</span>,
to fall in the range (85.9, 94.1) about 90% of the time. Again, this is
consistent with the result we got by simulation. </span><span
id="hevea_default1681"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.3  Representing normal distributions</span>
-----------------------------------------------------------------------------

<span style="font-size:medium">To make these calculations easier, I have
defined a class called <span style="font-family:monospace">Normal</span>
that represents a normal distribution and encodes the equations in the
previous sections. Here’s what it looks like: </span><span
id="hevea_default1682"></span>

    class Normal(object):

        def __init__(self, mu, sigma2):
            self.mu = mu
            self.sigma2 = sigma2

        def __str__(self):
            return 'N(%g, %g)' % (self.mu, self.sigma2)

<span style="font-size:medium">So we can instantiate a Normal that
represents the distribution of gorilla weights: </span><span
id="hevea_default1683"></span>

    >>> dist = Normal(90, 7.5**2)
    >>> dist
    N(90, 56.25)

<span style="font-size:medium"><span
style="font-family:monospace">Normal</span> provides <span
style="font-family:monospace">Sum</span>, which takes a sample size,
<span style="font-family:monospace">n</span>, and returns the
distribution of the sum of <span style="font-family:monospace">n</span>
values, using Equation 3:</span>

        def Sum(self, n):
            return Normal(n * self.mu, n * self.sigma2)

<span style="font-size:medium">Normal also knows how to multiply and
divide using Equation 1:</span>

        def __mul__(self, factor):
            return Normal(factor * self.mu, factor**2 * self.sigma2)

        def __div__(self, divisor):
            return 1 / divisor * self

<span style="font-size:medium">So we can compute the sampling
distribution of the mean with sample size 9: </span><span
id="hevea_default1684"></span><span style="font-size:medium">
</span><span id="hevea_default1685"></span>

    >>> dist_xbar = dist.Sum(9) / 9
    >>> dist_xbar.sigma
    2.5

<span style="font-size:medium">The standard deviation of the sampling
distribution is 2.5 kg, as we saw in the previous section. Finally,
Normal provides <span style="font-family:monospace">Percentile</span>,
which we can use to compute a confidence interval: </span><span
id="hevea_default1686"></span><span style="font-size:medium">
</span><span id="hevea_default1687"></span>

    >>> dist_xbar.Percentile(5), dist_xbar.Percentile(95)
    85.888 94.113

<span style="font-size:medium">And that’s the same answer we got before.
We’ll use the Normal class again later, but before we go on, we need one
more bit of analysis.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.4  Central limit theorem</span>
-----------------------------------------------------------------

<span style="font-size:medium"> </span><span id="CLT"></span>

<span style="font-size:medium">As we saw in the previous sections, if we
add values drawn from normal distributions, the distribution of the sum
is normal. Most other distributions don’t have this property; if we add
values drawn from other distributions, the sum does not generally have
an analytic distribution. </span><span
id="hevea_default1688"></span><span style="font-size:medium">
</span><span id="hevea_default1689"></span><span
style="font-size:medium"> </span><span
id="hevea_default1690"></span><span style="font-size:medium">
</span><span id="hevea_default1691"></span><span
style="font-size:medium"> </span><span id="hevea_default1692"></span>

<span style="font-size:medium">But if we add up <span
style="font-family:monospace">n</span> values from almost any
distribution, the distribution of the sum converges to normal as <span
style="font-family:monospace">n</span> increases.</span>

<span style="font-size:medium">More specifically, if the distribution of
the values has mean and standard deviation µ and σ, the distribution of
the sum is approximately <span
style="font-style:italic;color:red">N</span>(<span
style="font-style:italic">n</span> µ, <span
style="font-style:italic">n</span> σ</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">).
</span><span id="hevea_default1693"></span>

<span style="font-size:medium">This result is the Central Limit Theorem
(CLT). It is one of the most useful tools for statistical analysis, but
it comes with caveats: </span><span id="hevea_default1694"></span><span
style="font-size:medium"> </span><span id="hevea_default1695"></span>

-   <span style="font-size:medium">The values have to be drawn
    independently. If they are correlated, the CLT doesn’t apply
    (although this is seldom a problem in practice). </span><span
    id="hevea_default1696"></span>
-   <span style="font-size:medium">The values have to come from the same
    distribution (although this requirement can be relaxed).
    </span><span id="hevea_default1697"></span>
-   <span style="font-size:medium">The values have to be drawn from a
    distribution with finite mean and variance. So most Pareto
    distributions are out. </span><span
    id="hevea_default1698"></span><span style="font-size:medium">
    </span><span id="hevea_default1699"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1700"></span><span style="font-size:medium">
    </span><span id="hevea_default1701"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1702"></span><span style="font-size:medium">
    </span><span id="hevea_default1703"></span>
-   <span style="font-size:medium">The rate of convergence depends on
    the skewness of the distribution. Sums from an exponential
    distribution converge for small <span
    style="font-family:monospace">n</span>. Sums from a lognormal
    distribution require larger sizes. </span><span
    id="hevea_default1704"></span><span style="font-size:medium">
    </span><span id="hevea_default1705"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1706"></span>

<span style="font-size:medium">The Central Limit Theorem explains the
prevalence of normal distributions in the natural world. Many
characteristics of living things are affected by genetic and
environmental factors whose effect is additive. The characteristics we
measure are the sum of a large number of small effects, so their
distribution tends to be normal. </span><span
id="hevea_default1707"></span><span style="font-size:medium">
</span><span id="hevea_default1708"></span><span
style="font-size:medium"> </span><span
id="hevea_default1709"></span><span style="font-size:medium">
</span><span id="hevea_default1710"></span><span
style="font-size:medium"> </span><span
id="hevea_default1711"></span><span style="font-size:medium">
</span><span id="hevea_default1712"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.5  Testing the CLT</span>
-----------------------------------------------------------

<span style="font-size:medium">To see how the Central Limit Theorem
works, and when it doesn’t, let’s try some experiments. First, we’ll try
an exponential distribution:</span>

    def MakeExpoSamples(beta=2.0, iters=1000):
        samples = []
        for n in [1, 10, 100]:
            sample = [np.sum(np.random.exponential(beta, n))
                      for _ in range(iters)]
            samples.append((n, sample))
        return samples

<span style="font-size:medium"><span
style="font-family:monospace">MakeExpoSamples</span> generates samples
of sums of exponential values (I use “exponential values” as shorthand
for “values from an exponential distribution”). <span
style="font-family:monospace">beta</span> is the parameter of the
distribution; <span style="font-family:monospace">iters</span> is the
number of sums to generate.</span>

<span style="font-size:medium">To explain this function, I’ll start from
the inside and work my way out. Each time we call <span
style="font-family:monospace">np.random.exponential</span>, we get a
sequence of <span style="font-family:monospace">n</span> exponential
values and compute its sum. <span
style="font-family:monospace">sample</span> is a list of these sums,
with length <span style="font-family:monospace">iters</span>.
</span><span id="hevea_default1713"></span>

<span style="font-size:medium">It is easy to get <span
style="font-family:monospace">n</span> and <span
style="font-family:monospace">iters</span> confused: <span
style="font-family:monospace">n</span> is the number of terms in each
sum; <span style="font-family:monospace">iters</span> is the number of
sums we compute in order to characterize the distribution of
sums.</span>

<span style="font-size:medium">The return value is a list of <span
style="font-family:monospace">(n, sample)</span> pairs. For each pair,
we make a normal probability plot: </span><span
id="hevea_default1714"></span><span style="font-size:medium">
</span><span id="hevea_default1715"></span>

    def NormalPlotSamples(samples, plot=1, ylabel=''):
        for n, sample in samples:
            thinkplot.SubPlot(plot)
            thinkstats2.NormalProbabilityPlot(sample)

            thinkplot.Config(title='n=%d' % n, ylabel=ylabel)
            plot += 1

<span style="font-size:medium"><span
style="font-family:monospace">NormalPlotSamples</span> takes the list of
pairs from <span style="font-family:monospace">MakeExpoSamples</span>
and generates a row of normal probability plots. </span><span
id="hevea_default1716"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2052.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 14.1: Distributions of sums of exponential values (top row) and lognormal values (bottom row).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="normal1"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">14.1</span>](#normal1)<span
style="font-size:medium"> (top row) shows the results. With <span
style="font-family:monospace">n=1</span>, the distribution of the sum is
still exponential, so the normal probability plot is not a straight
line. But with <span style="font-family:monospace">n=10</span> the
distribution of the sum is approximately normal, and with <span
style="font-family:monospace">n=100</span> it is all but
indistinguishable from normal.</span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">14.1</span>](#normal1)<span
style="font-size:medium"> (bottom row) shows similar results for a
lognormal distribution. Lognormal distributions are generally more
skewed than exponential distributions, so the distribution of sums takes
longer to converge. With <span style="font-family:monospace">n=10</span>
the normal probability plot is nowhere near straight, but with <span
style="font-family:monospace">n=100</span> it is approximately normal.
</span><span id="hevea_default1717"></span><span
style="font-size:medium"> </span><span
id="hevea_default1718"></span><span style="font-size:medium">
</span><span id="hevea_default1719"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2053.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 14.2: Distributions of sums of Pareto values (top row) and correlated exponential values (bottom row).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="normal2"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Pareto distributions are even more skewed
than lognormal. Depending on the parameters, many Pareto distributions
do not have finite mean and variance. As a result, the Central Limit
Theorem does not apply. Figure </span>[<span
style="font-size:medium">14.2</span>](#normal2)<span
style="font-size:medium"> (top row) shows distributions of sums of
Pareto values. Even with <span
style="font-family:monospace">n=100</span> the normal probability plot
is far from straight. </span><span id="hevea_default1720"></span><span
style="font-size:medium"> </span><span
id="hevea_default1721"></span><span style="font-size:medium">
</span><span id="hevea_default1722"></span><span
style="font-size:medium"> </span><span
id="hevea_default1723"></span><span style="font-size:medium">
</span><span id="hevea_default1724"></span>

<span style="font-size:medium">I also mentioned that CLT does not apply
if the values are correlated. To test that, I generate correlated values
from an exponential distribution. The algorithm for generating
correlated values is (1) generate correlated normal values, (2) use the
normal CDF to transform the values to uniform, and (3) use the inverse
exponential CDF to transform the uniform values to exponential.
</span><span id="hevea_default1725"></span><span
style="font-size:medium"> </span><span
id="hevea_default1726"></span><span style="font-size:medium">
</span><span id="hevea_default1727"></span><span
style="font-size:medium"> </span><span id="hevea_default1728"></span>

<span style="font-size:medium"><span
style="font-family:monospace">GenerateCorrelated</span> returns an
iterator of <span style="font-family:monospace">n</span> normal values
with serial correlation <span style="font-family:monospace">rho</span>:
</span><span id="hevea_default1729"></span>

    def GenerateCorrelated(rho, n):
        x = random.gauss(0, 1)
        yield x

        sigma = math.sqrt(1 - rho**2)
        for _ in range(n-1):
            x = random.gauss(x*rho, sigma)
            yield x

<span style="font-size:medium">The first value is a standard normal
value. Each subsequent value depends on its predecessor: if the previous
value is <span style="font-family:monospace">x</span>, the mean of the
next value is <span style="font-family:monospace">x\*rho</span>, with
variance <span style="font-family:monospace">1-rho\*\*2</span>. Note
that <span style="font-family:monospace">random.gauss</span> takes the
standard deviation as the second argument, not variance. </span><span
id="hevea_default1730"></span><span style="font-size:medium">
</span><span id="hevea_default1731"></span>

<span style="font-size:medium"><span
style="font-family:monospace">GenerateExpoCorrelated</span> takes the
resulting sequence and transforms it to exponential:</span>

    def GenerateExpoCorrelated(rho, n):
        normal = list(GenerateCorrelated(rho, n))
        uniform = scipy.stats.norm.cdf(normal)
        expo = scipy.stats.expon.ppf(uniform)
        return expo

<span style="font-size:medium"><span
style="font-family:monospace">normal</span> is a list of correlated
normal values. <span style="font-family:monospace">uniform</span> is a
sequence of uniform values between 0 and 1. <span
style="font-family:monospace">expo</span> is a correlated sequence of
exponential values. <span style="font-family:monospace">ppf</span>
stands for “percent point function,” which is another name for the
inverse CDF. </span><span id="hevea_default1732"></span><span
style="font-size:medium"> </span><span
id="hevea_default1733"></span><span style="font-size:medium">
</span><span id="hevea_default1734"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">14.2</span>](#normal2)<span
style="font-size:medium"> (bottom row) shows distributions of sums of
correlated exponential values with <span
style="font-family:monospace">rho=0.9</span>. The correlation slows the
rate of convergence; nevertheless, with <span
style="font-family:monospace">n=100</span> the normal probability plot
is nearly straight. So even though CLT does not strictly apply when the
values are correlated, moderate correlations are seldom a problem in
practice. </span><span id="hevea_default1735"></span><span
style="font-size:medium"> </span><span id="hevea_default1736"></span>

<span style="font-size:medium">These experiments are meant to show how
the Central Limit Theorem works, and what happens when it doesn’t. Now
let’s see how we can use it.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.6  Applying the CLT</span>
------------------------------------------------------------

<span style="font-size:medium"> </span><span id="usingCLT"></span>

<span style="font-size:medium">To see why the Central Limit Theorem is
useful, let’s get back to the example in Section </span>[<span
style="font-size:medium">9.3</span>](thinkstats2010.html#testdiff)<span
style="font-size:medium">: testing the apparent difference in mean
pregnancy length for first babies and others. As we’ve seen, the
apparent difference is about 0.078 weeks: </span><span
id="hevea_default1737"></span><span style="font-size:medium">
</span><span id="hevea_default1738"></span><span
style="font-size:medium"> </span><span id="hevea_default1739"></span>

    >>> live, firsts, others = first.MakeFrames()
    >>> delta = firsts.prglngth.mean() - others.prglngth.mean()
    0.078

<span style="font-size:medium">Remember the logic of hypothesis testing:
we compute a p-value, which is the probability of the observed
difference under the null hypothesis; if it is small, we conclude that
the observed difference is unlikely to be due to chance. </span><span
id="hevea_default1740"></span><span style="font-size:medium">
</span><span id="hevea_default1741"></span><span
style="font-size:medium"> </span><span id="hevea_default1742"></span>

<span style="font-size:medium">In this example, the null hypothesis is
that the distribution of pregnancy lengths is the same for first babies
and others. So we can compute the sampling distribution of the mean like
this: </span><span id="hevea_default1743"></span>

        dist1 = SamplingDistMean(live.prglngth, len(firsts))
        dist2 = SamplingDistMean(live.prglngth, len(others))

<span style="font-size:medium">Both sampling distributions are based on
the same population, which is the pool of all live births. <span
style="font-family:monospace">SamplingDistMean</span> takes this
sequence of values and the sample size, and returns a Normal object
representing the sampling distribution:</span>

    def SamplingDistMean(data, n):
        mean, var = data.mean(), data.var()
        dist = Normal(mean, var)
        return dist.Sum(n) / n

<span style="font-size:medium"><span
style="font-family:monospace">mean</span> and <span
style="font-family:monospace">var</span> are the mean and variance of
<span style="font-family:monospace">data</span>. We approximate the
distribution of the data with a normal distribution, <span
style="font-family:monospace">dist</span>. </span>

<span style="font-size:medium">In this example, the data are not
normally distributed, so this approximation is not very good. But then
we compute <span style="font-family:monospace">dist.Sum(n) / n</span>,
which is the sampling distribution of the mean of <span
style="font-family:monospace">n</span> values. Even if the data are not
normally distributed, the sampling distribution of the mean is, by the
Central Limit Theorem. </span><span id="hevea_default1744"></span><span
style="font-size:medium"> </span><span id="hevea_default1745"></span>

<span style="font-size:medium">Next, we compute the sampling
distribution of the difference in the means. The <span
style="font-family:monospace">Normal</span> class knows how to perform
subtraction using Equation 2: </span><span
id="hevea_default1746"></span>

        def __sub__(self, other):
            return Normal(self.mu - other.mu,
                          self.sigma2 + other.sigma2)

<span style="font-size:medium">So we can compute the sampling
distribution of the difference like this:</span>

    >>> dist = dist1 - dist2
    N(0, 0.0032)

<span style="font-size:medium">The mean is 0, which makes sense because
we expect two samples from the same distribution to have the same mean,
on average. The variance of the sampling distribution is 0.0032.
</span><span id="hevea_default1747"></span>

<span style="font-size:medium"><span
style="font-family:monospace">Normal</span> provides <span
style="font-family:monospace">Prob</span>, which evaluates the normal
CDF. We can use <span style="font-family:monospace">Prob</span> to
compute the probability of a difference as large as <span
style="font-family:monospace">delta</span> under the null hypothesis:
</span><span id="hevea_default1748"></span>

    >>> 1 - dist.Prob(delta)
    0.084

<span style="font-size:medium">Which means that the p-value for a
one-sided test is 0.84. For a two-sided test we would also compute
</span><span id="hevea_default1749"></span><span
style="font-size:medium"> </span><span
id="hevea_default1750"></span><span style="font-size:medium">
</span><span id="hevea_default1751"></span>

    >>> dist.Prob(-delta)
    0.084

<span style="font-size:medium">Which is the same because the normal
distribution is symmetric. The sum of the tails is 0.168, which is
consistent with the estimate in Section </span>[<span
style="font-size:medium">9.3</span>](thinkstats2010.html#testdiff)<span
style="font-size:medium">, which was 0.17. </span><span
id="hevea_default1752"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.7  Correlation test</span>
------------------------------------------------------------

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">9.5</span>](thinkstats2010.html#corrtest)<span
style="font-size:medium"> we used a permutation test for the correlation
between birth weight and mother’s age, and found that it is
statistically significant, with p-value less than 0.001. </span><span
id="hevea_default1753"></span><span style="font-size:medium">
</span><span id="hevea_default1754"></span><span
style="font-size:medium"> </span><span
id="hevea_default1755"></span><span style="font-size:medium">
</span><span id="hevea_default1756"></span><span
style="font-size:medium"> </span><span
id="hevea_default1757"></span><span style="font-size:medium">
</span><span id="hevea_default1758"></span>

<span style="font-size:medium">Now we can do the same thing
analytically. The method is based on this mathematical result: given two
variables that are normally distributed and uncorrelated, if we generate
a sample with size <span style="font-style:italic">n</span>, compute
Pearson’s correlation, <span style="font-style:italic">r</span>, and
then compute the transformed correlation </span>

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">t</span> = <span style="font-style:italic">r</span> </span></td>
<td><table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: right;"><div class="vbar" style="height:2em;">

</div></td>
</tr>
<tr class="even">
<td style="text-align: right;"><span style="font-size:xx-large"><span style="font-size:150%">√</span></span></td>
</tr>
</tbody>
</table></td>
<td><table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td></td>
</tr>
<tr class="even">
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">n</span>−2</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1−<span style="font-style:italic">r</span></span><sup><span style="font-size:medium">2</span></sup></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> the distribution of <span
style="font-style:italic">t</span> is Student’s t-distribution with
parameter <span style="font-style:italic">n</span>−2. The t-distribution
is an analytic distribution; the CDF can be computed efficiently using
gamma functions. </span><span id="hevea_default1759"></span><span
style="font-size:medium"> </span><span id="hevea_default1760"></span>

<span style="font-size:medium">We can use this result to compute the
sampling distribution of correlation under the null hypothesis; that is,
if we generate uncorrelated sequences of normal values, what is the
distribution of their correlation? <span
style="font-family:monospace">StudentCdf</span> takes the sample size,
<span style="font-family:monospace">n</span>, and returns the sampling
distribution of correlation: </span><span
id="hevea_default1761"></span><span style="font-size:medium">
</span><span id="hevea_default1762"></span>

    def StudentCdf(n):
        ts = np.linspace(-3, 3, 101)
        ps = scipy.stats.t.cdf(ts, df=n-2)
        rs = ts / np.sqrt(n - 2 + ts**2)
        return thinkstats2.Cdf(rs, ps)

<span style="font-size:medium"><span
style="font-family:monospace">ts</span> is a NumPy array of values for
<span style="font-style:italic">t</span>, the transformed correlation.
<span style="font-family:monospace">ps</span> contains the corresponding
probabilities, computed using the CDF of the Student’s t-distribution
implemented in SciPy. The parameter of the t-distribution, <span
style="font-family:monospace">df</span>, stands for “degrees of
freedom.” I won’t explain that term, but you can read about it at
</span>[<span
style="font-family:monospace;font-size:medium">http://en.wikipedia.org/wiki/Degrees\_of\_freedom\_(statistics)</span>](http://en.wikipedia.org/wiki/Degrees_of_freedom_(statistics))<span
style="font-size:medium">. </span><span
id="hevea_default1763"></span><span style="font-size:medium">
</span><span id="hevea_default1764"></span><span
style="font-size:medium"> </span><span
id="hevea_default1765"></span><span style="font-size:medium">
</span><span id="hevea_default1766"></span><span
style="font-size:medium"> </span><span id="hevea_default1767"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2054.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 14.3: Sampling distribution of correlations for uncorrelated normal variables.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="normal4"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">To get from <span
style="font-family:monospace">ts</span> to the correlation coefficients,
<span style="font-family:monospace">rs</span>, we apply the inverse
transform, </span>

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
<col style="width: 25%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">r</span> = <span style="font-style:italic">t</span> / </span></td>
<td><span style="font-size:x-large">√</span></td>
<td><table>
<tbody>
<tr class="odd">
<td></td>
</tr>
<tr class="even">
<td><span style="font-size:medium"><span style="font-style:italic">n</span> − 2 + <span style="font-style:italic">t</span></span><sup><span style="font-size:medium">2</span></sup></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The result is the sampling distribution
of <span style="font-style:italic">r</span> under the null hypothesis.
Figure </span>[<span
style="font-size:medium">14.3</span>](#normal4)<span
style="font-size:medium"> shows this distribution along with the
distribution we generated in Section </span>[<span
style="font-size:medium">9.5</span>](thinkstats2010.html#corrtest)<span
style="font-size:medium"> by resampling. They are nearly identical.
Although the actual distributions are not normal, Pearson’s coefficient
of correlation is based on sample means and variances. By the Central
Limit Theorem, these moment-based statistics are normally distributed
even if the data are not. </span><span
id="hevea_default1768"></span><span style="font-size:medium">
</span><span id="hevea_default1769"></span><span
style="font-size:medium"> </span><span
id="hevea_default1770"></span><span style="font-size:medium">
</span><span id="hevea_default1771"></span>

<span style="font-size:medium">From Figure </span>[<span
style="font-size:medium">14.3</span>](#normal4)<span
style="font-size:medium">, we can see that the observed correlation,
0.07, is unlikely to occur if the variables are actually uncorrelated.
Using the analytic distribution, we can compute just how unlikely:
</span><span id="hevea_default1772"></span>

        t = r * math.sqrt((n-2) / (1-r**2))
        p_value = 1 - scipy.stats.t.cdf(t, df=n-2)

<span style="font-size:medium">We compute the value of <span
style="font-family:monospace">t</span> that corresponds to <span
style="font-family:monospace">r=0.07</span>, and then evaluate the
t-distribution at <span style="font-family:monospace">t</span>. The
result is <span style="font-family:monospace">2.9e-11</span>. This
example demonstrates an advantage of the analytic method: we can compute
very small p-values. But in practice it usually doesn’t matter.
</span><span id="hevea_default1773"></span><span
style="font-size:medium"> </span><span id="hevea_default1774"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.8  Chi-squared test</span>
------------------------------------------------------------

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">9.7</span>](thinkstats2010.html#casino2)<span
style="font-size:medium"> we used the chi-squared statistic to test
whether a die is crooked. The chi-squared statistic measures the total
normalized deviation from the expected values in a table: </span>

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">χ</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"> </span></td>
</tr>
<tr class="even">
<td style="text-align: center;"><span style="font-size:xx-large">∑</span></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">i</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">(<span style="font-style:italic">O</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="font-style:italic">E</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium">)</span><sup><span style="font-size:medium">2</span></sup></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">E</span><sub><span style="font-style:italic;font-size:medium">i</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> One reason the chi-squared statistic is
widely used is that its sampling distribution under the null hypothesis
is analytic; by a remarkable
coincidence</span><sup><a href="#note6" id="text6"><span style="font-size:medium">1</span></a></sup><span
style="font-size:medium">, it is called the chi-squared distribution.
Like the t-distribution, the chi-squared CDF can be computed efficiently
using gamma functions. </span><span id="hevea_default1775"></span><span
style="font-size:medium"> </span><span
id="hevea_default1776"></span><span style="font-size:medium">
</span><span id="hevea_default1777"></span><span
style="font-size:medium"> </span><span
id="hevea_default1778"></span><span style="font-size:medium">
</span><span id="hevea_default1779"></span><span
style="font-size:medium"> </span><span id="hevea_default1780"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2055.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 14.4: Sampling distribution of chi-squared statistics for a fair six-sided die.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span id="normal5"></span><span
> style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">SciPy provides an implementation of the
chi-squared distribution, which we use to compute the sampling
distribution of the chi-squared statistic: </span><span
id="hevea_default1781"></span>

    def ChiSquaredCdf(n):
        xs = np.linspace(0, 25, 101)
        ps = scipy.stats.chi2.cdf(xs, df=n-1)
        return thinkstats2.Cdf(xs, ps)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">14.4</span>](#normal5)<span
style="font-size:medium"> shows the analytic result along with the
distribution we got by resampling. They are very similar, especially in
the tail, which is the part we usually care most about. </span><span
id="hevea_default1782"></span><span style="font-size:medium">
</span><span id="hevea_default1783"></span>

<span style="font-size:medium">We can use this distribution to compute
the p-value of the observed test statistic, <span
style="font-family:monospace">chi2</span>: </span><span
id="hevea_default1784"></span><span style="font-size:medium">
</span><span id="hevea_default1785"></span>

        p_value = 1 - scipy.stats.chi2.cdf(chi2, df=n-1)

<span style="font-size:medium">The result is 0.041, which is consistent
with the result from Section </span>[<span
style="font-size:medium">9.7</span>](thinkstats2010.html#casino2)<span
style="font-size:medium">.</span>

<span style="font-size:medium">The parameter of the chi-squared
distribution is “degrees of freedom” again. In this case the correct
parameter is <span style="font-family:monospace">n-1</span>, where <span
style="font-family:monospace">n</span> is the size of the table, 6.
Choosing this parameter can be tricky; to be honest, I am never
confident that I have it right until I generate something like
Figure </span>[<span
style="font-size:medium">14.4</span>](#normal5)<span
style="font-size:medium"> to compare the analytic results to the
resampling results. </span><span id="hevea_default1786"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.9  Discussion</span>
------------------------------------------------------

<span style="font-size:medium">This book focuses on computational
methods like resampling and permutation. These methods have several
advantages over analysis: </span><span
id="hevea_default1787"></span><span style="font-size:medium">
</span><span id="hevea_default1788"></span><span
style="font-size:medium"> </span><span id="hevea_default1789"></span>

-   <span style="font-size:medium">They are easier to explain and
    understand. For example, one of the most difficult topics in an
    introductory statistics class is hypothesis testing. Many students
    don’t really understand what p-values are. I think the approach I
    presented in Chapter </span>[<span
    style="font-size:medium">9</span>](thinkstats2010.html#testing)<span
    style="font-size:medium">—simulating the null hypothesis and
    computing test statistics—makes the fundamental idea clearer.
    </span><span id="hevea_default1790"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1791"></span>
-   <span style="font-size:medium">They are robust and versatile.
    Analytic methods are often based on assumptions that might not hold
    in practice. Computational methods require fewer assumptions, and
    can be adapted and extended more easily. </span><span
    id="hevea_default1792"></span>
-   <span style="font-size:medium">They are debuggable. Analytic methods
    are often like a black box: you plug in numbers and they spit out
    results. But it’s easy to make subtle errors, hard to be confident
    that the results are right, and hard to find the problem if they are
    not. Computational methods lend themselves to incremental
    development and testing, which fosters confidence in the results.
    </span><span id="hevea_default1793"></span>

<span style="font-size:medium">But there is one drawback: computational
methods can be slow. Taking into account these pros and cons, I
recommend the following process:</span>

1.  <span style="font-size:medium">Use computational methods during
    exploration. If you find a satisfactory answer and the run time is
    acceptable, you can stop. </span><span
    id="hevea_default1794"></span>
2.  <span style="font-size:medium">If run time is not acceptable, look
    for opportunities to optimize. Using analytic methods is one of
    several methods of optimization.</span>
3.  <span style="font-size:medium">If replacing a computational method
    with an analytic method is appropriate, use the computational method
    as a basis of comparison, providing mutual validation between the
    computational and analytic results. </span><span
    id="hevea_default1795"></span>

<span style="font-size:medium">For the vast majority of problems I have
worked on, I didn’t have to go past Step 1.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">14.10  Exercises</span>
------------------------------------------------------

<span style="font-size:medium">A solution to these exercises is in
`chap14soln.py`</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   </span><span
id="log_clt"></span><span style="font-size:medium"> *In
Section *</span>[<span
style="font-size:medium">*5.4*</span>](thinkstats2006.html#lognormal)<span
style="font-size:medium">*, we saw that the distribution of adult
weights is approximately lognormal. One possible explanation is that the
weight a person gains each year is proportional to their current weight.
In that case, adult weight is the product of a large number of
multiplicative factors:* </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">w</span> = <span style="font-style:italic">w</span></span><sub><span style="font-size:medium">0</span></sub><span style="font-size:medium"> <span style="font-style:italic">f</span></span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> <span style="font-style:italic">f</span></span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> ... <span style="font-style:italic">f</span></span><sub><span style="font-style:italic;font-size:medium">n</span></sub><span style="font-size:medium">  </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> *where* <span
style="font-style:italic">w</span> *is adult weight,* <span
style="font-style:italic">w</span></span><sub><span
style="font-size:medium">0</span></sub><span style="font-size:medium">
*is birth weight, and* <span
style="font-style:italic">f</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> *is the weight gain factor for year* <span
style="font-style:italic">i</span>*.* </span><span
id="hevea_default1796"></span><span style="font-size:medium">
</span><span id="hevea_default1797"></span><span
style="font-size:medium"> </span><span
id="hevea_default1798"></span><span style="font-size:medium">
</span><span id="hevea_default1799"></span><span
style="font-size:medium"> </span><span id="hevea_default1800"></span>

<span style="font-size:medium">*The log of a product is the sum of the
logs of the factors:* </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">log<span style="font-style:italic">w</span> = log<span style="font-style:italic">w</span></span><sub><span style="font-size:medium">0</span></sub><span style="font-size:medium"> + log<span style="font-style:italic">f</span></span><sub><span style="font-size:medium">1</span></sub><span style="font-size:medium"> + log<span style="font-style:italic">f</span></span><sub><span style="font-size:medium">2</span></sub><span style="font-size:medium"> + ... + log<span style="font-style:italic">f</span></span><sub><span style="font-style:italic;font-size:medium">n</span></sub><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> *So by the Central Limit Theorem, the
distribution of* log<span style="font-style:italic">w</span> *is
approximately normal for large* <span
style="font-style:italic">n</span>*, which implies that the distribution
of* <span style="font-style:italic">w</span> *is lognormal.*
</span><span id="hevea_default1801"></span><span
style="font-size:medium"> </span><span id="hevea_default1802"></span>

<span style="font-size:medium">*To model this phenomenon, choose a
distribution for* <span style="font-style:italic">f</span> *that seems
reasonable, then generate a sample of adult weights by choosing a random
value from the distribution of birth weights, choosing a sequence of
factors from the distribution of* <span
style="font-style:italic">f</span>*, and computing the product. What
value of* <span style="font-style:italic">n</span> *is needed to
converge to a lognormal distribution?* </span><span
id="hevea_default1803"></span>

<span id="hevea_default1804"></span><span style="font-size:medium">
</span><span id="hevea_default1805"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *In Section *</span>[<span
style="font-size:medium">*14.6*</span>](#usingCLT)<span
style="font-size:medium"> *we used the Central Limit Theorem to find the
sampling distribution of the difference in means,* δ*, under the null
hypothesis that both samples are drawn from the same population.*
</span><span id="hevea_default1806"></span><span
style="font-size:medium"> </span><span id="hevea_default1807"></span>

<span style="font-size:medium">*We can also use this distribution to
find the standard error of the estimate and confidence intervals, but
that would only be approximately correct. To be more precise, we should
compute the sampling distribution of* δ *under the alternate hypothesis
that the samples are drawn from different populations.* </span><span
id="hevea_default1808"></span><span style="font-size:medium">
</span><span id="hevea_default1809"></span><span
style="font-size:medium"> </span><span id="hevea_default1810"></span>

<span style="font-size:medium">*Compute this distribution and use it to
calculate the standard error and a 90% confidence interval for the
difference in means.* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *In a recent
paper*</span><sup><a href="#note7" id="text7"><span style="font-size:medium"><em>2</em></span></a></sup><span
style="font-size:medium">*, Stein et al. investigate the effects of an
intervention intended to mitigate gender-stereotypical task allocation
within student engineering teams.*</span>

<span style="font-size:medium">*Before and after the intervention,
students responded to a survey that asked them to rate their
contribution to each aspect of class projects on a 7-point
scale.*</span>

<span style="font-size:medium">*Before the intervention, male students
reported higher scores for the programming aspect of the project than
female students; on average men reported a score of 3.57 with standard
error 0.28. Women reported 1.91, on average, with standard error 0.32.*
</span><span id="hevea_default1811"></span>

<span style="font-size:medium">*Compute the sampling distribution of the
gender gap (the difference in means), and test whether it is
statistically significant. Because you are given standard errors for the
estimated means, you don’t need to know the sample size to figure out
the sampling distributions.* </span><span
id="hevea_default1812"></span><span style="font-size:medium">
</span><span id="hevea_default1813"></span><span
style="font-size:medium"> </span><span id="hevea_default1814"></span>

<span style="font-size:medium">*After the intervention, the gender gap
was smaller: the average score for men was 3.44 (SE 0.16); the average
score for women was 3.18 (SE 0.16). Again, compute the sampling
distribution of the gender gap and test it.* </span><span
id="hevea_default1815"></span>

<span style="font-size:medium">*Finally, estimate the change in gender
gap; what is the sampling distribution of this change, and is it
statistically significant?* </span><span
id="hevea_default1816"></span><span style="font-size:medium">
</span><span id="hevea_default1817"></span><span
style="font-size:medium"> </span>

------------------------------------------------------------------------

 <span style="font-size:medium"> </span><a href="#text6" id="note6"><span style="font-size:medium">1</span></a>   
<span style="font-size:medium"></span>

Not really.

<a href="#text7" id="note7"><span style="font-size:medium">2</span></a>  
<span style="font-size:medium"></span>

“Evidence for the persistent effects of an intervention to mitigate
gender-sterotypical task allocation within student engineering teams,”
Proceedings of the IEEE Frontiers in Education Conference, 2014.
