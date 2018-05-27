# Setup and Usage ---------------------------------------------------------
#
# Will need to get a GitHub PAT to use some of these commands.
# See [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/). Once you have the GitHub PAT, you will need to save this PAT in your
# home directory ("~/") in a file called ".Renviron". Inside the file, type out:
#
#   GITHUB_PAT= # paste the PAT number after the equal sign
#
# NOTE: Keep this PAT **ONLY ON YOUR COMPUTER**. Don't save it to GitHub.
#
# This script can be used in a few ways. Either:
# 1.    Open the main.Rproj, open the scripts/announcements.R, and "Source" the file
#       using the button or the shortcut Ctrl-Shift-S.
# 2.    Open R console and run the command "source('announcements.R')" when in the
#       script folder.
# 3.    Open the main.Rproj, run "source('scripts/announcements.R')" in the console.

# Installation and Loading Packages ---------------------------------------
# Running these lines will install the necessary packages.

if (!require(devtools)) install.packages("devtools")
devtools::install_dev_deps()
library(tidyverse)
library(lubridate)
library(glue)
library(assertr)

# Importing and Filtering the Event Data ----------------------------------

session_details <- read_csv(here::here("_data", "events.csv")) %>%
    arrange(date) %>%
    mutate(location = str_c("Building ", loc_building, ", room ", loc_room)) %>%
    # drop sessions that are not set (NA in location)
    filter(!is.na(location)) %>%
    mutate_at(vars(skill_level, program_language, spoken_language, gh_labels), str_to_title)

# Data checks to make sure it was imported correctly.
session_details %>%
    assert(in_set("Beginner", "Intermediate", "Advanced"), skill_level)

# Find any existing posts, take the date, and filter out those sessions from the
# session_details dataframe.
keep_only_new_sessions <- function() {
    existing_post_dates <- fs::dir_ls(here::here("_posts"), regexp = ".md$") %>%
        str_extract("[0-9]{4}-[0-9]{2}-[0-9]{2}")

    session_details %>%
        filter(!as.character(date) %in% existing_post_dates)
}

new_sessions <- keep_only_new_sessions()

# Create a GitHub Issue of the session ------------------------------------

post_gh_issue <- function(title, body, labels) {
    # Will need to set up a GitHub PAT via (I think) the function
    # devtools::github_pat() in the console.
    devtools:::rule("Posting GitHub Issues")
    cat("Posting `", title, "`\n\n")
    if (!devtools:::yesno("Are you sure you want to post this event as an Issue?")) {
        gh::gh(
            "POST /repos/:owner/:repo/issues",
            owner = "au-oc",
            repo = "Events",
            title = title,
            body = body,
            labels = array(c(labels))
        )
        usethis:::done("Event posted as an Issue to au-oc/Events.")
        return(invisible())
    } else {
        message("Event not posted to Issue.")
    }
}

# Format as eg August 23
day_month <- function(.date) {
    trimws(format(as.Date(.date), format = "%e %B"))
}

gh_issue_info <- function(.data) {
    content <- .data %>%
        mutate(needs_packages = ifelse(
            !is.na(packages),
            str_c(
                "Please also install these packages: ",
                str_replace_all(packages, " ", ", "), "."
            ),
            ""
        )) %>%
        mutate_at(vars(start_time, end_time), funs(strftime(., format = "%H:%M"))) %>%
        glue_data(
            "
            {description}

            - **When**: {day_month(date)}, from {start_time}-{end_time}
            - **Where**: {location}
            - **Skill level**: {skill_level}

            *Installation instructions*:

            You will need to install the appropriate programs. See the {program_language} section of the [installation instructions page](https://au-oc.github.io/content/installation). {needs_packages}
            "
        )

    .data %>%
        mutate(content = content, title = str_c(day_month(date), ", ", title)) %>%
        select(title, content, skill_level, gh_labels, program_language)
}

create_gh_issues <- function(.data) {
    .data %>%
        gh_issue_info() %>%
        pmap( ~ post_gh_issue(..1, ..2, c(..3, ..4, ..5)))
}

create_gh_issues(new_sessions)

# Create files in _posts/ -------------------------------------------------
# Adds the new sessions/events to the _posts folder.

create_new_posts_with_content <- function(.data) {
    new_post_filenames <-
        glue_data(new_sessions, "{here::here('_posts')}/{date}-{key}.md")

    # Get the GitHub Issue URL for the event.
    gh_issue_number <- gh::gh("GET /repos/:owner/:repo/issues",
                              owner = "au-oc",
                              repo = "Events") %>%
        map_dfr(~ data_frame(title = .$title, url = .$html_url)) %>%
        mutate(title = str_remove(title, "^.*[1-9], "))

    new_post_content <- .data %>%
        left_join(gh_issue_number, by = "title") %>%
        glue_data(
            '
            ---
            title: "{title}"
            text: "{description}"
            location: "{location}"
            link: "{url}"
            date: "{as.Date(date)}"
            startTime: "{start_time}"
            endTime: "{end_time}"
            ---
            '
        )

    # Save post content to file
    fs::dir_create(here::here("_posts"))
    map2(new_post_content, new_post_filenames, ~ write_lines(x = .x, path = .y))
    usethis:::done("Markdown posts created in _posts/ folder.")
    return(invisible())
}

create_new_posts_with_content(new_sessions)

# Create emails for sessions ----------------------------------------------

create_new_emails_for_session <- function(.data) {
    email_content <- new_sessions %>%
        mutate(needs_packages = ifelse(
            !is.na(packages),
            str_c(
                "Please also install these packages: ",
                str_replace_all(packages, " ", ", "), "."
            ),
            ""
        )) %>%
        mutate_at(vars(start_time, end_time), funs(strftime(., format = "%H:%M"))) %>%
        glue_data(
            "
            R short workshop: {title}

            {description}

            - **When**: {day_month_format(date)}, from {start_time}-{end_time}
            - **Where**: {location}
            - **Skill level**: {skill_level}

            *Installation instructions*:

            You will need to install the appropriate programs. See the {program_language} section of the [installation instructions page](https://au-oc.github.io/content/installation). {needs_packages}
            "
        )

    email_file <- glue_data(.data, "{here::here('_emails')}/{date}-{key}.md")

    map2(email_content, email_file, ~ write_lines(x = .x, path = .y))
}

create_new_emails_for_session(new_sessions)

# Create a GitHub Issue of the session ------------------------------------

post_gh_issue <- function(title, body, labels) {
    # Get the authentication using the function devtools::github_pat() in the console.
    devtools:::rule("Posting GitHub Issues")
    cat("Posting ", title)
    if (devtools:::yesno("Are you sure you want to post this event as an Issue?")) {
        gh::gh(
            "POST /repos/:owner/:repo/issues",
            owner = "au-oc",
            repo = "Events",
            title = title,
            body = body,
            labels = array(c(labels))
        )
        usethis:::done("Event posted as an Issue to au-oc/Events.")
        return(invisible())
    }
}


