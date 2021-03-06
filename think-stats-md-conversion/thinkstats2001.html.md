This HTML version of is provided for convenience, but it is not the best
format for the book. In particular, some of the symbols are not rendered
correctly.

You might prefer to read the [PDF
version](http://thinkstats2.com/thinkstats2.pdf), or you can buy a
hardcopy from [Amazon](http://amzn.to/2gBBW7v).

Chapter 0  Preface
==================

<span id="preface"></span>

This book is an introduction to the practical tools of exploratory data
analysis. The organization of the book follows the process I use when I
start working with a dataset:

-   Importing and cleaning: Whatever format the data is in, it usually
    takes some time and effort to read the data, clean and transform it,
    and check that everything made it through the translation process
    intact. <span id="hevea_default0"></span>
-   Single variable explorations: I usually start by examining one
    variable at a time, finding out what the variables mean, looking at
    distributions of the values, and choosing appropriate summary
    statistics. <span id="hevea_default1"></span>
-   Pair-wise explorations: To identify possible relationships between
    variables, I look at tables and scatter plots, and compute
    correlations and linear fits. <span id="hevea_default2"></span>
    <span id="hevea_default3"></span>
-   Multivariate analysis: If there are apparent relationships between
    variables, I use multiple regression to add control variables and
    investigate more complex relationships. <span
    id="hevea_default4"></span> <span id="hevea_default5"></span>
-   Estimation and hypothesis testing: When reporting statistical
    results, it is important to answer three questions: How big is the
    effect? How much variability should we expect if we run the same
    measurement again? Is it possible that the apparent effect is due to
    chance? <span id="hevea_default6"></span> <span
    id="hevea_default7"></span>
-   Visualization: During exploration, visualization is an important
    tool for finding possible relationships and effects. Then if an
    apparent effect holds up to scrutiny, visualization is an effective
    way to communicate results. <span id="hevea_default8"></span>

This book takes a computational approach, which has several advantages
over mathematical approaches: <span id="hevea_default9"></span>

-   I present most ideas using Python code, rather than mathematical
    notation. In general, Python code is more readable; also, because it
    is executable, readers can download it, run it, and modify it.
-   Each chapter includes exercises readers can do to develop and
    solidify their learning. When you write programs, you express your
    understanding in code; while you are debugging the program, you are
    also correcting your understanding. <span
    id="hevea_default10"></span>
-   Some exercises involve experiments to test statistical behavior. For
    example, you can explore the Central Limit Theorem (CLT) by
    generating random samples and computing their sums. The resulting
    visualizations demonstrate why the CLT works and when it doesn’t.
    <span id="hevea_default11"></span> <span
    id="hevea_default12"></span>
-   Some ideas that are hard to grasp mathematically are easy to
    understand by simulation. For example, we approximate p-values by
    running random simulations, which reinforces the meaning of the
    p-value. <span id="hevea_default13"></span>
-   Because the book is based on a general-purpose programming language
    (Python), readers can import data from almost any source. They are
    not limited to datasets that have been cleaned and formatted for a
    particular statistics tool.

The book lends itself to a project-based approach. In my class, students
work on a semester-long project that requires them to pose a statistical
question, find a dataset that can address it, and apply each of the
techniques they learn to their own data.

To demonstrate my approach to statistical analysis, the book presents a
case study that runs through all of the chapters. It uses data from two
sources:

-   The National Survey of Family Growth (NSFG), conducted by the U.S.
    Centers for Disease Control and Prevention (CDC) to gather
    “information on family life, marriage and divorce, pregnancy,
    infertility, use of contraception, and men’s and women’s health.”
    (See [<span
    style="font-family:monospace">http://cdc.gov/nchs/nsfg.htm</span>](http://cdc.gov/nchs/nsfg.htm).)
-   The Behavioral Risk Factor Surveillance System (BRFSS), conducted by
    the National Center for Chronic Disease Prevention and Health
    Promotion to “track health conditions and risk behaviors in the
    United States.” (See [<span
    style="font-family:monospace">http://cdc.gov/BRFSS/</span>](http://cdc.gov/BRFSS/).)

Other examples use data from the IRS, the U.S. Census, and the Boston
Marathon.

This second edition of <span style="font-style:italic">Think
Stats</span> includes the chapters from the first edition, many of them
substantially revised, and new chapters on regression, time series
analysis, survival analysis, and analytic methods. The previous edition
did not use pandas, SciPy, or StatsModels, so all of that material is
new.

0.1  How I wrote this book
--------------------------

When people write a new textbook, they usually start by reading a stack
of old textbooks. As a result, most books contain the same material in
pretty much the same order.

I did not do that. In fact, I used almost no printed material while I
was writing this book, for several reasons:

-   My goal was to explore a new approach to this material, so I didn’t
    want much exposure to existing approaches.
-   Since I am making this book available under a free license, I wanted
    to make sure that no part of it was encumbered by copyright
    restrictions.
-   Many readers of my books don’t have access to libraries of printed
    material, so I tried to make references to resources that are freely
    available on the Internet.
-   Some proponents of old media think that the exclusive use of
    electronic resources is lazy and unreliable. They might be right
    about the first part, but I think they are wrong about the second,
    so I wanted to test my theory.

The resource I used more than any other is Wikipedia. In general, the
articles I read on statistical topics were very good (although I made a
few small changes along the way). I include references to Wikipedia
pages throughout the book and I encourage you to follow those links; in
many cases, the Wikipedia page picks up where my description leaves off.
The vocabulary and notation in this book are generally consistent with
Wikipedia, unless I had a good reason to deviate. Other resources I
found useful were Wolfram MathWorld and the Reddit statistics forum,
[<span
style="font-family:monospace">http://www.reddit.com/r/statistics</span>](http://www.reddit.com/r/statistics).

0.2  Using the code
-------------------

<span id="code"></span>

The code and data used in this book are available from [<span
style="font-family:monospace">https://github.com/AllenDowney/ThinkStats2</span>](https://github.com/AllenDowney/ThinkStats2).
Git is a version control system that allows you to keep track of the
files that make up a project. A collection of files under Git’s control
is called a <span style="font-weight:bold">repository</span>. GitHub is
a hosting service that provides storage for Git repositories and a
convenient web interface. <span id="hevea_default14"></span> <span
id="hevea_default15"></span> <span id="hevea_default16"></span>

The GitHub homepage for my repository provides several ways to work with
the code:

-   You can create a copy of my repository on GitHub by pressing the
    <span style="font-family:sans-serif">Fork</span> button. If you
    don’t already have a GitHub account, you’ll need to create one.
    After forking, you’ll have your own repository on GitHub that you
    can use to keep track of code you write while working on this book.
    Then you can clone the repo, which means that you make a copy of the
    files on your computer. <span id="hevea_default17"></span>
-   Or you could clone my repository. You don’t need a GitHub account to
    do this, but you won’t be able to write your changes back to GitHub.
    <span id="hevea_default18"></span>
-   If you don’t want to use Git at all, you can download the files in a
    Zip file using the button in the lower-right corner of the GitHub
    page.

All of the code is written to work in both Python 2 and Python 3 with no
translation.

I developed this book using Anaconda from Continuum Analytics, which is
a free Python distribution that includes all the packages you’ll need to
run the code (and lots more). I found Anaconda easy to install. By
default it does a user-level installation, not system-level, so you
don’t need administrative privileges. And it supports both Python 2 and
Python 3. You can download Anaconda from [<span
style="font-family:monospace">http://continuum.io/downloads</span>](http://continuum.io/downloads).
<span id="hevea_default19"></span>

If you don’t want to use Anaconda, you will need the following packages:

-   pandas for representing and analyzing data, [<span
    style="font-family:monospace">http://pandas.pydata.org/</span>](http://pandas.pydata.org/);
    <span id="hevea_default20"></span>
-   NumPy for basic numerical computation, [<span
    style="font-family:monospace">http://www.numpy.org/</span>](http://www.numpy.org/);
    <span id="hevea_default21"></span>
-   SciPy for scientific computation including statistics, [<span
    style="font-family:monospace">http://www.scipy.org/</span>](http://www.scipy.org/);
    <span id="hevea_default22"></span>
-   StatsModels for regression and other statistical analysis, [<span
    style="font-family:monospace">http://statsmodels.sourceforge.net/</span>](http://statsmodels.sourceforge.net/);
    and <span id="hevea_default23"></span>
-   matplotlib for visualization, [<span
    style="font-family:monospace">http://matplotlib.org/</span>](http://matplotlib.org/).
    <span id="hevea_default24"></span>

Although these are commonly used packages, they are not included with
all Python installations, and they can be hard to install in some
environments. If you have trouble installing them, I strongly recommend
using Anaconda or one of the other Python distributions that include
these packages. <span id="hevea_default25"></span>

After you clone the repository or unzip the zip file, you should have a
folder called <span
style="font-family:monospace">ThinkStats2/code</span> with a file called
nsfg.py. If you run nsfg.py, it should read a data file, run some tests,
and print a message like, “All tests passed.” If you get import errors,
it probably means there are packages you need to install.

Most exercises use Python scripts, but some also use the IPython
notebook. If you have not used IPython notebook before, I suggest you
start with the documentation at [<span
style="font-family:monospace">http://ipython.org/ipython-doc/stable/notebook/notebook.html</span>](http://ipython.org/ipython-doc/stable/notebook/notebook.html).
<span id="hevea_default26"></span>

I wrote this book assuming that the reader is familiar with core Python,
including object-oriented features, but not pandas, NumPy, and SciPy. If
you are already familiar with these modules, you can skip a few
sections.

I assume that the reader knows basic mathematics, including logarithms,
for example, and summations. I refer to calculus concepts in a few
places, but you don’t have to do any calculus.

If you have never studied statistics, I think this book is a good place
to start. And if you have taken a traditional statistics class, I hope
this book will help repair the damage.

—

Allen B. Downey is a Professor of Computer Science at the Franklin W.
Olin College of Engineering in Needham, MA.

Contributor List
----------------

If you have a suggestion or correction, please send email to <span
style="font-family:monospace">downey@allendowney.com</span>. If I make a
change based on your feedback, I will add you to the contributor list
(unless you ask to be omitted). <span id="hevea_default27"></span>

If you include at least part of the sentence the error appears in, that
makes it easy for me to search. Page and section numbers are fine, too,
but not quite as easy to work with. Thanks!

-   <span style="font-size:small">Lisa Downey and June Downey read an
    early draft and made many corrections and suggestions.</span>
-   <span style="font-size:small">Steven Zhang found several
    errors.</span>
-   <span style="font-size:small">Andy Pethan and Molly Farison helped
    debug some of the solutions, and Molly spotted several typos.</span>
-   <span style="font-size:small">Dr. Nikolas Akerblom knows how big a
    Hyracotherium is.</span>
-   <span style="font-size:small">Alex Morrow clarified one of the code
    examples.</span>
-   <span style="font-size:small">Jonathan Street caught an error in the
    nick of time.</span>
-   <span style="font-size:small">Many thanks to Kevin Smith and Tim
    Arnold for their work on plasTeX, which I used to convert this book
    to DocBook.</span>
-   <span style="font-size:small">George Caplan sent several suggestions
    for improving clarity.</span>
-   <span style="font-size:small">Julian Ceipek found an error and a
    number of typos.</span>
-   <span style="font-size:small">Stijn Debrouwere, Leo Marihart III,
    Jonathan Hammler, and Kent Johnson found errors in the first print
    edition.</span>
-   <span style="font-size:small">Jörg Beyer found typos in the book and
    made many corrections in the docstrings of the accompanying
    code.</span>
-   <span style="font-size:small">Tommie Gannert sent a patch file with
    a number of corrections.</span>
-   <span style="font-size:small">Christoph Lendenmann submitted several
    errata.</span>
-   <span style="font-size:small">Michael Kearney sent me many excellent
    suggestions.</span>
-   <span style="font-size:small">Alex Birch made a number of helpful
    suggestions.</span>
-   <span style="font-size:small">Lindsey Vanderlyn, Griffin Tschurwald,
    and Ben Small read an early version of this book and found many
    errors.</span>
-   <span style="font-size:small">John Roth, Carol Willing, and Carol
    Novitsky performed technical reviews of the book. They found many
    errors and made many helpful suggestions.</span>
-   <span style="font-size:small">David Palmer sent many helpful
    suggestions and corrections.</span>
-   <span style="font-size:small">Erik Kulyk found many typos.</span>
-   <span style="font-size:small">Nir Soffer sent several excellent pull
    requests for both the book and the supporting code.</span>
-   <span style="font-size:small">GitHub user flothesof sent a number of
    corrections.</span>
-   <span style="font-size:small">Toshiaki Kurokawa, who is working on
    the Japanese translation of this book, has sent many corrections and
    helpful suggestions.</span>
-   <span style="font-size:small">Benjamin White suggested more
    idiomatic Pandas code.</span>
-   <span style="font-size:small">Takashi Sato spotted an code
    error.</span>

<span style="font-size:small">Other people who found typos and similar
errors are Andrew Heine, Gábor Lipták, Dan Kearney, Alexander Gryzlov,
Martin Veillette, Haitao Ma, Jeff Pickhardt, Rohit Deshpande, Joanne
Pratt, Lucian Ursu, Paul Glezen, Ting-kuang Lin.</span>

<span style="font-size:medium"> </span>
