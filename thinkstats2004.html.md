This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 3  Probability mass functions</span>
===========================================================================

<span style="font-size:medium"> </span><span
id="hevea_default184"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">probability.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.1  Pmfs</span>
-----------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default185"></span>

<span style="font-size:medium">Another way to represent a distribution
is a <span style="font-weight:bold">probability mass function</span>
(PMF), which maps from each value to its probability. A <span
style="font-weight:bold">probability</span> is a frequency expressed as
a fraction of the sample size, <span
style="font-family:monospace">n</span>. To get from frequencies to
probabilities, we divide through by <span
style="font-family:monospace">n</span>, which is called <span
style="font-weight:bold">normalization</span>. </span><span
id="hevea_default186"></span><span style="font-size:medium">
</span><span id="hevea_default187"></span><span
style="font-size:medium"> </span><span
id="hevea_default188"></span><span style="font-size:medium">
</span><span id="hevea_default189"></span><span
style="font-size:medium"> </span><span id="hevea_default190"></span>

<span style="font-size:medium">Given a Hist, we can make a dictionary
that maps from each value to its probability: </span><span
id="hevea_default191"></span><span style="font-size:medium"> </span>

    n = hist.Total()
    d = {}
    for x, freq in hist.Items():
        d[x] = freq / n

<span style="font-size:medium">Or we can use the Pmf class provided by
<span style="font-family:monospace">thinkstats2</span>. Like Hist, the
Pmf constructor can take a list, pandas Series, dictionary, Hist, or
another Pmf object. Here’s an example with a simple list: </span>

    >>> import thinkstats2
    >>> pmf = thinkstats2.Pmf([1, 2, 2, 3, 5])
    >>> pmf
    Pmf({1: 0.2, 2: 0.4, 3: 0.2, 5: 0.2})

<span style="font-size:medium">The Pmf is normalized so total
probability is 1.</span>

<span style="font-size:medium">Pmf and Hist objects are similar in many
ways; in fact, they inherit many of their methods from a common parent
class. For example, the methods <span
style="font-family:monospace">Values</span> and <span
style="font-family:monospace">Items</span> work the same way for both.
The biggest difference is that a Hist maps from values to integer
counters; a Pmf maps from values to floating-point probabilities.
</span><span id="hevea_default192"></span>

<span style="font-size:medium">To look up the probability associated
with a value, use <span style="font-family:monospace">Prob</span>:
</span>

    >>> pmf.Prob(2)
    0.4

<span style="font-size:medium">The bracket operator is equivalent:
</span><span id="hevea_default193"></span>

    >>> pmf[2]
    0.4

<span style="font-size:medium">You can modify an existing Pmf by
incrementing the probability associated with a value: </span>

    >>> pmf.Incr(2, 0.2)
    >>> pmf.Prob(2)
    0.6

<span style="font-size:medium">Or you can multiply a probability by a
factor: </span>

    >>> pmf.Mult(2, 0.5)
    >>> pmf.Prob(2)
    0.3

<span style="font-size:medium">If you modify a Pmf, the result may not
be normalized; that is, the probabilities may no longer add up to 1. To
check, you can call <span style="font-family:monospace">Total</span>,
which returns the sum of the probabilities: </span>

    >>> pmf.Total()
    0.9

<span style="font-size:medium">To renormalize, call <span
style="font-family:monospace">Normalize</span>: </span>

    >>> pmf.Normalize()
    >>> pmf.Total()
    1.0

<span style="font-size:medium">Pmf objects provide a <span
style="font-family:monospace">Copy</span> method so you can make and
modify a copy without affecting the original. </span><span
id="hevea_default194"></span>

<span style="font-size:medium">My notation in this section might seem
inconsistent, but there is a system: I use Pmf for the name of the
class, <span style="font-family:monospace">pmf</span> for an instance of
the class, and PMF for the mathematical concept of a probability mass
function.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.2  Plotting PMFs</span>
--------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default195"></span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot</span> provides two ways to plot
Pmfs: </span><span id="hevea_default196"></span>

-   <span style="font-size:medium">To plot a Pmf as a bar graph, you can
    use <span style="font-family:monospace">thinkplot.Hist</span>. Bar
    graphs are most useful if the number of values in the Pmf is small.
    </span><span id="hevea_default197"></span><span
    style="font-size:medium"> </span><span id="hevea_default198"></span>
