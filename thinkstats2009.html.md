This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 8  Estimation</span>
===========================================================

<span style="font-size:medium"> </span><span
id="estimation"></span><span style="font-size:medium"> </span><span
id="hevea_default718"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">estimation.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.1  The estimation game</span>
--------------------------------------------------------------

<span style="font-size:medium">Let’s play a game. I think of a
distribution, and you have to guess what it is. I’ll give you two hints:
it’s a normal distribution, and here’s a random sample drawn from it:
</span><span id="hevea_default719"></span><span
style="font-size:medium"> </span><span
id="hevea_default720"></span><span style="font-size:medium">
</span><span id="hevea_default721"></span><span
style="font-size:medium"> </span><span id="hevea_default722"></span>

<span style="font-family:monospace;font-size:medium">\[-0.441, 1.774,
-0.101, -1.138, 2.975, -2.138\]</span>

<span style="font-size:medium">What do you think is the mean parameter,
µ, of this distribution? </span><span id="hevea_default723"></span><span
style="font-size:medium"> </span><span id="hevea_default724"></span>

<span style="font-size:medium">One choice is to use the sample mean,
<span style="text-decoration:overline">x</span>, as an estimate of µ. In
this example, <span style="text-decoration:overline">x</span> is 0.155,
so it would be reasonable to guess µ = 0.155. This process is called
<span style="font-weight:bold">estimation</span>, and the statistic we
used (the sample mean) is called an <span
style="font-weight:bold">estimator</span>. </span><span
id="hevea_default725"></span>

<span style="font-size:medium">Using the sample mean to estimate µ is so
obvious that it is hard to imagine a reasonable alternative. But suppose
we change the game by introducing outliers. </span><span
id="hevea_default726"></span><span style="font-size:medium">
</span><span id="hevea_default727"></span><span
style="font-size:medium"> </span><span
id="hevea_default728"></span><span style="font-size:medium">
</span><span id="hevea_default729"></span>

<span style="font-size:medium">*I’m thinking of a distribution.* It’s a
normal distribution, and here’s a sample that was collected by an
unreliable surveyor who occasionally puts the decimal point in the wrong
place. </span><span id="hevea_default730"></span>

<span style="font-family:monospace;font-size:medium">\[-0.441, 1.774,
-0.101, -1.138, 2.975, -213.8\]</span>

<span style="font-size:medium">Now what’s your estimate of µ? If you use
the sample mean, your guess is -35.12. Is that the best choice? What are
the alternatives? </span><span id="hevea_default731"></span>

<span style="font-size:medium">One option is to identify and discard
outliers, then compute the sample mean of the rest. Another option is to
use the median as an estimator. </span><span
id="hevea_default732"></span>

<span style="font-size:medium">Which estimator is best depends on the
circumstances (for example, whether there are outliers) and on what the
goal is. Are you trying to minimize errors, or maximize your chance of
getting the right answer? </span><span
id="hevea_default733"></span><span style="font-size:medium">
</span><span id="hevea_default734"></span><span
style="font-size:medium"> </span><span id="hevea_default735"></span>

<span style="font-size:medium">If there are no outliers, the sample mean
minimizes the <span style="font-weight:bold">mean squared error</span>
(MSE). That is, if we play the game many times, and each time compute
the error <span style="text-decoration:overline">x</span> − µ, the
sample mean minimizes </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">MSE</span> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">m</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> <span style="font-size:xx-large">∑</span>(<span style="text-decoration:overline">x</span> − µ)</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Where <span
style="font-style:italic">m</span> is the number of times you play the
estimation game, not to be confused with <span
style="font-style:italic">n</span>, which is the size of the sample used
to compute <span style="text-decoration:overline">x</span>.</span>

