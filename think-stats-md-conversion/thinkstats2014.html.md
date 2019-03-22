This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 13  Survival analysis</span>
===================================================================

<span style="font-size:medium"><span style="font-weight:bold">Survival
analysis</span> is a way to describe how long things last. It is often
used to study human lifetimes, but it also applies to “survival” of
mechanical and electronic components, or more generally to intervals in
time before an event. </span><span id="hevea_default1541"></span><span
style="font-size:medium"> </span><span
id="hevea_default1542"></span><span style="font-size:medium">
</span><span id="hevea_default1543"></span>

<span style="font-size:medium">If someone you know has been diagnosed
with a life-threatening disease, you might have seen a “5-year survival
rate,” which is the probability of surviving five years after diagnosis.
That estimate and related statistics are the result of survival
analysis. </span><span id="hevea_default1544"></span>

<span style="font-size:medium">The code in this chapter is in <span
style="font-family:monospace">survival.py</span>. For information about
downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.1  Survival curves</span>
-----------------------------------------------------------

<span style="font-size:medium"> </span><span id="survival"></span>

<span style="font-size:medium">The fundamental concept in survival
analysis is the <span style="font-weight:bold">survival curve</span>,
<span style="font-style:italic">S</span>(<span
style="font-style:italic">t</span>), which is a function that maps from
a duration, <span style="font-style:italic">t</span>, to the probability
of surviving longer than <span style="font-style:italic">t</span>. If
you know the distribution of durations, or “lifetimes”, finding the
survival curve is easy; it’s just the complement of the CDF:
</span><span id="hevea_default1545"></span><span
style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium"><span style="font-style:italic">S</span>(<span style="font-style:italic">t</span>) = 1 − <span style="font-style:italic">CDF</span>(<span style="font-style:italic">t</span>) </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> where <span
style="font-style:italic">CDF</span>(<span
style="font-style:italic">t</span>) is the probability of a lifetime
less than or equal to <span style="font-style:italic">t</span>.
</span><span id="hevea_default1546"></span><span
style="font-size:medium"> </span><span
id="hevea_default1547"></span><span style="font-size:medium">
</span><span id="hevea_default1548"></span>

<span style="font-size:medium">For example, in the NSFG dataset, we know
the duration of 11189 complete pregnancies. We can read this data and
compute the CDF: </span><span id="hevea_default1549"></span>

        preg = nsfg.ReadFemPreg()
        complete = preg.query('outcome in [1, 3, 4]').prglngth
        cdf = thinkstats2.Cdf(complete, label='cdf')

<span style="font-size:medium">The outcome codes <span
style="font-family:monospace">1, 3, 4</span> indicate live birth,
stillbirth, and miscarriage. For this analysis I am excluding induced
abortions, ectopic pregnancies, and pregnancies that were in progress
when the respondent was interviewed.</span>

