This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 6  Probability density functions</span>
==============================================================================

<span style="font-size:medium"> </span><span id="density"></span><span
style="font-size:medium"> </span><span
id="hevea_default473"></span><span style="font-size:medium">
</span><span id="hevea_default474"></span><span
style="font-size:medium"> </span><span
id="hevea_default475"></span><span style="font-size:medium">
</span><span id="hevea_default476"></span><span
style="font-size:medium"> </span><span
id="hevea_default477"></span><span style="font-size:medium">
</span><span id="hevea_default478"></span><span
style="font-size:medium"> </span><span
id="hevea_default479"></span><span style="font-size:medium">
</span><span id="hevea_default480"></span><span
style="font-size:medium"> </span><span
id="hevea_default481"></span><span style="font-size:medium">
</span><span id="hevea_default482"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">density.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.1  PDFs</span>
-----------------------------------------------

<span style="font-size:medium">The derivative of a CDF is called a <span
style="font-weight:bold">probability density function</span>, or PDF.
For example, the PDF of an exponential distribution is </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">PDF</span><sub><span style="font-style:italic;font-size:medium">expo</span></sub><span style="font-size:medium">(<span style="font-style:italic">x</span>) = λ <span style="font-style:italic">e</span></span><sup><span style="font-size:medium">−λ <span style="font-style:italic">x</span></span></sup><span style="font-size:medium">   </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The PDF of a normal distribution is
</span>

<table style="width:100%;">
<colgroup>
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 7%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">PDF</span><sub><span style="font-style:italic;font-size:medium">normal</span></sub><span style="font-size:medium">(<span style="font-style:italic">x</span>) = </span></td>
<td><table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">σ </span></td>
<td><span style="font-size:x-large">√</span></td>
<td><table>
<tbody>
<tr class="odd">
<td></td>
</tr>
<tr class="even">
<td><span style="font-size:medium">2 π</span></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium">  exp</span></td>
<td><span style="font-size:medium">⎡<br />
⎢<br />
⎢<br />
⎢<br />
⎢<br />
⎢<br />
⎣</span></td>
<td><span style="font-size:medium">−</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">2</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium">  </span></td>
<td><span style="font-size:medium">⎛<br />
⎜<br />
⎜<br />
⎝</span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">x</span> − µ</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">σ</span></td>
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
<td style="text-align: left;"><span style="font-size:medium">2</span></td>
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
<td><span style="font-size:medium">⎤<br />
⎥<br />
⎥<br />
⎥<br />
⎥<br />
⎥<br />
⎦</span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Evaluating a PDF for a particular value
of <span style="font-style:italic">x</span> is usually not useful. The
result is not a probability; it is a probability *density*. </span><span
id="hevea_default483"></span><span style="font-size:medium">
</span><span id="hevea_default484"></span>

<span style="font-size:medium">In physics, density is mass per unit of
volume; in order to get a mass, you have to multiply by volume or, if
the density is not constant, you have to integrate over volume.</span>

<span style="font-size:medium">Similarly, <span
style="font-weight:bold">probability density</span> measures probability
per unit of <span style="font-style:italic">x</span>. In order to get a
probability mass, you have to integrate over <span
style="font-style:italic">x</span>.</span>

<span style="font-size:medium"><span
style="font-family:monospace">thinkstats2</span> provides a class called
Pdf that represents a probability density function. Every Pdf object
provides the following methods:</span>

-   <span style="font-size:medium"><span
    style="font-family:monospace">Density</span>, which takes a value,
    <span style="font-family:monospace">x</span>, and returns the
    density of the distribution at <span
    style="font-family:monospace">x</span>.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">Render</span>, which evaluates the
    density at a discrete set of values and returns a pair of sequences:
    the sorted values, <span style="font-family:monospace">xs</span>,
    and their probability densities, <span
    style="font-family:monospace">ds</span>.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">MakePmf</span>, which evaluates <span
    style="font-family:monospace">Density</span> at a discrete set of
    values and returns a normalized Pmf that approximates the Pdf.
    </span><span id="hevea_default485"></span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">GetLinspace</span>, which returns the
    default set of points used by <span
    style="font-family:monospace">Render</span> and <span
    style="font-family:monospace">MakePmf</span>.</span>

<span style="font-size:medium">Pdf is an abstract parent class, which
means you should not instantiate it; that is, you cannot create a Pdf
object. Instead, you should define a child class that inherits from Pdf
and provides definitions of <span
style="font-family:monospace">Density</span> and <span
style="font-family:monospace">GetLinspace</span>. Pdf provides <span
style="font-family:monospace">Render</span> and <span
style="font-family:monospace">MakePmf</span>.</span>

