This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 9  Hypothesis testing</span>
===================================================================

<span style="font-size:medium"> </span><span id="testing"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">hypothesis.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.1  Classical hypothesis testing</span>
-----------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default837"></span><span style="font-size:medium">
</span><span id="hevea_default838"></span>

<span style="font-size:medium">Exploring the data from the NSFG, we saw
several “apparent effects,” including differences between first babies
and others. So far we have taken these effects at face value; in this
chapter, we put them to the test. </span><span
id="hevea_default839"></span><span style="font-size:medium">
</span><span id="hevea_default840"></span>

<span style="font-size:medium">The fundamental question we want to
address is whether the effects we see in a sample are likely to appear
in the larger population. For example, in the NSFG sample we see a
difference in mean pregnancy length for first babies and others. We
would like to know if that effect reflects a real difference for women
in the U.S., or if it might appear in the sample by chance. </span><span
id="hevea_default841"></span><span style="font-size:medium">
</span><span id="hevea_default842"></span>

<span style="font-size:medium">There are several ways we could formulate
this question, including Fisher null hypothesis testing, Neyman-Pearson
decision theory, and Bayesian
inference</span><sup><a href="#note4" id="text4"><span style="font-size:medium">1</span></a></sup><span
style="font-size:medium">. What I present here is a subset of all three
that makes up most of what people use in practice, which I will call
<span style="font-weight:bold">classical hypothesis testing</span>.
</span><span id="hevea_default843"></span><span
style="font-size:medium"> </span><span id="hevea_default844"></span>

<span style="font-size:medium">The goal of classical hypothesis testing
is to answer the question, “Given a sample and an apparent effect, what
is the probability of seeing such an effect by chance?” Here’s how we
answer that question:</span>

-   <span style="font-size:medium">The first step is to quantify the
    size of the apparent effect by choosing a <span
    style="font-weight:bold">test statistic</span>. In the NSFG example,
    the apparent effect is a difference in pregnancy length between
    first babies and others, so a natural choice for the test statistic
    is the difference in means between the two groups. </span><span
    id="hevea_default845"></span>
-   <span style="font-size:medium">The second step is to define a <span
    style="font-weight:bold">null hypothesis</span>, which is a model of
    the system based on the assumption that the apparent effect is not
    real. In the NSFG example the null hypothesis is that there is no
    difference between first babies and others; that is, that pregnancy
    lengths for both groups have the same distribution. </span><span
    id="hevea_default846"></span><span style="font-size:medium">
    </span><span id="hevea_default847"></span><span
    style="font-size:medium"> </span><span id="hevea_default848"></span>
-   <span style="font-size:medium">The third step is to compute a <span
    style="font-weight:bold">p-value</span>, which is the probability of
    seeing the apparent effect if the null hypothesis is true. In the
    NSFG example, we would compute the actual difference in means, then
    compute the probability of seeing a difference as big, or bigger,
    under the null hypothesis. </span><span
    id="hevea_default849"></span>
-   <span style="font-size:medium">The last step is to interpret the
    result. If the p-value is low, the effect is said to be <span
    style="font-weight:bold">statistically significant</span>, which
    means that it is unlikely to have occurred by chance. In that case
    we infer that the effect is more likely to appear in the larger
    population. </span><span id="hevea_default850"></span><span
    style="font-size:medium"> </span><span id="hevea_default851"></span>

<span style="font-size:medium">The logic of this process is similar to a
proof by contradiction. To prove a mathematical statement, A, you assume
temporarily that A is false. If that assumption leads to a
contradiction, you conclude that A must actually be true. </span><span
id="hevea_default852"></span><span style="font-size:medium">
</span><span id="hevea_default853"></span>

<span style="font-size:medium">Similarly, to test a hypothesis like,
“This effect is real,” we assume, temporarily, that it is not. That’s
the null hypothesis. Based on that assumption, we compute the
probability of the apparent effect. That’s the p-value. If the p-value
is low, we conclude that the null hypothesis is unlikely to be true.
</span><span id="hevea_default854"></span><span
style="font-size:medium"> </span><span id="hevea_default855"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.2  HypothesisTest</span>
---------------------------------------------------------

<span style="font-size:medium"> </span><span id="hypotest"></span><span
style="font-size:medium"> </span><span id="hevea_default856"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> provides <span
style="font-family:monospace">HypothesisTest</span>, a class that
represents the structure of a classical hypothesis test. Here is the
definition: </span><span id="hevea_default857"></span>

    class HypothesisTest(object):

        def __init__(self, data):
            self.data = data
            self.MakeModel()
            self.actual = self.TestStatistic(data)

        def PValue(self, iters=1000):
            self.test_stats = [self.TestStatistic(self.RunModel()) 
                               for _ in range(iters)]

            count = sum(1 for x in self.test_stats if x >= self.actual)
            return count / iters

        def TestStatistic(self, data):
            raise UnimplementedMethodException()

        def MakeModel(self):
            pass

        def RunModel(self):
            raise UnimplementedMethodException()

<span style="font-size:medium"><span
style="font-family:monospace">HypothesisTest</span> is an abstract
parent class that provides complete definitions for some methods and
place-keepers for others. Child classes based on <span
style="font-family:monospace">HypothesisTest</span> inherit `__init__`
and <span style="font-family:monospace">PValue</span> and provide <span
style="font-family:monospace">TestStatistic</span>, <span
style="font-family:monospace">RunModel</span>, and optionally <span
style="font-family:monospace">MakeModel</span>. </span><span
id="hevea_default858"></span>

