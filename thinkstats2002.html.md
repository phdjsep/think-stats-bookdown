This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

<span style="font-size:medium">Chapter 1  Exploratory data analysis</span>
==========================================================================

<span style="font-size:medium"> </span><span id="intro"></span>

<span style="font-size:medium">The thesis of this book is that data
combined with practical methods can answer questions and guide decisions
under uncertainty.</span>

<span style="font-size:medium">As an example, I present a case study
motivated by a question I heard when my wife and I were expecting our
first child: do first babies tend to arrive late? </span><span
id="hevea_default28"></span>

<span style="font-size:medium">If you Google this question, you will
find plenty of discussion. Some people claim it’s true, others say it’s
a myth, and some people say it’s the other way around: first babies come
early.</span>

<span style="font-size:medium">In many of these discussions, people
provide data to support their claims. I found many examples like
these:</span>

> <span style="font-size:medium">“My two friends that have given birth
> recently to their first babies, BOTH went almost 2 weeks overdue
> before going into labour or being induced.”</span>
>
> <span style="font-size:medium">“My first one came 2 weeks late and now
> I think the second one is going to come out two weeks early!!”</span>
>
> <span style="font-size:medium">“I don’t think that can be true because
> my sister was my mother’s first and she was early, as with many of my
> cousins.”</span>

<span style="font-size:medium">Reports like these are called <span
style="font-weight:bold">anecdotal evidence</span> because they are
based on data that is unpublished and usually personal. In casual
conversation, there is nothing wrong with anecdotes, so I don’t mean to
pick on the people I quoted. </span><span id="hevea_default29"></span>

<span style="font-size:medium">But we might want evidence that is more
persuasive and an answer that is more reliable. By those standards,
anecdotal evidence usually fails, because:</span>

-   <span style="font-size:medium">Small number of observations: If
    pregnancy length is longer for first babies, the difference is
    probably small compared to natural variation. In that case, we might
    have to compare a large number of pregnancies to be sure that a
    difference exists. </span><span id="hevea_default30"></span>
-   <span style="font-size:medium">Selection bias: People who join a
    discussion of this question might be interested because their first
    babies were late. In that case the process of selecting data would
    bias the results. </span><span id="hevea_default31"></span><span
    style="font-size:medium"> </span><span id="hevea_default32"></span>
-   <span style="font-size:medium">Confirmation bias: People who believe
    the claim might be more likely to contribute examples that confirm
    it. People who doubt the claim are more likely to cite
    counterexamples. </span><span id="hevea_default33"></span><span
    style="font-size:medium"> </span><span id="hevea_default34"></span>
-   <span style="font-size:medium">Inaccuracy: Anecdotes are often
    personal stories, and often misremembered, misrepresented, repeated
    inaccurately, etc.</span>

<span style="font-size:medium">So how can we do better?</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.1  A statistical approach</span>
-----------------------------------------------------------------

<span style="font-size:medium">To address the limitations of anecdotes,
we will use the tools of statistics, which include:</span>

-   <span style="font-size:medium">Data collection: We will use data
    from a large national survey that was designed explicitly with the
    goal of generating statistically valid inferences about the U.S.
    population. </span><span id="hevea_default35"></span>
-   <span style="font-size:medium">Descriptive statistics: We will
    generate statistics that summarize the data concisely, and evaluate
    different ways to visualize data. </span><span
    id="hevea_default36"></span>
-   <span style="font-size:medium">Exploratory data analysis: We will
    look for patterns, differences, and other features that address the
    questions we are interested in. At the same time we will check for
    inconsistencies and identify limitations. </span><span
    id="hevea_default37"></span>
-   <span style="font-size:medium">Estimation: We will use data from a
    sample to estimate characteristics of the general population.
    </span><span id="hevea_default38"></span>
-   <span style="font-size:medium">Hypothesis testing: Where we see
    apparent effects, like a difference between two groups, we will
    evaluate whether the effect might have happened by chance.
    </span><span id="hevea_default39"></span>

<span style="font-size:medium">By performing these steps with care to
avoid pitfalls, we can reach conclusions that are more justifiable and
more likely to be correct.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.2  The National Survey of Family Growth</span>
-------------------------------------------------------------------------------