<span style="font-size:medium">For example, <span
style="font-family:monospace">thinkstats2</span> provides a class named
<span style="font-family:monospace">NormalPdf</span> that evaluates the
normal density function.</span>

    class NormalPdf(Pdf):

        def __init__(self, mu=0, sigma=1, label=''):
            self.mu = mu
            self.sigma = sigma
            self.label = label

        def Density(self, xs):
            return scipy.stats.norm.pdf(xs, self.mu, self.sigma)

        def GetLinspace(self):
            low, high = self.mu-3*self.sigma, self.mu+3*self.sigma
            return np.linspace(low, high, 101)

<span style="font-size:medium">The NormalPdf object contains the
parameters <span style="font-family:monospace">mu</span> and <span
style="font-family:monospace">sigma</span>. <span
style="font-family:monospace">Density</span> uses <span
style="font-family:monospace">scipy.stats.norm</span>, which is an
object that represents a normal distribution and provides <span
style="font-family:monospace">cdf</span> and <span
style="font-family:monospace">pdf</span>, among other methods (see
Section </span>[<span
style="font-size:medium">5.2</span>](thinkstats2006.html#normal)<span
style="font-size:medium">). </span><span id="hevea_default486"></span>

<span style="font-size:medium">The following example creates a NormalPdf
with the mean and variance of adult female heights, in cm, from the
BRFSS (see Section </span>[<span
style="font-size:medium">5.4</span>](thinkstats2006.html#brfss)<span
style="font-size:medium">). Then it computes the density of the
distribution at a location one standard deviation from the mean.
</span><span id="hevea_default487"></span>

    >>> mean, var = 163, 52.8
    >>> std = math.sqrt(var)
    >>> pdf = thinkstats2.NormalPdf(mean, std)
    >>> pdf.Density(mean + std)
    0.0333001

<span style="font-size:medium">The result is about 0.03, in units of
probability mass per cm. Again, a probability density doesn’t mean much
by itself. But if we plot the Pdf, we can see the shape of the
distribution:</span>

    >>> thinkplot.Pdf(pdf, label='normal')
    >>> thinkplot.Show()

<span style="font-size:medium"><span
style="font-family:monospace">thinkplot.Pdf</span> plots the Pdf as a
smooth function, as contrasted with <span
style="font-family:monospace">thinkplot.Pmf</span>, which renders a Pmf
as a step function. Figure </span>[<span
style="font-size:medium">6.1</span>](#pdf_example)<span
style="font-size:medium"> shows the result, as well as a PDF estimated
from a sample, which we’ll compute in the next section. </span><span
id="hevea_default488"></span>

<span style="font-size:medium">You can use <span
style="font-family:monospace">MakePmf</span> to approximate the
Pdf:</span>

    >>> pmf = pdf.MakePmf()

<span style="font-size:medium">By default, the resulting Pmf contains
101 points equally spaced from <span style="font-family:monospace">mu -
3\*sigma</span> to <span style="font-family:monospace">mu +
3\*sigma</span>. Optionally, <span
style="font-family:monospace">MakePmf</span> and <span
style="font-family:monospace">Render</span> can take keyword arguments
<span style="font-family:monospace">low</span>, <span
style="font-family:monospace">high</span>, and <span
style="font-family:monospace">n</span>.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2025.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 6.1: A normal PDF that models adult female height in the U.S., and the kernel density estimate of a sample with <span style="font-style:italic">n</span>=500.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="pdf_example"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.2  Kernel density estimation</span>
--------------------------------------------------------------------

<span style="font-size:medium"><span style="font-weight:bold">Kernel
density estimation</span> (KDE) is an algorithm that takes a sample and
finds an appropriately smooth PDF that fits the data. You can read
details at </span>[<span
style="font-family:monospace;font-size:medium">http://en.wikipedia.org/wiki/Kernel\_density\_estimation</span>](http://en.wikipedia.org/wiki/Kernel_density_estimation)<span
style="font-size:medium">. </span><span
id="hevea_default489"></span><span style="font-size:medium">
</span><span id="hevea_default490"></span>

<span style="font-size:medium"><span
style="font-family:monospace">scipy</span> provides an implementation of
KDE and <span style="font-family:monospace">thinkstats2</span> provides
a class called <span style="font-family:monospace">EstimatedPdf</span>
that uses it: </span><span id="hevea_default491"></span><span
style="font-size:medium"> </span><span id="hevea_default492"></span>

    class EstimatedPdf(Pdf):

        def __init__(self, sample):
            self.kde = scipy.stats.gaussian_kde(sample)

        def Density(self, xs):
            return self.kde.evaluate(xs)

<span style="font-size:medium">`__init__` takes a sample and computes a
kernel density estimate. The result is a `gaussian_kde` object that
provides an <span style="font-family:monospace">evaluate</span>
method.</span>

<span style="font-size:medium"><span
style="font-family:monospace">Density</span> takes a value or sequence,
calls `gaussian_kde.evaluate`, and returns the resulting density. The
word “Gaussian” appears in the name because it uses a filter based on a
Gaussian distribution to smooth the KDE. </span><span
id="hevea_default493"></span>

<span style="font-size:medium">Here’s an example that generates a sample
from a normal distribution and then makes an EstimatedPdf to fit it:
</span><span id="hevea_default494"></span><span
style="font-size:medium"> </span><span id="hevea_default495"></span>

    >>> sample = [random.gauss(mean, std) for i in range(500)]
    >>> sample_pdf = thinkstats2.EstimatedPdf(sample)
    >>> thinkplot.Pdf(sample_pdf, label='sample KDE')

<span style="font-size:medium">`sample` is a list of 500 random heights.
`sample_pdf` is a Pdf object that contains the estimated KDE of the
sample. </span><span id="hevea_default496"></span><span
style="font-size:medium"> </span><span id="hevea_default497"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">6.1</span>](#pdf_example)<span
style="font-size:medium"> shows the normal density function and a KDE
based on a sample of 500 random heights. The estimate is a good match
for the original distribution.</span>

<span style="font-size:medium">Estimating a density function with KDE is
useful for several purposes:</span>

-   <span style="font-size:medium"><span
    style="font-style:italic">Visualization:</span> During the
    exploration phase of a project, CDFs are usually the best
    visualization of a distribution. After you look at a CDF, you can
    decide whether an estimated PDF is an appropriate model of the
    distribution. If so, it can be a better choice for presenting the
    distribution to an audience that is unfamiliar with CDFs.
    </span><span id="hevea_default498"></span><span
    style="font-size:medium"> </span><span id="hevea_default499"></span>
-   <span style="font-size:medium"><span
    style="font-style:italic">Interpolation:</span> An estimated PDF is
    a way to get from a sample to a model of the population. If you have
    reason to believe that the population distribution is smooth, you
    can use KDE to interpolate the density for values that don’t appear
    in the sample. </span><span id="hevea_default500"></span>
-   <span style="font-size:medium"><span
    style="font-style:italic">Simulation:</span> Simulations are often
    based on the distribution of a sample. If the sample size is small,
    it might be appropriate to smooth the sample distribution using KDE,
    which allows the simulation to explore more possible outcomes,
    rather than replicating the observed data. </span><span
    id="hevea_default501"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.3  The distribution framework</span>
---------------------------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default502"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2026.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 6.2: A framework that relates representations of distribution functions.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="dist_framework"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">At this point we have seen PMFs, CDFs and
PDFs; let’s take a minute to review. Figure </span>[<span
style="font-size:medium">6.2</span>](#dist_framework)<span
style="font-size:medium"> shows how these functions relate to each
other. </span><span id="hevea_default503"></span><span
style="font-size:medium"> </span><span
id="hevea_default504"></span><span style="font-size:medium">
</span><span id="hevea_default505"></span>

<span style="font-size:medium">We started with PMFs, which represent the
probabilities for a discrete set of values. To get from a PMF to a CDF,
you add up the probability masses to get cumulative probabilities. To
get from a CDF back to a PMF, you compute differences in cumulative
probabilities. We’ll see the implementation of these operations in the
next few sections. </span><span id="hevea_default506"></span>

<span style="font-size:medium">A PDF is the derivative of a continuous
CDF; or, equivalently, a CDF is the integral of a PDF. Remember that a
PDF maps from values to probability densities; to get a probability, you
have to integrate. </span><span id="hevea_default507"></span><span
style="font-size:medium"> </span><span
id="hevea_default508"></span><span style="font-size:medium">
</span><span id="hevea_default509"></span>

<span style="font-size:medium">To get from a discrete to a continuous
distribution, you can perform various kinds of smoothing. One form of
smoothing is to assume that the data come from an analytic continuous
distribution (like exponential or normal) and to estimate the parameters
of that distribution. Another option is kernel density estimation.
</span><span id="hevea_default510"></span><span
style="font-size:medium"> </span><span
id="hevea_default511"></span><span style="font-size:medium">
</span><span id="hevea_default512"></span><span
style="font-size:medium"> </span><span
id="hevea_default513"></span><span style="font-size:medium">
</span><span id="hevea_default514"></span><span
style="font-size:medium"> </span><span id="hevea_default515"></span>

<span style="font-size:medium">The opposite of smoothing is <span
style="font-weight:bold">discretizing</span>, or quantizing. If you
evaluate a PDF at discrete points, you can generate a PMF that is an
approximation of the PDF. You can get a better approximation using
numerical integration. </span><span id="hevea_default516"></span><span
style="font-size:medium"> </span><span
id="hevea_default517"></span><span style="font-size:medium">
</span><span id="hevea_default518"></span>

<span style="font-size:medium">To distinguish between continuous and
discrete CDFs, it might be better for a discrete CDF to be a “cumulative
mass function,” but as far as I can tell no one uses that term.
</span><span id="hevea_default519"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.4  Hist implementation</span>
--------------------------------------------------------------

<span style="font-size:medium">At this point you should know how to use
the basic types provided by <span
style="font-family:monospace">thinkstats2</span>: Hist, Pmf, Cdf, and
Pdf. The next few sections provide details about how they are
implemented. This material might help you use these classes more
effectively, but it is not strictly necessary. </span><span
id="hevea_default520"></span>

<span style="font-size:medium">Hist and Pmf inherit from a parent class
called `_DictWrapper`. The leading underscore indicates that this class
is “internal;” that is, it should not be used by code in other modules.
The name indicates what it is: a dictionary wrapper. Its primary
attribute is <span style="font-family:monospace">d</span>, the
dictionary that maps from values to their frequencies. </span><span
id="hevea_default521"></span><span style="font-size:medium">
</span><span id="hevea_default522"></span><span
style="font-size:medium"> </span><span id="hevea_default523"></span>

<span style="font-size:medium">The values can be any hashable type. The
frequencies should be integers, but can be any numeric type.
</span><span id="hevea_default524"></span>

<span style="font-size:medium">`_DictWrapper` contains methods
appropriate for both Hist and Pmf, including `__init__`, <span
style="font-family:monospace">Values</span>, <span
style="font-family:monospace">Items</span> and <span
style="font-family:monospace">Render</span>. It also provides modifier
methods <span style="font-family:monospace">Set</span>, <span
style="font-family:monospace">Incr</span>, <span
style="font-family:monospace">Mult</span>, and <span
style="font-family:monospace">Remove</span>. These methods are all
implemented with dictionary operations. For example: </span><span
id="hevea_default525"></span>

    # class _DictWrapper

        def Incr(self, x, term=1):
            self.d[x] = self.d.get(x, 0) + term

        def Mult(self, x, factor):
            self.d[x] = self.d.get(x, 0) * factor

        def Remove(self, x):
            del self.d[x]

<span style="font-size:medium">Hist also provides <span
style="font-family:monospace">Freq</span>, which looks up the frequency
of a given value. </span><span id="hevea_default526"></span>

<span style="font-size:medium">Because Hist operators and methods are
based on dictionaries, these methods are constant time operations; that
is, their run time does not increase as the Hist gets bigger.
</span><span id="hevea_default527"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.5  Pmf implementation</span>
-------------------------------------------------------------

<span style="font-size:medium">Pmf and Hist are almost the same thing,
except that a Pmf maps values to floating-point probabilities, rather
than integer frequencies. If the sum of the probabilities is 1, the Pmf
is normalized. </span><span id="hevea_default528"></span>

<span style="font-size:medium">Pmf provides <span
style="font-family:monospace">Normalize</span>, which computes the sum
of the probabilities and divides through by a factor:</span>

    # class Pmf

        def Normalize(self, fraction=1.0):
            total = self.Total()
            if total == 0.0:
                raise ValueError('Total probability is zero.')

            factor = float(fraction) / total
            for x in self.d:
                self.d[x] *= factor

            return total

<span style="font-size:medium"><span
style="font-family:monospace">fraction</span> determines the sum of the
probabilities after normalizing; the default value is 1. If the total
probability is 0, the Pmf cannot be normalized, so <span
style="font-family:monospace">Normalize</span> raises <span
style="font-family:monospace">ValueError</span>.</span>

<span style="font-size:medium">Hist and Pmf have the same constructor.
It can take as an argument a <span
style="font-family:monospace">dict</span>, Hist, Pmf or Cdf, a pandas
Series, a list of (value, frequency) pairs, or a sequence of values.
</span><span id="hevea_default529"></span>

<span style="font-size:medium">If you instantiate a Pmf, the result is
normalized. If you instantiate a Hist, it is not. To construct an
unnormalized Pmf, you can create an empty Pmf and modify it. The Pmf
modifiers do not renormalize the Pmf.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.6  Cdf implementation</span>
-------------------------------------------------------------

<span style="font-size:medium">A CDF maps from values to cumulative
probabilities, so I could have implemented Cdf as a `_DictWrapper`. But
the values in a CDF are ordered and the values in a `_DictWrapper` are
not. Also, it is often useful to compute the inverse CDF; that is, the
map from cumulative probability to value. So the implementaion I chose
is two sorted lists. That way I can use binary search to do a forward or
inverse lookup in logarithmic time. </span><span
id="hevea_default530"></span><span style="font-size:medium">
</span><span id="hevea_default531"></span><span
style="font-size:medium"> </span><span
id="hevea_default532"></span><span style="font-size:medium">
</span><span id="hevea_default533"></span><span
style="font-size:medium"> </span><span
id="hevea_default534"></span><span style="font-size:medium">
</span><span id="hevea_default535"></span>

<span style="font-size:medium">The Cdf constructor can take as a
parameter a sequence of values or a pandas Series, a dictionary that
maps from values to probabilities, a sequence of (value, probability)
pairs, a Hist, Pmf, or Cdf. Or if it is given two parameters, it treats
them as a sorted sequence of values and the sequence of corresponding
cumulative probabilities.</span>

<span style="font-size:medium">Given a sequence, pandas Series, or
dictionary, the constructor makes a Hist. Then it uses the Hist to
initialize the attributes:</span>

            self.xs, freqs = zip(*sorted(dw.Items()))
            self.ps = np.cumsum(freqs, dtype=np.float)
            self.ps /= self.ps[-1]

<span style="font-size:medium"><span
style="font-family:monospace">xs</span> is the sorted list of values;
<span style="font-family:monospace">freqs</span> is the list of
corresponding frequencies. <span
style="font-family:monospace">np.cumsum</span> computes the cumulative
sum of the frequencies. Dividing through by the total frequency yields
cumulative probabilities. For <span
style="font-family:monospace">n</span> values, the time to construct the
Cdf is proportional to <span style="font-style:italic">n</span> log<span
style="font-style:italic">n</span>. </span><span
id="hevea_default536"></span>

<span style="font-size:medium">Here is the implementation of <span
style="font-family:monospace">Prob</span>, which takes a value and
returns its cumulative probability: </span>

    # class Cdf
        def Prob(self, x):
            if x < self.xs[0]:
                return 0.0
            index = bisect.bisect(self.xs, x)
            p = self.ps[index - 1]
            return p

<span style="font-size:medium">The <span
style="font-family:monospace">bisect</span> module provides an
implementation of binary search. And here is the implementation of <span
style="font-family:monospace">Value</span>, which takes a cumulative
probability and returns the corresponding value:</span>

    # class Cdf
        def Value(self, p):
            if p < 0 or p > 1:
                raise ValueError('p must be in range [0, 1]')

            index = bisect.bisect_left(self.ps, p)
            return self.xs[index]

<span style="font-size:medium">Given a Cdf, we can compute the Pmf by
computing differences between consecutive cumulative probabilities. If
you call the Cdf constructor and pass a Pmf, it computes differences by
calling <span style="font-family:monospace">Cdf.Items</span>:
</span><span id="hevea_default537"></span><span
style="font-size:medium"> </span><span id="hevea_default538"></span>

    # class Cdf
        def Items(self):
            a = self.ps
            b = np.roll(a, 1)
            b[0] = 0
            return zip(self.xs, a-b)

<span style="font-size:medium"><span
style="font-family:monospace">np.roll</span> shifts the elements of
<span style="font-family:monospace">a</span> to the right, and “rolls”
the last one back to the beginning. We replace the first element of
<span style="font-family:monospace">b</span> with 0 and then compute the
difference <span style="font-family:monospace">a-b</span>. The result is
a NumPy array of probabilities. </span><span
id="hevea_default539"></span>

<span style="font-size:medium">Cdf provides <span
style="font-family:monospace">Shift</span> and <span
style="font-family:monospace">Scale</span>, which modify the values in
the Cdf, but the probabilities should be treated as immutable.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.7  Moments</span>
--------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default540"></span>

<span style="font-size:medium">Any time you take a sample and reduce it
to a single number, that number is a statistic. The statistics we have
seen so far include mean, variance, median, and interquartile
range.</span>

<span style="font-size:medium">A <span style="font-weight:bold">raw
moment</span> is a kind of statistic. If you have a sample of values,
<span style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, the <span
style="font-style:italic">k</span>th raw moment is: </span>

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
<td><span style="font-size:medium"><span style="font-style:italic">m</span>′</span><sub><span style="font-style:italic;font-size:medium">k</span></sub><span style="font-size:medium"> = </span></td>
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
<td><span style="font-size:medium"> <span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><sup><span style="font-style:italic;font-size:medium">k</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Or if you prefer Python notation:</span>

    def RawMoment(xs, k):
        return sum(x**k for x in xs) / len(xs)

<span style="font-size:medium">When <span
style="font-style:italic">k</span>=1 the result is the sample mean,
<span style="text-decoration:overline">x</span>. The other raw moments
don’t mean much by themselves, but they are used in some
computations.</span>

<span style="font-size:medium">The <span
style="font-weight:bold">central moments</span> are more useful. The
<span style="font-style:italic">k</span>th central moment is: </span>

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
<td><span style="font-style:italic;font-size:medium">m</span><sub><span style="font-style:italic;font-size:medium">k</span></sub><span style="font-size:medium"> = </span></td>
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
<td><span style="font-size:medium"> (<span style="font-style:italic">x</span></span><sub><span style="font-style:italic;font-size:medium">i</span></sub><span style="font-size:medium"> − <span style="text-decoration:overline">x</span>)</span><sup><span style="font-style:italic;font-size:medium">k</span></sup><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Or in Python:</span>

    def CentralMoment(xs, k):
        mean = RawMoment(xs, 1)
        return sum((x - mean)**k for x in xs) / len(xs)

<span style="font-size:medium">When <span
style="font-style:italic">k</span>=2 the result is the second central
moment, which you might recognize as variance. The definition of
variance gives a hint about why these statistics are called moments. If
we attach a weight along a ruler at each location, <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, and then spin the ruler around the mean, the
moment of inertia of the spinning weights is the variance of the values.
If you are not familiar with moment of inertia, see </span>[<span
style="font-family:monospace;font-size:medium">http://en.wikipedia.org/wiki/Moment\_of\_inertia</span>](http://en.wikipedia.org/wiki/Moment_of_inertia)<span
style="font-size:medium">. </span><span id="hevea_default541"></span>

<span style="font-size:medium">When you report moment-based statistics,
it is important to think about the units. For example, if the values
<span style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium"> are in cm, the first raw moment is also in cm.
But the second moment is in cm</span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">,
the third moment is in cm</span><sup><span
style="font-size:medium">3</span></sup><span style="font-size:medium">,
and so on.</span>

<span style="font-size:medium">Because of these units, moments are hard
to interpret by themselves. That’s why, for the second moment, it is
common to report standard deviation, which is the square root of
variance, so it is in the same units as <span
style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">. </span><span id="hevea_default542"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.8  Skewness</span>
---------------------------------------------------

<span style="font-size:medium"> </span><span
id="hevea_default543"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Skewness</span> is a property that describes
the shape of a distribution. If the distribution is symmetric around its
central tendency, it is unskewed. If the values extend farther to the
right, it is “right skewed” and if the values extend left, it is “left
skewed.” </span><span id="hevea_default544"></span>

<span style="font-size:medium">This use of “skewed” does not have the
usual connotation of “biased.” Skewness only describes the shape of the
distribution; it says nothing about whether the sampling process might
have been biased. </span><span id="hevea_default545"></span><span
style="font-size:medium"> </span><span id="hevea_default546"></span>

<span style="font-size:medium">Several statistics are commonly used to
quantify the skewness of a distribution. Given a sequence of values,
<span style="font-style:italic">x</span></span><sub><span
style="font-style:italic;font-size:medium">i</span></sub><span
style="font-size:medium">, the <span style="font-weight:bold">sample
skewness</span>, <span
style="font-style:italic">g</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">,
can be computed like this:</span>

    def StandardizedMoment(xs, k):
        var = CentralMoment(xs, 2)
        std = math.sqrt(var)
        return CentralMoment(xs, k) / std**k

    def Skewness(xs):
        return StandardizedMoment(xs, 3)

<span style="font-style:italic;font-size:medium">g</span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
is the third <span style="font-weight:bold">standardized moment</span>,
which means that it has been normalized so it has no units. </span><span
id="hevea_default547"></span>

<span style="font-size:medium">Negative skewness indicates that a
distribution skews left; positive skewness indicates that a distribution
skews right. The magnitude of <span
style="font-style:italic">g</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">
indicates the strength of the skewness, but by itself it is not easy to
interpret.</span>

<span style="font-size:medium">In practice, computing sample skewness is
usually not a good idea. If there are any outliers, they have a
disproportionate effect on <span
style="font-style:italic">g</span></span><sub><span
style="font-size:medium">1</span></sub><span style="font-size:medium">.
</span><span id="hevea_default548"></span>

<span style="font-size:medium">Another way to evaluate the asymmetry of
a distribution is to look at the relationship between the mean and
median. Extreme values have more effect on the mean than the median, so
in a distribution that skews left, the mean is less than the median. In
a distribution that skews right, the mean is greater. </span><span
id="hevea_default549"></span><span style="font-size:medium">
</span><span id="hevea_default550"></span>

<span style="font-size:medium"><span style="font-weight:bold">Pearson’s
median skewness coefficient</span> is a measure of skewness based on the
difference between the sample mean and median: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-style:italic;font-size:medium">g</span><sub><span style="font-style:italic;font-size:medium">p</span></sub><span style="font-size:medium"> = 3 (<span style="text-decoration:overline">x</span> − <span style="font-style:italic">m</span>) / <span style="font-style:italic">S</span> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> Where <span
style="text-decoration:overline">x</span> is the sample mean, <span
style="font-style:italic">m</span> is the median, and <span
style="font-style:italic">S</span> is the standard deviation. Or in
Python: </span><span id="hevea_default551"></span>

    def Median(xs):
        cdf = thinkstats2.Cdf(xs)
        return cdf.Value(0.5)

    def PearsonMedianSkewness(xs):
        median = Median(xs)
        mean = RawMoment(xs, 1)
        var = CentralMoment(xs, 2)
        std = math.sqrt(var)
        gp = 3 * (mean - median) / std
        return gp

<span style="font-size:medium">This statistic is <span
style="font-weight:bold">robust</span>, which means that it is less
vulnerable to the effect of outliers. </span><span
id="hevea_default552"></span><span style="font-size:medium">
</span><span id="hevea_default553"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2027.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 6.3: Estimated PDF of birthweight data from the NSFG.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="density_totalwgt_kde"></span><span style="font-size:medium">
> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">As an example, let’s look at the skewness
of birth weights in the NSFG pregnancy data. Here’s the code to estimate
and plot the PDF: </span><span id="hevea_default554"></span>

        live, firsts, others = first.MakeFrames()
        data = live.totalwgt_lb.dropna()
        pdf = thinkstats2.EstimatedPdf(data)
        thinkplot.Pdf(pdf, label='birth weight')

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">6.3</span>](#density_totalwgt_kde)<span
style="font-size:medium"> shows the result. The left tail appears longer
than the right, so we suspect the distribution is skewed left. The mean,
7.27 lbs, is a bit less than the median, 7.38 lbs, so that is consistent
with left skew. And both skewness coefficients are negative: sample
skewness is -0.59; Pearson’s median skewness is -0.23. </span><span
id="hevea_default555"></span><span style="font-size:medium">
</span><span id="hevea_default556"></span><span
style="font-size:medium"> </span><span id="hevea_default557"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2028.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 6.4: Estimated PDF of adult weight data from the BRFSS.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="density_wtkg2_kde"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Now let’s compare this distribution to
the distribution of adult weight in the BRFSS. Again, here’s the code:
</span><span id="hevea_default558"></span>

        df = brfss.ReadBrfss(nrows=None)
        data = df.wtkg2.dropna()
        pdf = thinkstats2.EstimatedPdf(data)
        thinkplot.Pdf(pdf, label='adult weight')

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">6.4</span>](#density_wtkg2_kde)<span
style="font-size:medium"> shows the result. The distribution appears
skewed to the right. Sure enough, the mean, 79.0, is bigger than the
median, 77.3. The sample skewness is 1.1 and Pearson’s median skewness
is 0.26. </span><span id="hevea_default559"></span><span
style="font-size:medium"> </span><span id="hevea_default560"></span>

<span style="font-size:medium">The sign of the skewness coefficient
indicates whether the distribution skews left or right, but other than
that, they are hard to interpret. Sample skewness is less robust; that
is, it is more susceptible to outliers. As a result it is less reliable
when applied to skewed distributions, exactly when it would be most
relevant. </span><span id="hevea_default561"></span><span
style="font-size:medium"> </span><span id="hevea_default562"></span>

<span style="font-size:medium">Pearson’s median skewness is based on a
computed mean and variance, so it is also susceptible to outliers, but
since it does not depend on a third moment, it is somewhat more robust.
</span><span id="hevea_default563"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.9  Exercises</span>
----------------------------------------------------

<span style="font-size:medium">A solution to this exercise is in
`chap06soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>  </span>

<span style="font-size:medium">*The distribution of income is famously
skewed to the right. In this exercise, we’ll measure how strong that
skew is.* </span><span id="hevea_default564"></span><span
style="font-size:medium"> </span><span id="hevea_default565"></span>

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
style="font-family:monospace">hinc2.py</span>, which reads this file and
transforms the data.* </span><span id="hevea_default566"></span><span
style="font-size:medium"> </span><span
id="hevea_default567"></span><span style="font-size:medium">
</span><span id="hevea_default568"></span>

<span style="font-size:medium">*The dataset is in the form of a series
of income ranges and the number of respondents who fell in each range.
The lowest range includes respondents who reported annual household
income “Under $5000.” The highest range includes respondents who made
“$250,000 or more.”*</span>

<span style="font-size:medium">*To estimate mean and other statistics
from these data, we have to make some assumptions about the lower and
upper bounds, and how the values are distributed in each range. <span
style="font-family:monospace">hinc2.py</span> provides <span
style="font-family:monospace">InterpolateSample</span>, which shows one
way to model this data. It takes a DataFrame with a column, <span
style="font-family:monospace">income</span>, that contains the upper
bound of each range, and <span
style="font-family:monospace">freq</span>, which contains the number of
respondents in each frame.* </span><span
id="hevea_default569"></span><span style="font-size:medium">
</span><span id="hevea_default570"></span>

<span style="font-size:medium">*It also takes `log_upper`, which is an
assumed upper bound on the highest range, expressed in <span
style="font-family:monospace">log10</span> dollars. The default value,
`log_upper=6.0` represents the assumption that the largest income among
the respondents is* 10</span><sup><span
style="font-size:medium">6</span></sup><span style="font-size:medium">*,
or one million dollars.*</span>

<span style="font-size:medium">*<span
style="font-family:monospace">InterpolateSample</span> generates a
pseudo-sample; that is, a sample of household incomes that yields the
same number of respondents in each range as the actual data. It assumes
that incomes in each range are equally spaced on a log10 scale.*</span>

<span style="font-size:medium">*Compute the median, mean, skewness and
Pearson’s skewness of the resulting sample. What fraction of households
reports a taxable income below the mean? How do the results depend on
the assumed upper bound?* </span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">6.10  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium">Probability density function (PDF):
    The derivative of a continuous CDF, a function that maps a value to
    its probability density. </span><span
    id="hevea_default571"></span><span style="font-size:medium">
    </span><span id="hevea_default572"></span>
-   <span style="font-size:medium">Probability density: A quantity that
    can be integrated over a range of values to yield a probability. If
    the values are in units of cm, for example, probability density is
    in units of probability per cm. </span><span
    id="hevea_default573"></span>
-   <span style="font-size:medium">Kernel density estimation (KDE): An
    algorithm that estimates a PDF based on a sample. </span><span
    id="hevea_default574"></span><span style="font-size:medium">
    </span><span id="hevea_default575"></span>
-   <span style="font-size:medium">discretize: To approximate a
    continuous function or distribution with a discrete function. The
    opposite of smoothing. </span><span id="hevea_default576"></span>
-   <span style="font-size:medium">raw moment: A statistic based on the
    sum of data raised to a power. </span><span
    id="hevea_default577"></span>
-   <span style="font-size:medium">central moment: A statistic based on
    deviation from the mean, raised to a power. </span><span
    id="hevea_default578"></span>
-   <span style="font-size:medium">standardized moment: A ratio of
    moments that has no units. </span><span
    id="hevea_default579"></span>
-   <span style="font-size:medium">skewness: A measure of how asymmetric
    a distribution is. </span><span id="hevea_default580"></span>
-   <span style="font-size:medium">sample skewness: A moment-based
    statistic intended to quantify the skewness of a distribution.
    </span><span id="hevea_default581"></span>
-   <span style="font-size:medium">Pearson’s median skewness
    coefficient: A statistic intended to quantify the skewness of a
    distribution based on the median, mean, and standard deviation.
    </span><span id="hevea_default582"></span>
-   <span style="font-size:medium">robust: A statistic is robust if it
    is relatively immune to the effect of outliers. </span><span
    id="hevea_default583"></span>

<span style="font-size:medium"> </span>
