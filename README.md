
<!-- README.md is generated from README.Rmd. Please edit that file -->

Shiny Dashboard Workshop
========================

This is an empty repo to initialize an R project for Introduction to
Shiny Dashboards at HealthCore Inc.

Please **follow all instructions** to set up your environment for the
training. Skimming the instructions often leads to errors, so be sure to
read everything.

Install R and RStudio
=====================

This is just like installing any other program.

-   [R](https://cloud.r-project.org/)
-   [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

It is important to have the most recent version of R, which as of this
repo creation was version 4.0.2.

Getting the Repo
================

In order to get the most out of class you have to be working in this
project. There are three ways to get this project on your computer.

Choose **one of these methods** only. Trying parts from each method can
lead to undesirable results. Most people will be most comfortable with
the third method.

1.  Clone the repo using the command line
2.  Clone the repo using the RStudio GUI
3.  Use the [`{usethis}`](https://usethis.r-lib.org) package to download
    and unzip the repo

Please only follow one of these methods. Attempting more than one can
lead to errors.

Command Line
------------

This assumes you have `git`
[installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).[1]

Run this command in the command line or shell.

    git clone https://github.com/brooklynbagel/healthcore-shiny.git

Then open the `healthcore-shiny.Rproj` file.

RStudio Gui
-----------

This assumes you have `git`
[installed](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Click `File > New Project`.

<img src="images/rstudio-project-menu.png" width="1467" />

Click `Version Control`.

<img src="images/rstudio-create-project.png" width="533" />

Click `Git`.

<img src="images/rstudio-create-project-version-control.png" width="536" />

Choose a folder in the `Create project as a subdirectory of` field.

Paste `https://github.com/brooklynbagel/healthcore-shiny`[2] in the
`Repository URL` field.

<img src="images/rstudio-create-project-git.png" width="536" />

`usethis` Package
-----------------

Run these commands in the R console.

    # install usethis package
    install.packages('usethis')

    # get the repo
    newProject <- usethis::use_course('https://github.com/brooklynbagel/healthcore-shiny/archive/master.zip')

Be sure to select the positive prompts such as `yes`, `yeah`, etc.

This will open the project in a new RStudio window.

After any of these methods you should have a new RStudio project called
`healthcore-shiny` or `healthcore-shiny-master`. You can see this in the
top right of RStudio (the name in the image may be different).

<img src="images/ProjectCorner.png" width="225" />

Finish Setup
============

Setting up all of the needed packages[3] and downloading data will be
handled by running the following lines of code in the R console.

    source('prep/install_packages.r')

Answer `y` to any questions asked in the terminal. However, if the
question is asking you to install packages from source, answer “no.”

Below is a list of all the required packages and their versions as of
Saturday, August 29 2020. Note that even if you already have a package
installed, you should update it if you have an older version than what
is shown below.

| Package         | Version |
|:----------------|:--------|
| DT              | 0.15    |
| dygraphs        | 1.1.1.6 |
| flexdashboard   | 0.5.2   |
| ggiraph         | 0.7.8   |
| glue            | 1.4.2   |
| here            | 0.1     |
| highcharter     | 0.8.2   |
| htmltools       | 0.5.0   |
| httr            | 1.4.2   |
| jsonlite        | 1.7.0   |
| leaflet         | 2.0.3   |
| plotly          | 4.9.2.1 |
| rmarkdown       | 2.3     |
| rsconnect       | 0.8.16  |
| sass            | 0.2.0   |
| shiny           | 1.5.0   |
| shinyalert      | 1.1     |
| shinycssloaders | 1.0.0   |
| shinydashboard  | 0.7.1   |
| shinyjs         | 1.1     |
| shinyloadtest   | 1.0.1   |
| shinytest       | 1.4.0   |
| shinythemes     | 1.1.2   |
| tidyverse       | 1.3.0   |
| timevis         | 0.5     |

All Done
========

That’s everything. You should now do all of your work for this class in
this project.

Footnotes
=========

[1] Can also be done with ssh instead of https.

[2] Or `git@github.com:brooklynbagel/healthcore-shiny.git` for ssh.

[3] Linux users might need to install `libxml2-dev` and `zlib1g-dev`