<span style="font-size:medium">`__init__` takes the data in whatever
form is appropriate. It calls <span
style="font-family:monospace">MakeModel</span>, which builds a
representation of the null hypothesis, then passes the data to <span
style="font-family:monospace">TestStatistic</span>, which computes the
size of the effect in the sample. </span><span
id="hevea_default859"></span><span style="font-size:medium">
</span><span id="hevea_default860"></span>

<span style="font-size:medium"><span
style="font-family:monospace">PValue</span> computes the probability of
the apparent effect under the null hypothesis. It takes as a parameter
<span style="font-family:monospace">iters</span>, which is the number of
simulations to run. The first line generates simulated data, computes
test statistics, and stores them in `test_stats`. The result is the
fraction of elements in `test_stats` that exceed or equal the observed
test statistic, <span style="font-family:monospace">self.actual</span>.
</span><span id="hevea_default861"></span>

<span style="font-size:medium">As a simple
example</span><sup><a href="#note5" id="text5"><span style="font-size:medium">2</span></a></sup><span
style="font-size:medium">, suppose we toss a coin 250 times and see 140
heads and 110 tails. Based on this result, we might suspect that the
coin is biased; that is, more likely to land heads. To test this
hypothesis, we compute the probability of seeing such a difference if
the coin is actually fair: </span><span
id="hevea_default862"></span><span style="font-size:medium">
</span><span id="hevea_default863"></span>

    class CoinTest(thinkstats2.HypothesisTest):

        def TestStatistic(self, data):
            heads, tails = data
            test_stat = abs(heads - tails)
            return test_stat

        def RunModel(self):
            heads, tails = self.data
            n = heads + tails
            sample = [random.choice('HT') for _ in range(n)]
            hist = thinkstats2.Hist(sample)
            data = hist['H'], hist['T']
            return data

<span style="font-size:medium">The parameter, <span
style="font-family:monospace">data</span>, is a pair of integers: the
number of heads and tails. The test statistic is the absolute difference
between them, so <span style="font-family:monospace">self.actual</span>
is 30. </span><span id="hevea_default864"></span>

<span style="font-size:medium"><span
style="font-family:monospace">RunModel</span> simulates coin tosses
assuming that the coin is actually fair. It generates a sample of 250
tosses, uses Hist to count the number of heads and tails, and returns a
pair of integers. </span><span id="hevea_default865"></span><span
style="font-size:medium"> </span><span id="hevea_default866"></span>

<span style="font-size:medium">Now all we have to do is instantiate
<span style="font-family:monospace">CoinTest</span> and call <span
style="font-family:monospace">PValue</span>:</span>

        ct = CoinTest((140, 110))
        pvalue = ct.PValue()

<span style="font-size:medium">The result is about 0.07, which means
that if the coin is fair, we expect to see a difference as big as 30
about 7% of the time.</span>

<span style="font-size:medium">How should we interpret this result? By
convention, 5% is the threshold of statistical significance. If the
p-value is less than 5%, the effect is considered significant; otherwise
it is not. </span><span id="hevea_default867"></span><span
style="font-size:medium"> </span><span
id="hevea_default868"></span><span style="font-size:medium">
</span><span id="hevea_default869"></span>

<span style="font-size:medium">But the choice of 5% is arbitrary, and
(as we will see later) the p-value depends on the choice of the test
statistics and the model of the null hypothesis. So p-values should not
be considered precise measurements. </span><span
id="hevea_default870"></span>

<span style="font-size:medium">I recommend interpreting p-values
according to their order of magnitude: if the p-value is less than 1%,
the effect is unlikely to be due to chance; if it is greater than 10%,
the effect can plausibly be explained by chance. P-values between 1% and
10% should be considered borderline. So in this example I conclude that
the data do not provide strong evidence that the coin is biased or
not.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.3  Testing a difference in means</span>
------------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="testdiff"></span><span
style="font-size:medium"> </span><span id="hevea_default871"></span>

<span style="font-size:medium">One of the most common effects to test is
a difference in mean between two groups. In the NSFG data, we saw that
the mean pregnancy length for first babies is slightly longer, and the
mean birth weight is slightly smaller. Now we will see if those effects
are statistically significant. </span><span
id="hevea_default872"></span><span style="font-size:medium">
</span><span id="hevea_default873"></span><span
style="font-size:medium"> </span><span
id="hevea_default874"></span><span style="font-size:medium">
</span><span id="hevea_default875"></span>

<span style="font-size:medium">For these examples, the null hypothesis
is that the distributions for the two groups are the same. One way to
model the null hypothesis is by <span
style="font-weight:bold">permutation</span>; that is, we can take values
for first babies and others and shuffle them, treating the two groups as
one big group: </span><span id="hevea_default876"></span><span
style="font-size:medium"> </span><span
id="hevea_default877"></span><span style="font-size:medium">
</span><span id="hevea_default878"></span>

    class DiffMeansPermute(thinkstats2.HypothesisTest):

        def TestStatistic(self, data):
            group1, group2 = data
            test_stat = abs(group1.mean() - group2.mean())
            return test_stat

        def MakeModel(self):
            group1, group2 = self.data
            self.n, self.m = len(group1), len(group2)
            self.pool = np.hstack((group1, group2))

        def RunModel(self):
            np.random.shuffle(self.pool)
            data = self.pool[:self.n], self.pool[self.n:]
            return data

<span style="font-size:medium"><span
style="font-family:monospace">data</span> is a pair of sequences, one
for each group. The test statistic is the absolute difference in the
means. </span><span id="hevea_default879"></span>