-   <span style="font-size:medium">To plot a Pmf as a step function, you
    can use <span style="font-family:monospace">thinkplot.Pmf</span>.
    This option is most useful if there are a large number of values and
    the Pmf is smooth. This function also works with Hist objects.
    </span><span id="hevea_default199"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default200"></span><span style="font-size:medium">
    </span><span id="hevea_default201"></span><span
    style="font-size:medium"> </span><span id="hevea_default202"></span>

<span style="font-size:medium">In addition, <span
style="font-family:monospace">pyplot</span> provides a function called
<span style="font-family:monospace">hist</span> that takes a sequence of
values, computes a histogram, and plots it. Since I use Hist objects, I
usually don’t use <span
style="font-family:monospace">pyplot.hist</span>. </span><span
id="hevea_default203"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2006.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 3.1: PMF of pregnancy lengths for first babies and others, using bar graphs and step functions.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="probability_nsfg_pmf"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default204"></span><span style="font-size:medium">
</span><span id="hevea_default205"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">3.1</span>](#probability_nsfg_pmf)<span
style="font-size:medium"> shows PMFs of pregnancy length for first
babies and others using bar graphs (left) and step functions (right).
</span><span id="hevea_default206"></span>

<span style="font-size:medium">By plotting the PMF instead of the
histogram, we can compare the two distributions without being mislead by
the difference in sample size. Based on this figure, first babies seem
to be less likely than others to arrive on time (week 39) and more
likely to be a late (weeks 41 and 42).</span>