<span style="font-size:medium">Here is a function that simulates the
estimation game and computes the root mean squared error (RMSE), which
is the square root of MSE: </span><span
id="hevea_default736"></span><span style="font-size:medium">
</span><span id="hevea_default737"></span><span
style="font-size:medium"> </span><span id="hevea_default738"></span>

    def Estimate1(n=7, m=1000):
        mu = 0
        sigma = 1

        means = []
        medians = []
        for _ in range(m):
            xs = [random.gauss(mu, sigma) for i in range(n)]
            xbar = np.mean(xs)
            median = np.median(xs)
            means.append(xbar)
            medians.append(median)

        print('rmse xbar', RMSE(means, mu))
        print('rmse median', RMSE(medians, mu))

<span style="font-size:medium">Again, <span
style="font-family:monospace">n</span> is the size of the sample, and
<span style="font-family:monospace">m</span> is the number of times we
play the game. <span style="font-family:monospace">means</span> is the
list of estimates based on <span
style="text-decoration:overline">x</span>. <span
style="font-family:monospace">medians</span> is the list of medians.
</span><span id="hevea_default739"></span>

<span style="font-size:medium">Here’s the function that computes
RMSE:</span>

    def RMSE(estimates, actual):
        e2 = [(estimate-actual)**2 for estimate in estimates]
        mse = np.mean(e2)
        return math.sqrt(mse)

<span style="font-size:medium"><span
style="font-family:monospace">estimates</span> is a list of estimates;
<span style="font-family:monospace">actual</span> is the actual value
being estimated. In practice, of course, we don’t know <span
style="font-family:monospace">actual</span>; if we did, we wouldn’t have
to estimate it. The purpose of this experiment is to compare the
performance of the two estimators. </span><span
id="hevea_default740"></span>

<span style="font-size:medium">When I ran this code, the RMSE of the
sample mean was 0.41, which means that if we use <span
style="text-decoration:overline">x</span> to estimate the mean of this
distribution, based on a sample with <span
style="font-style:italic">n</span>=7, we should expect to be off by 0.41
on average. Using the median to estimate the mean yields RMSE 0.53,
which confirms that <span style="text-decoration:overline">x</span>
yields lower RMSE, at least for this example.</span>

<span style="font-size:medium">Minimizing MSE is a nice property, but
it’s not always the best strategy. For example, suppose we are
estimating the distribution of wind speeds at a building site. If the
estimate is too high, we might overbuild the structure, increasing its
cost. But if it’s too low, the building might collapse. Because cost as
a function of error is not symmetric, minimizing MSE is not the best
strategy. </span><span id="hevea_default741"></span><span
style="font-size:medium"> </span><span
id="hevea_default742"></span><span style="font-size:medium">
</span><span id="hevea_default743"></span>

<span style="font-size:medium">As another example, suppose I roll three
six-sided dice and ask you to predict the total. If you get it exactly
right, you get a prize; otherwise you get nothing. In this case the
value that minimizes MSE is 10.5, but that would be a bad guess, because
the total of three dice is never 10.5. For this game, you want an
estimator that has the highest chance of being right, which is a <span
style="font-weight:bold">maximum likelihood estimator</span> (MLE). If
you pick 10 or 11, your chance of winning is 1 in 8, and that’s the best
you can do. </span><span id="hevea_default744"></span><span
style="font-size:medium"> </span><span
id="hevea_default745"></span><span style="font-size:medium">
</span><span id="hevea_default746"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.2  Guess the variance</span>
-------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default747"></span><span style="font-size:medium">
</span><span id="hevea_default748"></span><span
style="font-size:medium"> </span><span
id="hevea_default749"></span><span style="font-size:medium">
</span><span id="hevea_default750"></span><span
style="font-size:medium"> </span><span id="hevea_default751"></span>

<span style="font-size:medium">*I’m thinking of a distribution.* It’s a
normal distribution, and here’s a (familiar) sample:</span>

<span style="font-family:monospace;font-size:medium">\[-0.441, 1.774,
-0.101, -1.138, 2.975, -2.138\]</span>