<span style="font-size:medium"> </span><span id="nsfg"></span>

<span style="font-size:medium">Since 1973 the U.S. Centers for Disease
Control and Prevention (CDC) have conducted the National Survey of
Family Growth (NSFG), which is intended to gather “information on family
life, marriage and divorce, pregnancy, infertility, use of
contraception, and men’s and women’s health. The survey results are used
... to plan health services and health education programs, and to do
statistical studies of families, fertility, and health.” See
</span>[<span
style="font-family:monospace;font-size:medium">http://cdc.gov/nchs/nsfg.htm</span>](http://cdc.gov/nchs/nsfg.htm)<span
style="font-size:medium">. </span><span
id="hevea_default40"></span><span style="font-size:medium"> </span><span
id="hevea_default41"></span>

<span style="font-size:medium">We will use data collected by this survey
to investigate whether first babies tend to come late, and other
questions. In order to use this data effectively, we have to understand
the design of the study.</span>

<span style="font-size:medium">The NSFG is a <span
style="font-weight:bold">cross-sectional</span> study, which means that
it captures a snapshot of a group at a point in time. The most common
alternative is a <span style="font-weight:bold">longitudinal</span>
study, which observes a group repeatedly over a period of time.
</span><span id="hevea_default42"></span><span style="font-size:medium">
</span><span id="hevea_default43"></span><span style="font-size:medium">
</span><span id="hevea_default44"></span><span style="font-size:medium">
</span><span id="hevea_default45"></span>

<span style="font-size:medium">The NSFG has been conducted seven times;
each deployment is called a <span style="font-weight:bold">cycle</span>.
We will use data from Cycle 6, which was conducted from January 2002 to
March 2003. </span><span id="hevea_default46"></span>

<span style="font-size:medium">The goal of the survey is to draw
conclusions about a <span style="font-weight:bold">population</span>;
the target population of the NSFG is people in the United States aged
15-44. Ideally surveys would collect data from every member of the
population, but that’s seldom possible. Instead we collect data from a
subset of the population called a <span
style="font-weight:bold">sample</span>. The people who participate in a
survey are called <span style="font-weight:bold">respondents</span>.
</span><span id="hevea_default47"></span>

<span style="font-size:medium">In general, cross-sectional studies are
meant to be <span style="font-weight:bold">representative</span>, which
means that every member of the target population has an equal chance of
participating. That ideal is hard to achieve in practice, but people who
conduct surveys come as close as they can. </span><span
id="hevea_default48"></span><span style="font-size:medium"> </span><span
id="hevea_default49"></span>

<span style="font-size:medium">The NSFG is not representative; instead
it is deliberately <span style="font-weight:bold">oversampled</span>.
The designers of the study recruited three groups—Hispanics,
African-Americans and teenagers—at rates higher than their
representation in the U.S. population, in order to make sure that the
number of respondents in each of these groups is large enough to draw
valid statistical inferences. </span><span id="hevea_default50"></span>

<span style="font-size:medium">Of course, the drawback of oversampling
is that it is not as easy to draw conclusions about the general
population based on statistics from the survey. We will come back to
this point later.</span>

<span style="font-size:medium">When working with this kind of data, it
is important to be familiar with the <span
style="font-weight:bold">codebook</span>, which documents the design of
the study, the survey questions, and the encoding of the responses. The
codebook and user’s guide for the NSFG data are available from
</span>[<span
style="font-family:monospace;font-size:medium">http://www.cdc.gov/nchs/nsfg/nsfg\_cycle6.htm</span>](http://www.cdc.gov/nchs/nsfg/nsfg_cycle6.htm)

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.3  Importing the data</span>
-------------------------------------------------------------

<span style="font-size:medium">The code and data used in this book are
available from </span>[<span
style="font-family:monospace;font-size:medium">https://github.com/AllenDowney/ThinkStats2</span>](https://github.com/AllenDowney/ThinkStats2)<span
style="font-size:medium">. For information about downloading and working
with this code, see Section </span>[<span
style="font-size:medium">0.2</span>](thinkstats2001.html#code)<span
style="font-size:medium">.</span>

<span style="font-size:medium">Once you download the code, you should
have a file called <span
style="font-family:monospace">ThinkStats2/code/nsfg.py</span>. If you
run it, it should read a data file, run some tests, and print a message
like, “All tests passed.”</span>

<span style="font-size:medium">Let’s see what it does. Pregnancy data
from Cycle 6 of the NSFG is in a file called <span
style="font-family:monospace">2002FemPreg.dat.gz</span>; it is a
gzip-compressed data file in plain text (ASCII), with fixed width
columns. Each line in the file is a <span
style="font-weight:bold">record</span> that contains data about one
pregnancy.</span>

<span style="font-size:medium">The format of the file is documented in
<span style="font-family:monospace">2002FemPreg.dct</span>, which is a
Stata dictionary file. Stata is a statistical software system; a
“dictionary” in this context is a list of variable names, types, and
indices that identify where in each line to find each variable.</span>

<span style="font-size:medium">For example, here are a few lines from
<span style="font-family:monospace">2002FemPreg.dct</span>: </span>

    infile dictionary {
      _column(1)  str12  caseid    %12s  "RESPONDENT ID NUMBER"
      _column(13) byte   pregordr   %2f  "PREGNANCY ORDER (NUMBER)"
    }

<span style="font-size:medium">This dictionary describes two variables:
<span style="font-family:monospace">caseid</span> is a 12-character
string that represents the respondent ID; <span
style="font-family:monospace">pregorder</span> is a one-byte integer
that indicates which pregnancy this record describes for this
respondent.</span>

<span style="font-size:medium">The code you downloaded includes <span
style="font-family:monospace">thinkstats2.py</span>, which is a Python
module that contains many classes and functions used in this book,
including functions that read the Stata dictionary and the NSFG data
file. Here’s how they are used in <span
style="font-family:monospace">nsfg.py</span>:</span>

    def ReadFemPreg(dct_file='2002FemPreg.dct',
                    dat_file='2002FemPreg.dat.gz'):
        dct = thinkstats2.ReadStataDct(dct_file)
        df = dct.ReadFixedWidth(dat_file, compression='gzip')
        CleanFemPreg(df)
        return df

<span style="font-size:medium"><span
style="font-family:monospace">ReadStataDct</span> takes the name of the
dictionary file and returns <span
style="font-family:monospace">dct</span>, a <span
style="font-family:monospace">FixedWidthVariables</span> object that
contains the information from the dictionary file. <span
style="font-family:monospace">dct</span> provides <span
style="font-family:monospace">ReadFixedWidth</span>, which reads the
data file.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.4  DataFrames</span>
-----------------------------------------------------

<span style="font-size:medium"> </span><span id="dataframe"></span>

<span style="font-size:medium">The result of <span
style="font-family:monospace">ReadFixedWidth</span> is a DataFrame,
which is the fundamental data structure provided by pandas, which is a
Python data and statistics package we’ll use throughout this book. A
DataFrame contains a row for each record, in this case one row per
pregnancy, and a column for each variable. </span><span
id="hevea_default51"></span><span style="font-size:medium"> </span><span
id="hevea_default52"></span>

<span style="font-size:medium">In addition to the data, a DataFrame also
contains the variable names and their types, and it provides methods for
accessing and modifying the data.</span>

<span style="font-size:medium">If you print <span
style="font-family:monospace">df</span> you get a truncated view of the
rows and columns, and the shape of the DataFrame, which is 13593
rows/records and 244 columns/variables.</span>

    >>> import nsfg
    >>> df = nsfg.ReadFemPreg()
    >>> df
    ...
    [13593 rows x 244 columns]

<span style="font-size:medium">The DataFrame is too big to display, so
the output is truncated. The last line reports the number of rows and
columns.</span>

<span style="font-size:medium">The attribute <span
style="font-family:monospace">columns</span> returns a sequence of
column names as Unicode strings:</span>

    >>> df.columns
    Index([u'caseid', u'pregordr', u'howpreg_n', u'howpreg_p', ... ])

<span style="font-size:medium">The result is an Index, which is another
pandas data structure. We’ll learn more about Index later, but for now
we’ll treat it like a list: </span><span
id="hevea_default53"></span><span style="font-size:medium"> </span><span
id="hevea_default54"></span>

    >>> df.columns[1]
    'pregordr'

<span style="font-size:medium">To access a column from a DataFrame, you
can use the column name as a key: </span><span
id="hevea_default55"></span>

    >>> pregordr = df['pregordr']
    >>> type(pregordr)
    <class 'pandas.core.series.Series'>

<span style="font-size:medium">The result is a Series, yet another
pandas data structure. A Series is like a Python list with some
additional features. When you print a Series, you get the indices and
the corresponding values: </span><span id="hevea_default56"></span>

    >>> pregordr
    0     1
    1     2
    2     1
    3     2
    ...
    13590    3
    13591    4
    13592    5
    Name: pregordr, Length: 13593, dtype: int64

<span style="font-size:medium">In this example the indices are integers
from 0 to 13592, but in general they can be any sortable type. The
elements are also integers, but they can be any type.</span>

<span style="font-size:medium">The last line includes the variable name,
Series length, and data type; <span
style="font-family:monospace">int64</span> is one of the types provided
by NumPy. If you run this example on a 32-bit machine you might see
<span style="font-family:monospace">int32</span>. </span><span
id="hevea_default57"></span>

<span style="font-size:medium">You can access the elements of a Series
using integer indices and slices:</span>

    >>> pregordr[0]
    1
    >>> pregordr[2:5]
    2    1
    3    2
    4    3
    Name: pregordr, dtype: int64

<span style="font-size:medium">The result of the index operator is an
<span style="font-family:monospace">int64</span>; the result of the
slice is another Series.</span>

<span style="font-size:medium">You can also access the columns of a
DataFrame using dot notation: </span><span id="hevea_default58"></span>

    >>> pregordr = df.pregordr

<span style="font-size:medium">This notation only works if the column
name is a valid Python identifier, so it has to begin with a letter,
can’t contain spaces, etc.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.5  Variables</span>
----------------------------------------------------

<span style="font-size:medium">We have already seen two variables in the
NSFG dataset, <span style="font-family:monospace">caseid</span> and
<span style="font-family:monospace">pregordr</span>, and we have seen
that there are 244 variables in total. For the explorations in this
book, I use the following variables:</span>

-   <span style="font-size:medium"><span
    style="font-family:monospace">caseid</span> is the integer ID of the
    respondent.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">prglngth</span> is the integer
    duration of the pregnancy in weeks. </span><span
    id="hevea_default59"></span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">outcome</span> is an integer code for
    the outcome of the pregnancy. The code 1 indicates a live
    birth.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">pregordr</span> is a pregnancy serial
    number; for example, the code for a respondent’s first pregnancy is
    1, for the second pregnancy is 2, and so on.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">birthord</span> is a serial number for
    live births; the code for a respondent’s first child is 1, and so
    on. For outcomes other than live birth, this field is blank.</span>
-   <span style="font-size:medium">`birthwgt_lb` and `birthwgt_oz`
    contain the pounds and ounces parts of the birth weight of the baby.
    </span><span id="hevea_default60"></span><span
    style="font-size:medium"> </span><span id="hevea_default61"></span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">agepreg</span> is the mother’s age at
    the end of the pregnancy.</span>
-   <span style="font-size:medium"><span
    style="font-family:monospace">finalwgt</span> is the statistical
    weight associated with the respondent. It is a floating-point value
    that indicates the number of people in the U.S. population this
    respondent represents. </span><span id="hevea_default62"></span>

<span style="font-size:medium">If you read the codebook carefully, you
will see that many of the variables are <span
style="font-weight:bold">recodes</span>, which means that they are not
part of the <span style="font-weight:bold">raw data</span> collected by
the survey; they are calculated using the raw data. </span><span
id="hevea_default63"></span><span style="font-size:medium"> </span><span
id="hevea_default64"></span>

<span style="font-size:medium">For example, <span
style="font-family:monospace">prglngth</span> for live births is equal
to the raw variable <span style="font-family:monospace">wksgest</span>
(weeks of gestation) if it is available; otherwise it is estimated using
<span style="font-family:monospace">mosgest \* 4.33</span> (months of
gestation times the average number of weeks in a month).</span>

<span style="font-size:medium">Recodes are often based on logic that
checks the consistency and accuracy of the data. In general it is a good
idea to use recodes when they are available, unless there is a
compelling reason to process the raw data yourself.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.6  Transformation</span>
---------------------------------------------------------

<span style="font-size:medium"> </span><span id="cleaning"></span>

<span style="font-size:medium">When you import data like this, you often
have to check for errors, deal with special values, convert data into
different formats, and perform calculations. These operations are called
<span style="font-weight:bold">data cleaning</span>.</span>

<span style="font-size:medium"><span
style="font-family:monospace">nsfg.py</span> includes <span
style="font-family:monospace">CleanFemPreg</span>, a function that
cleans the variables I am planning to use.</span>

    def CleanFemPreg(df):
        df.agepreg /= 100.0

        na_vals = [97, 98, 99]
        df.birthwgt_lb.replace(na_vals, np.nan, inplace=True)
        df.birthwgt_oz.replace(na_vals, np.nan, inplace=True)

        df['totalwgt_lb'] = df.birthwgt_lb + df.birthwgt_oz / 16.0    

<span style="font-size:medium"><span
style="font-family:monospace">agepreg</span> contains the mother’s age
at the end of the pregnancy. In the data file, <span
style="font-family:monospace">agepreg</span> is encoded as an integer
number of centiyears. So the first line divides each element of <span
style="font-family:monospace">agepreg</span> by 100, yielding a
floating-point value in years.</span>

<span style="font-size:medium">`birthwgt_lb` and `birthwgt_oz` contain
the weight of the baby, in pounds and ounces, for pregnancies that end
in live birth. In addition it uses several special codes:</span>

    97 NOT ASCERTAINED
    98 REFUSED  
    99 DON'T KNOW

<span style="font-size:medium">Special values encoded as numbers are
*dangerous* because if they are not handled properly, they can generate
bogus results, like a 99-pound baby. The <span
style="font-family:monospace">replace</span> method replaces these
values with <span style="font-family:monospace">np.nan</span>, a special
floating-point value that represents “not a number.” The <span
style="font-family:monospace">inplace</span> flag tells <span
style="font-family:monospace">replace</span> to modify the existing
Series rather than create a new one. </span><span
id="hevea_default65"></span>

<span style="font-size:medium">As part of the IEEE floating-point
standard, all mathematical operations return <span
style="font-family:monospace">nan</span> if either argument is <span
style="font-family:monospace">nan</span>:</span>

    >>> import numpy as np
    >>> np.nan / 100.0
    nan

<span style="font-size:medium">So computations with <span
style="font-family:monospace">nan</span> tend to do the right thing, and
most pandas functions handle <span
style="font-family:monospace">nan</span> appropriately. But dealing with
missing data will be a recurring issue. </span><span
id="hevea_default66"></span><span style="font-size:medium"> </span><span
id="hevea_default67"></span>

<span style="font-size:medium">The last line of <span
style="font-family:monospace">CleanFemPreg</span> creates a new column
`totalwgt_lb` that combines pounds and ounces into a single quantity, in
pounds.</span>

<span style="font-size:medium">One important note: when you add a new
column to a DataFrame, you must use dictionary syntax, like this
</span><span id="hevea_default68"></span>

        # CORRECT
        df['totalwgt_lb'] = df.birthwgt_lb + df.birthwgt_oz / 16.0 

<span style="font-size:medium">Not dot notation, like this:</span>

        # WRONG!
        df.totalwgt_lb = df.birthwgt_lb + df.birthwgt_oz / 16.0 

<span style="font-size:medium">The version with dot notation adds an
attribute to the DataFrame object, but that attribute is not treated as
a new column.</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.7  Validation</span>
-----------------------------------------------------

<span style="font-size:medium">When data is exported from one software
environment and imported into another, errors might be introduced. And
when you are getting familiar with a new dataset, you might interpret
data incorrectly or introduce other misunderstandings. If you take time
to validate the data, you can save time later and avoid errors.</span>

<span style="font-size:medium">One way to validate data is to compute
basic statistics and compare them with published results. For example,
the NSFG codebook includes tables that summarize each variable. Here is
the table for <span style="font-family:monospace">outcome</span>, which
encodes the outcome of each pregnancy:</span>

    value label           Total
    1 LIVE BIRTH              9148
    2 INDUCED ABORTION        1862
    3 STILLBIRTH               120
    4 MISCARRIAGE             1921
    5 ECTOPIC PREGNANCY        190
    6 CURRENT PREGNANCY        352

<span style="font-size:medium">The Series class provides a method,
`value_counts`, that counts the number of times each value appears. If
we select the <span style="font-family:monospace">outcome</span> Series
from the DataFrame, we can use `value_counts` to compare with the
published data: </span><span id="hevea_default69"></span><span
style="font-size:medium"> </span><span id="hevea_default70"></span>

    >>> df.outcome.value_counts(sort=False)
    1    9148
    2    1862
    3     120
    4    1921
    5     190
    6     352

<span style="font-size:medium">The result of `value_counts` is a Series;
`sort=False` doesn’t sort the Series by values, so them appear in
order.</span>

<span style="font-size:medium">Comparing the results with the published
table, it looks like the values in <span
style="font-family:monospace">outcome</span> are correct. Similarly,
here is the published table for `birthwgt_lb`</span>

    value label                  Total
    . INAPPLICABLE            4449
    0-5 UNDER 6 POUNDS          1125
    6 6 POUNDS                2223
    7 7 POUNDS                3049
    8 8 POUNDS                1889
    9-95 9 POUNDS OR MORE         799

<span style="font-size:medium">And here are the value counts:</span>

    >>> df.birthwgt_lb.value_counts(sort=False)
    0        8
    1       40
    2       53
    3       98
    4      229
    5      697
    6     2223
    7     3049
    8     1889
    9      623
    10     132
    11      26
    12      10
    13       3
    14       3
    15       1
    51       1

<span style="font-size:medium">The counts for 6, 7, and 8 pounds check
out, and if you add up the counts for 0-5 and 9-95, they check out, too.
But if you look more closely, you will notice one value that has to be
an error, a 51 pound baby!</span>

<span style="font-size:medium">To deal with this error, I added a line
to <span style="font-family:monospace">CleanFemPreg</span>:</span>

    df.loc[df.birthwgt_lb > 20, 'birthwgt_lb'] = np.nan

<span style="font-size:medium">This statement replaces invalid values
with <span style="font-family:monospace">np.nan</span>. The attribute
<span style="font-family:monospace">loc</span> provides several ways to
select rows and columns from a DataFrame. In this example, the first
expression in brackets is the row indexer; the second expression selects
the column. </span><span id="hevea_default71"></span><span
style="font-size:medium"> </span><span id="hevea_default72"></span>

<span style="font-size:medium">The expression `df.birthwgt_lb > 20`
yields a Series of type <span style="font-family:monospace">bool</span>,
where True indicates that the condition is true. When a boolean Series
is used as an index, it selects only the elements that satisfy the
condition. </span><span id="hevea_default73"></span><span
style="font-size:medium"> </span><span id="hevea_default74"></span><span
style="font-size:medium"> </span><span id="hevea_default75"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.8  Interpretation</span>
---------------------------------------------------------

<span style="font-size:medium">To work with data effectively, you have
to think on two levels at the same time: the level of statistics and the
level of context.</span>

<span style="font-size:medium">As an example, let’s look at the sequence
of outcomes for a few respondents. Because of the way the data files are
organized, we have to do some processing to collect the pregnancy data
for each respondent. Here’s a function that does that:</span>

    def MakePregMap(df):
        d = defaultdict(list)
        for index, caseid in df.caseid.iteritems():
            d[caseid].append(index)
        return d

<span style="font-size:medium"><span
style="font-family:monospace">df</span> is the DataFrame with pregnancy
data. The <span style="font-family:monospace">iteritems</span> method
enumerates the index (row number) and <span
style="font-family:monospace">caseid</span> for each pregnancy.
</span><span id="hevea_default76"></span>

<span style="font-size:medium"><span
style="font-family:monospace">d</span> is a dictionary that maps from
each case ID to a list of indices. If you are not familiar with <span
style="font-family:monospace">defaultdict</span>, it is in the Python
<span style="font-family:monospace">collections</span> module. Using
<span style="font-family:monospace">d</span>, we can look up a
respondent and get the indices of that respondent’s pregnancies.</span>

<span style="font-size:medium">This example looks up one respondent and
prints a list of outcomes for her pregnancies:</span>

    >>> caseid = 10229
    >>> preg_map = nsfg.MakePregMap(df)
    >>> indices = preg_map[caseid]
    >>> df.outcome[indices].values
    [4 4 4 4 4 4 1]

<span style="font-size:medium"><span
style="font-family:monospace">indices</span> is the list of indices for
pregnancies corresponding to respondent <span
style="font-family:monospace">10229</span>.</span>

<span style="font-size:medium">Using this list as an index into <span
style="font-family:monospace">df.outcome</span> selects the indicated
rows and yields a Series. Instead of printing the whole Series, I
selected the <span style="font-family:monospace">values</span>
attribute, which is a NumPy array. </span><span
id="hevea_default77"></span><span style="font-size:medium"> </span><span
id="hevea_default78"></span>

<span style="font-size:medium">The outcome code <span
style="font-family:monospace">1</span> indicates a live birth. Code
<span style="font-family:monospace">4</span> indicates a miscarriage;
that is, a pregnancy that ended spontaneously, usually with no known
medical cause.</span>

<span style="font-size:medium">Statistically this respondent is not
unusual. Miscarriages are common and there are other respondents who
reported as many or more.</span>

<span style="font-size:medium">But remembering the context, this data
tells the story of a woman who was pregnant six times, each time ending
in miscarriage. Her seventh and most recent pregnancy ended in a live
birth. If we consider this data with empathy, it is natural to be moved
by the story it tells.</span>

<span style="font-size:medium">Each record in the NSFG dataset
represents a person who provided honest answers to many personal and
difficult questions. We can use this data to answer statistical
questions about family life, reproduction, and health. At the same time,
we have an obligation to consider the people represented by the data,
and to afford them respect and gratitude. </span><span
id="hevea_default79"></span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.9  Exercises</span>
----------------------------------------------------

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 1</span>   *In the repository you
downloaded, you should find a file named `chap01ex.ipynb`, which is an
IPython notebook. You can launch IPython notebook from the command line
like this:* </span><span id="hevea_default80"></span>

    $ ipython notebook &

<span style="font-size:medium">*If IPython is installed, it should
launch a server that runs in the background and open a browser to view
the notebook. If you are not familiar with IPython, I suggest you start
at* </span>[<span
style="font-family:monospace;font-size:medium">*http://ipython.org/ipython-doc/stable/notebook/notebook.html*</span>](http://ipython.org/ipython-doc/stable/notebook/notebook.html)<span
style="font-size:medium">*.*</span>

<span style="font-size:medium">*To launch the IPython notebook server,
run:*</span>

    $ ipython notebook &

<span style="font-size:medium">*It should open a new browser window, but
if not, the startup message provides a URL you can load in a browser,
usually* </span>[<span
style="font-family:monospace;font-size:medium">*http://localhost:8888*</span>](http://localhost:8888)<span
style="font-size:medium">*. The new window should list the notebooks in
the repository.*</span>

<span style="font-size:medium">*Open `chap01ex.ipynb`. Some cells are
already filled in, and you should execute them. Other cells give you
instructions for exercises you should try.*</span>

<span style="font-size:medium">*A solution to this exercise is in
`chap01soln.ipynb`* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 2</span>   *In the repository you
downloaded, you should find a file named `chap01ex.py`; using this file
as a starting place, write a function that reads the respondent file,
<span style="font-family:monospace">2002FemResp.dat.gz</span>.*</span>

<span style="font-size:medium">*The variable <span
style="font-family:monospace">pregnum</span> is a recode that indicates
how many times each respondent has been pregnant. Print the value counts
for this variable and compare them to the published results in the NSFG
codebook.*</span>

<span style="font-size:medium">*You can also cross-validate the
respondent and pregnancy files by comparing <span
style="font-family:monospace">pregnum</span> for each respondent with
the number of records in the pregnancy file.*</span>

<span style="font-size:medium">*You can use <span
style="font-family:monospace">nsfg.MakePregMap</span> to make a
dictionary that maps from each <span
style="font-family:monospace">caseid</span> to a list of indices into
the pregnancy DataFrame.* </span><span id="hevea_default81"></span>

<span style="font-size:medium">*A solution to this exercise is in
`chap01soln.py`* </span>

<span style="font-size:medium"><span
style="font-weight:bold">Exercise 3</span>   *The best way to learn
about statistics is to work on a project you are interested in. Is there
a question like, “Do first babies arrive late,” that you want to
investigate?*</span>

<span style="font-size:medium">*Think about questions you find
personally interesting, or items of conventional wisdom, or
controversial topics, or questions that have political consequences, and
see if you can formulate a question that lends itself to statistical
inquiry.*</span>

<span style="font-size:medium">*Look for data to help you address the
question. Governments are good sources because data from public research
is often freely available. Good places to start include* </span>[<span
style="font-family:monospace;font-size:medium">*http://www.data.gov/*</span>](http://www.data.gov/)<span
style="font-size:medium">*, and* </span>[<span
style="font-family:monospace;font-size:medium">*http://www.science.gov/*</span>](http://www.science.gov/)<span
style="font-size:medium">*, and in the United Kingdom,* </span>[<span
style="font-family:monospace;font-size:medium">*http://data.gov.uk/*</span>](http://data.gov.uk/)<span
style="font-size:medium">*.*</span>

<span style="font-size:medium">*Two of my favorite data sets are the
General Social Survey at* </span>[<span
style="font-family:monospace;font-size:medium">*http://www3.norc.org/gss+website/*</span>](http://www3.norc.org/gss+website/)<span
style="font-size:medium">*, and the European Social Survey at*
</span>[<span
style="font-family:monospace;font-size:medium">*http://www.europeansocialsurvey.org/*</span>](http://www.europeansocialsurvey.org/)<span
style="font-size:medium">*.*</span>

<span style="font-size:medium">*If it seems like someone has already
answered your question, look closely to see whether the answer is
justified. There might be flaws in the data or the analysis that make
the conclusion unreliable. In that case you could perform a different
analysis of the same data, or look for a better source of data.*</span>

<span style="font-size:medium">*If you find a published paper that
addresses your question, you should be able to get the raw data. Many
authors make their data available on the web, but for sensitive data you
might have to write to the authors, provide information about how you
plan to use the data, or agree to certain terms of use. Be
persistent!*</span>

<span style="font-size:medium"> </span>

<span style="font-size:medium">1.10  Glossary</span>
----------------------------------------------------

-   <span style="font-size:medium"><span
    style="font-weight:bold">anecdotal evidence</span>: Evidence, often
    personal, that is collected casually rather than by a well-designed
    study. </span><span id="hevea_default82"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">population</span>: A group we are
    interested in studying. “Population” often refers to a group of
    people, but the term is used for other subjects, too. </span><span
    id="hevea_default83"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">cross-sectional study</span>: A study that
    collects data about a population at a particular point in time.
    </span><span id="hevea_default84"></span><span
    style="font-size:medium"> </span><span id="hevea_default85"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">cycle</span>: In a repeated cross-sectional
    study, each repetition of the study is called a cycle.</span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">longitudinal study</span>: A study that
    follows a population over time, collecting data from the same group
    repeatedly. </span><span id="hevea_default86"></span><span
    style="font-size:medium"> </span><span id="hevea_default87"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">record</span>: In a dataset, a collection
    of information about a single person or other subject. </span><span
    id="hevea_default88"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">respondent</span>: A person who responds to
    a survey. </span><span id="hevea_default89"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">sample</span>: The subset of a population
    used to collect data. </span><span id="hevea_default90"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">representative</span>: A sample is
    representative if every member of the population has the same chance
    of being in the sample. </span><span id="hevea_default91"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">oversampling</span>: The technique of
    increasing the representation of a sub-population in order to avoid
    errors due to small sample sizes. </span><span
    id="hevea_default92"></span>
-   <span style="font-size:medium"><span style="font-weight:bold">raw
    data</span>: Values collected and recorded with little or no
    checking, calculation or interpretation. </span><span
    id="hevea_default93"></span>
-   <span style="font-size:medium"><span
    style="font-weight:bold">recode</span>: A value that is generated by
    calculation and other logic applied to raw data. </span><span
    id="hevea_default94"></span>
-   <span style="font-size:medium"><span style="font-weight:bold">data
    cleaning</span>: Processes that include validating data, identifying
    errors, translating between data types and representations,
    etc.</span>

<span style="font-size:medium"> </span>
