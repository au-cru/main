library(tidyverse)
library(lubridate)
library(glue)
library(fs)

session_details <- read_csv("_data/events.csv") %>%
    arrange(date) %>%
    mutate(location = str_c("Building ", loc_building, ", room ", loc_room)) %>%
    # drop sessions that are not set (NA in location)
    filter(!is.na(location)) %>%
    mutate_at(vars(skill_level, program_language, spoken_language), str_to_title)

# Find any existing posts, take the date, and filter out those sessions from the
# session_details dataframe.
keep_only_new_sessions <- function() {
    existing_post_dates <- dir_ls("_posts", regexp = ".md$") %>%
        str_extract("[0-9]{4}-[0-9]{2}-[0-9]{2}")

    session_details %>%
        filter(!date %in% existing_post_dates)
}

new_sessions <- keep_only_new_sessions()

# Create files in _posts/ -------------------------------------------------

create_new_posts_with_content <- function(.data) {
    new_post_filenames <- glue_data(.data, "_posts/{date}-{key}.md")

    new_post_content <- .data %>%
        glue_data(
            '
            ---
            title: "{title}"
            text: "{description}"
            location: "{location}"
            #link: "github_issue"
            date: "{as.Date(date)}"
            startTime: "{start_time}"
            endTime: "{end_time}"
            ---
            '
        )

    # Save post content to file
    map2(new_post_content, new_post_filenames, ~ write_lines(x = .x, path = .y))
}

create_new_posts_with_content(new_sessions)


# Create emails for sessions ----------------------------------------------

day_month_format <- function(.date) {
    trimws(format(as.Date(.date), format = "%e %B"))
}

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

            {str_wrap(description)}

            - **When**: {day_month_format(date)}, from {start_time}-{end_time}
            - **Where**: {location}
            - **Skill level**: {skill_level}

            *Installation instructions*:

            You will need to install the appropriate programs. See the {program_language} section of the
            [installation instructions page](https://au-oc.github.io/content/installation).
            {needs_packages}
            "
        )

    email_file <- glue_data(.data, "_emails/{date}-{key}.md")

    map2(email_content, email_file, ~ write_lines(x = .x, path = .y))
}

create_new_emails_for_session(new_sessions)
