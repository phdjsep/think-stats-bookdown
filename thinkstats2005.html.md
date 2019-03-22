This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 4  Cumulative distribution functions</span>
==================================================================================

<span style="font-size:medium"> </span><span id="cumulative"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">cumulative.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.1  The limits of PMFs</span>
-------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default244"></span>

<span style="font-size:medium">PMFs work well if the number of values is
small. But as the number of values increases, the probability associated
with each value gets smaller and the effect of random noise
increases.</span>

<span style="font-size:medium">For example, we might be interested in
the distribution of birth weights. In the NSFG data, the variable
`totalwgt_lb` records weight at birth in pounds. Figure </span>[<span
style="font-size:medium">4.1</span>](#nsfg_birthwgt_pmf)<span
style="font-size:medium"> shows the PMF of these values for first babies
and others. </span><span id="hevea_default245"></span><span
style="font-size:medium"> </span><span
id="hevea_default246"></span><span style="font-size:medium">
</span><span id="hevea_default247"></span><span
style="font-size:medium"> </span><span id="hevea_default248"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2009.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 4.1: PMF of birth weights. This figure shows a limitation of PMFs: they are hard to compare visually.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="nsfg_birthwgt_pmf"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Overall, these distributions resemble the
bell shape of a normal distribution, with many values near the mean and
a few values much higher and lower.</span>

<span style="font-size:medium">But parts of this figure are hard to
interpret. There are many spikes and valleys, and some apparent
differences between the distributions. It is hard to tell which of these
features are meaningful. Also, it is hard to see overall patterns; for
example, which distribution do you think has the higher mean?
</span><span id="hevea_default249"></span>

<span style="font-size:medium">These problems can be mitigated by
binning the data; that is, dividing the range of values into
non-overlapping intervals and counting the number of values in each bin.
Binning can be useful, but it is tricky to get the size of the bins
right. If they are big enough to smooth out noise, they might also
smooth out useful information.</span>

<span style="font-size:medium">An alternative that avoids these problems
is the cumulative distribution function (CDF), which is the subject of
this chapter. But before I can explain CDFs, I have to explain
percentiles. </span><span id="hevea_default250"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.2  Percentiles</span>
------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default251"></span>

<span style="font-size:medium">If you have taken a standardized test,
you probably got your results in the form of a raw score and a <span
style="font-weight:bold">percentile rank</span>. In this context, the
percentile rank is the fraction of people who scored lower than you (or
the same). So if you are “in the 90th percentile,” you did as well as or
better than 90% of the people who took the exam.</span>

<span style="font-size:medium">Here’s how you could compute the
percentile rank of a value, `your_score`, relative to the values in the
sequence <span style="font-family:monospace">scores</span>: </span>

    def PercentileRank(scores, your_score):
        count = 0
        for score in scores:
            if score <= your_score:
                count += 1

        percentile_rank = 100.0 * count / len(scores)
        return percentile_rank

<span style="font-size:medium">As an example, if the scores in the
sequence were 55, 66, 77, 88 and 99, and you got the 88, then your
percentile rank would be <span style="font-family:monospace">100 \* 4 /
5</span> which is 80.</span>

<span style="font-size:medium">If you are given a value, it is easy to
find its percentile rank; going the other way is slightly harder. If you
are given a percentile rank and you want to find the corresponding
value, one option is to sort the values and search for the one you want:
</span>

    def Percentile(scores, percentile_rank):
        scores.sort()
        for score in scores:
            if PercentileRank(scores, score) >= percentile_rank:
                return score

<span style="font-size:medium">The result of this calculation is a <span
style="font-weight:bold">percentile</span>. For example, the 50th
percentile is the value with percentile rank 50. In the distribution of
exam scores, the 50th percentile is 77. </span><span
id="hevea_default252"></span>

<span style="font-size:medium">This implementation of <span
style="font-family:monospace">Percentile</span> is not efficient. A
better approach is to use the percentile rank to compute the index of
the corresponding percentile:</span>

    def Percentile2(scores, percentile_rank):
        scores.sort()
        index = percentile_rank * (len(scores)-1) // 100
        return scores[index]

<span style="font-size:medium">The difference between “percentile” and
“percentile rank” can be confusing, and people do not always use the
terms precisely. To summarize, <span
style="font-family:monospace">PercentileRank</span> takes a value and
computes its percentile rank in a set of values; <span
style="font-family:monospace">Percentile</span> takes a percentile rank
and computes the corresponding value. </span><span
id="hevea_default253"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.3  CDFs</span>
-----------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default254"></span>

<span style="font-size:medium">Now that we understand percentiles and
percentile ranks, we are ready to tackle the <span
style="font-weight:bold">cumulative distribution function</span> (CDF).
The CDF is the function that maps from a value to its percentile rank.
</span><span id="hevea_default255"></span><span
style="font-size:medium"> </span><span id="hevea_default256"></span>

<span style="font-size:medium">The CDF is a function of <span
style="font-style:italic">x</span>, where <span
style="font-style:italic">x</span> is any value that might appear in the
distribution. To evaluate <span
style="font-style:italic">CDF</span>(<span
style="font-style:italic">x</span>) for a particular value of <span
style="font-style:italic">x</span>, we compute the fraction of values in
the distribution less than or equal to <span
style="font-style:italic">x</span>.</span>

<span style="font-size:medium">Here’s what that looks like as a function
that takes a sequence, <span
style="font-family:monospace">sample</span>, and a value, <span
style="font-family:monospace">x</span>: </span>

    def EvalCdf(sample, x):
        count = 0.0
        for value in sample:
            if value <= x:
                count += 1

        prob = count / len(sample)
        return prob

<span style="font-size:medium">This function is almost identical to
<span style="font-family:monospace">PercentileRank</span>, except that
the result is a probability in the range 0–1 rather than a percentile
rank in the range 0–100. </span><span id="hevea_default257"></span>

<span style="font-size:medium">As an example, suppose we collect a
sample with the values <span style="font-family:monospace">\[1, 2, 2, 3,
5\]</span>. Here are some values from its CDF: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(0) = 0 </span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(1) = 0.2</span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(2) = 0.6</span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(3) = 0.8</span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(4) = 0.8</span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">CDF</span>(5) = 1</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> We can evaluate the CDF for any value of
<span style="font-style:italic">x</span>, not just values that appear in
the sample. If <span style="font-style:italic">x</span> is less than the
smallest value in the sample, <span
style="font-style:italic">CDF</span>(<span
style="font-style:italic">x</span>) is 0. If <span
style="font-style:italic">x</span> is greater than the largest value,
<span style="font-style:italic">CDF</span>(<span
style="font-style:italic">x</span>) is 1.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2010.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 4.2: Example of a CDF.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="example_cdf"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">4.2</span>](#example_cdf)<span
style="font-size:medium"> is a graphical representation of this CDF. The
CDF of a sample is a step function. </span><span
id="hevea_default258"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.4  Representing CDFs</span>
------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default259"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> provides a class named
Cdf that represents CDFs. The fundamental methods Cdf provides
are:</span>

-   <span style="font-size:medium"><span
    style="font-family:monospace">Prob(x)</span>: Given a value <span
    style="font-family:monospace">x</span>, computes the probability
    <span style="font-style:italic">p</span> = <span
    style="font-style:italic">CDF</span>(<span
    style="font-style:italic">x</span>). The bracket operator is
    equivalent to <span style="font-family:monospace">Prob</span>.
    </span><span id="hevea_default260"></span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">Value(p)</span>: Given a probability
    <span style="font-family:monospace">p</span>, computes the
    corresponding value, <span style="font-family:monospace">x</span>;
    that is, the <span style="font-weight:bold">inverse CDF</span> of
    <span style="font-family:monospace">p</span>. </span><span
    id="hevea_default261"></span><span style="font-size:medium">
    </span><span id="hevea_default262"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2011.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 4.3: CDF of pregnancy length.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="cumulative_prglngth_cdf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">The Cdf constructor can take as an
argument a list of values, a pandas Series, a Hist, Pmf, or another Cdf.
The following code makes a Cdf for the distribution of pregnancy lengths
in the NSFG: </span><span id="hevea_default263"></span><span
style="font-size:medium"> </span><span id="hevea_default264"></span>

        live, firsts, others = first.MakeFrames()
        cdf = thinkstats2.Cdf(live.prglngth, label='prglngth')

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot</span> provides a function named
<span style="font-family:monospace">Cdf</span> that plots Cdfs as lines:
</span><span id="hevea_default265"></span>

        thinkplot.Cdf(cdf)
        thinkplot.Show(xlabel='weeks', ylabel='CDF')

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">4.3</span>](#cumulative_prglngth_cdf)<span
style="font-size:medium"> shows the result. One way to read a CDF is to
look up percentiles. For example, it looks like about 10% of pregnancies
are shorter than 36 weeks, and about 90% are shorter than 41 weeks. The
CDF also provides a visual representation of the shape of the
distribution. Common values appear as steep or vertical sections of the
CDF; in this example, the mode at 39 weeks is apparent. There are few
values below 30 weeks, so the CDF in this range is flat. </span><span
id="hevea_default266"></span>

<span style="font-size:medium">It takes some time to get used to CDFs,
but once you do, I think you will find that they show more information,
more clearly, than PMFs.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.5  Comparing CDFs</span>
---------------------------------------------------------

<span style="font-size:medium"> </span><span
id="birth_weights"></span><span style="font-size:medium"> </span><span
id="hevea_default267"></span><span style="font-size:medium">
</span><span id="hevea_default268"></span><span
style="font-size:medium"> </span><span
id="hevea_default269"></span><span style="font-size:medium">
</span><span id="hevea_default270"></span>

<span style="font-size:medium">CDFs are especially useful for comparing
distributions. For example, here is the code that plots the CDF of birth
weight for first babies and others. </span><span
id="hevea_default271"></span><span style="font-size:medium">
</span><span id="hevea_default272"></span>

        first_cdf = thinkstats2.Cdf(firsts.totalwgt_lb, label='first')
        other_cdf = thinkstats2.Cdf(others.totalwgt_lb, label='other')

        thinkplot.PrePlot(2)
        thinkplot.Cdfs([first_cdf, other_cdf])
        thinkplot.Show(xlabel='weight (pounds)', ylabel='CDF')

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2012.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 4.4: CDF of birth weights for first babies and others.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="cumulative_birthwgt_cdf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">4.4</span>](#cumulative_birthwgt_cdf)<span
style="font-size:medium"> shows the result. Compared to
Figure </span>[<span
style="font-size:medium">4.1</span>](#nsfg_birthwgt_pmf)<span
style="font-size:medium">, this figure makes the shape of the
distributions, and the differences between them, much clearer. We can
see that first babies are slightly lighter throughout the distribution,
with a larger discrepancy above the mean. </span><span
id="hevea_default273"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.6  Percentile-based statistics</span>
----------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default274"></span><span style="font-size:medium">
</span><span id="hevea_default275"></span><span
style="font-size:medium"> </span><span
id="hevea_default276"></span><span style="font-size:medium">
</span><span id="hevea_default277"></span><span
style="font-size:medium"> </span><span
id="hevea_default278"></span><span style="font-size:medium">
</span><span id="hevea_default279"></span><span
style="font-size:medium"> </span><span id="hevea_default280"></span>

<span style="font-size:medium">Once you have computed a CDF, it is easy
to compute percentiles and percentile ranks. The Cdf class provides
these two methods: </span><span id="hevea_default281"></span><span
style="font-size:medium"> </span><span id="hevea_default282"></span>

-   <span style="font-size:medium"><span
    style="font-family:monospace">PercentileRank(x)</span>: Given a
    value <span style="font-family:monospace">x</span>, computes its
    percentile rank, 100 · <span
    style="font-style:italic">CDF</span>(<span
    style="font-style:italic">x</span>).</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">Percentile(p)</span>: Given a
    percentile rank <span style="font-family:monospace">p</span>,
    computes the corresponding value, <span
    style="font-family:monospace">x</span>. Equivalent to <span
    style="font-family:monospace">Value(p/100)</span>.</span>

<span style="font-size:medium"><span
style="font-family:monospace">Percentile</span> can be used to compute
percentile-based summary statistics. For example, the 50th percentile is
the value that divides the distribution in half, also known as the <span
style="font-weight:bold">median</span>. Like the mean, the median is a
measure of the central tendency of a distribution.</span>

<span style="font-size:medium">Actually, there are several definitions
of “median,” each with different properties. But <span
style="font-family:monospace">Percentile(50)</span> is simple and
efficient to compute.</span>

<span style="font-size:medium">Another percentile-based statistic is the
<span style="font-weight:bold">interquartile range</span> (IQR), which
is a measure of the spread of a distribution. The IQR is the difference
between the 75th and 25th percentiles.</span>

<span style="font-size:medium">More generally, percentiles are often
used to summarize the shape of a distribution. For example, the
distribution of income is often reported in “quintiles”; that is, it is
split at the 20th, 40th, 60th and 80th percentiles. Other distributions
are divided into ten “deciles”. Statistics like these that represent
equally-spaced points in a CDF are called <span
style="font-weight:bold">quantiles</span>. For more, see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Quantile</span>](https://en.wikipedia.org/wiki/Quantile)<span
style="font-size:medium">. </span><span
id="hevea_default283"></span><span style="font-size:medium">
</span><span id="hevea_default284"></span><span
style="font-size:medium"> </span><span id="hevea_default285"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.7  Random numbers</span>
---------------------------------------------------------

<span style="font-size:medium"> </span><span id="random"></span><span
style="font-size:medium"> </span><span id="hevea_default286"></span>

<span style="font-size:medium">Suppose we choose a random sample from
the population of live births and look up the percentile rank of their
birth weights. Now suppose we compute the CDF of the percentile ranks.
What do you think the distribution will look like? </span><span
id="hevea_default287"></span><span style="font-size:medium">
</span><span id="hevea_default288"></span><span
style="font-size:medium"> </span><span id="hevea_default289"></span>

<span style="font-size:medium">Here’s how we can compute it. First, we
make the Cdf of birth weights: </span><span
id="hevea_default290"></span>

        weights = live.totalwgt_lb
        cdf = thinkstats2.Cdf(weights, label='totalwgt_lb')

<span style="font-size:medium">Then we generate a sample and compute the
percentile rank of each value in the sample.</span>

        sample = np.random.choice(weights, 100, replace=True)
        ranks = [cdf.PercentileRank(x) for x in sample]

<span style="font-size:medium"><span
style="font-family:monospace">sample</span> is a random sample of 100
birth weights, chosen with <span
style="font-weight:bold">replacement</span>; that is, the same value
could be chosen more than once. <span
style="font-family:monospace">ranks</span> is a list of percentile
ranks. </span><span id="hevea_default291"></span>

<span style="font-size:medium">Finally we make and plot the Cdf of the
percentile ranks. </span><span id="hevea_default292"></span>

        rank_cdf = thinkstats2.Cdf(ranks)
        thinkplot.Cdf(rank_cdf)
        thinkplot.Show(xlabel='percentile rank', ylabel='CDF')

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2013.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 4.5: CDF of percentile ranks for a random sample of birth weights.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="cumulative_random"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">4.5</span>](#cumulative_random)<span
style="font-size:medium"> shows the result. The CDF is approximately a
straight line, which means that the distribution is uniform.</span>

<span style="font-size:medium">That outcome might be non-obvious, but it
is a consequence of the way the CDF is defined. What this figure shows
is that 10% of the sample is below the 10th percentile, 20% is below the
20th percentile, and so on, exactly as we should expect.</span>

<span style="font-size:medium">So, regardless of the shape of the CDF,
the distribution of percentile ranks is uniform. This property is
useful, because it is the basis of a simple and efficient algorithm for
generating random numbers with a given CDF. Here’s how: </span><span
id="hevea_default293"></span><span style="font-size:medium">
</span><span id="hevea_default294"></span>

-   <span style="font-size:medium">Choose a percentile rank uniformly
    from the range 0–100.</span>
-   <span style="font-size:medium">Use <span
    style="font-family:monospace">Cdf.Percentile</span> to find the
    value in the distribution that corresponds to the percentile rank
    you chose. </span><span id="hevea_default295"></span>

<span style="font-size:medium">Cdf provides an implementation of this
algorithm, called <span
style="font-family:monospace">Random</span>:</span>

    # class Cdf:
        def Random(self):
            return self.Percentile(random.uniform(0, 100))

<span style="font-size:medium">Cdf also provides <span
style="font-family:monospace">Sample</span>, which takes an integer,
<span style="font-family:monospace">n</span>, and returns a list of
<span style="font-family:monospace">n</span> values chosen at random
from the Cdf.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.8  Comparing percentile ranks</span>
---------------------------------------------------------------------

<span style="font-size:medium">Percentile ranks are useful for comparing
measurements across different groups. For example, people who compete in
foot races are usually grouped by age and gender. To compare people in
different age groups, you can convert race times to percentile ranks.
</span><span id="hevea_default296"></span>

<span style="font-size:medium">A few years ago I ran the James Joyce
Ramble 10K in Dedham MA; I finished in 42:44, which was 97th in a field
of 1633. I beat or tied 1537 runners out of 1633, so my percentile rank
in the field is 94%. </span><span id="hevea_default297"></span><span
style="font-size:medium"> </span><span id="hevea_default298"></span>

<span style="font-size:medium">More generally, given position and field
size, we can compute percentile rank: </span><span
id="hevea_default299"></span>

    def PositionToPercentile(position, field_size):
        beat = field_size - position + 1
        percentile = 100.0 * beat / field_size
        return percentile

<span style="font-size:medium">In my age group, denoted M4049 for “male
between 40 and 49 years of age”, I came in 26th out of 256. So my
percentile rank in my age group was 90%. </span><span
id="hevea_default300"></span>

<span style="font-size:medium">If I am still running in 10 years (and I
hope I am), I will be in the M5059 division. Assuming that my percentile
rank in my division is the same, how much slower should I expect to
be?</span>

<span style="font-size:medium">I can answer that question by converting
my percentile rank in M4049 to a position in M5059. Here’s the
code:</span>

    def PercentileToPosition(percentile, field_size):
        beat = percentile * field_size / 100.0
        position = field_size - beat + 1
        return position

<span style="font-size:medium">There were 171 people in M5059, so I
would have to come in between 17th and 18th place to have the same
percentile rank. The finishing time of the 17th runner in M5059 was
46:05, so that’s the time I will have to beat to maintain my percentile
rank.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.9  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">For the following exercises, you can
start with `chap04ex.ipynb`. My solution is in
`chap04soln.ipynb`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *How much did you weigh at
birth? If you don’t know, call your mother or someone else who knows.
Using the NSFG data (all live births), compute the distribution of birth
weights and use it to find your percentile rank. If you were a first
baby, find your percentile rank in the distribution for first babies.
Otherwise use the distribution for others. If you are in the 90th
percentile or higher, call your mother back and apologize.* </span><span
id="hevea_default301"></span><span style="font-size:medium">
</span><span id="hevea_default302"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *The numbers generated by
<span style="font-family:monospace">random.random</span> are supposed to
be uniform between 0 and 1; that is, every value in the range should
have the same probability.*</span>

<span style="font-size:medium">*Generate 1000 numbers from <span
style="font-family:monospace">random.random</span> and plot their PMF
and CDF. Is the distribution uniform?* </span><span
id="hevea_default303"></span><span style="font-size:medium">
</span><span id="hevea_default304"></span><span
style="font-size:medium"> </span><span id="hevea_default305"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">4.10  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">percentile rank: The percentage of
    values in a distribution that are less than or equal to a given
    value. </span><span id="hevea_default306"></span>
-   <span style="font-size:medium">percentile: The value associated with
    a given percentile rank. </span><span id="hevea_default307"></span>
-   <span style="font-size:medium">cumulative distribution function
    (CDF): A function that maps from values to their cumulative
    probabilities. <span style="font-style:italic">CDF</span>(<span
    style="font-style:italic">x</span>) is the fraction of the sample
    less than or equal to <span style="font-style:italic">x</span>.
    </span><span id="hevea_default308"></span><span
    style="font-size:medium"> </span><span id="hevea_default309"></span>
-   <span style="font-size:medium">inverse CDF: A function that maps
    from a cumulative probability, <span
    style="font-style:italic">p</span>, to the corresponding value.
    </span><span id="hevea_default310"></span><span
    style="font-size:medium"> </span><span id="hevea_default311"></span>
-   <span style="font-size:medium">median: The 50th percentile, often
    used as a measure of central tendency. </span><span
    id="hevea_default312"></span>
-   <span style="font-size:medium">interquartile range: The difference
    between the 75th and 25th percentiles, used as a measure of spread.
    </span><span id="hevea_default313"></span>
-   <span style="font-size:medium">quantile: A sequence of values that
    correspond to equally spaced percentile ranks; for example, the
    quartiles of a distribution are the 25th, 50th and 75th percentiles.
    </span><span id="hevea_default314"></span>
-   <span style="font-size:medium">replacement: A property of a sampling
    process. “With replacement” means that the same value can be chosen
    more than once; “without replacement” means that once a value is
    chosen, it is removed from the population. </span><span
    id="hevea_default315"></span>

<span style="font-size:medium"> </span>