<span style="font-size:medium"><span
style="font-family:monospace">MakeModel</span> records the sizes of the
groups, <span style="font-family:monospace">n</span> and <span
style="font-family:monospace">m</span>, and combines the groups into one
NumPy array, <span style="font-family:monospace">self.pool</span>.
</span><span id="hevea_default880"></span>

<span style="font-size:medium"><span
style="font-family:monospace">RunModel</span> simulates the null
hypothesis by shuffling the pooled values and splitting them into two
groups with sizes <span style="font-family:monospace">n</span> and <span
style="font-family:monospace">m</span>. As always, the return value from
<span style="font-family:monospace">RunModel</span> has the same format
as the observed data. </span><span id="hevea_default881"></span><span
style="font-size:medium"> </span><span id="hevea_default882"></span>

<span style="font-size:medium">To test the difference in pregnancy
length, we run:</span>

        live, firsts, others = first.MakeFrames()
        data = firsts.prglngth.values, others.prglngth.values
        ht = DiffMeansPermute(data)
        pvalue = ht.PValue()

<span style="font-size:medium"><span
style="font-family:monospace">MakeFrames</span> reads the NSFG data and
returns DataFrames representing all live births, first babies, and
others. We extract pregnancy lengths as NumPy arrays, pass them as data
to <span style="font-family:monospace">DiffMeansPermute</span>, and
compute the p-value. The result is about 0.17, which means that we
expect to see a difference as big as the observed effect about 17% of
the time. So this effect is not statistically significant. </span><span
id="hevea_default883"></span><span style="font-size:medium">
</span><span id="hevea_default884"></span><span
style="font-size:medium"> </span><span
id="hevea_default885"></span><span style="font-size:medium">
</span><span id="hevea_default886"></span><span
style="font-size:medium"> </span><span id="hevea_default887"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2034.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 9.1: CDF of difference in mean pregnancy length under the null hypothesis.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="hypothesis1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">HypothesisTest</span> provides <span
style="font-family:monospace">PlotCdf</span>, which plots the
distribution of the test statistic and a gray line indicating the
observed effect size: </span><span id="hevea_default888"></span><span
style="font-size:medium"> </span><span
id="hevea_default889"></span><span style="font-size:medium">
</span><span id="hevea_default890"></span><span
style="font-size:medium"> </span><span id="hevea_default891"></span>

        ht.PlotCdf()
        thinkplot.Show(xlabel='test statistic',
                       ylabel='CDF')

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">9.1</span>](#hypothesis1)<span
style="font-size:medium"> shows the result. The CDF intersects the
observed difference at 0.83, which is the complement of the p-value,
0.17. </span><span id="hevea_default892"></span>

<span style="font-size:medium">If we run the same analysis with birth
weight, the computed p-value is 0; after 1000 attempts, the simulation
never yields an effect as big as the observed difference, 0.12 lbs. So
we would report <span style="font-style:italic">p</span> &lt; 0.001, and
conclude that the difference in birth weight is statistically
significant. </span><span id="hevea_default893"></span><span
style="font-size:medium"> </span><span
id="hevea_default894"></span><span style="font-size:medium">
</span><span id="hevea_default895"></span><span
style="font-size:medium"> </span><span id="hevea_default896"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.4  Other test statistics</span>
----------------------------------------------------------------

<span style="font-size:medium">Choosing the best test statistic depends
on what question you are trying to address. For example, if the relevant
question is whether pregnancy lengths are different for first babies,
then it makes sense to test the absolute difference in means, as we did
in the previous section. </span><span id="hevea_default897"></span><span
style="font-size:medium"> </span><span id="hevea_default898"></span>

<span style="font-size:medium">If we had some reason to think that first
babies are likely to be late, then we would not take the absolute value
of the difference; instead we would use this test statistic:</span>

    class DiffMeansOneSided(DiffMeansPermute):

        def TestStatistic(self, data):
            group1, group2 = data
            test_stat = group1.mean() - group2.mean()
            return test_stat

<span style="font-size:medium"><span
style="font-family:monospace">DiffMeansOneSided</span> inherits <span
style="font-family:monospace">MakeModel</span> and <span
style="font-family:monospace">RunModel</span> from <span
style="font-family:monospace">DiffMeansPermute</span>; the only
difference is that <span
style="font-family:monospace">TestStatistic</span> does not take the
absolute value of the difference. This kind of test is called <span
style="font-weight:bold">one-sided</span> because it only counts one
side of the distribution of differences. The previous test, using both
sides, is <span style="font-weight:bold">two-sided</span>. </span><span
id="hevea_default899"></span><span style="font-size:medium">
</span><span id="hevea_default900"></span>

<span style="font-size:medium">For this version of the test, the p-value
is 0.09. In general the p-value for a one-sided test is about half the
p-value for a two-sided test, depending on the shape of the
distribution. </span><span id="hevea_default901"></span>

<span style="font-size:medium">The one-sided hypothesis, that first
babies are born late, is more specific than the two-sided hypothesis, so
the p-value is smaller. But even for the stronger hypothesis, the
difference is not statistically significant. </span><span
id="hevea_default902"></span><span style="font-size:medium">
</span><span id="hevea_default903"></span>