<span style="font-size:medium">Here’s the code that generates
Figure </span>[<span
style="font-size:medium">3.1</span>](#probability_nsfg_pmf)<span
style="font-size:medium">:</span>

        thinkplot.PrePlot(2, cols=2)
        thinkplot.Hist(first_pmf, align='right', width=width)
        thinkplot.Hist(other_pmf, align='left', width=width)
        thinkplot.Config(xlabel='weeks',
                         ylabel='probability',
                         axis=[27, 46, 0, 0.6])

        thinkplot.PrePlot(2)
        thinkplot.SubPlot(2)
        thinkplot.Pmfs([first_pmf, other_pmf])
        thinkplot.Show(xlabel='weeks',
                       axis=[27, 46, 0, 0.6])

<span style="font-size:medium"><span
style="font-family:monospace">PrePlot</span> takes optional parameters
<span style="font-family:monospace">rows</span> and <span
style="font-family:monospace">cols</span> to make a grid of figures, in
this case one row of two figures. The first figure (on the left)
displays the Pmfs using <span
style="font-family:monospace">thinkplot.Hist</span>, as we have seen
before. </span><span id="hevea_default207"></span><span
style="font-size:medium"> </span><span id="hevea_default208"></span>

<span style="font-size:medium">The second call to <span
style="font-family:monospace">PrePlot</span> resets the color generator.
Then <span style="font-family:monospace">SubPlot</span> switches to the
second figure (on the right) and displays the Pmfs using <span
style="font-family:monospace">thinkplot.Pmfs</span>. I used the <span
style="font-family:monospace">axis</span> option to ensure that the two
figures are on the same axes, which is generally a good idea if you
intend to compare two figures.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.3  Other visualizations</span>
---------------------------------------------------------------

<span style="font-size:medium"> </span><span id="visualization"></span>

<span style="font-size:medium">Histograms and PMFs are useful while you
are exploring data and trying to identify patterns and relationships.
Once you have an idea what is going on, a good next step is to design a
visualization that makes the patterns you have identified as clear as
possible. </span><span id="hevea_default209"></span><span
style="font-size:medium"> </span><span id="hevea_default210"></span>

<span style="font-size:medium">In the NSFG data, the biggest differences
in the distributions are near the mode. So it makes sense to zoom in on
that part of the graph, and to transform the data to emphasize
differences: </span><span id="hevea_default211"></span><span
style="font-size:medium"> </span><span id="hevea_default212"></span>

        weeks = range(35, 46)
        diffs = []
        for week in weeks:
            p1 = first_pmf.Prob(week)
            p2 = other_pmf.Prob(week)
            diff = 100 * (p1 - p2)
            diffs.append(diff)

        thinkplot.Bar(weeks, diffs)

<span style="font-size:medium">In this code, <span
style="font-family:monospace">weeks</span> is the range of weeks; <span
style="font-family:monospace">diffs</span> is the difference between the
two PMFs in percentage points. Figure </span>[<span
style="font-size:medium">3.2</span>](#probability_nsfg_diffs)<span
style="font-size:medium"> shows the result as a bar chart. This figure
makes the pattern clearer: first babies are less likely to be born in
week 39, and somewhat more likely to be born in weeks 41 and 42.
</span><span id="hevea_default213"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2007.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 3.2: Difference, in percentage points, by week.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="probability_nsfg_diffs"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">For now we should hold this conclusion
only tentatively. We used the same dataset to identify an apparent
difference and then chose a visualization that makes the difference
apparent. We can’t be sure this effect is real; it might be due to
random variation. We’ll address this concern later.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.4  The class size paradox</span>
-----------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default214"></span>

<span style="font-size:medium">Before we go on, I want to demonstrate
one kind of computation you can do with Pmf objects; I call this example
the “class size paradox.” </span><span id="hevea_default215"></span>

<span style="font-size:medium">At many American colleges and
universities, the student-to-faculty ratio is about 10:1. But students
are often surprised to discover that their average class size is bigger
than 10. There are two reasons for the discrepancy:</span>

-   <span style="font-size:medium">Students typically take 4–5 classes
    per semester, but professors often teach 1 or 2.</span>
-   <span style="font-size:medium">The number of students who enjoy a
    small class is small, but the number of students in a large class is
    (ahem!) large.</span>

<span style="font-size:medium">The first effect is obvious, at least
once it is pointed out; the second is more subtle. Let’s look at an
example. Suppose that a college offers 65 classes in a given semester,
with the following distribution of sizes: </span>

     size      count
     5- 9          8
    10-14          8
    15-19         14
    20-24          4
    25-29          6
    30-34         12
    35-39          8
    40-44          3
    45-49          2

<span style="font-size:medium">If you ask the Dean for the average class
size, he would construct a PMF, compute the mean, and report that the
average class size is 23.7. Here’s the code:</span>

        d = { 7: 8, 12: 8, 17: 14, 22: 4, 
              27: 6, 32: 12, 37: 8, 42: 3, 47: 2 }

        pmf = thinkstats2.Pmf(d, label='actual')
        print('mean', pmf.Mean())

<span style="font-size:medium">But if you survey a group of students,
ask them how many students are in their classes, and compute the mean,
you would think the average class was bigger. Let’s see how much
bigger.</span>

<span style="font-size:medium">First, I compute the distribution as
observed by students, where the probability associated with each class
size is “biased” by the number of students in the class. </span><span
id="hevea_default216"></span><span style="font-size:medium">
</span><span id="hevea_default217"></span>

    def BiasPmf(pmf, label):
        new_pmf = pmf.Copy(label=label)

        for x, p in pmf.Items():
            new_pmf.Mult(x, x)
            
        new_pmf.Normalize()
        return new_pmf

<span style="font-size:medium">For each class size, <span
style="font-family:monospace">x</span>, we multiply the probability by
<span style="font-family:monospace">x</span>, the number of students who
observe that class size. The result is a new Pmf that represents the
biased distribution.</span>

<span style="font-size:medium">Now we can plot the actual and observed
distributions: </span><span id="hevea_default218"></span>

        biased_pmf = BiasPmf(pmf, label='observed')
        thinkplot.PrePlot(2)
        thinkplot.Pmfs([pmf, biased_pmf])
        thinkplot.Show(xlabel='class size', ylabel='PMF')

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2008.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 3.3: Distribution of class sizes, actual and as observed by students.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="class_size1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">3.3</span>](#class_size1)<span
style="font-size:medium"> shows the result. In the biased distribution
there are fewer small classes and more large ones. The mean of the
biased distribution is 29.1, almost 25% higher than the actual
mean.</span>

<span style="font-size:medium">It is also possible to invert this
operation. Suppose you want to find the distribution of class sizes at a
college, but you can’t get reliable data from the Dean. An alternative
is to choose a random sample of students and ask how many students are
in their classes. </span><span id="hevea_default219"></span><span
style="font-size:medium"> </span><span id="hevea_default220"></span>

<span style="font-size:medium">The result would be biased for the
reasons we’ve just seen, but you can use it to estimate the actual
distribution. Here’s the function that unbiases a Pmf:</span>

    def UnbiasPmf(pmf, label):
        new_pmf = pmf.Copy(label=label)

        for x, p in pmf.Items():
            new_pmf.Mult(x, 1.0/x)
            
        new_pmf.Normalize()
        return new_pmf

<span style="font-size:medium">It’s similar to <span
style="font-family:monospace">BiasPmf</span>; the only difference is
that it divides each probability by <span
style="font-family:monospace">x</span> instead of multiplying.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.5  DataFrame indexing</span>
-------------------------------------------------------------

<span style="font-size:medium">In Section </span>[<span
style="font-size:medium">1.4</span>](thinkstats2002.html#dataframe)<span
style="font-size:medium"> we read a pandas DataFrame and used it to
select and modify data columns. Now let’s look at row selection. To
start, I create a NumPy array of random numbers and use it to initialize
a DataFrame: </span><span id="hevea_default221"></span><span
style="font-size:medium"> </span><span
id="hevea_default222"></span><span style="font-size:medium">
</span><span id="hevea_default223"></span>

    >>> import numpy as np
    >>> import pandas
    >>> array = np.random.randn(4, 2)
    >>> df = pandas.DataFrame(array)
    >>> df
              0         1
    0 -0.143510  0.616050
    1 -1.489647  0.300774
    2 -0.074350  0.039621
    3 -1.369968  0.545897

<span style="font-size:medium">By default, the rows and columns are
numbered starting at zero, but you can provide column names:</span>

    >>> columns = ['A', 'B']
    >>> df = pandas.DataFrame(array, columns=columns)
    >>> df
              A         B
    0 -0.143510  0.616050
    1 -1.489647  0.300774
    2 -0.074350  0.039621
    3 -1.369968  0.545897

<span style="font-size:medium">You can also provide row names. The set
of row names is called the <span style="font-weight:bold">index</span>;
the row names themselves are called <span
style="font-weight:bold">labels</span>.</span>

    >>> index = ['a', 'b', 'c', 'd']
    >>> df = pandas.DataFrame(array, columns=columns, index=index)
    >>> df
              A         B
    a -0.143510  0.616050
    b -1.489647  0.300774
    c -0.074350  0.039621
    d -1.369968  0.545897

<span style="font-size:medium">As we saw in the previous chapter, simple
indexing selects a column, returning a Series: </span><span
id="hevea_default224"></span>

    >>> df['A']
    a   -0.143510
    b   -1.489647
    c   -0.074350
    d   -1.369968
    Name: A, dtype: float64

<span style="font-size:medium">To select a row by label, you can use the
<span style="font-family:monospace">loc</span> attribute, which returns
a Series:</span>

    >>> df.loc['a']
    A   -0.14351
    B    0.61605
    Name: a, dtype: float64

<span style="font-size:medium">If you know the integer position of a
row, rather than its label, you can use the <span
style="font-family:monospace">iloc</span> attribute, which also returns
a Series.</span>

    >>> df.iloc[0]
    A   -0.14351
    B    0.61605
    Name: a, dtype: float64

<span style="font-size:medium"><span
style="font-family:monospace">loc</span> can also take a list of labels;
in that case, the result is a DataFrame.</span>

    >>> indices = ['a', 'c']
    >>> df.loc[indices]
             A         B
    a -0.14351  0.616050
    c -0.07435  0.039621

<span style="font-size:medium">Finally, you can use a slice to select a
range of rows by label:</span>

    >>> df['a':'c']
              A         B
    a -0.143510  0.616050
    b -1.489647  0.300774
    c -0.074350  0.039621

<span style="font-size:medium">Or by integer position:</span>

    >>> df[0:2]
              A         B
    a -0.143510  0.616050
    b -1.489647  0.300774

<span style="font-size:medium">The result in either case is a DataFrame,
but notice that the first result includes the end of the slice; the
second doesn’t. </span><span id="hevea_default225"></span>

<span style="font-size:medium">My advice: if your rows have labels that
are not simple integers, use the labels consistently and avoid using
integer positions.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.6  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">Solutions to these exercises are in
`chap03soln.ipynb` and `chap03soln.py`</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *Something like the class
size paradox appears if you survey children and ask how many children
are in their family. Families with many children are more likely to
appear in your sample, and families with no children have no chance to
be in the sample.* </span><span id="hevea_default226"></span><span
style="font-size:medium"> </span><span id="hevea_default227"></span>

<span style="font-size:medium">*Use the NSFG respondent variable
`NUMKDHH` to construct the actual distribution for the number of
children under 18 in the household.*</span>

<span style="font-size:medium">*Now compute the biased distribution we
would see if we surveyed the children and asked them how many children
under 18 (including themselves) are in their household.* </span>

<span style="font-size:medium">*Plot the actual and biased
distributions, and compute their means. As a starting place, you can use
`chap03ex.ipynb`.* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   </span><span
id="hevea_default228"></span><span style="font-size:medium">
</span><span id="hevea_default229"></span><span
style="font-size:medium"> </span><span id="hevea_default230"></span>

<span style="font-size:medium">*In Section *</span>[<span
style="font-size:medium">*2.7*</span>](thinkstats2003.html#mean)<span
style="font-size:medium"> *we computed the mean of a sample by adding up
the elements and dividing by n. If you are given a PMF, you can still
compute the mean, but the process is slightly different:* </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="text-decoration:overline">x</span> = </span></td>
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
<td><span style="font-size:medium"> <span style="font-style:italic">p</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> *where the* <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> *are the unique values in the PMF and* <span
style="font-style:italic">p</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">=<span
style="font-style:italic">PMF</span>(<span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">)*. Similarly, you can compute variance like
this:* </span>

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
<td><span style="font-size:medium"> <span style="font-style:italic">p</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> (<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span><sup><span style="font-size:medium">2</span></sup></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> *Write functions called <span
style="font-family:monospace">PmfMean</span> and <span
style="font-family:monospace">PmfVar</span> that take a Pmf object and
compute the mean and variance. To test these methods, check that they
are consistent with the methods <span
style="font-family:monospace">Mean</span> and <span
style="font-family:monospace">Var</span> provided by Pmf.* </span><span
id="hevea_default231"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *I started with the
question, “Are first babies more likely to be late?” To address it, I
computed the difference in means between groups of babies, but I ignored
the possibility that there might be a difference between first babies
and others* for the same woman*.*</span>

<span style="font-size:medium">*To address this version of the question,
select respondents who have at least two babies and compute pairwise
differences. Does this formulation of the question yield a different
result?*</span>

<span style="font-size:medium">*Hint: use <span
style="font-family:monospace">nsfg.MakePregMap</span>.* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 4</span>   </span><span
id="relay"></span>

<span style="font-size:medium">*In most foot races, everyone starts at
the same time. If you are a fast runner, you usually pass a lot of
people at the beginning of the race, but after a few miles everyone
around you is going at the same speed.* </span><span
id="hevea_default232"></span>

<span style="font-size:medium">*When I ran a long-distance (209 miles)
relay race for the first time, I noticed an odd phenomenon: when I
overtook another runner, I was usually much faster, and when another
runner overtook me, he was usually much faster.*</span>

<span style="font-size:medium">*At first I thought that the distribution
of speeds might be bimodal; that is, there were many slow runners and
many fast runners, but few at my speed.*</span>

<span style="font-size:medium">*Then I realized that I was the victim of
a bias similar to the effect of class size. The race was unusual in two
ways: it used a staggered start, so teams started at different times;
also, many teams included runners at different levels of ability.*
</span><span id="hevea_default233"></span><span
style="font-size:medium"> </span><span id="hevea_default234"></span>

<span style="font-size:medium">*As a result, runners were spread out
along the course with little relationship between speed and location.
When I joined the race, the runners near me were (pretty much) a random
sample of the runners in the race.*</span>

<span style="font-size:medium">*So where does the bias come from? During
my time on the course, the chance of overtaking a runner, or being
overtaken, is proportional to the difference in our speeds. I am more
likely to catch a slow runner, and more likely to be caught by a fast
runner. But runners at the same speed are unlikely to see each
other.*</span>

<span style="font-size:medium">*Write a function called <span
style="font-family:monospace">ObservedPmf</span> that takes a Pmf
representing the actual distribution of runners’ speeds, and the speed
of a running observer, and returns a new Pmf representing the
distribution of runners’ speeds as seen by the observer.* </span><span
id="hevea_default235"></span><span style="font-size:medium">
</span><span id="hevea_default236"></span>

<span style="font-size:medium">*To test your function, you can use <span
style="font-family:monospace">relay.py</span>, which reads the results
from the James Joyce Ramble 10K in Dedham MA and converts the pace of
each runner to mph.*</span>

<span style="font-size:medium">*Compute the distribution of speeds you
would observe if you ran a relay race at 7.5 mph with this group of
runners. A solution to this exercise is in `relay_soln.py`.* </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">3.7  Glossary</span>
---------------------------------------------------

-   <span style="font-size:medium">Probability mass function (PMF): a
    representation of a distribution as a function that maps from values
    to probabilities. </span><span id="hevea_default237"></span><span
    style="font-size:medium"> </span><span id="hevea_default238"></span>
-   <span style="font-size:medium">probability: A frequency expressed as
    a fraction of the sample size. </span><span
    id="hevea_default239"></span><span style="font-size:medium">
    </span><span id="hevea_default240"></span>
-   <span style="font-size:medium">normalization: The process of
    dividing a frequency by a sample size to get a probability.
    </span><span id="hevea_default241"></span>
-   <span style="font-size:medium">index: In a pandas DataFrame, the
    index is a special column that contains the row labels. </span><span
    id="hevea_default242"></span><span style="font-size:medium">
    </span><span id="hevea_default243"></span>

<span style="font-size:medium"> </span>