<span style="font-size:medium">The DataFrame method <span
style="font-family:monospace">query</span> takes a boolean expression
and evaluates it for each row, selecting the rows that yield True.
</span><span id="hevea_default1550"></span><span
style="font-size:medium"> </span><span
id="hevea_default1551"></span><span style="font-size:medium">
</span><span id="hevea_default1552"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2046.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.1: Cdf and survival curve for pregnancy length (top), hazard curve (bottom).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.1</span>](#survival1)<span
style="font-size:medium"> (top) shows the CDF of pregnancy length and
its complement, the survival curve. To represent the survival curve, I
define an object that wraps a Cdf and adapts the interface: </span><span
id="hevea_default1553"></span><span style="font-size:medium">
</span><span id="hevea_default1554"></span><span
style="font-size:medium"> </span><span id="hevea_default1555"></span>

    class SurvivalFunction(object):
        def __init__(self, cdf, label=''):
            self.cdf = cdf
            self.label = label or cdf.label

        @property
        def ts(self):
            return self.cdf.xs

        @property
        def ss(self):
            return 1 - self.cdf.ps

<span style="font-size:medium"><span
style="font-family:monospace">SurvivalFunction</span> provides two
properties: <span style="font-family:monospace">ts</span>, which is the
sequence of lifetimes, and <span
style="font-family:monospace">ss</span>, which is the survival curve. In
Python, a “property” is a method that can be invoked as if it were a
variable.</span>

<span style="font-size:medium">We can instantiate a <span
style="font-family:monospace">SurvivalFunction</span> by passing the CDF
of lifetimes: </span><span id="hevea_default1556"></span>

        sf = SurvivalFunction(cdf)

<span style="font-size:medium"><span
style="font-family:monospace">SurvivalFunction</span> also provides
`__getitem__` and <span style="font-family:monospace">Prob</span>, which
evaluates the survival curve:</span>

    # class SurvivalFunction

        def __getitem__(self, t):
            return self.Prob(t)

        def Prob(self, t):
            return 1 - self.cdf.Prob(t)

<span style="font-size:medium">For example, <span
style="font-family:monospace">sf\[13\]</span> is the fraction of
pregnancies that proceed past the first trimester: </span><span
id="hevea_default1557"></span>

    >>> sf[13]
    0.86022
    >>> cdf[13]
    0.13978

<span style="font-size:medium">About 86% of pregnancies proceed past the
first trimester; about 14% do not.</span>

<span style="font-size:medium"><span
style="font-family:monospace">SurvivalFunction</span> provides <span
style="font-family:monospace">Render</span>, so we can plot <span
style="font-family:monospace">sf</span> using the functions in <span
style="font-family:monospace">thinkplot</span>: </span><span
id="hevea_default1558"></span>

        thinkplot.Plot(sf)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.1</span>](#survival1)<span
style="font-size:medium"> (top) shows the result. The curve is nearly
flat between 13 and 26 weeks, which shows that few pregnancies end in
the second trimester. And the curve is steepest around 39 weeks, which
is the most common pregnancy length. </span><span
id="hevea_default1559"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.2  Hazard function</span>
-----------------------------------------------------------

<span style="font-size:medium"> </span><span id="hazard"></span>

<span style="font-size:medium">From the survival curve we can derive the
<span style="font-weight:bold">hazard function</span>; for pregnancy
lengths, the hazard function maps from a time, <span
style="font-style:italic">t</span>, to the fraction of pregnancies that
continue until <span style="font-style:italic">t</span> and then end at
<span style="font-style:italic">t</span>. To be more precise: </span>

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">λ(<span style="font-style:italic">t</span>) = </span></td>
<td><table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">S</span>(<span style="font-style:italic">t</span>) − <span style="font-style:italic">S</span>(<span style="font-style:italic">t</span>+1)</span></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium"><span style="font-style:italic">S</span>(<span style="font-style:italic">t</span>)</span></td>
</tr>
</tbody>
</table></td>
<td><span style="font-size:medium"> </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The numerator is the fraction of
lifetimes that end at <span style="font-style:italic">t</span>, which is
also <span style="font-style:italic">PMF</span>(<span
style="font-style:italic">t</span>). </span><span
id="hevea_default1560"></span>

<span style="font-size:medium"><span
style="font-family:monospace">SurvivalFunction</span> provides <span
style="font-family:monospace">MakeHazard</span>, which calculates the
hazard function:</span>

    # class SurvivalFunction

        def MakeHazard(self, label=''):
            ss = self.ss
            lams = {}
            for i, t in enumerate(self.ts[:-1]):
                hazard = (ss[i] - ss[i+1]) / ss[i]
                lams[t] = hazard

            return HazardFunction(lams, label=label)

<span style="font-size:medium">The <span
style="font-family:monospace">HazardFunction</span> object is a wrapper
for a pandas Series: </span><span id="hevea_default1561"></span><span
style="font-size:medium"> </span><span
id="hevea_default1562"></span><span style="font-size:medium">
</span><span id="hevea_default1563"></span>

    class HazardFunction(object):

        def __init__(self, d, label=''):
            self.series = pandas.Series(d)
            self.label = label

<span style="font-size:medium"><span
style="font-family:monospace">d</span> can be a dictionary or any other
type that can initialize a Series, including another Series. <span
style="font-family:monospace">label</span> is a string used to identify
the HazardFunction when plotted. </span><span
id="hevea_default1564"></span>

<span style="font-size:medium"><span
style="font-family:monospace">HazardFunction</span> provides
`__getitem__`, so we can evaluate it like this:</span>

    >>> hf = sf.MakeHazard()
    >>> hf[39]
    0.49689

<span style="font-size:medium">So of all pregnancies that proceed until
week 39, about 50% end in week 39.</span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.1</span>](#survival1)<span
style="font-size:medium"> (bottom) shows the hazard function for
pregnancy lengths. For times after week 42, the hazard function is
erratic because it is based on a small number of cases. Other than that
the shape of the curve is as expected: it is highest around 39 weeks,
and a little higher in the first trimester than in the second.
</span><span id="hevea_default1565"></span>

<span style="font-size:medium">The hazard function is useful in its own
right, but it is also an important tool for estimating survival curves,
as we’ll see in the next section.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.3  Inferring survival curves</span>
---------------------------------------------------------------------

<span style="font-size:medium">If someone gives you the CDF of
lifetimes, it is easy to compute the survival and hazard functions. But
in many real-world scenarios, we can’t measure the distribution of
lifetimes directly. We have to infer it. </span><span
id="hevea_default1566"></span><span style="font-size:medium">
</span><span id="hevea_default1567"></span>

<span style="font-size:medium">For example, suppose you are following a
group of patients to see how long they survive after diagnosis. Not all
patients are diagnosed on the same day, so at any point in time, some
patients have survived longer than others. If some patients have died,
we know their survival times. For patients who are still alive, we don’t
know survival times, but we have a lower bound. </span><span
id="hevea_default1568"></span>

<span style="font-size:medium">If we wait until all patients are dead,
we can compute the survival curve, but if we are evaluating the
effectiveness of a new treatment, we can’t wait that long! We need a way
to estimate survival curves using incomplete information. </span><span
id="hevea_default1569"></span>

<span style="font-size:medium">As a more cheerful example, I will use
NSFG data to quantify how long respondents “survive” until they get
married for the first time. The range of respondents’ ages is 14 to 44
years, so the dataset provides a snapshot of women at different stages
in their lives. </span><span id="hevea_default1570"></span>

<span style="font-size:medium">For women who have been married, the
dataset includes the date of their first marriage and their age at the
time. For women who have not been married, we know their age when
interviewed, but have no way of knowing when or if they will get
married. </span><span id="hevea_default1571"></span>

<span style="font-size:medium">Since we know the age at first marriage
for *some* women, it might be tempting to exclude the rest and compute
the CDF of the known data. That is a bad idea. The result would be
doubly misleading: (1) older women would be overrepresented, because
they are more likely to be married when interviewed, and (2) married
women would be overrepresented! In fact, this analysis would lead to the
conclusion that all women get married, which is obviously
incorrect.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.4  Kaplan-Meier estimation</span>
-------------------------------------------------------------------

<span style="font-size:medium">In this example it is not only desirable
but necessary to include observations of unmarried women, which brings
us to one of the central algorithms in survival analysis, <span
style="font-weight:bold">Kaplan-Meier estimation</span>. </span><span
id="hevea_default1572"></span>

<span style="font-size:medium">The general idea is that we can use the
data to estimate the hazard function, then convert the hazard function
to a survival curve. To estimate the hazard function, we consider, for
each age, (1) the number of women who got married at that age and (2)
the number of women “at risk” of getting married, which includes all
women who were not married at an earlier age. </span><span
id="hevea_default1573"></span><span style="font-size:medium">
</span><span id="hevea_default1574"></span>

<span style="font-size:medium">Here’s the code:</span>

    def EstimateHazardFunction(complete, ongoing, label=''):

        hist_complete = Counter(complete)
        hist_ongoing = Counter(ongoing)

        ts = list(hist_complete | hist_ongoing)
        ts.sort()

        at_risk = len(complete) + len(ongoing)

        lams = pandas.Series(index=ts)
        for t in ts:
            ended = hist_complete[t]
            censored = hist_ongoing[t]

            lams[t] = ended / at_risk
            at_risk -= ended + censored

        return HazardFunction(lams, label=label)

<span style="font-size:medium"><span
style="font-family:monospace">complete</span> is the set of complete
observations; in this case, the ages when respondents got married. <span
style="font-family:monospace">ongoing</span> is the set of incomplete
observations; that is, the ages of unmarried women when they were
interviewed.</span>

<span style="font-size:medium">First, we precompute `hist_complete`,
which is a Counter that maps from each age to the number of women
married at that age, and `hist_ongoing` which maps from each age to the
number of unmarried women interviewed at that age.</span>

<span id="hevea_default1575"></span><span style="font-size:medium">
</span><span id="hevea_default1576"></span>

<span style="font-size:medium"><span
style="font-family:monospace">ts</span> is the union of ages when
respondents got married and ages when unmarried women were interviewed,
sorted in increasing order.</span>

<span style="font-size:medium">`at_risk` keeps track of the number of
respondents considered “at risk” at each age; initially, it is the total
number of respondents.</span>

<span style="font-size:medium">The result is stored in a Pandas <span
style="font-family:monospace">Series</span> that maps from each age to
the estimated hazard function at that age.</span>

<span style="font-size:medium">Each time through the loop, we consider
one age, <span style="font-family:monospace">t</span>, and compute the
number of events that end at <span
style="font-family:monospace">t</span> (that is, the number of
respondents married at that age) and the number of events censored at
<span style="font-family:monospace">t</span> (that is, the number of
women interviewed at <span style="font-family:monospace">t</span> whose
future marriage dates are censored). In this context, “censored” means
that the data are unavailable because of the data collection
process.</span>

<span style="font-size:medium">The estimated hazard function is the
fraction of the cases at risk that end at .</span>

<span style="font-size:medium">At the end of the loop, we subtract from
`at_risk` the number of cases that ended or were censored at <span
style="font-family:monospace">t</span>.</span>

<span style="font-size:medium">Finally, we pass <span
style="font-family:monospace">lams</span> to the <span
style="font-family:monospace">HazardFunction</span> constructor and
return the result.</span>

<span id="hevea_default1577"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.5  The marriage curve</span>
--------------------------------------------------------------

<span style="font-size:medium">To test this function, we have to do some
data cleaning and transformation. The NSFG variables we need are:
</span><span id="hevea_default1578"></span>

-   <span style="font-size:medium"><span
    style="font-family:monospace">cmbirth</span>: The respondent’s date
    of birth, known for all respondents. </span><span
    id="hevea_default1579"></span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">cmintvw</span>: The date the
    respondent was interviewed, known for all respondents.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">cmmarrhx</span>: The date the
    respondent was first married, if applicable and known.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">evrmarry</span>: 1 if the respondent
    had been married prior to the date of interview, 0 otherwise.</span>

<span style="font-size:medium">The first three variables are encoded in
“century-months”; that is, the integer number of months since December
1899. So century-month 1 is January 1900. </span><span
id="hevea_default1580"></span>

<span style="font-size:medium">First, we read the respondent file and
replace invalid values of <span
style="font-family:monospace">cmmarrhx</span>:</span>

        resp = chap01soln.ReadFemResp()
        resp.cmmarrhx.replace([9997, 9998, 9999], np.nan, inplace=True)

<span style="font-size:medium">Then we compute each respondent’s age
when married and age when interviewed: </span><span
id="hevea_default1581"></span>

        resp['agemarry'] = (resp.cmmarrhx - resp.cmbirth) / 12.0
        resp['age'] = (resp.cmintvw - resp.cmbirth) / 12.0

<span style="font-size:medium">Next we extract <span
style="font-family:monospace">complete</span>, which is the age at
marriage for women who have been married, and <span
style="font-family:monospace">ongoing</span>, which is the age at
interview for women who have not: </span><span
id="hevea_default1582"></span>

        complete = resp[resp.evrmarry==1].agemarry
        ongoing = resp[resp.evrmarry==0].age

<span style="font-size:medium">Finally we compute the hazard function.
</span><span id="hevea_default1583"></span>

        hf = EstimateHazardFunction(complete, ongoing)

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.2</span>](#survival2)<span
style="font-size:medium"> (top) shows the estimated hazard function; it
is low in the teens, higher in the 20s, and declining in the 30s. It
increases again in the 40s, but that is an artifact of the estimation
process; as the number of respondents “at risk” decreases, a small
number of women getting married yields a large estimated hazard. The
survival curve will smooth out this noise. </span><span
id="hevea_default1584"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.6  Estimating the survival curve</span>
-------------------------------------------------------------------------

<span style="font-size:medium">Once we have the hazard function, we can
estimate the survival curve. The chance of surviving past time <span
style="font-family:monospace">t</span> is the chance of surviving all
times up through <span style="font-family:monospace">t</span>, which is
the cumulative product of the complementary hazard function: </span>

<table>
<tbody>
<tr class="odd">
<td><span style="font-size:medium">[1−λ(0)] [1−λ(1)] ... [1−λ(<span style="font-style:italic">t</span>)] </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> The <span
style="font-family:monospace">HazardFunction</span> class provides <span
style="font-family:monospace">MakeSurvival</span>, which computes this
product: </span><span id="hevea_default1585"></span><span
style="font-size:medium"> </span><span id="hevea_default1586"></span>

    # class HazardFunction:

        def MakeSurvival(self):
            ts = self.series.index
            ss = (1 - self.series).cumprod()
            cdf = thinkstats2.Cdf(ts, 1-ss)
            sf = SurvivalFunction(cdf)
            return sf

<span style="font-size:medium"><span
style="font-family:monospace">ts</span> is the sequence of times where
the hazard function is estimated. <span
style="font-family:monospace">ss</span> is the cumulative product of the
complementary hazard function, so it is the survival curve.</span>

<span style="font-size:medium">Because of the way <span
style="font-family:monospace">SurvivalFunction</span> is implemented, we
have to compute the complement of <span
style="font-family:monospace">ss</span>, make a Cdf, and then
instantiate a SurvivalFunction object. </span><span
id="hevea_default1587"></span><span style="font-size:medium">
</span><span id="hevea_default1588"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2047.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.2: Hazard function for age at first marriage (top) and survival curve (bottom).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival2"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.2</span>](#survival2)<span
style="font-size:medium"> (bottom) shows the result. The survival curve
is steepest between 25 and 35, when most women get married. Between 35
and 45, the curve is nearly flat, indicating that women who do not marry
before age 35 are unlikely to get married.</span>

<span style="font-size:medium">A curve like this was the basis of a
famous magazine article in 1986; <span
style="font-style:italic">Newsweek</span> reported that a 40-year old
unmarried woman was “more likely to be killed by a terrorist” than get
married. These statistics were widely reported and became part of
popular culture, but they were wrong then (because they were based on
faulty analysis) and turned out to be even more wrong (because of
cultural changes that were already in progress and continued). In 2006,
<span style="font-style:italic">Newsweek</span> ran an another article
admitting that they were wrong. </span><span
id="hevea_default1589"></span>

<span style="font-size:medium">I encourage you to read more about this
article, the statistics it was based on, and the reaction. It should
remind you of the ethical obligation to perform statistical analysis
with care, interpret the results with appropriate skepticism, and
present them to the public accurately and honestly. </span><span
id="hevea_default1590"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.7  Confidence intervals</span>
----------------------------------------------------------------

<span style="font-size:medium">Kaplan-Meier analysis yields a single
estimate of the survival curve, but it is also important to quantify the
uncertainty of the estimate. As usual, there are three possible sources
of error: measurement error, sampling error, and modeling error.
</span><span id="hevea_default1591"></span><span
style="font-size:medium"> </span><span
id="hevea_default1592"></span><span style="font-size:medium">
</span><span id="hevea_default1593"></span>

<span style="font-size:medium">In this example, measurement error is
probably small. People generally know when they were born, whether
they’ve been married, and when. And they can be expected to report this
information accurately. </span><span id="hevea_default1594"></span>

<span style="font-size:medium">We can quantify sampling error by
resampling. Here’s the code: </span><span id="hevea_default1595"></span>

    def ResampleSurvival(resp, iters=101):
        low, high = resp.agemarry.min(), resp.agemarry.max()
        ts = np.arange(low, high, 1/12.0)

        ss_seq = []
        for i in range(iters):
            sample = thinkstats2.ResampleRowsWeighted(resp)
            hf, sf = EstimateSurvival(sample)
            ss_seq.append(sf.Probs(ts))

        low, high = thinkstats2.PercentileRows(ss_seq, [5, 95])
        thinkplot.FillBetween(ts, low, high)

<span style="font-size:medium"><span
style="font-family:monospace">ResampleSurvival</span> takes <span
style="font-family:monospace">resp</span>, a DataFrame of respondents,
and <span style="font-family:monospace">iters</span>, the number of
times to resample. It computes <span
style="font-family:monospace">ts</span>, which is the sequence of ages
where we will evaluate the survival curves. </span><span
id="hevea_default1596"></span>

<span style="font-size:medium">Inside the loop, <span
style="font-family:monospace">ResampleSurvival</span>:</span>

-   <span style="font-size:medium">Resamples the respondents using <span
    style="font-family:monospace">ResampleRowsWeighted</span>, which we
    saw in Section </span>[<span
    style="font-size:medium">10.7</span>](thinkstats2011.html#weighted)<span
    style="font-size:medium">. </span><span
    id="hevea_default1597"></span>
-   <span style="font-size:medium">Calls <span
    style="font-family:monospace">EstimateSurvival</span>, which uses
    the process in the previous sections to estimate the hazard and
    survival curves, and</span>
-   <span style="font-size:medium">Evaluates the survival curve at each
    age in <span style="font-family:monospace">ts</span>.</span>

<span style="font-size:medium">`ss_seq` is a sequence of evaluated
survival curves. <span
style="font-family:monospace">PercentileRows</span> takes this sequence
and computes the 5th and 95th percentiles, returning a 90% confidence
interval for the survival curve. </span><span
id="hevea_default1598"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2048.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.3: Survival curve for age at first marriage (dark line) and a 90% confidence interval based on weighted resampling (gray line).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival3"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.3</span>](#survival3)<span
style="font-size:medium"> shows the result along with the survival curve
we estimated in the previous section. The confidence interval takes into
account the sampling weights, unlike the estimated curve. The
discrepancy between them indicates that the sampling weights have a
substantial effect on the estimate—we will have to keep that in mind.
</span><span id="hevea_default1599"></span><span
style="font-size:medium"> </span><span id="hevea_default1600"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.8  Cohort effects</span>
----------------------------------------------------------

<span style="font-size:medium">One of the challenges of survival
analysis is that different parts of the estimated curve are based on
different groups of respondents. The part of the curve at time <span
style="font-family:monospace">t</span> is based on respondents whose age
was at least <span style="font-family:monospace">t</span> when they were
interviewed. So the leftmost part of the curve includes data from all
respondents, but the rightmost part includes only the oldest
respondents.</span>

<span style="font-size:medium">If the relevant characteristics of the
respondents are not changing over time, that’s fine, but in this case it
seems likely that marriage patterns are different for women born in
different generations. We can investigate this effect by grouping
respondents according to their decade of birth. Groups like this,
defined by date of birth or similar events, are called <span
style="font-weight:bold">cohorts</span>, and differences between the
groups are called <span style="font-weight:bold">cohort effects</span>.
</span><span id="hevea_default1601"></span><span
style="font-size:medium"> </span><span id="hevea_default1602"></span>

<span style="font-size:medium">To investigate cohort effects in the NSFG
marriage data, I gathered the Cycle 6 data from 2002 used throughout
this book; the Cycle 7 data from 2006–2010 used in Section </span>[<span
style="font-size:medium">9.11</span>](thinkstats2010.html#replication)<span
style="font-size:medium">; and the Cycle 5 data from 1995. In total
these datasets include 30,769 respondents.</span>

        resp5 = ReadFemResp1995()
        resp6 = ReadFemResp2002()
        resp7 = ReadFemResp2010()
        resps = [resp5, resp6, resp7]

<span style="font-size:medium">For each DataFrame, <span
style="font-family:monospace">resp</span>, I use <span
style="font-family:monospace">cmbirth</span> to compute the decade of
birth for each respondent: </span><span
id="hevea_default1603"></span><span style="font-size:medium">
</span><span id="hevea_default1604"></span>

        month0 = pandas.to_datetime('1899-12-15')
        dates = [month0 + pandas.DateOffset(months=cm) 
                 for cm in resp.cmbirth]
        resp['decade'] = (pandas.DatetimeIndex(dates).year - 1900) // 10

<span style="font-size:medium"><span
style="font-family:monospace">cmbirth</span> is encoded as the integer
number of months since December 1899; <span
style="font-family:monospace">month0</span> represents that date as a
Timestamp object. For each birth date, we instantiate a <span
style="font-family:monospace">DateOffset</span> that contains the
century-month and add it to <span
style="font-family:monospace">month0</span>; the result is a sequence of
Timestamps, which is converted to a <span
style="font-family:monospace">DateTimeIndex</span>. Finally, we extract
<span style="font-family:monospace">year</span> and compute decades.
</span><span id="hevea_default1605"></span><span
style="font-size:medium"> </span><span
id="hevea_default1606"></span><span style="font-size:medium">
</span><span id="hevea_default1607"></span>

<span style="font-size:medium">To take into account the sampling
weights, and also to show variability due to sampling error, I resample
the data, group respondents by decade, and plot survival curves:
</span><span id="hevea_default1608"></span><span
style="font-size:medium"> </span><span id="hevea_default1609"></span>

        for i in range(iters):
            samples = [thinkstats2.ResampleRowsWeighted(resp) 
                       for resp in resps]
            sample = pandas.concat(samples, ignore_index=True)
            groups = sample.groupby('decade')

            EstimateSurvivalByDecade(groups, alpha=0.2)

<span style="font-size:medium">Data from the three NSFG cycles use
different sampling weights, so I resample them separately and then use
<span style="font-family:monospace">concat</span> to merge them into a
single DataFrame. The parameter `ignore_index` tells <span
style="font-family:monospace">concat</span> not to match up respondents
by index; instead it creates a new index from 0 to 30768. </span><span
id="hevea_default1610"></span><span style="font-size:medium">
</span><span id="hevea_default1611"></span><span
style="font-size:medium"> </span><span id="hevea_default1612"></span>

<span style="font-size:medium"><span
style="font-family:monospace">EstimateSurvivalByDecade</span> plots
survival curves for each cohort:</span>

    def EstimateSurvivalByDecade(resp):
        for name, group in groups:
            hf, sf = EstimateSurvival(group)
            thinkplot.Plot(sf)

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2049.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.4: Survival curves for respondents born during different decades.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival4"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.4</span>](#survival4)<span
style="font-size:medium"> shows the results. Several patterns are
visible:</span>

-   <span style="font-size:medium">Women born in the 50s married
    earliest, with successive cohorts marrying later and later, at least
    until age 30 or so.</span>
-   <span style="font-size:medium">Women born in the 60s follow a
    surprising pattern. Prior to age 25, they were marrying at slower
    rates than their predecessors. After age 25, they were marrying
    faster. By age 32 they had overtaken the 50s cohort, and at age 44
    they are substantially more likely to have married. </span><span
    id="hevea_default1613"></span>

    <span style="font-size:medium">Women born in the 60s turned 25
    between 1985 and 1995. Remembering that the <span
    style="font-style:italic">Newsweek</span> article I mentioned was
    published in 1986, it is tempting to imagine that the article
    triggered a marriage boom. That explanation would be too pat, but it
    is possible that the article and the reaction to it were indicative
    of a mood that affected the behavior of this cohort. </span><span
    id="hevea_default1614"></span>

-   <span style="font-size:medium">The pattern of the 70s cohort is
    similar. They are less likely than their predecessors to be married
    before age 25, but at age 35 they have caught up with both of the
    previous cohorts.</span>
-   <span style="font-size:medium">Women born in the 80s are even less
    likely to marry before age 25. What happens after that is not clear;
    for more data, we have to wait for the next cycle of the
    NSFG.</span>

<span style="font-size:medium">In the meantime we can make some
predictions. </span><span id="hevea_default1615"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.9  Extrapolation</span>
---------------------------------------------------------

<span style="font-size:medium">The survival curve for the 70s cohort
ends at about age 38; for the 80s cohort it ends at age 28, and for the
90s cohort we hardly have any data at all. </span><span
id="hevea_default1616"></span>

<span style="font-size:medium">We can extrapolate these curves by
“borrowing” data from the previous cohort. HazardFunction provides a
method, <span style="font-family:monospace">Extend</span>, that copies
the tail from another longer HazardFunction: </span><span
id="hevea_default1617"></span>

    # class HazardFunction

        def Extend(self, other):
            last = self.series.index[-1]
            more = other.series[other.series.index > last]
            self.series = pandas.concat([self.series, more])

<span style="font-size:medium">As we saw in Section </span>[<span
style="font-size:medium">13.2</span>](#hazard)<span
style="font-size:medium">, the HazardFunction contains a Series that
maps from <span style="font-style:italic">t</span> to λ(<span
style="font-style:italic">t</span>). <span
style="font-family:monospace">Extend</span> finds <span
style="font-family:monospace">last</span>, which is the last index in
<span style="font-family:monospace">self.series</span>, selects values
from <span style="font-family:monospace">other</span> that come later
than <span style="font-family:monospace">last</span>, and appends them
onto <span style="font-family:monospace">self.series</span>.
</span><span id="hevea_default1618"></span><span
style="font-size:medium"> </span><span id="hevea_default1619"></span>

<span style="font-size:medium">Now we can extend the HazardFunction for
each cohort, using values from the predecessor:</span>

    def PlotPredictionsByDecade(groups):
        hfs = []
        for name, group in groups:
            hf, sf = EstimateSurvival(group)
            hfs.append(hf)

        thinkplot.PrePlot(len(hfs))
        for i, hf in enumerate(hfs):
            if i > 0:
                hf.Extend(hfs[i-1])
            sf = hf.MakeSurvival()
            thinkplot.Plot(sf)

<span style="font-size:medium"><span
style="font-family:monospace">groups</span> is a GroupBy object with
respondents grouped by decade of birth. The first loop computes the
HazardFunction for each group. </span><span
id="hevea_default1620"></span>

<span style="font-size:medium">The second loop extends each
HazardFunction with values from its predecessor, which might contain
values from the previous group, and so on. Then it converts each
HazardFunction to a SurvivalFunction and plots it.</span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2050.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.5: Survival curves for respondents born during different decades, with predictions for the later cohorts.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival5"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.5</span>](#survival5)<span
style="font-size:medium"> shows the results; I’ve removed the 50s cohort
to make the predictions more visible. These results suggest that by age
40, the most recent cohorts will converge with the 60s cohort, with
fewer than 20% never married. </span><span
id="hevea_default1621"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.10  Expected remaining lifetime</span>
------------------------------------------------------------------------

<span style="font-size:medium">Given a survival curve, we can compute
the expected remaining lifetime as a function of current age. For
example, given the survival curve of pregnancy length from
Section </span>[<span
style="font-size:medium">13.1</span>](#survival)<span
style="font-size:medium">, we can compute the expected time until
delivery. </span><span id="hevea_default1622"></span>

<span style="font-size:medium">The first step is to extract the PMF of
lifetimes. <span style="font-family:monospace">SurvivalFunction</span>
provides a method that does that:</span>

    # class SurvivalFunction

        def MakePmf(self, filler=None):
            pmf = thinkstats2.Pmf()
            for val, prob in self.cdf.Items():
                pmf.Set(val, prob)

            cutoff = self.cdf.ps[-1]
            if filler is not None:
                pmf[filler] = 1-cutoff

            return pmf

<span style="font-size:medium">Remember that the SurvivalFunction
contains the Cdf of lifetimes. The loop copies the values and
probabilities from the Cdf into a Pmf. </span><span
id="hevea_default1623"></span><span style="font-size:medium">
</span><span id="hevea_default1624"></span>

<span style="font-size:medium"><span
style="font-family:monospace">cutoff</span> is the highest probability
in the Cdf, which is 1 if the Cdf is complete, and otherwise less than
1. If the Cdf is incomplete, we plug in the provided value, <span
style="font-family:monospace">filler</span>, to cap it off.</span>

<span style="font-size:medium">The Cdf of pregnancy lengths is complete,
so we don’t have to worry about this detail yet. </span><span
id="hevea_default1625"></span>

<span style="font-size:medium">The next step is to compute the expected
remaining lifetime, where “expected” means average. <span
style="font-family:monospace">SurvivalFunction</span> provides a method
that does that, too: </span><span id="hevea_default1626"></span>

    # class SurvivalFunction

        def RemainingLifetime(self, filler=None, func=thinkstats2.Pmf.Mean):
            pmf = self.MakePmf(filler=filler)
            d = {}
            for t in sorted(pmf.Values())[:-1]:
                pmf[t] = 0
                pmf.Normalize()
                d[t] = func(pmf) - t

            return pandas.Series(d)

<span style="font-size:medium"><span
style="font-family:monospace">RemainingLifetime</span> takes <span
style="font-family:monospace">filler</span>, which is passed along to
<span style="font-family:monospace">MakePmf</span>, and <span
style="font-family:monospace">func</span> which is the function used to
summarize the distribution of remaining lifetimes.</span>

<span style="font-size:medium"><span
style="font-family:monospace">pmf</span> is the Pmf of lifetimes
extracted from the SurvivalFunction. <span
style="font-family:monospace">d</span> is a dictionary that contains the
results, a map from current age, <span
style="font-family:monospace">t</span>, to expected remaining lifetime.
</span><span id="hevea_default1627"></span>

<span style="font-size:medium">The loop iterates through the values in
the Pmf. For each value of <span style="font-family:monospace">t</span>
it computes the conditional distribution of lifetimes, given that the
lifetime exceeds <span style="font-family:monospace">t</span>. It does
that by removing values from the Pmf one at a time and renormalizing the
remaining values.</span>

<span style="font-size:medium">Then it uses <span
style="font-family:monospace">func</span> to summarize the conditional
distribution. In this example the result is the mean pregnancy length,
given that the length exceeds <span
style="font-family:monospace">t</span>. By subtracting <span
style="font-family:monospace">t</span> we get the mean remaining
pregnancy length. </span><span id="hevea_default1628"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2051.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 13.6: Expected remaining pregnancy length (left) and years until first marriage (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="survival6"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.6</span>](#survival6)<span
style="font-size:medium"> (left) shows the expected remaining pregnancy
length as a function of the current duration. For example, during Week
0, the expected remaining duration is about 34 weeks. That’s less than
full term (39 weeks) because terminations of pregnancy in the first
trimester bring the average down. </span><span
id="hevea_default1629"></span>

<span style="font-size:medium">The curve drops slowly during the first
trimester. After 13 weeks, the expected remaining lifetime has dropped
by only 9 weeks, to 25. After that the curve drops faster, by about a
week per week.</span>

<span style="font-size:medium">Between Week 37 and 42, the curve levels
off between 1 and 2 weeks. At any time during this period, the expected
remaining lifetime is the same; with each week that passes, the
destination gets no closer. Processes with this property are called
<span style="font-weight:bold">memoryless</span> because the past has no
effect on the predictions. This behavior is the mathematical basis of
the infuriating mantra of obstetrics nurses: “any day now.” </span><span
id="hevea_default1630"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">13.6</span>](#survival6)<span
style="font-size:medium"> (right) shows the median remaining time until
first marriage, as a function of age. For an 11 year-old girl, the
median time until first marriage is about 14 years. The curve decreases
until age 22 when the median remaining time is about 7 years. After that
it increases again: by age 30 it is back where it started, at 14
years.</span>

<span style="font-size:medium">Based on this data, young women have
decreasing remaining "lifetimes". Mechanical components with this
property are called <span style="font-weight:bold">NBUE</span> for "new
better than used in expectation," meaning that a new part is expected to
last longer. </span><span id="hevea_default1631"></span>

<span style="font-size:medium">Women older than 22 have increasing
remaining time until first marriage. Components with this property are
called <span style="font-weight:bold">UBNE</span> for "used better than
new in expectation." That is, the older the part, the longer it is
expected to last. Newborns and cancer patients are also UBNE; their life
expectancy increases the longer they live. </span><span
id="hevea_default1632"></span>

<span style="font-size:medium">For this example I computed median,
rather than mean, because the Cdf is incomplete; the survival curve
projects that about 20% of respondents will not marry before age 44. The
age of first marriage for these women is unknown, and might be
non-existent, so we can’t compute a mean. </span><span
id="hevea_default1633"></span><span style="font-size:medium">
</span><span id="hevea_default1634"></span>

<span style="font-size:medium">I deal with these unknown values by
replacing them with <span style="font-family:monospace">np.inf</span>, a
special value that represents infinity. That makes the mean infinity for
all ages, but the median is well-defined as long as more than 50% of the
remaining lifetimes are finite, which is true until age 30. After that
it is hard to define a meaningful expected remaining lifetime.
</span><span id="hevea_default1635"></span>

<span style="font-size:medium">Here’s the code that computes and plots
these functions:</span>

        rem_life1 = sf1.RemainingLifetime()
        thinkplot.Plot(rem_life1)

        func = lambda pmf: pmf.Percentile(50)
        rem_life2 = sf2.RemainingLifetime(filler=np.inf, func=func)
        thinkplot.Plot(rem_life2)

<span style="font-size:medium"><span
style="font-family:monospace">sf1</span> is the survival curve for
pregnancy length; in this case we can use the default values for <span
style="font-family:monospace">RemainingLifetime</span>. </span><span
id="hevea_default1636"></span>

<span style="font-size:medium"><span
style="font-family:monospace">sf2</span> is the survival curve for age
at first marriage; <span style="font-family:monospace">func</span> is a
function that takes a Pmf and computes its median (50th percentile).
</span><span id="hevea_default1637"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.11  Exercises</span>
------------------------------------------------------

<span style="font-size:medium">My solution to this exercise is in
`chap13soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *In NSFG Cycles 6 and 7,
the variable <span style="font-family:monospace">cmdivorcx</span>
contains the date of divorce for the respondent’s first marriage, if
applicable, encoded in century-months.* </span><span
id="hevea_default1638"></span><span style="font-size:medium">
</span><span id="hevea_default1639"></span>

<span style="font-size:medium">*Compute the duration of marriages that
have ended in divorce, and the duration, so far, of marriages that are
ongoing. Estimate the hazard and survival curve for the duration of
marriage.*</span>

<span style="font-size:medium">*Use resampling to take into account
sampling weights, and plot data from several resamples to visualize
sampling error.* </span><span id="hevea_default1640"></span>

<span style="font-size:medium">*Consider dividing the respondents into
groups by decade of birth, and possibly by age at first marriage.*
</span><span id="hevea_default1641"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">13.12  Glossary</span>
-----------------------------------------------------

-   <span style="font-size:medium">survival analysis: A set of methods
    for describing and predicting lifetimes, or more generally time
    until an event occurs. </span><span id="hevea_default1642"></span>
-   <span style="font-size:medium">survival curve: A function that maps
    from a time, <span style="font-style:italic">t</span>, to the
    probability of surviving past <span
    style="font-style:italic">t</span>. </span><span
    id="hevea_default1643"></span>
-   <span style="font-size:medium">hazard function: A function that maps
    from <span style="font-style:italic">t</span> to the fraction of
    people alive until <span style="font-style:italic">t</span> who die
    at <span style="font-style:italic">t</span>. </span><span
    id="hevea_default1644"></span>
-   <span style="font-size:medium">Kaplan-Meier estimation: An algorithm
    for estimating hazard and survival functions. </span><span
    id="hevea_default1645"></span>
-   <span style="font-size:medium">cohort: a group of subjects defined
    by an event, like date of birth, in a particular interval of time.
    </span><span id="hevea_default1646"></span>
-   <span style="font-size:medium">cohort effect: a difference between
    cohorts. </span><span id="hevea_default1647"></span>
-   <span style="font-size:medium">NBUE: A property of expected
    remaining lifetime, “New better than used in expectation.”
    </span><span id="hevea_default1648"></span>
-   <span style="font-size:medium">UBNE: A property of expected
    remaining lifetime, “Used better than new in expectation.”
    </span><span id="hevea_default1649"></span>

<span style="font-size:medium"> </span>