<span style="font-size:medium">We can use the same framework to test for
a difference in standard deviation. In Section </span>[<span
style="font-size:medium">3.3</span>](thinkstats2004.html#visualization)<span
style="font-size:medium">, we saw some evidence that first babies are
more likely to be early or late, and less likely to be on time. So we
might hypothesize that the standard deviation is higher. Here’s how we
can test that: </span><span id="hevea_default904"></span>

    class DiffStdPermute(DiffMeansPermute):

        def TestStatistic(self, data):
            group1, group2 = data
            test_stat = group1.std() - group2.std()
            return test_stat

<span style="font-size:medium">This is a one-sided test because the
hypothesis is that the standard deviation for first babies is higher,
not just different. The p-value is 0.09, which is not statistically
significant. </span><span id="hevea_default905"></span><span
style="font-size:medium"> </span><span
id="hevea_default906"></span><span style="font-size:medium">
</span><span id="hevea_default907"></span><span
style="font-size:medium"> </span><span id="hevea_default908"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.5  Testing a correlation</span>
----------------------------------------------------------------

<span style="font-size:medium"> </span><span id="corrtest"></span>

<span style="font-size:medium">This framework can also test
correlations. For example, in the NSFG data set, the correlation between
birth weight and mother’s age is about 0.07. It seems like older mothers
have heavier babies. But could this effect be due to chance?
</span><span id="hevea_default909"></span><span
style="font-size:medium"> </span><span id="hevea_default910"></span>

<span style="font-size:medium">For the test statistic, I use Pearson’s
correlation, but Spearman’s would work as well. If we had reason to
expect positive correlation, we would do a one-sided test. But since we
have no such reason, I’ll do a two-sided test using the absolute value
of correlation. </span><span id="hevea_default911"></span><span
style="font-size:medium"> </span><span id="hevea_default912"></span>

<span style="font-size:medium">The null hypothesis is that there is no
correlation between mother’s age and birth weight. By shuffling the
observed values, we can simulate a world where the distributions of age
and birth weight are the same, but where the variables are unrelated:
</span><span id="hevea_default913"></span><span
style="font-size:medium"> </span><span
id="hevea_default914"></span><span style="font-size:medium">
</span><span id="hevea_default915"></span>

    class CorrelationPermute(thinkstats2.HypothesisTest):

        def TestStatistic(self, data):
            xs, ys = data
            test_stat = abs(thinkstats2.Corr(xs, ys))
            return test_stat

        def RunModel(self):
            xs, ys = self.data
            xs = np.random.permutation(xs)
            return xs, ys

<span style="font-size:medium"><span
style="font-family:monospace">data</span> is a pair of sequences. <span
style="font-family:monospace">TestStatistic</span> computes the absolute
value of Pearson’s correlation. <span
style="font-family:monospace">RunModel</span> shuffles the <span
style="font-family:monospace">xs</span> and returns simulated data.
</span><span id="hevea_default916"></span><span
style="font-size:medium"> </span><span
id="hevea_default917"></span><span style="font-size:medium">
</span><span id="hevea_default918"></span>

<span style="font-size:medium">Here’s the code that reads the data and
runs the test:</span>

        live, firsts, others = first.MakeFrames()
        live = live.dropna(subset=['agepreg', 'totalwgt_lb'])
        data = live.agepreg.values, live.totalwgt_lb.values
        ht = CorrelationPermute(data)
        pvalue = ht.PValue()

<span style="font-size:medium">I use <span
style="font-family:monospace">dropna</span> with the <span
style="font-family:monospace">subset</span> argument to drop rows that
are missing either of the variables we need. </span><span
id="hevea_default919"></span><span style="font-size:medium">
</span><span id="hevea_default920"></span><span
style="font-size:medium"> </span><span id="hevea_default921"></span>

<span style="font-size:medium">The actual correlation is 0.07. The
computed p-value is 0; after 1000 iterations the largest simulated
correlation is 0.04. So although the observed correlation is small, it
is statistically significant. </span><span
id="hevea_default922"></span><span style="font-size:medium">
</span><span id="hevea_default923"></span><span
style="font-size:medium"> </span><span id="hevea_default924"></span>

<span style="font-size:medium">This example is a reminder that
“statistically significant” does not always mean that an effect is
important, or significant in practice. It only means that it is unlikely
to have occurred by chance.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.6  Testing proportions</span>
--------------------------------------------------------------

<span style="font-size:medium"> </span><span id="casino"></span><span
style="font-size:medium"> </span><span id="hevea_default925"></span>

<span style="font-size:medium">Suppose you run a casino and you suspect
that a customer is using a crooked die; that is, one that has been
modified to make one of the faces more likely than the others. You
apprehend the alleged cheater and confiscate the die, but now you have
to prove that it is crooked. You roll the die 60 times and get the
following results: </span><span id="hevea_default926"></span><span
style="font-size:medium"> </span><span
id="hevea_default927"></span><span style="font-size:medium">
</span><span id="hevea_default928"></span>

<span style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">Value</span></td>
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
<td style="text-align: center;"><span style="font-size:medium">2</span></td>
<td style="text-align: center;"><span style="font-size:medium">3</span></td>
<td style="text-align: center;"><span style="font-size:medium">4</span></td>
<td style="text-align: center;"><span style="font-size:medium">5</span></td>
<td style="text-align: center;"><span style="font-size:medium">6 </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">Frequency</span></td>
<td style="text-align: center;"><span style="font-size:medium">8</span></td>
<td style="text-align: center;"><span style="font-size:medium">9</span></td>
<td style="text-align: center;"><span style="font-size:medium">19</span></td>
<td style="text-align: center;"><span style="font-size:medium">5</span></td>
<td style="text-align: center;"><span style="font-size:medium">8</span></td>
<td style="text-align: center;"><span style="font-size:medium">11 </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">On average you expect each value to
appear 10 times. In this dataset, the value 3 appears more often than
expected, and the value 4 appears less often. But are these differences
statistically significant? </span><span
id="hevea_default929"></span><span style="font-size:medium">
</span><span id="hevea_default930"></span><span
style="font-size:medium"> </span><span id="hevea_default931"></span>

<span style="font-size:medium">To test this hypothesis, we can compute
the expected frequency for each value, the difference between the
expected and observed frequencies, and the total absolute difference. In
this example, we expect each side to come up 10 times out of 60; the
deviations from this expectation are -2, -1, 9, -5, -2, and 1; so the
total absolute difference is 20. How often would we see such a
difference by chance? </span><span id="hevea_default932"></span>

<span style="font-size:medium">Here’s a version of <span
style="font-family:monospace">HypothesisTest</span> that answers that
question: </span><span id="hevea_default933"></span>

    class DiceTest(thinkstats2.HypothesisTest):

        def TestStatistic(self, data):
            observed = data
            n = sum(observed)
            expected = np.ones(6) * n / 6
            test_stat = sum(abs(observed - expected))
            return test_stat

        def RunModel(self):
            n = sum(self.data)
            values = [1, 2, 3, 4, 5, 6]
            rolls = np.random.choice(values, n, replace=True)
            hist = thinkstats2.Hist(rolls)
            freqs = hist.Freqs(values)
            return freqs

<span style="font-size:medium">The data are represented as a list of
frequencies: the observed values are <span
style="font-family:monospace">\[8, 9, 19, 5, 8, 11\]</span>; the
expected frequencies are all 10. The test statistic is the sum of the
absolute differences. </span><span id="hevea_default934"></span>

<span style="font-size:medium">The null hypothesis is that the die is
fair, so we simulate that by drawing random samples from <span
style="font-family:monospace">values</span>. <span
style="font-family:monospace">RunModel</span> uses <span
style="font-family:monospace">Hist</span> to compute and return the list
of frequencies. </span><span id="hevea_default935"></span><span
style="font-size:medium"> </span><span
id="hevea_default936"></span><span style="font-size:medium">
</span><span id="hevea_default937"></span>

<span style="font-size:medium">The p-value for this data is 0.13, which
means that if the die is fair we expect to see the observed total
deviation, or more, about 13% of the time. So the apparent effect is not
statistically significant. </span><span
id="hevea_default938"></span><span style="font-size:medium">
</span><span id="hevea_default939"></span><span
style="font-size:medium"> </span><span
id="hevea_default940"></span><span style="font-size:medium">
</span><span id="hevea_default941"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.7  Chi-squared tests</span>
------------------------------------------------------------

<span style="font-size:medium"> </span><span id="casino2"></span>

<span style="font-size:medium">In the previous section we used total
deviation as the test statistic. But for testing proportions it is more
common to use the chi-squared statistic: </span>

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

<span style="font-size:medium"> Where <span
style="font-style:italic">O</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> are the observed frequencies and <span
style="font-style:italic">E</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> are the expected frequencies. Here’s the
Python code: </span><span id="hevea_default942"></span><span
style="font-size:medium"> </span><span
id="hevea_default943"></span><span style="font-size:medium">
</span><span id="hevea_default944"></span>

    class DiceChiTest(DiceTest):

        def TestStatistic(self, data):
            observed = data
            n = sum(observed)
            expected = np.ones(6) * n / 6
            test_stat = sum((observed - expected)**2 / expected)
            return test_stat

<span style="font-size:medium">Squaring the deviations (rather than
taking absolute values) gives more weight to large deviations. Dividing
through by <span style="font-family:monospace">expected</span>
standardizes the deviations, although in this case it has no effect
because the expected frequencies are all equal. </span><span
id="hevea_default945"></span>

<span style="font-size:medium">The p-value using the chi-squared
statistic is 0.04, substantially smaller than what we got using total
deviation, 0.13. If we take the 5% threshold seriously, we would
consider this effect statistically significant. But considering the two
tests togther, I would say that the results are borderline. I would not
rule out the possibility that the die is crooked, but I would not
convict the accused cheater. </span><span
id="hevea_default946"></span><span style="font-size:medium">
</span><span id="hevea_default947"></span><span
style="font-size:medium"> </span><span id="hevea_default948"></span>

<span style="font-size:medium">This example demonstrates an important
point: the p-value depends on the choice of test statistic and the model
of the null hypothesis, and sometimes these choices determine whether an
effect is statistically significant or not. </span><span
id="hevea_default949"></span><span style="font-size:medium">
</span><span id="hevea_default950"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.8  First babies again</span>
-------------------------------------------------------------

<span style="font-size:medium">Earlier in this chapter we looked at
pregnancy lengths for first babies and others, and concluded that the
apparent differences in mean and standard deviation are not
statistically significant. But in Section </span>[<span
style="font-size:medium">3.3</span>](thinkstats2004.html#visualization)<span
style="font-size:medium">, we saw several apparent differences in the
distribution of pregnancy length, especially in the range from 35 to 43
weeks. To see whether those differences are statistically significant,
we can use a test based on a chi-squared statistic. </span><span
id="hevea_default951"></span><span style="font-size:medium">
</span><span id="hevea_default952"></span><span
style="font-size:medium"> </span><span
id="hevea_default953"></span><span style="font-size:medium">
</span><span id="hevea_default954"></span>

<span style="font-size:medium">The code combines elements from previous
examples: </span><span id="hevea_default955"></span>

    class PregLengthTest(thinkstats2.HypothesisTest):

        def MakeModel(self):
            firsts, others = self.data
            self.n = len(firsts)
            self.pool = np.hstack((firsts, others))

            pmf = thinkstats2.Pmf(self.pool)
            self.values = range(35, 44)
            self.expected_probs = np.array(pmf.Probs(self.values))

        def RunModel(self):
            np.random.shuffle(self.pool)
            data = self.pool[:self.n], self.pool[self.n:]
            return data

<span style="font-size:medium">The data are represented as two lists of
pregnancy lengths. The null hypothesis is that both samples are drawn
from the same distribution. <span
style="font-family:monospace">MakeModel</span> models that distribution
by pooling the two samples using <span
style="font-family:monospace">hstack</span>. Then <span
style="font-family:monospace">RunModel</span> generates simulated data
by shuffling the pooled sample and splitting it into two parts.
</span><span id="hevea_default956"></span><span
style="font-size:medium"> </span><span
id="hevea_default957"></span><span style="font-size:medium">
</span><span id="hevea_default958"></span><span
style="font-size:medium"> </span><span id="hevea_default959"></span>

<span style="font-size:medium"><span
style="font-family:monospace">MakeModel</span> also defines <span
style="font-family:monospace">values</span>, which is the range of weeks
we’ll use, and `expected_probs`, which is the probability of each value
in the pooled distribution.</span>

<span style="font-size:medium">Here’s the code that computes the test
statistic:</span>

    # class PregLengthTest:

        def TestStatistic(self, data):
            firsts, others = data
            stat = self.ChiSquared(firsts) + self.ChiSquared(others)
            return stat

        def ChiSquared(self, lengths):
            hist = thinkstats2.Hist(lengths)
            observed = np.array(hist.Freqs(self.values))
            expected = self.expected_probs * len(lengths)
            stat = sum((observed - expected)**2 / expected)
            return stat

<span style="font-size:medium"><span
style="font-family:monospace">TestStatistic</span> computes the
chi-squared statistic for first babies and others, and adds them.
</span><span id="hevea_default960"></span>

<span style="font-size:medium"><span
style="font-family:monospace">ChiSquared</span> takes a sequence of
pregnancy lengths, computes its histogram, and computes <span
style="font-family:monospace">observed</span>, which is a list of
frequencies corresponding to <span
style="font-family:monospace">self.values</span>. To compute the list of
expected frequencies, it multiplies the pre-computed probabilities,
`expected_probs`, by the sample size. It returns the chi-squared
statistic, <span style="font-family:monospace">stat</span>.</span>

<span style="font-size:medium">For the NSFG data the total chi-squared
statistic is 102, which doesn’t mean much by itself. But after 1000
iterations, the largest test statistic generated under the null
hypothesis is 32. We conclude that the observed chi-squared statistic is
unlikely under the null hypothesis, so the apparent effect is
statistically significant. </span><span
id="hevea_default961"></span><span style="font-size:medium">
</span><span id="hevea_default962"></span><span
style="font-size:medium"> </span><span id="hevea_default963"></span>

<span style="font-size:medium">This example demonstrates a limitation of
chi-squared tests: they indicate that there is a difference between the
two groups, but they don’t say anything specific about what the
difference is.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.9  Errors</span>
-------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default964"></span>

<span style="font-size:medium">In classical hypothesis testing, an
effect is considered statistically significant if the p-value is below
some threshold, commonly 5%. This procedure raises two questions:
</span><span id="hevea_default965"></span><span
style="font-size:medium"> </span><span
id="hevea_default966"></span><span style="font-size:medium">
</span><span id="hevea_default967"></span><span
style="font-size:medium"> </span><span id="hevea_default968"></span>

-   <span style="font-size:medium">If the effect is actually due to
    chance, what is the probability that we will wrongly consider it
    significant? This probability is the <span
    style="font-weight:bold">false positive rate</span>. </span><span
    id="hevea_default969"></span>
-   <span style="font-size:medium">If the effect is real, what is the
    chance that the hypothesis test will fail? This probability is the
    <span style="font-weight:bold">false negative rate</span>.
    </span><span id="hevea_default970"></span>

<span style="font-size:medium">The false positive rate is relatively
easy to compute: if the threshold is 5%, the false positive rate is 5%.
Here’s why:</span>

-   <span style="font-size:medium">If there is no real effect, the null
    hypothesis is true, so we can compute the distribution of the test
    statistic by simulating the null hypothesis. Call this distribution
    <span style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium">. </span><span
    id="hevea_default971"></span><span style="font-size:medium">
    </span><span id="hevea_default972"></span>
-   <span style="font-size:medium">Each time we run an experiment, we
    get a test statistic, <span style="font-style:italic">t</span>,
    which is drawn from <span
    style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium">. Then we compute a p-value, which is the
    probability that a random value from <span
    style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium"> exceeds <span
    style="font-family:monospace">t</span>, so that’s 1 − <span
    style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium">(<span
    style="font-style:italic">t</span>).</span>
-   <span style="font-size:medium">The p-value is less than 5% if <span
    style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium">(<span style="font-style:italic">t</span>)
    is greater than 95%; that is, if <span
    style="font-style:italic">t</span> exceeds the 95th percentile. And
    how often does a value chosen from <span
    style="font-style:italic">CDF</span></span><sub><span
    style="font-style:italic;font-size:medium">T</span></sub><span
    style="font-size:medium"> exceed the 95th percentile? 5% of the
    time.</span>

<span style="font-size:medium">So if you perform one hypothesis test
with a 5% threshold, you expect a false positive 1 time in 20.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.10  Power</span>
-------------------------------------------------

<span style="font-size:medium"> </span><span id="power"></span>

<span style="font-size:medium">The false negative rate is harder to
compute because it depends on the actual effect size, and normally we
don’t know that. One option is to compute a rate conditioned on a
hypothetical effect size. </span><span id="hevea_default973"></span>

<span style="font-size:medium">For example, if we assume that the
observed difference between groups is accurate, we can use the observed
samples as a model of the population and run hypothesis tests with
simulated data: </span><span id="hevea_default974"></span>

    def FalseNegRate(data, num_runs=100):
        group1, group2 = data
        count = 0

        for i in range(num_runs):
            sample1 = thinkstats2.Resample(group1)
            sample2 = thinkstats2.Resample(group2)

            ht = DiffMeansPermute((sample1, sample2))
            pvalue = ht.PValue(iters=101)
            if pvalue > 0.05:
                count += 1

        return count / num_runs

<span style="font-size:medium"><span
style="font-family:monospace">FalseNegRate</span> takes data in the form
of two sequences, one for each group. Each time through the loop, it
simulates an experiment by drawing a random sample from each group and
running a hypothesis test. Then it checks the result and counts the
number of false negatives. </span><span
id="hevea_default975"></span><span style="font-size:medium">
</span><span id="hevea_default976"></span>

<span style="font-size:medium"><span
style="font-family:monospace">Resample</span> takes a sequence and draws
a sample with the same length, with replacement: </span><span
id="hevea_default977"></span>

    def Resample(xs):
        return np.random.choice(xs, len(xs), replace=True)

<span style="font-size:medium">Here’s the code that tests pregnancy
lengths:</span>

        live, firsts, others = first.MakeFrames()
        data = firsts.prglngth.values, others.prglngth.values
        neg_rate = FalseNegRate(data)

<span style="font-size:medium">The result is about 70%, which means that
if the actual difference in mean pregnancy length is 0.078 weeks, we
expect an experiment with this sample size to yield a negative test 70%
of the time. </span><span id="hevea_default978"></span>

<span style="font-size:medium">This result is often presented the other
way around: if the actual difference is 0.078 weeks, we should expect a
positive test only 30% of the time. This “correct positive rate” is
called the <span style="font-weight:bold">power</span> of the test, or
sometimes “sensitivity”. It reflects the ability of the test to detect
an effect of a given size. </span><span
id="hevea_default979"></span><span style="font-size:medium">
</span><span id="hevea_default980"></span><span
style="font-size:medium"> </span><span id="hevea_default981"></span>

<span style="font-size:medium">In this example, the test had only a 30%
chance of yielding a positive result (again, assuming that the
difference is 0.078 weeks). As a rule of thumb, a power of 80% is
considered acceptable, so we would say that this test was
“underpowered.” </span><span id="hevea_default982"></span>

<span style="font-size:medium">In general a negative hypothesis test
does not imply that there is no difference between the groups; instead
it suggests that if there is a difference, it is too small to detect
with this sample size.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.11  Replication</span>
-------------------------------------------------------

<span style="font-size:medium"> </span><span id="replication"></span>

<span style="font-size:medium">The hypothesis testing process I
demonstrated in this chapter is not, strictly speaking, good
practice.</span>

<span style="font-size:medium">First, I performed multiple tests. If you
run one hypothesis test, the chance of a false positive is about 1 in
20, which might be acceptable. But if you run 20 tests, you should
expect at least one false positive, most of the time. </span><span
id="hevea_default983"></span>

<span style="font-size:medium">Second, I used the same dataset for
exploration and testing. If you explore a large dataset, find a
surprising effect, and then test whether it is significant, you have a
good chance of generating a false positive. </span><span
id="hevea_default984"></span><span style="font-size:medium">
</span><span id="hevea_default985"></span>

<span style="font-size:medium">To compensate for multiple tests, you can
adjust the p-value threshold (see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Holm-Bonferroni\_method</span>](https://en.wikipedia.org/wiki/Holm-Bonferroni_method)<span
style="font-size:medium">). Or you can address both problems by
partitioning the data, using one set for exploration and the other for
testing. </span><span id="hevea_default986"></span><span
style="font-size:medium"> </span><span id="hevea_default987"></span>

<span style="font-size:medium">In some fields these practices are
required or at least encouraged. But it is also common to address these
problems implicitly by replicating published results. Typically the
first paper to report a new result is considered exploratory. Subsequent
papers that replicate the result with new data are considered
confirmatory. </span><span id="hevea_default988"></span>

<span style="font-size:medium">As it happens, we have an opportunity to
replicate the results in this chapter. The first edition of this book is
based on Cycle 6 of the NSFG, which was released in 2002. In October
2011, the CDC released additional data based on interviews conducted
from 2006–2010. <span style="font-family:monospace">nsfg2.py</span>
contains code to read and clean this data. In the new dataset:
</span><span id="hevea_default989"></span>

-   <span style="font-size:medium">The difference in mean pregnancy
    length is 0.16 weeks and statistically significant with <span
    style="font-style:italic">p</span> &lt; 0.001 (compared to 0.078
    weeks in the original dataset). </span><span
    id="hevea_default990"></span><span style="font-size:medium">
    </span><span id="hevea_default991"></span><span
    style="font-size:medium"> </span><span id="hevea_default992"></span>
-   <span style="font-size:medium">The difference in birth weight is
    0.17 pounds with <span style="font-style:italic">p</span> &lt; 0.001
    (compared to 0.12 lbs in the original dataset). </span><span
    id="hevea_default993"></span><span style="font-size:medium">
    </span><span id="hevea_default994"></span>
-   <span style="font-size:medium">The correlation between birth weight
    and mother’s age is 0.08 with <span
    style="font-style:italic">p</span> &lt; 0.001 (compared to
    0.07).</span>
-   <span style="font-size:medium">The chi-squared test is statistically
    significant with <span style="font-style:italic">p</span> &lt; 0.001
    (as it was in the original).</span>

<span style="font-size:medium">In summary, all of the effects that were
statistically significant in the original dataset were replicated in the
new dataset, and the difference in pregnancy length, which was not
significant in the original, is bigger in the new dataset and
significant.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.12  Exercises</span>
-----------------------------------------------------

<span style="font-size:medium">A solution to these exercises is in
`chap09soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *As sample size increases,
the power of a hypothesis test increases, which means it is more likely
to be positive if the effect is real. Conversely, as sample size
decreases, the test is less likely to be positive even if the effect is
real.* </span><span id="hevea_default995"></span>

<span style="font-size:medium">*To investigate this behavior, run the
tests in this chapter with different subsets of the NSFG data. You can
use <span style="font-family:monospace">thinkstats2.SampleRows</span> to
select a random subset of the rows in a DataFrame.* </span><span
id="hevea_default996"></span><span style="font-size:medium">
</span><span id="hevea_default997"></span><span
style="font-size:medium"> </span><span id="hevea_default998"></span>

<span style="font-size:medium">*What happens to the p-values of these
tests as sample size decreases? What is the smallest sample size that
yields a positive test?* </span><span id="hevea_default999"></span><span
style="font-size:medium"> </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>  </span>

<span style="font-size:medium">*In Section *</span>[<span
style="font-size:medium">*9.3*</span>](#testdiff)<span
style="font-size:medium">*, we simulated the null hypothesis by
permutation; that is, we treated the observed values as if they
represented the entire population, and randomly assigned the members of
the population to the two groups.* </span><span
id="hevea_default1000"></span><span style="font-size:medium">
</span><span id="hevea_default1001"></span>

<span style="font-size:medium">*An alternative is to use the sample to
estimate the distribution for the population, then draw a random sample
from that distribution. This process is called <span
style="font-weight:bold">resampling</span>. There are several ways to
implement resampling, but one of the simplest is to draw a sample with
replacement from the observed values, as in Section *</span>[<span
style="font-size:medium">*9.10*</span>](#power)<span
style="font-size:medium">*.* </span><span
id="hevea_default1002"></span><span style="font-size:medium">
</span><span id="hevea_default1003"></span>

<span style="font-size:medium">*Write a class named <span
style="font-family:monospace">DiffMeansResample</span> that inherits
from <span style="font-family:monospace">DiffMeansPermute</span> and
overrides <span style="font-family:monospace">RunModel</span> to
implement resampling, rather than permutation.* </span><span
id="hevea_default1004"></span>

<span style="font-size:medium">*Use this model to test the differences
in pregnancy length and birth weight. How much does the model affect the
results?* </span><span id="hevea_default1005"></span><span
style="font-size:medium"> </span><span
id="hevea_default1006"></span><span style="font-size:medium">
</span><span id="hevea_default1007"></span><span
style="font-size:medium"> </span><span id="hevea_default1008"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">9.13  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">hypothesis testing: The process of
    determining whether an apparent effect is statistically significant.
    </span><span id="hevea_default1009"></span>
-   <span style="font-size:medium">test statistic: A statistic used to
    quantify an effect size. </span><span
    id="hevea_default1010"></span><span style="font-size:medium">
    </span><span id="hevea_default1011"></span>
-   <span style="font-size:medium">null hypothesis: A model of a system
    based on the assumption that an apparent effect is due to chance.
    </span><span id="hevea_default1012"></span>
-   <span style="font-size:medium">p-value: The probability that an
    effect could occur by chance. </span><span
    id="hevea_default1013"></span>
-   <span style="font-size:medium">statistically significant: An effect
    is statistically significant if it is unlikely to occur by chance.
    </span><span id="hevea_default1014"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1015"></span>
-   <span style="font-size:medium">permutation test: A way to compute
    p-values by generating permutations of an observed dataset.
    </span><span id="hevea_default1016"></span>
-   <span style="font-size:medium">resampling test: A way to compute
    p-values by generating samples, with replacement, from an observed
    dataset. </span><span id="hevea_default1017"></span>
-   <span style="font-size:medium">two-sided test: A test that asks,
    “What is the chance of an effect as big as the observed effect,
    positive or negative?”</span>
-   <span style="font-size:medium">one-sided test: A test that asks,
    “What is the chance of an effect as big as the observed effect, and
    with the same sign?” </span><span
    id="hevea_default1018"></span><span style="font-size:medium">
    </span><span id="hevea_default1019"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1020"></span><span style="font-size:medium">
    </span><span id="hevea_default1021"></span>
-   <span style="font-size:medium">chi-squared test: A test that uses
    the chi-squared statistic as the test statistic. </span><span
    id="hevea_default1022"></span>
-   <span style="font-size:medium">false positive: The conclusion that
    an effect is real when it is not. </span><span
    id="hevea_default1023"></span>
-   <span style="font-size:medium">false negative: The conclusion that
    an effect is due to chance when it is not. </span><span
    id="hevea_default1024"></span>
-   <span style="font-size:medium">power: The probability of a positive
    test if the null hypothesis is false. </span><span
    id="hevea_default1025"></span><span style="font-size:medium">
    </span><span id="hevea_default1026"></span>

<span style="font-size:medium"> </span>

------------------------------------------------------------------------

 <span style="font-size:medium"> </span><a href="#text4" id="note4"><span style="font-size:medium">1</span></a>   
<span style="font-size:medium"></span>

For more about Bayesian inference, see the sequel to this book, <span
style="font-style:italic">Think Bayes</span>.

<a href="#text5" id="note5"><span style="font-size:medium">2</span></a>  
<span style="font-size:medium"></span>

Adapted from MacKay, <span style="font-style:italic">Information Theory,
Inference, and Learning Algorithms</span>, 2003.
