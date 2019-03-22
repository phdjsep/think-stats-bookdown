This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 2  Distributions</span>
==============================================================

<span style="font-size:medium"> </span><span id="descriptive"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.1  Histograms</span>
-----------------------------------------------------

<span style="font-size:medium"> </span><span id="histograms"></span>

<span style="font-size:medium">One of the best ways to describe a
variable is to report the values that appear in the dataset and how many
times each value appears. This description is called the <span
style="font-weight:bold">distribution</span> of the variable.
</span><span id="hevea_default95"></span>

<span style="font-size:medium">The most common representation of a
distribution is a <span style="font-weight:bold">histogram</span>, which
is a graph that shows the <span
style="font-weight:bold">frequency</span> of each value. In this
context, “frequency” means the number of times the value appears.
</span><span id="hevea_default96"></span><span style="font-size:medium">
</span><span id="hevea_default97"></span><span style="font-size:medium">
</span><span id="hevea_default98"></span>

<span style="font-size:medium">In Python, an efficient way to compute
frequencies is with a dictionary. Given a sequence of values, <span
style="font-family:monospace">t</span>: </span>

    hist = {}
    for x in t:
        hist[x] = hist.get(x, 0) + 1

<span style="font-size:medium">The result is a dictionary that maps from
values to frequencies. Alternatively, you could use the <span
style="font-family:monospace">Counter</span> class defined in the <span
style="font-family:monospace">collections</span> module:</span>

    from collections import Counter
    counter = Counter(t)

<span style="font-size:medium">The result is a <span
style="font-family:monospace">Counter</span> object, which is a subclass
of dictionary.</span>

<span style="font-size:medium">Another option is to use the pandas
method `value_counts`, which we saw in the previous chapter. But for
this book I created a class, Hist, that represents histograms and
provides the methods that operate on them. </span><span
id="hevea_default99"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.2  Representing histograms</span>
------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default100"></span><span style="font-size:medium">
</span><span id="hevea_default101"></span>

<span style="font-size:medium">The Hist constructor can take a sequence,
dictionary, pandas Series, or another Hist. You can instantiate a Hist
object like this: </span>

    >>> import thinkstats2
    >>> hist = thinkstats2.Hist([1, 2, 2, 3, 5])
    >>> hist
    Hist({1: 1, 2: 2, 3: 1, 5: 1})

<span style="font-size:medium">Hist objects provide <span
style="font-family:monospace">Freq</span>, which takes a value and
returns its frequency: </span><span id="hevea_default102"></span><span
style="font-size:medium"> </span>

    >>> hist.Freq(2)
    2

<span style="font-size:medium">The bracket operator does the same thing:
</span><span id="hevea_default103"></span><span
style="font-size:medium"> </span>

    >>> hist[2]
    2

<span style="font-size:medium">If you look up a value that has never
appeared, the frequency is 0. </span>

    >>> hist.Freq(4)
    0

<span style="font-size:medium"><span
style="font-family:monospace">Values</span> returns an unsorted list of
the values in the Hist: </span>

    >>> hist.Values()
    [1, 5, 3, 2]

<span style="font-size:medium">To loop through the values in order, you
can use the built-in function <span
style="font-family:monospace">sorted</span>: </span>

    for val in sorted(hist.Values()):
        print(val, hist.Freq(val))

<span style="font-size:medium">Or you can use <span
style="font-family:monospace">Items</span> to iterate through
value-frequency pairs: </span><span id="hevea_default104"></span><span
style="font-size:medium"> </span>

    for val, freq in hist.Items():
         print(val, freq)

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.3  Plotting histograms</span>
--------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default105"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2001.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 2.1: Histogram of the pound part of birth weight.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="first_wgt_lb_hist"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">For this book I wrote a module called
<span style="font-family:monospace">thinkplot.py</span> that provides
functions for plotting Hists and other objects defined in <span
style="font-family:monospace">thinkstats2.py</span>. It is based on
<span style="font-family:monospace">pyplot</span>, which is part of the
<span style="font-family:monospace">matplotlib</span> package. See
Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium"> for information about installing <span
style="font-family:monospace">matplotlib</span>. </span><span
id="hevea_default106"></span><span style="font-size:medium">
</span><span id="hevea_default107"></span>

<span style="font-size:medium">To plot <span
style="font-family:monospace">hist</span> with <span
style="font-family:monospace">thinkplot</span>, try this: </span><span
id="hevea_default108"></span>

    >>> import thinkplot
    >>> thinkplot.Hist(hist)
    >>> thinkplot.Show(xlabel='value', ylabel='frequency')

