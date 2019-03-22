This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 7  Relationships between variables</span>
================================================================================

<span style="font-size:medium">So far we have only looked at one
variable at a time. In this chapter we look at relationships between
variables. Two variables are related if knowing one gives you
information about the other. For example, height and weight are related;
people who are taller tend to be heavier. Of course, it is not a perfect
relationship: there are short heavy people and tall light ones. But if
you are trying to guess someone’s weight, you will be more accurate if
you know their height than if you don’t. </span><span
id="hevea_default584"></span><span style="font-size:medium">
</span><span id="hevea_default585"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">scatter.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.1  Scatter plots</span>
--------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default586"></span><span style="font-size:medium">
</span><span id="hevea_default587"></span>

<span style="font-size:medium">The simplest way to check for a
relationship between two variables is a <span
style="font-weight:bold">scatter plot</span>, but making a good scatter
plot is not always easy. As an example, I’ll plot weight versus height
for the respondents in the BRFSS (see Section </span>[<span
style="font-size:medium">5.4</span>](thinkstats2006.html#lognormal)<span
style="font-size:medium">). </span><span id="hevea_default588"></span>

<span style="font-size:medium">Here’s the code that reads the data file
and extracts height and weight:</span>

        df = brfss.ReadBrfss(nrows=None)
        sample = thinkstats2.SampleRows(df, 5000)
        heights, weights = sample.htm3, sample.wtkg2

<span style="font-size:medium"><span
style="font-family:monospace">SampleRows</span> chooses a random subset
of the data: </span><span id="hevea_default589"></span>

    def SampleRows(df, nrows, replace=False):
        indices = np.random.choice(df.index, nrows, replace=replace)
        sample = df.loc[indices]
        return sample

<span style="font-size:medium"><span
style="font-family:monospace">df</span> is the DataFrame, <span
style="font-family:monospace">nrows</span> is the number of rows to
choose, and <span style="font-family:monospace">replace</span> is a
boolean indicating whether sampling should be done with replacement; in
other words, whether the same row could be chosen more than once.
</span><span id="hevea_default590"></span><span
style="font-size:medium"> </span><span
id="hevea_default591"></span><span style="font-size:medium">
</span><span id="hevea_default592"></span><span
style="font-size:medium"> </span><span id="hevea_default593"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot</span> provides <span
style="font-family:monospace">Scatter</span>, which makes scatter plots:
</span>

        thinkplot.Scatter(heights, weights)
        thinkplot.Show(xlabel='Height (cm)',
                       ylabel='Weight (kg)',
                       axis=[140, 210, 20, 200])

<span style="font-size:medium">The result, in Figure </span>[<span
style="font-size:medium">7.1</span>](#scatter1)<span
style="font-size:medium"> (left), shows the shape of the relationship.
As we expected, taller people tend to be heavier. </span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2029.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 7.1: Scatter plots of weight versus height for the respondents in the BRFSS, unjittered (left), jittered (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="scatter1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">But this is not the best representation
of the data, because the data are packed into columns. The problem is
that the heights are rounded to the nearest inch, converted to
centimeters, and then rounded again. Some information is lost in
translation. </span><span id="hevea_default594"></span><span
style="font-size:medium"> </span><span
id="hevea_default595"></span><span style="font-size:medium">
</span><span id="hevea_default596"></span>

<span style="font-size:medium">We can’t get that information back, but
we can minimize the effect on the scatter plot by <span
style="font-weight:bold">jittering</span> the data, which means adding
random noise to reverse the effect of rounding off. Since these
measurements were rounded to the nearest inch, they might be off by up
to 0.5 inches or 1.3 cm. Similarly, the weights might be off by 0.5 kg.
</span><span id="hevea_default597"></span><span
style="font-size:medium"> </span><span
id="hevea_default598"></span><span style="font-size:medium">
</span><span id="hevea_default599"></span>

        heights = thinkstats2.Jitter(heights, 1.3)
        weights = thinkstats2.Jitter(weights, 0.5)

<span style="font-size:medium">Here’s the implementation of <span
style="font-family:monospace">Jitter</span>:</span>

    def Jitter(values, jitter=0.5):
        n = len(values)
        return np.random.uniform(-jitter, +jitter, n) + values

<span style="font-size:medium">The values can be any sequence; the
result is a NumPy array. </span><span id="hevea_default600"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">7.1</span>](#scatter1)<span
style="font-size:medium"> (right) shows the result. Jittering reduces
the visual effect of rounding and makes the shape of the relationship
clearer. But in general you should only jitter data for purposes of
visualization and avoid using jittered data for analysis.</span>

<span style="font-size:medium">Even with jittering, this is not the best
way to represent the data. There are many overlapping points, which
hides data in the dense parts of the figure and gives disproportionate
emphasis to outliers. This effect is called <span
style="font-weight:bold">saturation</span>. </span><span
id="hevea_default601"></span><span style="font-size:medium">
</span><span id="hevea_default602"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2030.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 7.2: Scatter plot with jittering and transparency (left), hexbin plot (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="scatter2"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">We can solve this problem with the <span
style="font-family:monospace">alpha</span> parameter, which makes the
points partly transparent: </span>

        thinkplot.Scatter(heights, weights, alpha=0.2)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">7.2</span>](#scatter2)<span
style="font-size:medium"> (left) shows the result. Overlapping data
points look darker, so darkness is proportional to density. In this
version of the plot we can see two details that were not apparent
before: vertical clusters at several heights and a horizontal line near
90 kg or 200 pounds. Since this data is based on self-reports in pounds,
the most likely explanation is that some respondents reported rounded
values. </span><span id="hevea_default603"></span><span
style="font-size:medium"> </span><span
id="hevea_default604"></span><span style="font-size:medium">
</span><span id="hevea_default605"></span>

<span style="font-size:medium">Using transparency works well for
moderate-sized datasets, but this figure only shows the first 5000
records in the BRFSS, out of a total of 414 509. </span><span
id="hevea_default606"></span><span style="font-size:medium">
</span><span id="hevea_default607"></span>

<span style="font-size:medium">To handle larger datasets, another option
is a hexbin plot, which divides the graph into hexagonal bins and colors
each bin according to how many data points fall in it. <span
style="font-family:monospace">thinkplot</span> provides <span
style="font-family:monospace">HexBin</span>: </span>

        thinkplot.HexBin(heights, weights)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">7.2</span>](#scatter2)<span
style="font-size:medium"> (right) shows the result. An advantage of a
hexbin is that it shows the shape of the relationship well, and it is
efficient for large datasets, both in time and in the size of the file
it generates. A drawback is that it makes the outliers invisible.
</span><span id="hevea_default608"></span><span
style="font-size:medium"> </span><span id="hevea_default609"></span>

<span style="font-size:medium">The point of this example is that it is
not easy to make a scatter plot that shows relationships clearly without
introducing misleading artifacts. </span><span
id="hevea_default610"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.2  Characterizing relationships</span>
-----------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="characterizing"></span>

<span style="font-size:medium">Scatter plots provide a general
impression of the relationship between variables, but there are other
visualizations that provide more insight into the nature of the
relationship. One option is to bin one variable and plot percentiles of
the other. </span><span id="hevea_default611"></span>

<span style="font-size:medium">NumPy and pandas provide functions for
binning data: </span><span id="hevea_default612"></span><span
style="font-size:medium"> </span><span id="hevea_default613"></span>

        df = df.dropna(subset=['htm3', 'wtkg2'])
        bins = np.arange(135, 210, 5)
        indices = np.digitize(df.htm3, bins)
        groups = df.groupby(indices)

<span style="font-size:medium"><span
style="font-family:monospace">dropna</span> drops rows with <span
style="font-family:monospace">nan</span> in any of the listed columns.
<span style="font-family:monospace">arange</span> makes a NumPy array of
bins from 135 to, but not including, 210, in increments of 5.
</span><span id="hevea_default614"></span><span
style="font-size:medium"> </span><span
id="hevea_default615"></span><span style="font-size:medium">
</span><span id="hevea_default616"></span>

<span style="font-size:medium"><span
style="font-family:monospace">digitize</span> computes the index of the
bin that contains each value in <span
style="font-family:monospace">df.htm3</span>. The result is a NumPy
array of integer indices. Values that fall below the lowest bin are
mapped to index 0. Values above the highest bin are mapped to <span
style="font-family:monospace">len(bins)</span>.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2031.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 7.3: Percentiles of weight for a range of height bins.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="scatter3"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">groupby</span> is a DataFrame method that
returns a GroupBy object; used in a <span
style="font-family:monospace">for</span> loop, <span
style="font-family:monospace">groups</span> iterates the names of the
groups and the DataFrames that represent them. So, for example, we can
print the number of rows in each group like this: </span><span
id="hevea_default617"></span><span style="font-size:medium">
</span><span id="hevea_default618"></span>

    for i, group in groups:
        print(i, len(group))

<span style="font-size:medium">Now for each group we can compute the
mean height and the CDF of weight: </span><span
id="hevea_default619"></span>

        heights = [group.htm3.mean() for i, group in groups]
        cdfs = [thinkstats2.Cdf(group.wtkg2) for i, group in groups]

<span style="font-size:medium">Finally, we can plot percentiles of
weight versus height: </span><span id="hevea_default620"></span>

        for percent in [75, 50, 25]:
            weights = [cdf.Percentile(percent) for cdf in cdfs]
            label = '%dth' % percent
            thinkplot.Plot(heights, weights, label=label)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">7.3</span>](#scatter3)<span
style="font-size:medium"> shows the result. Between 140 and 200 cm the
relationship between these variables is roughly linear. This range
includes more than 99% of the data, so we don’t have to worry too much
about the extremes. </span><span id="hevea_default621"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.3  Correlation</span>
------------------------------------------------------

<span style="font-size:medium">A <span
style="font-weight:bold">correlation</span> is a statistic intended to
quantify the strength of the relationship between two variables.
</span><span id="hevea_default622"></span>

<span style="font-size:medium">A challenge in measuring correlation is
that the variables we want to compare are often not expressed in the
same units. And even if they are in the same units, they come from
different distributions. </span><span id="hevea_default623"></span>

<span style="font-size:medium">There are two common solutions to these
problems:</span>

1.  <span style="font-size:medium">Transform each value to a <span
    style="font-weight:bold">standard scores</span>, which is the number
    of standard deviations from the mean. This transform leads to the
    “Pearson product-moment correlation coefficient.” </span><span
    id="hevea_default624"></span><span style="font-size:medium">
    </span><span id="hevea_default625"></span><span
    style="font-size:medium"> </span><span id="hevea_default626"></span>
2.  <span style="font-size:medium">Transform each value to its <span
    style="font-weight:bold">rank</span>, which is its index in the
    sorted list of values. This transform leads to the “Spearman rank
    correlation coefficient.” </span><span
    id="hevea_default627"></span><span style="font-size:medium">
    </span><span id="hevea_default628"></span><span
    style="font-size:medium"> </span><span id="hevea_default629"></span>

<span style="font-size:medium">If <span
style="font-style:italic">X</span> is a series of <span
style="font-style:italic">n</span> values, <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, we can convert to standard scores by
subtracting the mean and dividing by the standard deviation: <span
style="font-style:italic">z</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> = (<span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> − µ) / σ. </span><span
id="hevea_default630"></span><span style="font-size:medium">
</span><span id="hevea_default631"></span>

<span style="font-size:medium">The numerator is a deviation: the
distance from the mean. Dividing by σ <span
style="font-weight:bold">standardizes</span> the deviation, so the
values of <span style="font-style:italic">Z</span> are dimensionless (no
units) and their distribution has mean 0 and variance 1. </span><span
id="hevea_default632"></span><span style="font-size:medium">
</span><span id="hevea_default633"></span><span
style="font-size:medium"> </span><span
id="hevea_default634"></span><span style="font-size:medium">
</span><span id="hevea_default635"></span><span
style="font-size:medium"> </span><span
id="hevea_default636"></span><span style="font-size:medium">
</span><span id="hevea_default637"></span>

<span style="font-size:medium">If <span
style="font-style:italic">X</span> is normally distributed, so is <span
style="font-style:italic">Z</span>. But if <span
style="font-style:italic">X</span> is skewed or has outliers, so does
<span style="font-style:italic">Z</span>; in those cases, it is more
robust to use percentile ranks. If we compute a new variable, <span
style="font-style:italic">R</span>, so that <span
style="font-style:italic">r</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> is the rank of <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, the distribution of <span
style="font-style:italic">R</span> is uniform from 1 to <span
style="font-style:italic">n</span>, regardless of the distribution of
<span style="font-style:italic">X</span>. </span><span
id="hevea_default638"></span><span style="font-size:medium">
</span><span id="hevea_default639"></span><span
style="font-size:medium"> </span><span
id="hevea_default640"></span><span style="font-size:medium">
</span><span id="hevea_default641"></span><span
style="font-size:medium"> </span><span id="hevea_default642"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.4  Covariance</span>
-----------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default643"></span><span style="font-size:medium">
</span><span id="hevea_default644"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Covariance</span> is a measure of the tendency
of two variables to vary together. If we have two series, <span
style="font-style:italic">X</span> and <span
style="font-style:italic">Y</span>, their deviations from the mean are
</span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">dx</span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> = <span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span> </span></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">dy</span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> = <span style="font-style:italic">y</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − ȳ </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where <span
style="text-decoration:overline">x</span> is the sample mean of <span
style="font-style:italic">X</span> and ȳ is the sample mean of <span
style="font-style:italic">Y</span>. If <span
style="font-style:italic">X</span> and <span
style="font-style:italic">Y</span> vary together, their deviations tend
to have the same sign.</span>

<span style="font-size:medium">If we multiply them together, the product
is positive when the deviations have the same sign and negative when
they have the opposite sign. So adding up the products gives a measure
of the tendency to vary together.</span>

<span style="font-size:medium">Covariance is the mean of these products:
</span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">Cov</span>(<span style="font-style:italic">X</span>,<span style="font-style:italic">Y</span>) = </span></td>
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
<td><span style="font-size:medium"> <span style="font-size:xx-large">∑</span><span style="font-style:italic">dx</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> <span style="font-style:italic">dy</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where <span
style="font-style:italic">n</span> is the length of the two series (they
have to be the same length).</span>

<span style="font-size:medium">If you have studied linear algebra, you
might recognize that <span style="font-family:monospace">Cov</span> is
the dot product of the deviations, divided by their length. So the
covariance is maximized if the two vectors are identical, 0 if they are
orthogonal, and negative if they point in opposite directions. <span
style="font-family:monospace">thinkstats2</span> uses <span
style="font-family:monospace">np.dot</span> to implement <span
style="font-family:monospace">Cov</span> efficiently: </span><span
id="hevea_default645"></span><span style="font-size:medium">
</span><span id="hevea_default646"></span><span
style="font-size:medium"> </span><span id="hevea_default647"></span>

    def Cov(xs, ys, meanx=None, meany=None):
        xs = np.asarray(xs)
        ys = np.asarray(ys)

        if meanx is None:
            meanx = np.mean(xs)
        if meany is None:
            meany = np.mean(ys)

        cov = np.dot(xs-meanx, ys-meany) / len(xs)
        return cov

<span style="font-size:medium">By default <span
style="font-family:monospace">Cov</span> computes deviations from the
sample means, or you can provide known means. If <span
style="font-family:monospace">xs</span> and <span
style="font-family:monospace">ys</span> are Python sequences, <span
style="font-family:monospace">np.asarray</span> converts them to NumPy
arrays. If they are already NumPy arrays, <span
style="font-family:monospace">np.asarray</span> does nothing.
</span><span id="hevea_default648"></span>

<span style="font-size:medium">This implementation of covariance is
meant to be simple for purposes of explanation. NumPy and pandas also
provide implementations of covariance, but both of them apply a
correction for small sample sizes that we have not covered yet, and
<span style="font-family:monospace">np.cov</span> returns a covariance
matrix, which is more than we need for now. </span><span
id="hevea_default649"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.5  Pearson’s correlation</span>
----------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default650"></span><span style="font-size:medium">
</span><span id="hevea_default651"></span>

<span style="font-size:medium">Covariance is useful in some
computations, but it is seldom reported as a summary statistic because
it is hard to interpret. Among other problems, its units are the product
of the units of <span style="font-style:italic">X</span> and <span
style="font-style:italic">Y</span>. For example, the covariance of
weight and height in the BRFSS dataset is 113 kilogram-centimeters,
whatever that means. </span><span id="hevea_default652"></span><span
style="font-size:medium"> </span><span id="hevea_default653"></span>

<span style="font-size:medium">One solution to this problem is to divide
the deviations by the standard deviation, which yields standard scores,
and compute the product of standard scores: </span>

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
<td><span style="font-style:italic;font-size:medium">p</span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">(<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">S</span><sub><span style="font-style:italic;font-size:medium">X</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">(<span style="font-style:italic">y</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − ȳ)</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">S</span><sub><span style="font-style:italic;font-size:medium">Y</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Where <span
style="font-style:italic">S</span></span><sub><span
style="font-style:italic;font-size:medium">X</span></sub><span
style="font-size:medium"> and <span
style="font-style:italic">S</span></span><sub><span
style="font-style:italic;font-size:medium">Y</span></sub><span
style="font-size:medium"> are the standard deviations of <span
style="font-style:italic">X</span> and <span
style="font-style:italic">Y</span>. The mean of these products is
</span><span id="hevea_default654"></span><span
style="font-size:medium"> </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">ρ = </span></td>
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
<td><span style="font-size:medium"> <span style="font-size:xx-large">∑</span><span style="font-style:italic">p</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Or we can rewrite ρ by factoring out
<span style="font-style:italic">S</span></span><sub><span
style="font-style:italic;font-size:medium">X</span></sub><span
style="font-size:medium"> and <span
style="font-style:italic">S</span></span><sub><span
style="font-style:italic;font-size:medium">Y</span></sub><span
style="font-size:medium">: </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">ρ = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">Cov</span>(<span style="font-style:italic">X</span>,<span style="font-style:italic">Y</span>)</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">S</span><sub><span style="font-style:italic;font-size:medium">X</span></sub><span style="font-size:medium"> <span style="font-style:italic">S</span></span><sub><span style="font-style:italic;font-size:medium">Y</span></sub></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> This value is called <span
style="font-weight:bold">Pearson’s correlation</span> after Karl
Pearson, an influential early statistician. It is easy to compute and
easy to interpret. Because standard scores are dimensionless, so is ρ.
</span><span id="hevea_default655"></span><span
style="font-size:medium"> </span><span id="hevea_default656"></span>

<span style="font-size:medium">Here is the implementation in <span
style="font-family:monospace">thinkstats2</span>:</span>

    def Corr(xs, ys):
        xs = np.asarray(xs)
        ys = np.asarray(ys)

        meanx, varx = MeanVar(xs)
        meany, vary = MeanVar(ys)

        corr = Cov(xs, ys, meanx, meany) / math.sqrt(varx * vary)
        return corr

<span style="font-size:medium"><span
style="font-family:monospace">MeanVar</span> computes mean and variance
slightly more efficiently than separate calls to <span
style="font-family:monospace">np.mean</span> and <span
style="font-family:monospace">np.var</span>. </span><span
id="hevea_default657"></span>

<span style="font-size:medium">Pearson’s correlation is always between
-1 and +1 (including both). If ρ is positive, we say that the
correlation is positive, which means that when one variable is high, the
other tends to be high. If ρ is negative, the correlation is negative,
so when one variable is high, the other is low.</span>

<span style="font-size:medium">The magnitude of ρ indicates the strength
of the correlation. If ρ is 1 or -1, the variables are perfectly
correlated, which means that if you know one, you can make a perfect
prediction about the other. </span><span id="hevea_default658"></span>

<span style="font-size:medium">Most correlation in the real world is not
perfect, but it is still useful. The correlation of height and weight is
0.51, which is a strong correlation compared to similar human-related
variables.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.6  Nonlinear relationships</span>
------------------------------------------------------------------

<span style="font-size:medium">If Pearson’s correlation is near 0, it is
tempting to conclude that there is no relationship between the
variables, but that conclusion is not valid. Pearson’s correlation only
measures *linear* relationships. If there’s a nonlinear relationship, ρ
understates its strength. </span><span
id="hevea_default659"></span><span style="font-size:medium">
</span><span id="hevea_default660"></span><span
style="font-size:medium"> </span><span id="hevea_default661"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2032.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 7.4: Examples of datasets with a range of correlations.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="corr_examples"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">7.4</span>](#corr_examples)<span
style="font-size:medium"> is from </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Correlation\_and\_dependence</span>](http://wikipedia.org/wiki/Correlation_and_dependence)<span
style="font-size:medium">. It shows scatter plots and correlation
coefficients for several carefully constructed datasets. </span><span
id="hevea_default662"></span><span style="font-size:medium">
</span><span id="hevea_default663"></span>

<span style="font-size:medium">The top row shows linear relationships
with a range of correlations; you can use this row to get a sense of
what different values of ρ look like. The second row shows perfect
correlations with a range of slopes, which demonstrates that correlation
is unrelated to slope (we’ll talk about estimating slope soon). The
third row shows variables that are clearly related, but because the
relationship is nonlinear, the correlation coefficient is 0.
</span><span id="hevea_default664"></span>

<span style="font-size:medium">The moral of this story is that you
should always look at a scatter plot of your data before blindly
computing a correlation coefficient. </span><span
id="hevea_default665"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.7  Spearman’s rank correlation</span>
----------------------------------------------------------------------

<span style="font-size:medium">Pearson’s correlation works well if the
relationship between variables is linear and if the variables are
roughly normal. But it is not robust in the presence of outliers.
</span><span id="hevea_default666"></span><span
style="font-size:medium"> </span><span
id="hevea_default667"></span><span style="font-size:medium">
</span><span id="hevea_default668"></span><span
style="font-size:medium"> </span><span
id="hevea_default669"></span><span style="font-size:medium">
</span><span id="hevea_default670"></span><span
style="font-size:medium"> </span><span
id="hevea_default671"></span><span style="font-size:medium">
</span><span id="hevea_default672"></span><span
style="font-size:medium"> Spearman’s rank correlation is an alternative
that mitigates the effect of outliers and skewed distributions. To
compute Spearman’s correlation, we have to compute the <span
style="font-weight:bold">rank</span> of each value, which is its index
in the sorted sample. For example, in the sample <span
style="font-family:monospace">\[1, 2, 5, 7\]</span> the rank of the
value 5 is 3, because it appears third in the sorted list. Then we
compute Pearson’s correlation for the ranks. </span><span
id="hevea_default673"></span><span style="font-size:medium">
</span><span id="hevea_default674"></span><span
style="font-size:medium"> </span><span id="hevea_default675"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> provides a function
that computes Spearman’s rank correlation:</span>

    def SpearmanCorr(xs, ys):
        xranks = pandas.Series(xs).rank()
        yranks = pandas.Series(ys).rank()
        return Corr(xranks, yranks)

<span style="font-size:medium">I convert the arguments to pandas Series
objects so I can use <span style="font-family:monospace">rank</span>,
which computes the rank for each value and returns a Series. Then I use
<span style="font-family:monospace">Corr</span> to compute the
correlation of the ranks. </span><span
id="hevea_default676"></span><span style="font-size:medium">
</span><span id="hevea_default677"></span>

<span style="font-size:medium">I could also use <span
style="font-family:monospace">Series.corr</span> directly and specify
Spearman’s method:</span>

    def SpearmanCorr(xs, ys):
        xs = pandas.Series(xs)
        ys = pandas.Series(ys)
        return xs.corr(ys, method='spearman')

<span style="font-size:medium">The Spearman rank correlation for the
BRFSS data is 0.54, a little higher than the Pearson correlation, 0.51.
There are several possible reasons for the difference, including:
</span><span id="hevea_default678"></span><span
style="font-size:medium"> </span><span id="hevea_default679"></span>

-   <span style="font-size:medium">If the relationship is nonlinear,
    Pearson’s correlation tends to underestimate the strength of the
    relationship, and </span><span id="hevea_default680"></span>
-   <span style="font-size:medium">Pearson’s correlation can be affected
    (in either direction) if one of the distributions is skewed or
    contains outliers. Spearman’s rank correlation is more robust.
    </span><span id="hevea_default681"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default682"></span><span style="font-size:medium">
    </span><span id="hevea_default683"></span>

<span style="font-size:medium">In the BRFSS example, we know that the
distribution of weights is roughly lognormal; under a log transform it
approximates a normal distribution, so it has no skew. So another way to
eliminate the effect of skewness is to compute Pearson’s correlation
with log-weight and height: </span><span
id="hevea_default684"></span><span style="font-size:medium">
</span><span id="hevea_default685"></span>

        thinkstats2.Corr(df.htm3, np.log(df.wtkg2)))

<span style="font-size:medium">The result is 0.53, close to the rank
correlation, 0.54. So that suggests that skewness in the distribution of
weight explains most of the difference between Pearson’s and Spearman’s
correlation. </span><span id="hevea_default686"></span><span
style="font-size:medium"> </span><span
id="hevea_default687"></span><span style="font-size:medium">
</span><span id="hevea_default688"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.8  Correlation and causation</span>
--------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default689"></span><span style="font-size:medium">
</span><span id="hevea_default690"></span>

<span style="font-size:medium">If variables A and B are correlated,
there are three possible explanations: A causes B, or B causes A, or
some other set of factors causes both A and B. These explanations are
called “causal relationships”. </span><span
id="hevea_default691"></span>

<span style="font-size:medium">Correlation alone does not distinguish
between these explanations, so it does not tell you which ones are true.
This rule is often summarized with the phrase “Correlation does not
imply causation,” which is so pithy it has its own Wikipedia page:
</span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Correlation\_does\_not\_imply\_causation</span>](http://wikipedia.org/wiki/Correlation_does_not_imply_causation)<span
style="font-size:medium">.</span>

<span style="font-size:medium">So what can you do to provide evidence of
causation?</span>

1.  <span style="font-size:medium">Use time. If A comes before B, then A
    can cause B but not the other way around (at least according to our
    common understanding of causation). The order of events can help us
    infer the direction of causation, but it does not preclude the
    possibility that something else causes both A and B.</span>
2.  <span style="font-size:medium">Use randomness. If you divide a large
    sample into two groups at random and compute the means of almost any
    variable, you expect the difference to be small. If the groups are
    nearly identical in all variables but one, you can eliminate
    spurious relationships. </span><span id="hevea_default692"></span>

    <span style="font-size:medium">This works even if you don’t know
    what the relevant variables are, but it works even better if you do,
    because you can check that the groups are identical.</span>

<span style="font-size:medium">These ideas are the motivation for the
<span style="font-weight:bold">randomized controlled trial</span>, in
which subjects are assigned randomly to two (or more) groups: a <span
style="font-weight:bold">treatment group</span> that receives some kind
of intervention, like a new medicine, and a <span
style="font-weight:bold">control group</span> that receives no
intervention, or another treatment whose effects are known. </span><span
id="hevea_default693"></span><span style="font-size:medium">
</span><span id="hevea_default694"></span><span
style="font-size:medium"> </span><span
id="hevea_default695"></span><span style="font-size:medium">
</span><span id="hevea_default696"></span><span
style="font-size:medium"> </span><span id="hevea_default697"></span>

<span style="font-size:medium">A randomized controlled trial is the most
reliable way to demonstrate a causal relationship, and the foundation of
science-based medicine (see </span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Randomized\_controlled\_trial</span>](http://wikipedia.org/wiki/Randomized_controlled_trial)<span
style="font-size:medium">).</span>

<span style="font-size:medium">Unfortunately, controlled trials are only
possible in the laboratory sciences, medicine, and a few other
disciplines. In the social sciences, controlled experiments are rare,
usually because they are impossible or unethical. </span><span
id="hevea_default698"></span>

<span style="font-size:medium">An alternative is to look for a <span
style="font-weight:bold">natural experiment</span>, where different
“treatments” are applied to groups that are otherwise similar. One
danger of natural experiments is that the groups might differ in ways
that are not apparent. You can read more about this topic at
</span>[<span
style="font-family:monospace;font-size:medium">http://wikipedia.org/wiki/Natural\_experiment</span>](http://wikipedia.org/wiki/Natural_experiment)<span
style="font-size:medium">. </span><span id="hevea_default699"></span>

<span style="font-size:medium">In some cases it is possible to infer
causal relationships using <span style="font-weight:bold">regression
analysis</span>, which is the topic of Chapter </span>[<span
style="font-size:medium">11</span>](thinkstats2012.html#regression)<span
style="font-size:medium">. </span><span id="hevea_default700"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.9  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">A solution to this exercise is in
`chap07soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *Using data from the NSFG,
make a scatter plot of birth weight versus mother’s age. Plot
percentiles of birth weight versus mother’s age. Compute Pearson’s and
Spearman’s correlations. How would you characterize the relationship
between these variables?* </span><span
id="hevea_default701"></span><span style="font-size:medium">
</span><span id="hevea_default702"></span><span
style="font-size:medium"> </span><span
id="hevea_default703"></span><span style="font-size:medium">
</span><span id="hevea_default704"></span><span
style="font-size:medium"> </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">7.10  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">scatter plot: A visualization of the
    relationship between two variables, showing one point for each row
    of data. </span><span id="hevea_default705"></span>
-   <span style="font-size:medium">jitter: Random noise added to data
    for purposes of visualization. </span><span
    id="hevea_default706"></span>
-   <span style="font-size:medium">saturation: Loss of information when
    multiple points are plotted on top of each other. </span><span
    id="hevea_default707"></span>
-   <span style="font-size:medium">correlation: A statistic that
    measures the strength of the relationship between two variables.
    </span><span id="hevea_default708"></span>
-   <span style="font-size:medium">standardize: To transform a set of
    values so that their mean is 0 and their variance is 1. </span><span
    id="hevea_default709"></span>
-   <span style="font-size:medium">standard score: A value that has been
    standardized so that it is expressed in standard deviations from the
    mean. </span><span id="hevea_default710"></span><span
    style="font-size:medium"> </span><span id="hevea_default711"></span>
-   <span style="font-size:medium">covariance: A measure of the tendency
    of two variables to vary together. </span><span
    id="hevea_default712"></span>
-   <span style="font-size:medium">rank: The index where an element
    appears in a sorted list. </span><span id="hevea_default713"></span>
-   <span style="font-size:medium">randomized controlled trial: An
    experimental design in which subjects are divided into groups at
    random, and different groups are given different treatments.
    </span><span id="hevea_default714"></span>
-   <span style="font-size:medium">treatment group: A group in a
    controlled trial that receives some kind of intervention.
    </span><span id="hevea_default715"></span>
-   <span style="font-size:medium">control group: A group in a
    controlled trial that receives no treatment, or a treatment whose
    effect is known. </span><span id="hevea_default716"></span>
-   <span style="font-size:medium">natural experiment: An experimental
    design that takes advantage of a natural division of subjects into
    groups in ways that are at least approximately random. </span><span
    id="hevea_default717"></span>

<span style="font-size:medium"> </span>
