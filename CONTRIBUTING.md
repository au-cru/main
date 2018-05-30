---
layout: page
title: Contributing to AU Open Coders
---

> Note: Much of this contributing guideline came from the [UofTCoders](https://uoftcoders.github.io/studyGroup/CONTRIBUTING)

Welcome to the Contributing guideline for AUOC. Thanks for taking the time to contribute! :clap::clap:  

The following is a set of guidelines for contributing to the AUOC community,
whether it be by teaching a lesson, fixing the website, helping to plan and
organize our various events, or taking on a leadership role.

### Table of Contents

1. [About AUOC](#about-auoc)
    - [Code of Conduct](#code-of-conduct)

2. [How You Can Contribute](#how-you-can-contribute)
    - [Leading a Lesson](#leading-a-lesson)
        - [Creating the Content](#creating-the-content)
        - [Teaching in Class](#teaching-in-class)
    - [Fixing and Updating the Website](#fixing-and-updating-the-website)
    - [Other Ways to Get Involved](#other-ways-to-get-involved)

-----

# About AUOC

The AUOC group was formed to share and learn about coding techniques and
best practices for computing and analysis in research. We hold frequent sessions
in the format of mainly short code-alongs, but also longer workshops.
To see our previous and upcoming events, you can visit our [Events repo](https://github.com/au-oc/Events/issues).

## Code of Conduct

We adhere to a [Code of Conduct](https://github.com/au-oc/main/blob/gh-pages/CODE_OF_CONDUCT.md)
and by participating, you agree to also uphold this code.

-----

# How You Can Contribute

## Leading a Lesson

The Mozilla Science Study Group
handbook [**here**](https://mozillascience.github.io/studyGroupHandbook/lessons.html#reuse)
and [**here**](https://mozillascience.github.io/studyGroupHandbook/event-types.html#workalong)
has several very good points about making a lesson. This section summarizes bits
of the handbook, but also adds pieces that are missing from it. Check out the
[lesson bank too](https://github.com/mozillascience/studyGroupLessons/issues).

### Creating the Content

+ **Use Built-in Datasets**: Use built-in sample datasets instead of requiring
attendees to download files.
+ **Keep in mind beginners**: Make few assumptions about the knowledge of the audience,
unless specified that this is an intermediate level lesson, requiring prior knowledge.
Keep it simple.
+ **Minimal use of slides**: If your lesson involves coding, keep slides to a minimum
if at all, focus on interactive live-coding.
+ **Code Review**: The lesson code is posted to GitHub along with a pull request to
[au-oc/main](https://github.com/au-oc/main) repository at
least 1 full day prior to the lesson date to allow for review.
See [Submitting a Pull Request](https://au-oc.github.io/main/pull-request/)


### Teaching in Class

+ **Arrive early**: Come 10 minutes before the lesson starts to set up.
+ **Introduce yourself**: Start by introducing yourself and perhaps why you're teaching this lesson.
+ **Stay on time**: Keep mindful of the time, lessons are 50-60 minutes long.
+ **Start from the very beginning**: Briefly explain all aspects of the what you are doing when live-coding including:
    - show how to open the program or IDE (e.g. RStudio/Jupyter Notebook/Shell or Terminal/etc)
    - how to run code (e.g. press `Shift+Enter` in the Jupyter Notebook)
    - if this is an intro lesson, explain the concept of an IDE or shell
    - importing modules and packages such as  `import numpy as np` or `library(dplyr)`

+ **Live-coding**: Use of slides is minimal, majority of lesson involves writing the code WITH the audience during the lesson
+ **Stay on topic**: There is only one hour, if a question arises that is off-topic, you can always suggest discussing afterwards.

-----

## Fixing and updating the website

There are two ways of fixing or adding to the website, either by:

- Creating an [Issue](https://github.com/au-oc/main/issues/new)
describing the problem or enhancement. This is technically not doing anything
yourself, just recommending something to be done.
- Submitting a Pull Request from a clone of this repo. This way takes a bit more
work and requires knowledge of Git and likely HTML. But we would appreciate any
help! No harm in giving it a try! That's a beauty of using Git, it's hard to
mess up and break something.

If you want to view the website before submitting a Pull Request to make sure
your changes are as you expect, you'll need to:

- Install Jekyll by following these 
[instructions](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/).
- To build the site locally, run `jekyll serve`.
- The built site can also be viewed at your forked version
(`https:://yourusername.github.io/main`).

----

## Other Ways to Get Involved

### Helping Out at Our Events

We hold various sessions that incorporate code-alongs, and having the help of
more advanced users to help out the beginners is very much appreciated.

- If you see a session topic that is more beginner than your current level, we
highly encourage you to attend anyway and help answer questions or provide more
one-on-one support during lessons.
- We do a call for helpers for all our other workshops, and we definitely
wouldn't be able to run these without the help of volunteers like you!

### Taking On A Leadership Role

We are still developing this group so if you are interested in taking on a larger
role, please contact us! Best way would be to come to one of our sessions and
talk to us!