<span style="font-size:medium">You can read the documentation for <span
style="font-family:monospace">thinkplot</span> at </span>[<span
style="font-family:monospace;font-size:medium">http://greenteapress.com/thinkstats2/thinkplot.html</span>](http://greenteapress.com/thinkstats2/thinkplot.html)<span
style="font-size:medium">.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2002.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 2.2: Histogram of the ounce part of birth weight.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="first_wgt_oz_hist"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.4  NSFG variables</span>
---------------------------------------------------------

<span style="font-size:medium">Now let’s get back to the data from the
NSFG. The code in this chapter is in <span
style="font-family:monospace">first.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium">When you start working with a new
dataset, I suggest you explore the variables you are planning to use one
at a time, and a good way to start is by looking at histograms.
</span><span id="hevea_default109"></span>

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">1.6</span>](thinkstats2002.html#cleaning)<span
style="font-size:medium"> we transformed <span
style="font-family:monospace">agepreg</span> from centiyears to years,
and combined `birthwgt_lb` and `birthwgt_oz` into a single quantity,
`totalwgt_lb`. In this section I use these variables to demonstrate some
features of histograms.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2003.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 2.3: Histogram of mother’s age at end of pregnancy.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="first_agepreg_hist"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">I’ll start by reading the data and
selecting records for live births:</span>

        preg = nsfg.ReadFemPreg()
        live = preg[preg.outcome == 1]

<span style="font-size:medium">The expression in brackets is a boolean
Series that selects rows from the DataFrame and returns a new DataFrame.
Next I generate and plot the histogram of `birthwgt_lb` for live births.
</span><span id="hevea_default110"></span><span
style="font-size:medium"> </span><span
id="hevea_default111"></span><span style="font-size:medium">
</span><span id="hevea_default112"></span><span
style="font-size:medium"> </span><span
id="hevea_default113"></span><span style="font-size:medium">
</span><span id="hevea_default114"></span>

        hist = thinkstats2.Hist(live.birthwgt_lb, label='birthwgt_lb')
        thinkplot.Hist(hist)
        thinkplot.Show(xlabel='pounds', ylabel='frequency')

<span style="font-size:medium">When the argument passed to Hist is a
pandas Series, any <span style="font-family:monospace">nan</span> values
are dropped. <span style="font-family:monospace">label</span> is a
string that appears in the legend when the Hist is plotted. </span><span
id="hevea_default115"></span><span style="font-size:medium">
</span><span id="hevea_default116"></span><span
style="font-size:medium"> </span><span
id="hevea_default117"></span><span style="font-size:medium">
</span><span id="hevea_default118"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2004.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 2.4: Histogram of pregnancy length in weeks.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="first_prglngth_hist"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">2.1</span>](#first_wgt_lb_hist)<span
style="font-size:medium"> shows the result. The most common value,
called the <span style="font-weight:bold">mode</span>, is 7 pounds. The
distribution is approximately bell-shaped, which is the shape of the
<span style="font-weight:bold">normal</span> distribution, also called a
<span style="font-weight:bold">Gaussian</span> distribution. But unlike
a true normal distribution, this distribution is asymmetric; it has a
<span style="font-weight:bold">tail</span> that extends farther to the
left than to the right.</span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">2.2</span>](#first_wgt_oz_hist)<span
style="font-size:medium"> shows the histogram of `birthwgt_oz`, which is
the ounces part of birth weight. In theory we expect this distribution
to be <span style="font-weight:bold">uniform</span>; that is, all values
should have the same frequency. In fact, 0 is more common than the other
values, and 1 and 15 are less common, probably because respondents round
off birth weights that are close to an integer value. </span><span
id="hevea_default119"></span><span style="font-size:medium">
</span><span id="hevea_default120"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">2.3</span>](#first_agepreg_hist)<span
style="font-size:medium"> shows the histogram of `agepreg`, the mother’s
age at the end of pregnancy. The mode is 21 years. The distribution is
very roughly bell-shaped, but in this case the tail extends farther to
the right than left; most mothers are in their 20s, fewer in their
30s.</span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">2.4</span>](#first_prglngth_hist)<span
style="font-size:medium"> shows the histogram of `prglngth`, the length
of the pregnancy in weeks. By far the most common value is 39 weeks. The
left tail is longer than the right; early babies are common, but
pregnancies seldom go past 43 weeks, and doctors often intervene if they
do. </span><span id="hevea_default121"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.5  Outliers</span>
---------------------------------------------------

<span style="font-size:medium">Looking at histograms, it is easy to
identify the most common values and the shape of the distribution, but
rare values are not always visible. </span><span
id="hevea_default122"></span>

<span style="font-size:medium">Before going on, it is a good idea to
check for <span style="font-weight:bold">outliers</span>, which are
extreme values that might be errors in measurement and recording, or
might be accurate reports of rare events. </span><span
id="hevea_default123"></span>

<span style="font-size:medium">Hist provides methods <span
style="font-family:monospace">Largest</span> and <span
style="font-family:monospace">Smallest</span>, which take an integer
<span style="font-family:monospace">n</span> and return the <span
style="font-family:monospace">n</span> largest or smallest values from
the histogram: </span><span id="hevea_default124"></span>

        for weeks, freq in hist.Smallest(10):
            print(weeks, freq)

<span style="font-size:medium">In the list of pregnancy lengths for live
births, the 10 lowest values are <span
style="font-family:monospace">\[0, 4, 9, 13, 17, 18, 19, 20, 21,
22\]</span>. Values below 10 weeks are certainly errors; the most likely
explanation is that the outcome was not coded correctly. Values higher
than 30 weeks are probably legitimate. Between 10 and 30 weeks, it is
hard to be sure; some values are probably errors, but some represent
premature babies. </span><span id="hevea_default125"></span>

<span style="font-size:medium">On the other end of the range, the
highest values are: </span>

    weeks  count
    43     148
    44     46
    45     10
    46     1
    47     1
    48     7
    50     2

<span style="font-size:medium">Most doctors recommend induced labor if a
pregnancy exceeds 42 weeks, so some of the longer values are surprising.
In particular, 50 weeks seems medically unlikely.</span>

<span style="font-size:medium">The best way to handle outliers depends
on “domain knowledge”; that is, information about where the data come
from and what they mean. And it depends on what analysis you are
planning to perform. </span><span id="hevea_default126"></span>

<span style="font-size:medium">In this example, the motivating question
is whether first babies tend to be early (or late). When people ask this
question, they are usually interested in full-term pregnancies, so for
this analysis I will focus on pregnancies longer than 27 weeks.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.6  First babies</span>
-------------------------------------------------------

<span style="font-size:medium">Now we can compare the distribution of
pregnancy lengths for first babies and others. I divided the DataFrame
of live births using <span
style="font-family:monospace">birthord</span>, and computed their
histograms: </span><span id="hevea_default127"></span><span
style="font-size:medium"> </span><span
id="hevea_default128"></span><span style="font-size:medium">
</span><span id="hevea_default129"></span>

        firsts = live[live.birthord == 1]
        others = live[live.birthord != 1]

        first_hist = thinkstats2.Hist(firsts.prglngth)
        other_hist = thinkstats2.Hist(others.prglngth)

<span style="font-size:medium">Then I plotted their histograms on the
same axis:</span>

        width = 0.45
        thinkplot.PrePlot(2)
        thinkplot.Hist(first_hist, align='right', width=width)
        thinkplot.Hist(other_hist, align='left', width=width)
        thinkplot.Show(xlabel='weeks', ylabel='frequency',
                       xlim=[27, 46])

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot.PrePlot</span> takes the number
of histograms we are planning to plot; it uses this information to
choose an appropriate collection of colors. </span><span
id="hevea_default130"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2005.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 2.5: Histogram of pregnancy lengths.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="first_nsfg_hist"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot.Hist</span> normally uses <span
style="font-family:monospace">align=’center’</span> so that each bar is
centered over its value. For this figure, I use <span
style="font-family:monospace">align=’right’</span> and <span
style="font-family:monospace">align=’left’</span> to place corresponding
bars on either side of the value. </span><span
id="hevea_default131"></span>

<span style="font-size:medium">With <span
style="font-family:monospace">width=0.45</span>, the total width of the
two bars is 0.9, leaving some space between each pair.</span>

<span style="font-size:medium">Finally, I adjust the axis to show only
data between 27 and 46 weeks. Figure </span>[<span
style="font-size:medium">2.5</span>](#first_nsfg_hist)<span
style="font-size:medium"> shows the result. </span><span
id="hevea_default132"></span><span style="font-size:medium">
</span><span id="hevea_default133"></span>

<span style="font-size:medium">Histograms are useful because they make
the most frequent values immediately apparent. But they are not the best
choice for comparing two distributions. In this example, there are fewer
“first babies” than “others,” so some of the apparent differences in the
histograms are due to sample sizes. In the next chapter we address this
problem using probability mass functions.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.7  Summarizing distributions</span>
--------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="mean"></span>

<span style="font-size:medium">A histogram is a complete description of
the distribution of a sample; that is, given a histogram, we could
reconstruct the values in the sample (although not their order).</span>

<span style="font-size:medium">If the details of the distribution are
important, it might be necessary to present a histogram. But often we
want to summarize the distribution with a few descriptive
statistics.</span>

<span style="font-size:medium">Some of the characteristics we might want
to report are:</span>

-   <span style="font-size:medium">central tendency: Do the values tend
    to cluster around a particular point? </span><span
    id="hevea_default134"></span>
-   <span style="font-size:medium">modes: Is there more than one
    cluster? </span><span id="hevea_default135"></span>
-   <span style="font-size:medium">spread: How much variability is there
    in the values? </span><span id="hevea_default136"></span>
-   <span style="font-size:medium">tails: How quickly do the
    probabilities drop off as we move away from the modes? </span><span
    id="hevea_default137"></span>
-   <span style="font-size:medium">outliers: Are there extreme values
    far from the modes? </span><span id="hevea_default138"></span>

<span style="font-size:medium">Statistics designed to answer these
questions are called <span style="font-weight:bold">summary
statistics</span>. By far the most common summary statistic is the <span
style="font-weight:bold">mean</span>, which is meant to describe the
central tendency of the distribution. </span><span
id="hevea_default139"></span><span style="font-size:medium">
</span><span id="hevea_default140"></span><span
style="font-size:medium"> </span><span id="hevea_default141"></span>

<span style="font-size:medium">If you have a sample of <span
style="font-family:monospace">n</span> values, <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, the mean, <span
style="text-decoration:overline">x</span>, is the sum of the values
divided by the number of values; in other words </span>

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
<td><span style="font-size:medium"><span style="text-decoration:overline">x</span> = </span></td>
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
<td><span style="font-size:medium"> </span></td>
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
<td><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The words “mean” and “average” are
sometimes used interchangeably, but I make this distinction:</span>

-   <span style="font-size:medium">The “mean” of a sample is the summary
    statistic computed with the previous formula.</span>
-   <span style="font-size:medium">An “average” is one of several
    summary statistics you might choose to describe a central tendency.
    </span><span id="hevea_default142"></span>

<span style="font-size:medium">Sometimes the mean is a good description
of a set of values. For example, apples are all pretty much the same
size (at least the ones sold in supermarkets). So if I buy 6 apples and
the total weight is 3 pounds, it would be a reasonable summary to say
they are about a half pound each. </span><span
id="hevea_default143"></span>

<span style="font-size:medium">But pumpkins are more diverse. Suppose I
grow several varieties in my garden, and one day I harvest three
decorative pumpkins that are 1 pound each, two pie pumpkins that are 3
pounds each, and one Atlantic Giant® pumpkin that weighs 591 pounds. The
mean of this sample is 100 pounds, but if I told you “The average
pumpkin in my garden is 100 pounds,” that would be misleading. In this
example, there is no meaningful average because there is no typical
pumpkin. </span><span id="hevea_default144"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.8  Variance</span>
---------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default145"></span>

<span style="font-size:medium">If there is no single number that
summarizes pumpkin weights, we can do a little better with two numbers:
mean and <span style="font-weight:bold">variance</span>.</span>

<span style="font-size:medium">Variance is a summary statistic intended
to describe the variability or spread of a distribution. The variance of
a set of values is </span>

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
<td><span style="font-size:medium"> </span></td>
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
<td><span style="font-size:medium"> (<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The term <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> − <span
style="text-decoration:overline">x</span> is called the “deviation from
the mean,” so variance is the mean squared deviation. The square root of
variance, <span style="font-style:italic">S</span>, is the <span
style="font-weight:bold">standard deviation</span>. </span><span
id="hevea_default146"></span><span style="font-size:medium">
</span><span id="hevea_default147"></span><span
style="font-size:medium"> </span><span id="hevea_default148"></span>

<span style="font-size:medium">If you have prior experience, you might
have seen a formula for variance with <span
style="font-style:italic">n</span>−1 in the denominator, rather than
<span style="font-family:monospace">n</span>. This statistic is used to
estimate the variance in a population using a sample. We will come back
to this in Chapter </span>[<span
style="font-size:medium">8</span>](thinkstats2009.html#estimation)<span
style="font-size:medium">. </span><span id="hevea_default149"></span>

<span style="font-size:medium">Pandas data structures provides methods
to compute mean, variance and standard deviation: </span><span
id="hevea_default150"></span>

        mean = live.prglngth.mean()
        var = live.prglngth.var()
        std = live.prglngth.std()

<span style="font-size:medium">For all live births, the mean pregnancy
length is 38.6 weeks, the standard deviation is 2.7 weeks, which means
we should expect deviations of 2-3 weeks to be common. </span><span
id="hevea_default151"></span>

<span style="font-size:medium">Variance of pregnancy length is 7.3,
which is hard to interpret, especially since the units are
weeks</span><sup><span style="font-size:medium">2</span></sup><span
style="font-size:medium">, or “square weeks.” Variance is useful in some
calculations, but it is not a good summary statistic.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.9  Effect size</span>
------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default152"></span>

<span style="font-size:medium">An <span style="font-weight:bold">effect
size</span> is a summary statistic intended to describe (wait for it)
the size of an effect. For example, to describe the difference between
two groups, one obvious choice is the difference in the means.
</span><span id="hevea_default153"></span>

<span style="font-size:medium">Mean pregnancy length for first babies is
38.601; for other babies it is 38.523. The difference is 0.078 weeks,
which works out to 13 hours. As a fraction of the typical pregnancy
length, this difference is about 0.2%. </span><span
id="hevea_default154"></span>

<span style="font-size:medium">If we assume this estimate is accurate,
such a difference would have no practical consequences. In fact, without
observing a large number of pregnancies, it is unlikely that anyone
would notice this difference at all. </span><span
id="hevea_default155"></span>

<span style="font-size:medium">Another way to convey the size of the
effect is to compare the difference between groups to the variability
within groups. Cohen’s <span style="font-style:italic">d</span> is a
statistic intended to do that; it is defined </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">d</span> = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="text-decoration:overline">x_1</span> − <span style="text-decoration:overline">x_2</span></span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">s</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium">  </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where <span
style="text-decoration:overline">x\_1</span> and <span
style="text-decoration:overline">x\_2</span> are the means of the groups
and <span style="font-style:italic">s</span> is the “pooled standard
deviation”. Here’s the Python code that computes Cohen’s <span
style="font-style:italic">d</span>: </span><span
id="hevea_default156"></span>

    def CohenEffectSize(group1, group2):
        diff = group1.mean() - group2.mean()

        var1 = group1.var()
        var2 = group2.var()
        n1, n2 = len(group1), len(group2)

        pooled_var = (n1 * var1 + n2 * var2) / (n1 + n2)
        d = diff / math.sqrt(pooled_var)
        return d

<span style="font-size:medium">In this example, the difference in means
is 0.029 standard deviations, which is small. To put that in
perspective, the difference in height between men and women is about 1.7
standard deviations (see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Effect\_size</span>](https://en.wikipedia.org/wiki/Effect_size)<span
style="font-size:medium">).</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.10  Reporting results</span>
-------------------------------------------------------------

<span style="font-size:medium">We have seen several ways to describe the
difference in pregnancy length (if there is one) between first babies
and others. How should we report these results? </span><span
id="hevea_default157"></span>

<span style="font-size:medium">The answer depends on who is asking the
question. A scientist might be interested in any (real) effect, no
matter how small. A doctor might only care about effects that are <span
style="font-weight:bold">clinically significant</span>; that is,
differences that affect treatment decisions. A pregnant woman might be
interested in results that are relevant to her, like the probability of
delivering early or late. </span><span
id="hevea_default158"></span><span style="font-size:medium">
</span><span id="hevea_default159"></span>

<span style="font-size:medium">How you report results also depends on
your goals. If you are trying to demonstrate the importance of an
effect, you might choose summary statistics that emphasize differences.
If you are trying to reassure a patient, you might choose statistics
that put the differences in context.</span>

<span style="font-size:medium">Of course your decisions should also be
guided by professional ethics. It’s ok to be persuasive; you *should*
design statistical reports and visualizations that tell a story clearly.
But you should also do your best to make your reports honest, and to
acknowledge uncertainty and limitations. </span><span
id="hevea_default160"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.11  Exercises</span>
-----------------------------------------------------

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *Based on the results in
this chapter, suppose you were asked to summarize what you learned about
whether first babies arrive late.*</span>

<span style="font-size:medium">*Which summary statistics would you use
if you wanted to get a story on the evening news? Which ones would you
use if you wanted to reassure an anxious patient?* </span><span
id="hevea_default161"></span><span style="font-size:medium">
</span><span id="hevea_default162"></span>

<span style="font-size:medium">*Finally, imagine that you are Cecil
Adams, author of <span style="font-style:italic">The Straight
Dope</span> (*</span>[<span
style="font-family:monospace;font-size:medium">*http://straightdope.com*</span>](http://straightdope.com)<span
style="font-size:medium">*), and your job is to answer the question, “Do
first babies arrive late?” Write a paragraph that uses the results in
this chapter to answer the question clearly, precisely, and honestly.*
</span><span id="hevea_default163"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *In the repository you
downloaded, you should find a file named `chap02ex.ipynb`; open it. Some
cells are already filled in, and you should execute them. Other cells
give you instructions for exercises. Follow the instructions and fill in
the answers.*</span>

<span style="font-size:medium">*A solution to this exercise is in
`chap02soln.ipynb`* </span>

<span style="font-size:medium">In the repository you downloaded, you
should find a file named `chap02ex.py`; you can use this file as a
starting place for the following exercises. My solution is in
`chap02soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *The mode of a distribution
is the most frequent value; see* </span>[<span
style="font-family:monospace;font-size:medium">*http://wikipedia.org/wiki/Mode\_(statistics)*</span>](http://wikipedia.org/wiki/Mode_(statistics))<span
style="font-size:medium">*. Write a function called <span
style="font-family:monospace">Mode</span> that takes a Hist and returns
the most frequent value.*</span><span id="hevea_default164"></span><span
style="font-size:medium"> </span><span id="hevea_default165"></span>

<span style="font-size:medium">*As a more challenging exercise, write a
function called <span style="font-family:monospace">AllModes</span> that
returns a list of value-frequency pairs in descending order of
frequency.* </span><span id="hevea_default166"></span><span
style="font-size:medium"> </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 4</span>   *Using the variable
`totalwgt_lb`, investigate whether first babies are lighter or heavier
than others. Compute Cohen’s* <span style="font-style:italic">d</span>
*to quantify the difference between the groups. How does it compare to
the difference in pregnancy length?* </span><span
id="hevea_default167"></span><span style="font-size:medium"> </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">2.12  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">distribution: The values that appear
    in a sample and the frequency of each. </span><span
    id="hevea_default168"></span>
-   <span style="font-size:medium">histogram: A mapping from values to
    frequencies, or a graph that shows this mapping. </span><span
    id="hevea_default169"></span>
-   <span style="font-size:medium">frequency: The number of times a
    value appears in a sample. </span><span
    id="hevea_default170"></span>
-   <span style="font-size:medium">mode: The most frequent value in a
    sample, or one of the most frequent values. </span><span
    id="hevea_default171"></span>
-   <span style="font-size:medium">normal distribution: An idealization
    of a bell-shaped distribution; also known as a Gaussian
    distribution. </span><span id="hevea_default172"></span><span
    style="font-size:medium"> </span><span id="hevea_default173"></span>
-   <span style="font-size:medium">uniform distribution: A distribution
    in which all values have the same frequency. </span><span
    id="hevea_default174"></span>
-   <span style="font-size:medium">tail: The part of a distribution at
    the high and low extremes. </span><span
    id="hevea_default175"></span>
-   <span style="font-size:medium">central tendency: A characteristic of
    a sample or population; intuitively, it is an average or typical
    value. </span><span id="hevea_default176"></span>
-   <span style="font-size:medium">outlier: A value far from the central
    tendency. </span><span id="hevea_default177"></span>
-   <span style="font-size:medium">spread: A measure of how spread out
    the values in a distribution are. </span><span
    id="hevea_default178"></span>
-   <span style="font-size:medium">summary statistic: A statistic that
    quantifies some aspect of a distribution, like central tendency or
    spread. </span><span id="hevea_default179"></span>
-   <span style="font-size:medium">variance: A summary statistic often
    used to quantify spread. </span><span id="hevea_default180"></span>
-   <span style="font-size:medium">standard deviation: The square root
    of variance, also used as a measure of spread. </span><span
    id="hevea_default181"></span>
-   <span style="font-size:medium">effect size: A summary statistic
    intended to quantify the size of an effect like a difference between
    groups. </span><span id="hevea_default182"></span>
-   <span style="font-size:medium">clinically significant: A result,
    like a difference between groups, that is relevant in practice.
    </span><span id="hevea_default183"></span>

<span style="font-size:medium"> </span>
