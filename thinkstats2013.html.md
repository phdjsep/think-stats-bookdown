This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 12  Time series analysis</span>
======================================================================

<span style="font-size:medium">A <span style="font-weight:bold">time
series</span> is a sequence of measurements from a system that varies in
time. One famous example is the “hockey stick graph” that shows global
average temperature over time (see </span>[<span
style="font-family:monospace;font-size:medium">https://en.wikipedia.org/wiki/Hockey\_stick\_graph</span>](https://en.wikipedia.org/wiki/Hockey_stick_graph)<span
style="font-size:medium">). </span><span
id="hevea_default1373"></span><span style="font-size:medium">
</span><span id="hevea_default1374"></span>

<span style="font-size:medium">The example I work with in this chapter
comes from Zachary M. Jones, a researcher in political science who
studies the black market for cannabis in the U.S. (</span>[<span
style="font-family:monospace;font-size:medium">http://zmjones.com/marijuana</span>](http://zmjones.com/marijuana)<span
style="font-size:medium">). He collected data from a web site called
“Price of Weed” that crowdsources market information by asking
participants to report the price, quantity, quality, and location of
cannabis transactions (</span>[<span
style="font-family:monospace;font-size:medium">http://www.priceofweed.com/</span>](http://www.priceofweed.com/)<span
style="font-size:medium">). The goal of his project is to investigate
the effect of policy decisions, like legalization, on markets. I find
this project appealing because it is an example that uses data to
address important political questions, like drug policy. </span><span
id="hevea_default1375"></span><span style="font-size:medium">
</span><span id="hevea_default1376"></span>

<span style="font-size:medium">I hope you will find this chapter
interesting, but I’ll take this opportunity to reiterate the importance
of maintaining a professional attitude to data analysis. Whether and
which drugs should be illegal are important and difficult public policy
questions; our decisions should be informed by accurate data reported
honestly. </span><span id="hevea_default1377"></span>

<span style="font-size:medium">The code for this chapter is in <span
style="font-family:monospace">timeseries.py</span>. For information
about downloading and working with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.1  Importing and cleaning</span>
------------------------------------------------------------------

<span style="font-size:medium">The data I downloaded from Mr. Jones’s
site is in the repository for this book. The following code reads it
into a pandas DataFrame: </span><span
id="hevea_default1378"></span><span style="font-size:medium">
</span><span id="hevea_default1379"></span>

        transactions = pandas.read_csv('mj-clean.csv', parse_dates=[5])

<span style="font-size:medium">`parse_dates` tells `read_csv` to
interpret values in column 5 as dates and convert them to NumPy <span
style="font-family:monospace">datetime64</span> objects. </span><span
id="hevea_default1380"></span>

<span style="font-size:medium">The DataFrame has a row for each reported
transaction and the following columns:</span>

-   <span style="font-size:medium">city: string city name.</span>
-   <span style="font-size:medium">state: two-letter state
    abbreviation.</span>
-   <span style="font-size:medium">price: price paid in dollars.
    </span><span id="hevea_default1381"></span>
-   <span style="font-size:medium">amount: quantity purchased in
    grams.</span>
-   <span style="font-size:medium">quality: high, medium, or low
    quality, as reported by the purchaser.</span>
-   <span style="font-size:medium">date: date of report, presumed to be
    shortly after date of purchase.</span>
-   <span style="font-size:medium">ppg: price per gram, in
    dollars.</span>
-   <span style="font-size:medium">state.name: string state name.</span>
-   <span style="font-size:medium">lat: approximate latitude of the
    transaction, based on city name.</span>
-   <span style="font-size:medium">lon: approximate longitude of the
    transaction.</span>

<span style="font-size:medium">Each transaction is an event in time, so
we could treat this dataset as a time series. But the events are not
equally spaced in time; the number of transactions reported each day
varies from 0 to several hundred. Many methods used to analyze time
series require the measurements to be equally spaced, or at least things
are simpler if they are. </span><span
id="hevea_default1382"></span><span style="font-size:medium">
</span><span id="hevea_default1383"></span>

<span style="font-size:medium">In order to demonstrate these methods, I
divide the dataset into groups by reported quality, and then transform
each group into an equally spaced series by computing the mean daily
price per gram.</span>

    def GroupByQualityAndDay(transactions):
        groups = transactions.groupby('quality')
        dailies = {}
        for name, group in groups:
            dailies[name] = GroupByDay(group)        

        return dailies

<span style="font-size:medium"><span
style="font-family:monospace">groupby</span> is a DataFrame method that
returns a GroupBy object, <span
style="font-family:monospace">groups</span>; used in a for loop, it
iterates the names of the groups and the DataFrames that represent them.
Since the values of <span style="font-family:monospace">quality</span>
are <span style="font-family:monospace">low</span>, <span
style="font-family:monospace">medium</span>, and <span
style="font-family:monospace">high</span>, we get three groups with
those names. </span><span id="hevea_default1384"></span><span
style="font-size:medium"> </span><span id="hevea_default1385"></span>

<span style="font-size:medium">The loop iterates through the groups and
calls <span style="font-family:monospace">GroupByDay</span>, which
computes the daily average price and returns a new DataFrame:</span>

    def GroupByDay(transactions, func=np.mean):
        grouped = transactions[['date', 'ppg']].groupby('date')
        daily = grouped.aggregate(func)

        daily['date'] = daily.index
        start = daily.date[0]
        one_year = np.timedelta64(1, 'Y')
        daily['years'] = (daily.date - start) / one_year

        return daily

<span style="font-size:medium">The parameter, <span
style="font-family:monospace">transactions</span>, is a DataFrame that
contains columns <span style="font-family:monospace">date</span> and
<span style="font-family:monospace">ppg</span>. We select these two
columns, then group by <span style="font-family:monospace">date</span>.
</span><span id="hevea_default1386"></span>

<span style="font-size:medium">The result, <span
style="font-family:monospace">grouped</span>, is a map from each date to
a DataFrame that contains prices reported on that date. <span
style="font-family:monospace">aggregate</span> is a GroupBy method that
iterates through the groups and applies a function to each column of the
group; in this case there is only one column, <span
style="font-family:monospace">ppg</span>. So the result of <span
style="font-family:monospace">aggregate</span> is a DataFrame with one
row for each date and one column, <span
style="font-family:monospace">ppg</span>. </span><span
id="hevea_default1387"></span>

<span style="font-size:medium">Dates in these DataFrames are stored as
NumPy <span style="font-family:monospace">datetime64</span> objects,
which are represented as 64-bit integers in nanoseconds. For some of the
analyses coming up, it will be convenient to work with time in more
human-friendly units, like years. So <span
style="font-family:monospace">GroupByDay</span> adds a column named
<span style="font-family:monospace">date</span> by copying the <span
style="font-family:monospace">index</span>, then adds <span
style="font-family:monospace">years</span>, which contains the number of
years since the first transaction as a floating-point number.
</span><span id="hevea_default1388"></span><span
style="font-size:medium"> </span><span id="hevea_default1389"></span>

<span style="font-size:medium">The resulting DataFrame has columns <span
style="font-family:monospace">ppg</span>, <span
style="font-family:monospace">date</span>, and <span
style="font-family:monospace">years</span>. </span><span
id="hevea_default1390"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.2  Plotting</span>
----------------------------------------------------

<span style="font-size:medium">The result from <span
style="font-family:monospace">GroupByQualityAndDay</span> is a map from
each quality to a DataFrame of daily prices. Here’s the code I use to
plot the three time series: </span><span
id="hevea_default1391"></span><span style="font-size:medium">
</span><span id="hevea_default1392"></span>

        thinkplot.PrePlot(rows=3)
        for i, (name, daily) in enumerate(dailies.items()):
            thinkplot.SubPlot(i+1)
            title = 'price per gram ($)' if i==0 else ''
            thinkplot.Config(ylim=[0, 20], title=title)
            thinkplot.Scatter(daily.index, daily.ppg, s=10, label=name)
            if i == 2: 
                pyplot.xticks(rotation=30)
            else:
                thinkplot.Config(xticks=[])

<span style="font-size:medium"><span
style="font-family:monospace">PrePlot</span> with <span
style="font-family:monospace">rows=3</span> means that we are planning
to make three subplots laid out in three rows. The loop iterates through
the DataFrames and creates a scatter plot for each. It is common to plot
time series with line segments between the points, but in this case
there are many data points and prices are highly variable, so adding
lines would not help. </span><span id="hevea_default1393"></span>

<span style="font-size:medium">Since the labels on the x-axis are dates,
I use <span style="font-family:monospace">pyplot.xticks</span> to rotate
the “ticks” 30 degrees, making them more readable. </span><span
id="hevea_default1394"></span><span style="font-size:medium">
</span><span id="hevea_default1395"></span><span
style="font-size:medium"> </span><span id="hevea_default1396"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2039.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.1: Time series of daily price per gram for high, medium, and low quality cannabis.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries1"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.1</span>](#timeseries1)<span
style="font-size:medium"> shows the result. One apparent feature in
these plots is a gap around November 2013. It’s possible that data
collection was not active during this time, or the data might not be
available. We will consider ways to deal with this missing data later.
</span><span id="hevea_default1397"></span>

<span style="font-size:medium">Visually, it looks like the price of high
quality cannabis is declining during this period, and the price of
medium quality is increasing. The price of low quality might also be
increasing, but it is harder to tell, since it seems to be more
volatile. Keep in mind that quality data is reported by volunteers, so
trends over time might reflect changes in how participants apply these
labels. </span><span id="hevea_default1398"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.3  Linear regression</span>
-------------------------------------------------------------

<span style="font-size:medium"> </span><span id="timeregress"></span>

<span style="font-size:medium">Although there are methods specific to
time series analysis, for many problems a simple way to get started is
by applying general-purpose tools like linear regression. The following
function takes a DataFrame of daily prices and computes a least squares
fit, returning the model and results objects from StatsModels:
</span><span id="hevea_default1399"></span><span
style="font-size:medium"> </span><span
id="hevea_default1400"></span><span style="font-size:medium">
</span><span id="hevea_default1401"></span>

    def RunLinearModel(daily):
        model = smf.ols('ppg ~ years', data=daily)
        results = model.fit()
        return model, results

<span style="font-size:medium">Then we can iterate through the qualities
and fit a model to each:</span>

        for name, daily in dailies.items():
            model, results = RunLinearModel(daily)
            print(name)
            regression.SummarizeResults(results)

<span style="font-size:medium">Here are the results:</span>

<span style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">quality</span></td>
<td style="text-align: left;"><span style="font-size:medium">intercept</span></td>
<td style="text-align: left;"><span style="font-size:medium">slope</span></td>
<td style="text-align: center;"><span style="font-style:italic;font-size:medium">R</span><sup><span style="font-size:medium">2</span></sup><span style="font-size:medium"> </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">high</span></td>
<td style="text-align: left;"><span style="font-size:medium">13.450</span></td>
<td style="text-align: left;"><span style="font-size:medium">-0.708</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.444 </span></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><span style="font-size:medium">medium</span></td>
<td style="text-align: left;"><span style="font-size:medium">8.879</span></td>
<td style="text-align: left;"><span style="font-size:medium">0.283</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.050 </span></td>
</tr>
<tr class="even">
<td style="text-align: left;"><span style="font-size:medium">low</span></td>
<td style="text-align: left;"><span style="font-size:medium">5.362</span></td>
<td style="text-align: left;"><span style="font-size:medium">0.568</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.030 </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">The estimated slopes indicate that the
price of high quality cannabis dropped by about 71 cents per year during
the observed interval; for medium quality it increased by 28 cents per
year, and for low quality it increased by 57 cents per year. These
estimates are all statistically significant with very small p-values.
</span><span id="hevea_default1402"></span><span
style="font-size:medium"> </span><span
id="hevea_default1403"></span><span style="font-size:medium">
</span><span id="hevea_default1404"></span>

<span style="font-size:medium">The <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
value for high quality cannabis is 0.44, which means that time as an
explanatory variable accounts for 44% of the observed variability in
price. For the other qualities, the change in price is smaller, and
variability in prices is higher, so the values of <span
style="font-style:italic">R</span></span><sup><span
style="font-size:medium">2</span></sup><span style="font-size:medium">
are smaller (but still statistically significant). </span><span
id="hevea_default1405"></span><span style="font-size:medium">
</span><span id="hevea_default1406"></span><span
style="font-size:medium"> </span><span id="hevea_default1407"></span>

<span style="font-size:medium">The following code plots the observed
prices and the fitted values:</span>

    def PlotFittedValues(model, results, label=''):
        years = model.exog[:,1]
        values = model.endog
        thinkplot.Scatter(years, values, s=15, label=label)
        thinkplot.Plot(years, results.fittedvalues, label='model')

<span style="font-size:medium">As we saw in Section </span>[<span
style="font-size:medium">11.8</span>](thinkstats2012.html#implementation)<span
style="font-size:medium">, <span
style="font-family:monospace">model</span> contains <span
style="font-family:monospace">exog</span> and <span
style="font-family:monospace">endog</span>, NumPy arrays with the
exogenous (explanatory) and endogenous (dependent) variables.
</span><span id="hevea_default1408"></span><span
style="font-size:medium"> </span><span
id="hevea_default1409"></span><span style="font-size:medium">
</span><span id="hevea_default1410"></span><span
style="font-size:medium"> </span><span
id="hevea_default1411"></span><span style="font-size:medium">
</span><span id="hevea_default1412"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2040.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.2: Time series of daily price per gram for high quality cannabis, and a linear least squares fit.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries2"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium"><span
style="font-family:monospace">PlotFittedValues</span> makes a scatter
plot of the data points and a line plot of the fitted values.
Figure </span>[<span
style="font-size:medium">12.2</span>](#timeseries2)<span
style="font-size:medium"> shows the results for high quality cannabis.
The model seems like a good linear fit for the data; nevertheless,
linear regression is not the most appropriate choice for this data:
</span><span id="hevea_default1413"></span><span
style="font-size:medium"> </span><span id="hevea_default1414"></span>

-   <span style="font-size:medium">First, there is no reason to expect
    the long-term trend to be a line or any other simple function. In
    general, prices are determined by supply and demand, both of which
    vary over time in unpredictable ways. </span><span
    id="hevea_default1415"></span>
-   <span style="font-size:medium">Second, the linear regression model
    gives equal weight to all data, recent and past. For purposes of
    prediction, we should probably give more weight to recent data.
    </span><span id="hevea_default1416"></span>
-   <span style="font-size:medium">Finally, one of the assumptions of
    linear regression is that the residuals are uncorrelated noise. With
    time series data, this assumption is often false because successive
    values are correlated. </span><span id="hevea_default1417"></span>

<span style="font-size:medium">The next section presents an alternative
that is more appropriate for time series data.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.4  Moving averages</span>
-----------------------------------------------------------

<span style="font-size:medium">Most time series analysis is based on the
modeling assumption that the observed series is the sum of three
components: </span><span id="hevea_default1418"></span><span
style="font-size:medium"> </span><span id="hevea_default1419"></span>

-   <span style="font-size:medium">Trend: A smooth function that
    captures persistent changes. </span><span
    id="hevea_default1420"></span>
-   <span style="font-size:medium">Seasonality: Periodic variation,
    possibly including daily, weekly, monthly, or yearly cycles.
    </span><span id="hevea_default1421"></span>
-   <span style="font-size:medium">Noise: Random variation around the
    long-term trend. </span><span id="hevea_default1422"></span>

<span style="font-size:medium">Regression is one way to extract the
trend from a series, as we saw in the previous section. But if the trend
is not a simple function, a good alternative is a <span
style="font-weight:bold">moving average</span>. A moving average divides
the series into overlapping regions, called <span
style="font-weight:bold">windows</span>, and computes the average of the
values in each window. </span><span id="hevea_default1423"></span>

<span style="font-size:medium">One of the simplest moving averages is
the <span style="font-weight:bold">rolling mean</span>, which computes
the mean of the values in each window. For example, if the window size
is 3, the rolling mean computes the mean of values 0 through 2, 1
through 3, 2 through 4, etc. </span><span
id="hevea_default1424"></span><span style="font-size:medium">
</span><span id="hevea_default1425"></span>

<span style="font-size:medium">pandas provides `rolling_mean`, which
takes a Series and a window size and returns a new Series. </span><span
id="hevea_default1426"></span><span style="font-size:medium">
</span><span id="hevea_default1427"></span>

    >>> series = np.arange(10)
    array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])

    >>> pandas.rolling_mean(series, 3)
    array([ nan,  nan,   1,   2,   3,   4,   5,   6,   7,   8])

<span style="font-size:medium">The first two values are <span
style="font-family:monospace">nan</span>; the next value is the mean of
the first three elements, 0, 1, and 2. The next value is the mean of 1,
2, and 3. And so on.</span>

<span style="font-size:medium">Before we can apply `rolling_mean` to the
cannabis data, we have to deal with missing values. There are a few days
in the observed interval with no reported transactions for one or more
quality categories, and a period in 2013 when data collection was not
active. </span><span id="hevea_default1428"></span>

<span style="font-size:medium">In the DataFrames we have used so far,
these dates are absent; the index skips days with no data. For the
analysis that follows, we need to represent this missing data
explicitly. We can do that by “reindexing” the DataFrame: </span><span
id="hevea_default1429"></span><span style="font-size:medium">
</span><span id="hevea_default1430"></span>

        dates = pandas.date_range(daily.index.min(), daily.index.max())
        reindexed = daily.reindex(dates)

<span style="font-size:medium">The first line computes a date range that
includes every day from the beginning to the end of the observed
interval. The second line creates a new DataFrame with all of the data
from <span style="font-family:monospace">daily</span>, but including
rows for all dates, filled with <span
style="font-family:monospace">nan</span>. </span><span
id="hevea_default1431"></span><span style="font-size:medium">
</span><span id="hevea_default1432"></span>

<span style="font-size:medium">Now we can plot the rolling mean like
this:</span>

        roll_mean = pandas.rolling_mean(reindexed.ppg, 30)
        thinkplot.Plot(roll_mean.index, roll_mean)

<span style="font-size:medium">The window size is 30, so each value in
`roll_mean` is the mean of 30 values from <span
style="font-family:monospace">reindexed.ppg</span>. </span><span
id="hevea_default1433"></span><span style="font-size:medium">
</span><span id="hevea_default1434"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2041.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.3: Daily price and a rolling mean (left) and exponentially-weighted moving average (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries10"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.3</span>](#timeseries10)<span
style="font-size:medium"> (left) shows the result. The rolling mean
seems to do a good job of smoothing out the noise and extracting the
trend. The first 29 values are <span
style="font-family:monospace">nan</span>, and wherever there’s a missing
value, it’s followed by another 29 <span
style="font-family:monospace">nan</span>s. There are ways to fill in
these gaps, but they are a minor nuisance. </span><span
id="hevea_default1435"></span><span style="font-size:medium">
</span><span id="hevea_default1436"></span><span
style="font-size:medium"> </span><span id="hevea_default1437"></span>

<span style="font-size:medium">An alternative is the <span
style="font-weight:bold">exponentially-weighted moving average</span>
(EWMA), which has two advantages. First, as the name suggests, it
computes a weighted average where the most recent value has the highest
weight and the weights for previous values drop off exponentially.
Second, the pandas implementation of EWMA handles missing values better.
</span><span id="hevea_default1438"></span><span
style="font-size:medium"> </span><span
id="hevea_default1439"></span><span style="font-size:medium">
</span><span id="hevea_default1440"></span>

        ewma = pandas.ewma(reindexed.ppg, span=30)
        thinkplot.Plot(ewma.index, ewma)

<span style="font-size:medium">The <span
style="font-weight:bold">span</span> parameter corresponds roughly to
the window size of a moving average; it controls how fast the weights
drop off, so it determines the number of points that make a
non-negligible contribution to each average. </span><span
id="hevea_default1441"></span><span style="font-size:medium">
</span><span id="hevea_default1442"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.3</span>](#timeseries10)<span
style="font-size:medium"> (right) shows the EWMA for the same data. It
is similar to the rolling mean, where they are both defined, but it has
no missing values, which makes it easier to work with. The values are
noisy at the beginning of the time series, because they are based on
fewer data points. </span><span id="hevea_default1443"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.5  Missing values</span>
----------------------------------------------------------

<span style="font-size:medium">Now that we have characterized the trend
of the time series, the next step is to investigate seasonality, which
is periodic behavior. Time series data based on human behavior often
exhibits daily, weekly, monthly, or yearly cycles. In the next section I
present methods to test for seasonality, but they don’t work well with
missing data, so we have to solve that problem first. </span><span
id="hevea_default1444"></span><span style="font-size:medium">
</span><span id="hevea_default1445"></span>

<span style="font-size:medium">A simple and common way to fill missing
data is to use a moving average. The Series method <span
style="font-family:monospace">fillna</span> does just what we want:
</span><span id="hevea_default1446"></span><span
style="font-size:medium"> </span><span id="hevea_default1447"></span>

        reindexed.ppg.fillna(ewma, inplace=True)

<span style="font-size:medium">Wherever <span
style="font-family:monospace">reindexed.ppg</span> is <span
style="font-family:monospace">nan</span>, <span
style="font-family:monospace">fillna</span> replaces it with the
corresponding value from <span
style="font-family:monospace">ewma</span>. The <span
style="font-family:monospace">inplace</span> flag tells <span
style="font-family:monospace">fillna</span> to modify the existing
Series rather than create a new one.</span>

<span style="font-size:medium">A drawback of this method is that it
understates the noise in the series. We can solve that problem by adding
in resampled residuals: </span><span id="hevea_default1448"></span><span
style="font-size:medium"> </span><span id="hevea_default1449"></span>

        resid = (reindexed.ppg - ewma).dropna()
        fake_data = ewma + thinkstats2.Resample(resid, len(reindexed))
        reindexed.ppg.fillna(fake_data, inplace=True)

<span style="font-size:medium"><span
style="font-family:monospace">resid</span> contains the residual values,
not including days when <span style="font-family:monospace">ppg</span>
is <span style="font-family:monospace">nan</span>. `fake_data` contains
the sum of the moving average and a random sample of residuals. Finally,
<span style="font-family:monospace">fillna</span> replaces <span
style="font-family:monospace">nan</span> with values from `fake_data`.
</span><span id="hevea_default1450"></span><span
style="font-size:medium"> </span><span
id="hevea_default1451"></span><span style="font-size:medium">
</span><span id="hevea_default1452"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2042.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.4: Daily price with filled data.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries8"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.4</span>](#timeseries8)<span
style="font-size:medium"> shows the result. The filled data is visually
similar to the actual values. Since the resampled residuals are random,
the results are different every time; later we’ll see how to
characterize the error created by missing values. </span><span
id="hevea_default1453"></span><span style="font-size:medium">
</span><span id="hevea_default1454"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.6  Serial correlation</span>
--------------------------------------------------------------

<span style="font-size:medium">As prices vary from day to day, you might
expect to see patterns. If the price is high on Monday, you might expect
it to be high for a few more days; and if it’s low, you might expect it
to stay low. A pattern like this is called <span
style="font-weight:bold">serial correlation</span>, because each value
is correlated with the next one in the series. </span><span
id="hevea_default1455"></span><span style="font-size:medium">
</span><span id="hevea_default1456"></span>

<span style="font-size:medium">To compute serial correlation, we can
shift the time series by an interval called a <span
style="font-weight:bold">lag</span>, and then compute the correlation of
the shifted series with the original: </span><span
id="hevea_default1457"></span>

    def SerialCorr(series, lag=1):
        xs = series[lag:]
        ys = series.shift(lag)[lag:]
        corr = thinkstats2.Corr(xs, ys)
        return corr

<span style="font-size:medium">After the shift, the first <span
style="font-family:monospace">lag</span> values are <span
style="font-family:monospace">nan</span>, so I use a slice to remove
them before computing <span style="font-family:monospace">Corr</span>.
</span><span id="hevea_default1458"></span>

<span style="font-size:medium">If we apply <span
style="font-family:monospace">SerialCorr</span> to the raw price data
with lag 1, we find serial correlation 0.48 for the high quality
category, 0.16 for medium and 0.10 for low. In any time series with a
long-term trend, we expect to see strong serial correlations; for
example, if prices are falling, we expect to see values above the mean
in the first half of the series and values below the mean in the second
half.</span>

<span style="font-size:medium">It is more interesting to see if the
correlation persists if you subtract away the trend. For example, we can
compute the residual of the EWMA and then compute its serial
correlation: </span><span id="hevea_default1459"></span>

        ewma = pandas.ewma(reindexed.ppg, span=30)
        resid = reindexed.ppg - ewma
        corr = SerialCorr(resid, 1)

<span style="font-size:medium">With lag=1, the serial correlations for
the de-trended data are -0.022 for high quality, -0.015 for medium, and
0.036 for low. These values are small, indicating that there is little
or no one-day serial correlation in this series. </span><span
id="hevea_default1460"></span>

<span style="font-size:medium">To check for weekly, monthly, and yearly
seasonality, I ran the analysis again with different lags. Here are the
results: </span><span id="hevea_default1461"></span>

<span style="font-size:medium"> </span>

<table>
<tbody>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">lag</span></td>
<td style="text-align: center;"><span style="font-size:medium">high</span></td>
<td style="text-align: center;"><span style="font-size:medium">medium</span></td>
<td style="text-align: center;"><span style="font-size:medium">low </span></td>
</tr>
<tr class="even">
<td style="text-align: center;"><span style="font-size:medium">1</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.029</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.014</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.034 </span></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">7</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.02</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.042</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.0097 </span></td>
</tr>
<tr class="even">
<td style="text-align: center;"><span style="font-size:medium">30</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.014</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.0064</span></td>
<td style="text-align: center;"><span style="font-size:medium">-0.013 </span></td>
</tr>
<tr class="odd">
<td style="text-align: center;"><span style="font-size:medium">365</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.045</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.015</span></td>
<td style="text-align: center;"><span style="font-size:medium">0.033 </span></td>
</tr>
</tbody>
</table>

<span style="font-size:medium"> </span>

<span style="font-size:medium">In the next section we’ll test whether
these correlations are statistically significant (they are not), but at
this point we can tentatively conclude that there are no substantial
seasonal patterns in these series, at least not with these lags.
</span><span id="hevea_default1462"></span><span
style="font-size:medium"> </span><span id="hevea_default1463"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.7  Autocorrelation</span>
-----------------------------------------------------------

<span style="font-size:medium">If you think a series might have some
serial correlation, but you don’t know which lags to test, you can test
them all! The <span style="font-weight:bold">autocorrelation
function</span> is a function that maps from lag to the serial
correlation with the given lag. “Autocorrelation” is another name for
serial correlation, used more often when the lag is not 1. </span><span
id="hevea_default1464"></span>

<span style="font-size:medium">StatsModels, which we used for linear
regression in Section </span>[<span
style="font-size:medium">11.1</span>](thinkstats2012.html#statsmodels)<span
style="font-size:medium">, also provides functions for time series
analysis, including <span style="font-family:monospace">acf</span>,
which computes the autocorrelation function: </span><span
id="hevea_default1465"></span>

        import statsmodels.tsa.stattools as smtsa
        acf = smtsa.acf(filled.resid, nlags=365, unbiased=True)

<span style="font-size:medium"><span
style="font-family:monospace">acf</span> computes serial correlations
with lags from 0 through <span
style="font-family:monospace">nlags</span>. The <span
style="font-family:monospace">unbiased</span> flag tells <span
style="font-family:monospace">acf</span> to correct the estimates for
the sample size. The result is an array of correlations. If we select
daily prices for high quality, and extract correlations for lags 1, 7,
30, and 365, we can confirm that <span
style="font-family:monospace">acf</span> and <span
style="font-family:monospace">SerialCorr</span> yield approximately the
same results: </span><span id="hevea_default1466"></span>

    >>> acf[0], acf[1], acf[7], acf[30], acf[365]
    1.000, -0.029, 0.020, 0.014, 0.044

<span style="font-size:medium">With <span
style="font-family:monospace">lag=0</span>, <span
style="font-family:monospace">acf</span> computes the correlation of the
series with itself, which is always 1. </span><span
id="hevea_default1467"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2043.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.5: Autocorrelation function for daily prices (left), and daily prices with a simulated weekly seasonality (right).</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries9"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.5</span>](#timeseries9)<span
style="font-size:medium"> (left) shows autocorrelation functions for the
three quality categories, with <span
style="font-family:monospace">nlags=40</span>. The gray region shows the
normal variability we would expect if there is no actual
autocorrelation; anything that falls outside this range is statistically
significant, with a p-value less than 5%. Since the false positive rate
is 5%, and we are computing 120 correlations (40 lags for each of 3
times series), we expect to see about 6 points outside this region. In
fact, there are 7. We conclude that there are no autocorrelations in
these series that could not be explained by chance. </span><span
id="hevea_default1468"></span><span style="font-size:medium">
</span><span id="hevea_default1469"></span><span
style="font-size:medium"> </span><span
id="hevea_default1470"></span><span style="font-size:medium">
</span><span id="hevea_default1471"></span>

<span style="font-size:medium">I computed the gray regions by resampling
the residuals. You can see my code in <span
style="font-family:monospace">timeseries.py</span>; the function is
called <span
style="font-family:monospace">SimulateAutocorrelation</span>.
</span><span id="hevea_default1472"></span>

<span style="font-size:medium">To see what the autocorrelation function
looks like when there is a seasonal component, I generated simulated
data by adding a weekly cycle. Assuming that demand for cannabis is
higher on weekends, we might expect the price to be higher. To simulate
this effect, I select dates that fall on Friday or Saturday and add a
random amount to the price, chosen from a uniform distribution from $0
to $2. </span><span id="hevea_default1473"></span><span
style="font-size:medium"> </span><span
id="hevea_default1474"></span><span style="font-size:medium">
</span><span id="hevea_default1475"></span>

    def AddWeeklySeasonality(daily):
        frisat = (daily.index.dayofweek==4) | (daily.index.dayofweek==5)
        fake = daily.copy()
        fake.ppg[frisat] += np.random.uniform(0, 2, frisat.sum())
        return fake

<span style="font-size:medium"><span
style="font-family:monospace">frisat</span> is a boolean Series, <span
style="font-family:monospace">True</span> if the day of the week is
Friday or Saturday. <span style="font-family:monospace">fake</span> is a
new DataFrame, initially a copy of <span
style="font-family:monospace">daily</span>, which we modify by adding
random values to <span style="font-family:monospace">ppg</span>. <span
style="font-family:monospace">frisat.sum()</span> is the total number of
Fridays and Saturdays, which is the number of random values we have to
generate. </span><span id="hevea_default1476"></span><span
style="font-size:medium"> </span><span
id="hevea_default1477"></span><span style="font-size:medium">
</span><span id="hevea_default1478"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.5</span>](#timeseries9)<span
style="font-size:medium"> (right) shows autocorrelation functions for
prices with this simulated seasonality. As expected, the correlations
are highest when the lag is a multiple of 7. For high and medium
quality, the new correlations are statistically significant. For low
quality they are not, because residuals in this category are large; the
effect would have to be bigger to be visible through the noise.
</span><span id="hevea_default1479"></span><span
style="font-size:medium"> </span><span
id="hevea_default1480"></span><span style="font-size:medium">
</span><span id="hevea_default1481"></span><span
style="font-size:medium"> </span><span id="hevea_default1482"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.8  Prediction</span>
------------------------------------------------------

<span style="font-size:medium">Time series analysis can be used to
investigate, and sometimes explain, the behavior of systems that vary in
time. It can also make predictions. </span><span
id="hevea_default1483"></span>

<span style="font-size:medium">The linear regressions we used in
Section </span>[<span
style="font-size:medium">12.3</span>](#timeregress)<span
style="font-size:medium"> can be used for prediction. The
RegressionResults class provides <span
style="font-family:monospace">predict</span>, which takes a DataFrame
containing the explanatory variables and returns a sequence of
predictions. Here’s the code: </span><span
id="hevea_default1484"></span><span style="font-size:medium">
</span><span id="hevea_default1485"></span>

    def GenerateSimplePrediction(results, years):
        n = len(years)
        inter = np.ones(n)
        d = dict(Intercept=inter, years=years)
        predict_df = pandas.DataFrame(d)
        predict = results.predict(predict_df)
        return predict

<span style="font-size:medium"><span
style="font-family:monospace">results</span> is a RegressionResults
object; <span style="font-family:monospace">years</span> is the sequence
of time values we want predictions for. The function constructs a
DataFrame, passes it to <span
style="font-family:monospace">predict</span>, and returns the result.
</span><span id="hevea_default1486"></span><span
style="font-size:medium"> </span><span id="hevea_default1487"></span>

<span style="font-size:medium">If all we want is a single, best-guess
prediction, we’re done. But for most purposes it is important to
quantify error. In other words, we want to know how accurate the
prediction is likely to be.</span>

<span style="font-size:medium">There are three sources of error we
should take into account:</span>

-   <span style="font-size:medium">Sampling error: The prediction is
    based on estimated parameters, which depend on random variation in
    the sample. If we run the experiment again, we expect the estimates
    to vary. </span><span id="hevea_default1488"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1489"></span>
-   <span style="font-size:medium">Random variation: Even if the
    estimated parameters are perfect, the observed data varies randomly
    around the long-term trend, and we expect this variation to continue
    in the future. </span><span id="hevea_default1490"></span>
-   <span style="font-size:medium">Modeling error: We have already seen
    evidence that the long-term trend is not linear, so predictions
    based on a linear model will eventually fail. </span><span
    id="hevea_default1491"></span>

<span style="font-size:medium">Another source of error to consider is
unexpected future events. Agricultural prices are affected by weather,
and all prices are affected by politics and law. As I write this,
cannabis is legal in two states and legal for medical purposes in 20
more. If more states legalize it, the price is likely to go down. But if
the federal government cracks down, the price might go up.</span>

<span style="font-size:medium">Modeling errors and unexpected future
events are hard to quantify. Sampling error and random variation are
easier to deal with, so we’ll do that first.</span>

<span style="font-size:medium">To quantify sampling error, I use
resampling, as we did in Section </span>[<span
style="font-size:medium">10.4</span>](thinkstats2011.html#regest)<span
style="font-size:medium">. As always, the goal is to use the actual
observations to simulate what would happen if we ran the experiment
again. The simulations are based on the assumption that the estimated
parameters are correct, but the random residuals could have been
different. Here is a function that runs the simulations: </span><span
id="hevea_default1492"></span>

    def SimulateResults(daily, iters=101):
        model, results = RunLinearModel(daily)
        fake = daily.copy()
        
        result_seq = []
        for i in range(iters):
            fake.ppg = results.fittedvalues + Resample(results.resid)
            _, fake_results = RunLinearModel(fake)
            result_seq.append(fake_results)

        return result_seq

<span style="font-size:medium"><span
style="font-family:monospace">daily</span> is a DataFrame containing the
observed prices; <span style="font-family:monospace">iters</span> is the
number of simulations to run. </span><span
id="hevea_default1493"></span><span style="font-size:medium">
</span><span id="hevea_default1494"></span>

<span style="font-size:medium"><span
style="font-family:monospace">SimulateResults</span> uses <span
style="font-family:monospace">RunLinearModel</span>, from
Section </span>[<span
style="font-size:medium">12.3</span>](#timeregress)<span
style="font-size:medium">, to estimate the slope and intercept of the
observed values.</span>

<span style="font-size:medium">Each time through the loop, it generates
a “fake” dataset by resampling the residuals and adding them to the
fitted values. Then it runs a linear model on the fake data and stores
the RegressionResults object. </span><span
id="hevea_default1495"></span><span style="font-size:medium">
</span><span id="hevea_default1496"></span>

<span style="font-size:medium">The next step is to use the simulated
results to generate predictions:</span>

    def GeneratePredictions(result_seq, years, add_resid=False):
        n = len(years)
        d = dict(Intercept=np.ones(n), years=years, years2=years**2)
        predict_df = pandas.DataFrame(d)
        
        predict_seq = []
        for fake_results in result_seq:
            predict = fake_results.predict(predict_df)
            if add_resid:
                predict += thinkstats2.Resample(fake_results.resid, n)
            predict_seq.append(predict)

        return predict_seq

<span style="font-size:medium"><span
style="font-family:monospace">GeneratePredictions</span> takes the
sequence of results from the previous step, as well as <span
style="font-family:monospace">years</span>, which is a sequence of
floats that specifies the interval to generate predictions for, and
`add_resid`, which indicates whether it should add resampled residuals
to the straight-line prediction. <span
style="font-family:monospace">GeneratePredictions</span> iterates
through the sequence of RegressionResults and generates a sequence of
predictions. </span><span id="hevea_default1497"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2044.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.6: Predictions based on linear fits, showing variation due to sampling error and prediction error.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries4"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Finally, here’s the code that plots a 90%
confidence interval for the predictions: </span><span
id="hevea_default1498"></span>

    def PlotPredictions(daily, years, iters=101, percent=90):
        result_seq = SimulateResults(daily, iters=iters)
        p = (100 - percent) / 2
        percents = p, 100-p

        predict_seq = GeneratePredictions(result_seq, years, True)
        low, high = thinkstats2.PercentileRows(predict_seq, percents)
        thinkplot.FillBetween(years, low, high, alpha=0.3, color='gray')

        predict_seq = GeneratePredictions(result_seq, years, False)
        low, high = thinkstats2.PercentileRows(predict_seq, percents)
        thinkplot.FillBetween(years, low, high, alpha=0.5, color='gray')

<span style="font-size:medium"><span
style="font-family:monospace">PlotPredictions</span> calls <span
style="font-family:monospace">GeneratePredictions</span> twice: once
with `add_resid=True` and again with `add_resid=False`. It uses <span
style="font-family:monospace">PercentileRows</span> to select the 5th
and 95th percentiles for each year, then plots a gray region between
these bounds. </span><span id="hevea_default1499"></span>

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.6</span>](#timeseries4)<span
style="font-size:medium"> shows the result. The dark gray region
represents a 90% confidence interval for the sampling error; that is,
uncertainty about the estimated slope and intercept due to sampling.
</span><span id="hevea_default1500"></span>

<span style="font-size:medium">The lighter region shows a 90% confidence
interval for prediction error, which is the sum of sampling error and
random variation. </span><span id="hevea_default1501"></span>

<span style="font-size:medium">These regions quantify sampling error and
random variation, but not modeling error. In general modeling error is
hard to quantify, but in this case we can address at least one source of
error, unpredictable external events. </span><span
id="hevea_default1502"></span>

<span style="font-size:medium">The regression model is based on the
assumption that the system is <span
style="font-weight:bold">stationary</span>; that is, that the parameters
of the model don’t change over time. Specifically, it assumes that the
slope and intercept are constant, as well as the distribution of
residuals. </span><span id="hevea_default1503"></span><span
style="font-size:medium"> </span><span id="hevea_default1504"></span>

<span style="font-size:medium">But looking at the moving averages in
Figure </span>[<span
style="font-size:medium">12.3</span>](#timeseries10)<span
style="font-size:medium">, it seems like the slope changes at least once
during the observed interval, and the variance of the residuals seems
bigger in the first half than the second. </span><span
id="hevea_default1505"></span>

<span style="font-size:medium">As a result, the parameters we get depend
on the interval we observe. To see how much effect this has on the
predictions, we can extend <span
style="font-family:monospace">SimulateResults</span> to use intervals of
observation with different start and end dates. My implementation is in
<span style="font-family:monospace">timeseries.py</span>. </span><span
id="hevea_default1506"></span>

> ------------------------------------------------------------------------
>
> <span style="font-size:medium"> </span>
>
> <span style="font-size:medium">![](thinkstats2045.png)</span>
>
> <span style="font-size:medium"> </span>
>
> <table>
> <tbody>
> <tr class="odd">
> <td style="text-align: left;"><span style="font-size:medium">Figure 12.7: Predictions based on linear fits, showing variation due to the interval of observation.</span></td>
> </tr>
> </tbody>
> </table>
>
> <span style="font-size:medium"> </span><span
> id="timeseries5"></span><span style="font-size:medium"> </span>
>
> ------------------------------------------------------------------------

<span style="font-size:medium">Figure </span>[<span
style="font-size:medium">12.7</span>](#timeseries5)<span
style="font-size:medium"> shows the result for the medium quality
category. The lightest gray area shows a confidence interval that
includes uncertainty due to sampling error, random variation, and
variation in the interval of observation. </span><span
id="hevea_default1507"></span><span style="font-size:medium">
</span><span id="hevea_default1508"></span>

<span style="font-size:medium">The model based on the entire interval
has positive slope, indicating that prices were increasing. But the most
recent interval shows signs of decreasing prices, so models based on the
most recent data have negative slope. As a result, the widest predictive
interval includes the possibility of decreasing prices over the next
year. </span><span id="hevea_default1509"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.9  Further reading</span>
-----------------------------------------------------------

<span style="font-size:medium">Time series analysis is a big topic; this
chapter has only scratched the surface. An important tool for working
with time series data is autoregression, which I did not cover here,
mostly because it turns out not to be useful for the example data I
worked with. </span><span id="hevea_default1510"></span>

<span style="font-size:medium">But once you have learned the material in
this chapter, you are well prepared to learn about autoregression. One
resource I recommend is Philipp Janert’s book, <span
style="font-style:italic">Data Analysis with Open Source Tools</span>,
O’Reilly Media, 2011. His chapter on time series analysis picks up where
this one leaves off. </span><span id="hevea_default1511"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.10  Exercises</span>
------------------------------------------------------

<span style="font-size:medium">My solution to these exercises is in
`chap12soln.py`.</span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *The linear model I used in
this chapter has the obvious drawback that it is linear, and there is no
reason to expect prices to change linearly over time. We can add
flexibility to the model by adding a quadratic term, as we did in
Section *</span>[<span
style="font-size:medium">*11.3*</span>](thinkstats2012.html#nonlinear)<span
style="font-size:medium">*.* </span><span
id="hevea_default1512"></span><span style="font-size:medium">
</span><span id="hevea_default1513"></span><span
style="font-size:medium"> </span><span id="hevea_default1514"></span>

<span style="font-size:medium">*Use a quadratic model to fit the time
series of daily prices, and use the model to generate predictions. You
will have to write a version of <span
style="font-family:monospace">RunLinearModel</span> that runs that
quadratic model, but after that you should be able to reuse code in
<span style="font-family:monospace">timeseries.py</span> to generate
predictions.* </span><span id="hevea_default1515"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *Write a definition for a
class named <span
style="font-family:monospace">SerialCorrelationTest</span> that extends
<span style="font-family:monospace">HypothesisTest</span> from
Section *</span>[<span
style="font-size:medium">*9.2*</span>](thinkstats2010.html#hypotest)<span
style="font-size:medium">*. It should take a series and a lag as data,
compute the serial correlation of the series with the given lag, and
then compute the p-value of the observed correlation.* </span><span
id="hevea_default1516"></span><span style="font-size:medium">
</span><span id="hevea_default1517"></span><span
style="font-size:medium"> </span><span id="hevea_default1518"></span>

<span style="font-size:medium">*Use this class to test whether the
serial correlation in raw price data is statistically significant. Also
test the residuals of the linear model and (if you did the previous
exercise), the quadratic model.* </span><span
id="hevea_default1519"></span><span style="font-size:medium">
</span><span id="hevea_default1520"></span><span
style="font-size:medium"> </span><span id="hevea_default1521"></span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *There are several ways to
extend the EWMA model to generate predictions. One of the simplest is
something like this:* </span><span id="hevea_default1522"></span>

1.  <span style="font-size:medium">*Compute the EWMA of the time series
    and use the last point as an intercept, <span
    style="font-family:monospace">inter</span>.*</span>
2.  <span style="font-size:medium">*Compute the EWMA of differences
    between successive elements in the time series and use the last
    point as a slope, <span style="font-family:monospace">slope</span>.*
    </span><span id="hevea_default1523"></span>
3.  <span style="font-size:medium">*To predict values at future times,
    compute <span style="font-family:monospace">inter + slope \*
    dt</span>, where <span style="font-family:monospace">dt</span> is
    the difference between the time of the prediction and the time of
    the last observation.* </span><span id="hevea_default1524"></span>

<span style="font-size:medium">*Use this method to generate predictions
for a year after the last observation. A few hints:*</span>

-   <span style="font-size:medium">*Use <span
    style="font-family:monospace">timeseries.FillMissing</span> to fill
    in missing values before running this analysis. That way the time
    between consecutive elements is consistent.* </span><span
    id="hevea_default1525"></span>
-   <span style="font-size:medium">*Use <span
    style="font-family:monospace">Series.diff</span> to compute
    differences between successive elements.* </span><span
    id="hevea_default1526"></span>
-   <span style="font-size:medium">*Use <span
    style="font-family:monospace">reindex</span> to extend the DataFrame
    index into the future.* </span><span id="hevea_default1527"></span>
-   <span style="font-size:medium">*Use <span
    style="font-family:monospace">fillna</span> to put your predicted
    values into the DataFrame.* </span><span
    id="hevea_default1528"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">12.11  Glossary</span>
-----------------------------------------------------

-   <span style="font-size:medium">time series: A dataset where each
    value is associated with a timestamp, often a series of measurements
    and the times they were collected. </span><span
    id="hevea_default1529"></span>
-   <span style="font-size:medium">window: A sequence of consecutive
    values in a time series, often used to compute a moving average.
    </span><span id="hevea_default1530"></span>
-   <span style="font-size:medium">moving average: One of several
    statistics intended to estimate the underlying trend in a time
    series by computing averages (of some kind) for a series of
    overlapping windows. </span><span id="hevea_default1531"></span>
-   <span style="font-size:medium">rolling mean: A moving average based
    on the mean value in each window. </span><span
    id="hevea_default1532"></span>
-   <span style="font-size:medium">exponentially-weighted moving average
    (EWMA): A moving average based on a weighted mean that gives the
    highest weight to the most recent values, and exponentially
    decreasing weights to earlier values. </span><span
    id="hevea_default1533"></span><span style="font-size:medium">
    </span><span id="hevea_default1534"></span>
-   <span style="font-size:medium">span: A parameter of EWMA that
    determines how quickly the weights decrease. </span><span
    id="hevea_default1535"></span>
-   <span style="font-size:medium">serial correlation: Correlation
    between a time series and a shifted or lagged version of itself.
    </span><span id="hevea_default1536"></span>
-   <span style="font-size:medium">lag: The size of the shift in a
    serial correlation or autocorrelation. </span><span
    id="hevea_default1537"></span>
-   <span style="font-size:medium">autocorrelation: A more general term
    for a serial correlation with any amount of lag. </span><span
    id="hevea_default1538"></span>
-   <span style="font-size:medium">autocorrelation function: A function
    that maps from lag to serial correlation.</span>
-   <span style="font-size:medium">stationary: A model is stationary if
    the parameters and the distribution of residuals does not change
    over time. </span><span id="hevea_default1539"></span><span
    style="font-size:medium"> </span><span
    id="hevea_default1540"></span>

<span style="font-size:medium"> </span>