<span style="font-size:medium">What do you think is the variance,
σ</span><sup><span style="font-size:medium">2</span></sup><span
style="font-size:medium">, of my distribution? Again, the obvious choice
is to use the sample variance, <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
as an estimator. </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">S</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">n</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> <span style="font-size:xx-large">∑</span>(<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> For large samples, <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is an adequate estimator, but for small samples it tends to be too low.
Because of this unfortunate property, it is called a <span
style="font-weight:bold">biased</span> estimator. An estimator is <span
style="font-weight:bold">unbiased</span> if the expected total (or mean)
error, after many iterations of the estimation game, is 0. </span><span
id="hevea_default752"></span><span style="font-size:medium">
</span><span id="hevea_default753"></span><span
style="font-size:medium"> </span><span
id="hevea_default754"></span><span style="font-size:medium">
</span><span id="hevea_default755"></span><span
style="font-size:medium"> </span><span id="hevea_default756"></span>

<span style="font-size:medium">Fortunately, there is another simple
statistic that is an unbiased estimator of σ</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">:
</span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">S</span><sub><span style="font-size:medium"><span style="font-style:italic">n</span>−1</span></sub><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">n</span>−1</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> <span style="font-size:xx-large">∑</span>(<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> For an explanation of why <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is biased, and a proof that <span
style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is unbiased, see </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Bias\_of\_an\_estimator</span>](http://wikipedia.org/wiki/Bias_of_an_estimator)<span
style="font-size:medium">.</span>

<span style="font-size:medium">The biggest problem with this estimator
is that its name and symbol are used inconsistently. The name “sample
variance” can refer to either <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
or <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
and the symbol <span style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
is used for either or both.</span>

<span style="font-size:medium">Here is a function that simulates the
estimation game and tests the performance of <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
and <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span
style="font-size:medium">:</span>

    def Estimate2(n=7, m=1000):
        mu = 0
        sigma = 1

        estimates1 = []
        estimates2 = []
        for _ in range(m):
            xs = [random.gauss(mu, sigma) for i in range(n)]
            biased = np.var(xs)
            unbiased = np.var(xs, ddof=1)
            estimates1.append(biased)
            estimates2.append(unbiased)

        print('mean error biased', MeanError(estimates1, sigma**2))
        print('mean error unbiased', MeanError(estimates2, sigma**2))

<span style="font-size:medium">Again, <span
style="font-family:monospace">n</span> is the sample size and <span
style="font-family:monospace">m</span> is the number of times we play
the game. <span style="font-family:monospace">np.var</span> computes
<span style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
by default and <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
if you provide the argument <span
style="font-family:monospace">ddof=1</span>, which stands for “delta
degrees of freedom.” I won’t explain that term, but you can read about
it at </span>[<span
style="font-family:monospace;font-size:medium">http://en.wikipedia.org/wiki/Degrees\_of\_freedom\_(statistics)</span>](http://en.wikipedia.org/wiki/Degrees_of_freedom_(statistics))<span
style="font-size:medium">. </span><span id="hevea_default757"></span>

<span style="font-size:medium"><span
style="font-family:monospace">MeanError</span> computes the mean
difference between the estimates and the actual value:</span>

    def MeanError(estimates, actual):
        errors = [estimate-actual for estimate in estimates]
        return np.mean(errors)

<span style="font-size:medium">When I ran this code, the mean error for
<span style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
was -0.13. As expected, this biased estimator tends to be too low. For
<span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
the mean error was 0.014, about 10 times smaller. As <span
style="font-family:monospace">m</span> increases, we expect the mean
error for <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
to approach 0. </span><span id="hevea_default758"></span>

<span style="font-size:medium">Properties like MSE and bias are
long-term expectations based on many iterations of the estimation game.
By running simulations like the ones in this chapter, we can compare
estimators and check whether they have desired properties. </span><span
id="hevea_default759"></span><span style="font-size:medium">
</span><span id="hevea_default760"></span>

<span style="font-size:medium">But when you apply an estimator to real
data, you just get one estimate. It would not be meaningful to say that
the estimate is unbiased; being unbiased is a property of the estimator,
not the estimate.</span>

<span style="font-size:medium">After you choose an estimator with
appropriate properties, and use it to generate an estimate, the next
step is to characterize the uncertainty of the estimate, which is the
topic of the next section.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.3  Sampling distributions</span>
-----------------------------------------------------------------

<span style="font-size:medium"> </span><span id="gorilla"></span>

<span style="font-size:medium">Suppose you are a scientist studying
gorillas in a wildlife preserve. You want to know the average weight of
the adult female gorillas in the preserve. To weigh them, you have to
tranquilize them, which is dangerous, expensive, and possibly harmful to
the gorillas. But if it is important to obtain this information, it
might be acceptable to weigh a sample of 9 gorillas. Let’s assume that
the population of the preserve is well known, so we can choose a
representative sample of adult females. We could use the sample mean,
<span style="text-decoration:overline">x</span>, to estimate the unknown
population mean, µ. </span><span id="hevea_default761"></span><span
style="font-size:medium"> </span><span
id="hevea_default762"></span><span style="font-size:medium">
</span><span id="hevea_default763"></span>

<span style="font-size:medium">Having weighed 9 female gorillas, you
might find <span style="text-decoration:overline">x</span>=90 kg and
sample standard deviation, <span style="font-style:italic">S</span>=7.5
kg. The sample mean is an unbiased estimator of µ, and in the long run
it minimizes MSE. So if you report a single estimate that summarizes the
results, you would report 90 kg. </span><span
id="hevea_default764"></span><span style="font-size:medium">
</span><span id="hevea_default765"></span><span
style="font-size:medium"> </span><span
id="hevea_default766"></span><span style="font-size:medium">
</span><span id="hevea_default767"></span><span
style="font-size:medium"> </span><span id="hevea_default768"></span>

<span style="font-size:medium">But how confident should you be in this
estimate? If you only weigh <span style="font-style:italic">n</span>=9
gorillas out of a much larger population, you might be unlucky and
choose the 9 heaviest gorillas (or the 9 lightest ones) just by chance.
Variation in the estimate caused by random selection is called <span
style="font-weight:bold">sampling error</span>. </span><span
id="hevea_default769"></span>

<span style="font-size:medium">To quantify sampling error, we can
simulate the sampling process with hypothetical values of µ and σ, and
see how much <span style="text-decoration:overline">x</span>
varies.</span>

<span style="font-size:medium">Since we don’t know the actual values of
µ and σ in the population, we’ll use the estimates <span
style="text-decoration:overline">x</span> and <span
style="font-style:italic">S</span>. So the question we answer is: “If
the actual values of µ and σ were 90 kg and 7.5 kg, and we ran the same
experiment many times, how much would the estimated mean, <span
style="text-decoration:overline">x</span>, vary?”</span>

<span style="font-size:medium">The following function answers that
question:</span>

    def SimulateSample(mu=90, sigma=7.5, n=9, m=1000):
        means = []
        for j in range(m):
            xs = np.random.normal(mu, sigma, n)
            xbar = np.mean(xs)
            means.append(xbar)

        cdf = thinkstats2.Cdf(means)
        ci = cdf.Percentile(5), cdf.Percentile(95)
        stderr = RMSE(means, mu)

<span style="font-size:medium"><span
style="font-family:monospace">mu</span> and <span
style="font-family:monospace">sigma</span> are the *hypothetical* values
of the parameters. <span style="font-family:monospace">n</span> is the
sample size, the number of gorillas we measured. <span
style="font-family:monospace">m</span> is the number of times we run the
simulation. </span><span id="hevea_default770"></span><span
style="font-size:medium"> </span><span
id="hevea_default771"></span><span style="font-size:medium">
</span><span id="hevea_default772"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2033.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 8.1: Sampling distribution of <span style="text-decoration:overline">x</span>, with confidence interval.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="estimation1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">In each iteration, we choose <span
style="font-family:monospace">n</span> values from a normal distribution
with the given parameters, and compute the sample mean, <span
style="font-family:monospace">xbar</span>. We run 1000 simulations and
then compute the distribution, <span
style="font-family:monospace">cdf</span>, of the estimates. The result
is shown in Figure </span>[<span
style="font-size:medium">8.1</span>](#estimation1)<span
style="font-size:medium">. This distribution is called the <span
style="font-weight:bold">sampling distribution</span> of the estimator.
It shows how much the estimates would vary if we ran the experiment over
and over. </span><span id="hevea_default773"></span>

<span style="font-size:medium">The mean of the sampling distribution is
pretty close to the hypothetical value of µ, which means that the
experiment yields the right answer, on average. After 1000 tries, the
lowest result is 82 kg, and the highest is 98 kg. This range suggests
that the estimate might be off by as much as 8 kg.</span>

<span style="font-size:medium">There are two common ways to summarize
the sampling distribution:</span>

-   <span style="font-size:medium"><span
    style="font-weight:bold">Standard error</span> (SE) is a measure of
    how far we expect the estimate to be off, on average. For each
    simulated experiment, we compute the error, <span
    style="text-decoration:overline">x</span> − µ, and then compute the
    root mean squared error (RMSE). In this example, it is roughly 2.5
    kg. </span><span id="hevea_default774"></span>
-   <span style="font-size:medium">A <span
    style="font-weight:bold">confidence interval</span> (CI) is a range
    that includes a given fraction of the sampling distribution. For
    example, the 90% confidence interval is the range from the 5th to
    the 95th percentile. In this example, the 90% CI is (86, 94) kg.
    </span><span id="hevea_default775"></span><span
    style="font-size:medium"> </span><span id="hevea_default776"></span>

<span style="font-size:medium">Standard errors and confidence intervals
are the source of much confusion:</span>

-   <span style="font-size:medium">People often confuse standard error
    and standard deviation. Remember that standard deviation describes
    variability in a measured quantity; in this example, the standard
    deviation of gorilla weight is 7.5 kg. Standard error describes
    variability in an estimate. In this example, the standard error of
    the mean, based on a sample of 9 measurements, is 2.5 kg.
    </span><span id="hevea_default777"></span><span
    style="font-size:medium"> </span><span id="hevea_default778"></span>

    <span style="font-size:medium">One way to remember the difference is
    that, as sample size increases, standard error gets smaller;
    standard deviation does not.</span>

-   <span style="font-size:medium">People often think that there is a
    90% probability that the actual parameter, µ, falls in the 90%
    confidence interval. Sadly, that is not true. If you want to make a
    claim like that, you have to use Bayesian methods (see my book,
    <span style="font-style:italic">Think Bayes</span>). </span><span
    id="hevea_default779"></span>

    <span style="font-size:medium">The sampling distribution answers a
    different question: it gives you a sense of how reliable an estimate
    is by telling you how much it would vary if you ran the experiment
    again. </span><span id="hevea_default780"></span>

<span style="font-size:medium">It is important to remember that
confidence intervals and standard errors only quantify sampling error;
that is, error due to measuring only part of the population. The
sampling distribution does not account for other sources of error,
notably sampling bias and measurement error, which are the topics of the
next section.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.4  Sampling bias</span>
--------------------------------------------------------

<span style="font-size:medium">Suppose that instead of the weight of
gorillas in a nature preserve, you want to know the average weight of
women in the city where you live. It is unlikely that you would be
allowed to choose a representative sample of women and weigh them.
</span><span id="hevea_default781"></span><span
style="font-size:medium"> </span><span
id="hevea_default782"></span><span style="font-size:medium">
</span><span id="hevea_default783"></span><span
style="font-size:medium"> </span><span
id="hevea_default784"></span><span style="font-size:medium">
</span><span id="hevea_default785"></span>

<span style="font-size:medium">A simple alternative would be “telephone
sampling;” that is, you could choose random numbers from the phone book,
call and ask to speak to an adult woman, and ask how much she weighs.
</span><span id="hevea_default786"></span><span
style="font-size:medium"> </span><span id="hevea_default787"></span>

<span style="font-size:medium">Telephone sampling has obvious
limitations. For example, the sample is limited to people whose
telephone numbers are listed, so it eliminates people without phones
(who might be poorer than average) and people with unlisted numbers (who
might be richer). Also, if you call home telephones during the day, you
are less likely to sample people with jobs. And if you only sample the
person who answers the phone, you are less likely to sample people who
share a phone line.</span>

<span style="font-size:medium">If factors like income, employment, and
household size are related to weight—and it is plausible that they
are—the results of your survey would be affected one way or another.
This problem is called <span style="font-weight:bold">sampling
bias</span> because it is a property of the sampling process.
</span><span id="hevea_default788"></span>

<span style="font-size:medium">This sampling process is also vulnerable
to self-selection, which is a kind of sampling bias. Some people will
refuse to answer the question, and if the tendency to refuse is related
to weight, that would affect the results. </span><span
id="hevea_default789"></span>

<span style="font-size:medium">Finally, if you ask people how much they
weigh, rather than weighing them, the results might not be accurate.
Even helpful respondents might round up or down if they are
uncomfortable with their actual weight. And not all respondents are
helpful. These inaccuracies are examples of <span
style="font-weight:bold">measurement error</span>. </span><span
id="hevea_default790"></span>

<span style="font-size:medium">When you report an estimated quantity, it
is useful to report standard error, or a confidence interval, or both,
in order to quantify sampling error. But it is also important to
remember that sampling error is only one source of error, and often it
is not the biggest. </span><span id="hevea_default791"></span><span
style="font-size:medium"> </span><span id="hevea_default792"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.5  Exponential distributions</span>
--------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default793"></span><span style="font-size:medium">
</span><span id="hevea_default794"></span>

<span style="font-size:medium">Let’s play one more round of the
estimation game. *I’m thinking of a distribution.* It’s an exponential
distribution, and here’s a sample:</span>

<span style="font-family:monospace;font-size:medium">\[5.384, 4.493,
19.198, 2.790, 6.122, 12.844\]</span>

<span style="font-size:medium">What do you think is the parameter, λ, of
this distribution? </span><span id="hevea_default795"></span><span
style="font-size:medium"> </span><span id="hevea_default796"></span>

<span style="font-size:medium">In general, the mean of an exponential
distribution is 1/λ, so working backwards, we might choose </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">L</span> = 1 / <span style="text-decoration:overline">x</span></span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> <span style="font-style:italic">L</span>
is an estimator of λ. And not just any estimator; it is also the maximum
likelihood estimator (see </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Exponential\_distribution\#Maximum\_likelihood</span>](http://wikipedia.org/wiki/Exponential_distribution#Maximum_likelihood)<span
style="font-size:medium">). So if you want to maximize your chance of
guessing λ exactly, <span style="font-style:italic">L</span> is the way
to go. </span><span id="hevea_default797"></span><span
style="font-size:medium"> </span><span id="hevea_default798"></span>

<span style="font-size:medium">But we know that <span
style="text-decoration:overline">x</span> is not robust in the presence
of outliers, so we expect <span style="font-style:italic">L</span> to
have the same problem. </span><span id="hevea_default799"></span><span
style="font-size:medium"> </span><span
id="hevea_default800"></span><span style="font-size:medium">
</span><span id="hevea_default801"></span>

<span style="font-size:medium">We can choose an alternative based on the
sample median. The median of an exponential distribution is ln(2) / λ,
so working backwards again, we can define an estimator </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">L</span><sub><span style="font-style:italic;font-size:medium">m</span></sub><span style="font-size:medium"> = ln(2) / <span style="font-style:italic">m</span> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where <span
style="font-style:italic">m</span> is the sample median. </span><span
id="hevea_default802"></span>

<span style="font-size:medium">To test the performance of these
estimators, we can simulate the sampling process:</span>

    def Estimate3(n=7, m=1000):
        lam = 2

        means = []
        medians = []
        for _ in range(m):
            xs = np.random.exponential(1.0/lam, n)
            L = 1 / np.mean(xs)
            Lm = math.log(2) / thinkstats2.Median(xs)
            means.append(L)
            medians.append(Lm)

        print('rmse L', RMSE(means, lam))
        print('rmse Lm', RMSE(medians, lam))
        print('mean error L', MeanError(means, lam))
        print('mean error Lm', MeanError(medians, lam))

<span style="font-size:medium">When I run this experiment with λ=2, the
RMSE of <span style="font-style:italic">L</span> is 1.1. For the
median-based estimator <span
style="font-style:italic">L</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium">, RMSE is 1.8. We can’t tell from this
experiment whether <span style="font-style:italic">L</span> minimizes
MSE, but at least it seems better than <span
style="font-style:italic">L</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium">. </span><span
id="hevea_default803"></span><span style="font-size:medium">
</span><span id="hevea_default804"></span>

<span style="font-size:medium">Sadly, it seems that both estimators are
biased. For <span style="font-style:italic">L</span> the mean error is
0.33; for <span style="font-style:italic">L</span></span><sub><span
style="font-style:italic;font-size:medium">m</span></sub><span
style="font-size:medium"> it is 0.45. And neither converges to 0 as
<span style="font-family:monospace">m</span> increases. </span><span
id="hevea_default805"></span><span style="font-size:medium">
</span><span id="hevea_default806"></span>

<span style="font-size:medium">It turns out that <span
style="text-decoration:overline">x</span> is an unbiased estimator of
the mean of the distribution, 1 / λ, but <span
style="font-style:italic">L</span> is not an unbiased estimator of
λ.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.6  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">For the following exercises, you might
want to start with a copy of <span
style="font-family:monospace">estimation.py</span>. Solutions are in
`chap08soln.py`</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>  </span>

<span style="font-size:medium">*In this chapter we used* <span
style="text-decoration:overline">x</span> *and median to estimate* µ*,
and found that* <span style="text-decoration:overline">x</span> *yields
lower MSE. Also, we used* <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*and* <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*to estimate* σ*, and found that* <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*is biased and* <span
style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*unbiased.*</span>

<span style="font-size:medium">*Run similar experiments to see if* <span
style="text-decoration:overline">x</span> *and median are biased
estimates of* µ*. Also check whether* <span
style="font-style:italic">S</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*or* <span style="font-style:italic">S</span></span><sub><span
style="font-size:medium"><span
style="font-style:italic">n</span>−1</span></sub><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
*yields a lower MSE.* </span><span id="hevea_default807"></span><span
style="font-size:medium"> </span><span
id="hevea_default808"></span><span style="font-size:medium">
</span><span id="hevea_default809"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>  </span>

<span style="font-size:medium">*Suppose you draw a sample with size*
<span style="font-style:italic">n</span>=10 *from an exponential
distribution with* λ=2*. Simulate this experiment 1000 times and plot
the sampling distribution of the estimate* <span
style="font-style:italic">L</span>*. Compute the standard error of the
estimate and the 90% confidence interval.* </span><span
id="hevea_default810"></span><span style="font-size:medium">
</span><span id="hevea_default811"></span><span
style="font-size:medium"> </span><span id="hevea_default812"></span>

<span style="font-size:medium">*Repeat the experiment with a few
different values of* <span style="font-style:italic">n</span> *and make
a plot of standard error versus* <span
style="font-style:italic">n</span>*.* </span><span
id="hevea_default813"></span><span style="font-size:medium">
</span><span id="hevea_default814"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>  </span>

<span style="font-size:medium">*In games like hockey and soccer, the
time between goals is roughly exponential. So you could estimate a
team’s goal-scoring rate by observing the number of goals they score in
a game. This estimation process is a little different from sampling the
time between goals, so let’s see how it works.* </span><span
id="hevea_default815"></span><span style="font-size:medium">
</span><span id="hevea_default816"></span>

<span style="font-size:medium">*Write a function that takes a
goal-scoring rate, <span style="font-family:monospace">lam</span>, in
goals per game, and simulates a game by generating the time between
goals until the total time exceeds 1 game, then returns the number of
goals scored.*</span>

<span style="font-size:medium">*Write another function that simulates
many games, stores the estimates of <span
style="font-family:monospace">lam</span>, then computes their mean error
and RMSE.*</span>

<span style="font-size:medium">*Is this way of making an estimate
biased? Plot the sampling distribution of the estimates and the 90%
confidence interval. What is the standard error? What happens to
sampling error for increasing values of <span
style="font-family:monospace">lam</span>?* </span><span
id="hevea_default817"></span><span style="font-size:medium">
</span><span id="hevea_default818"></span><span
style="font-size:medium"> </span><span
id="hevea_default819"></span><span style="font-size:medium">
</span><span id="hevea_default820"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">8.7  Glossary</span>
---------------------------------------------------

-   <span style="font-size:medium">estimation: The process of inferring
    the parameters of a distribution from a sample. </span><span
    id="hevea_default821"></span>
-   <span style="font-size:medium">estimator: A statistic used to
    estimate a parameter. </span><span id="hevea_default822"></span>
-   <span style="font-size:medium">mean squared error (MSE): A measure
    of estimation error. </span><span id="hevea_default823"></span><span
    style="font-size:medium"> </span><span id="hevea_default824"></span>
-   <span style="font-size:medium">root mean squared error (RMSE): The
    square root of MSE, a more meaningful representation of typical
    error magnitude. </span><span id="hevea_default825"></span><span
    style="font-size:medium"> </span><span id="hevea_default826"></span>
-   <span style="font-size:medium">maximum likelihood estimator (MLE):
    An estimator that computes the point estimate most likely to be
    correct. </span><span id="hevea_default827"></span><span
    style="font-size:medium"> </span><span id="hevea_default828"></span>
-   <span style="font-size:medium">bias (of an estimator): The tendency
    of an estimator to be above or below the actual value of the
    parameter, when averaged over repeated experiments. </span><span
    id="hevea_default829"></span>
-   <span style="font-size:medium">sampling error: Error in an estimate
    due to the limited size of the sample and variation due to chance.
    </span><span id="hevea_default830"></span>
-   <span style="font-size:medium">sampling bias: Error in an estimate
    due to a sampling process that is not representative of the
    population. </span><span id="hevea_default831"></span>
-   <span style="font-size:medium">measurement error: Error in an
    estimate due to inaccuracy collecting or recording data.
    </span><span id="hevea_default832"></span>
-   <span style="font-size:medium">sampling distribution: The
    distribution of a statistic if an experiment is repeated many times.
    </span><span id="hevea_default833"></span>
-   <span style="font-size:medium">standard error: The RMSE of an
    estimate, which quantifies variability due to sampling error (but
    not other sources of error). </span><span
    id="hevea_default834"></span>
-   <span style="font-size:medium">confidence interval: An interval that
    represents the expected range of an estimator if an experiment is
    repeated many times. </span><span id="hevea_default835"></span><span
    style="font-size:medium"> </span><span id="hevea_default836"></span>

<span style="font-size:medium"> </span>
