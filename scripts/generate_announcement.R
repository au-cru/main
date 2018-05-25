library(magrittr)

session_details <- yaml::read_yaml("_data/events.yml")[["intro_r_functions"]]

date_time <-
    glue::glue(
        "{date}, from {start}-{end}",
        date = trimws(format(as.Date(
            session_details$date
        ), format = "%e %B")),
        start = session_details$start_time,
        end = session_details$end_time
    )

if (session_details$packages != "") {
    packages <- stringr::str_c(packages,
}
installation <- stringr::str_c(
"You will need to install the appropriate programs. See the {program_language} section
of the [installation instructions page](https://au-oc.github.io/content/installation).",
session_details$packages

website_listing <- glue::glue(
    '
    ---
    title: "{title}"
    text: "{description}"
    location: "{location}"
    link: "{github_issue}"
    date: "{date}"
    startTime: "{start_time}"
    endTime: "{end_time}"
    ---
    ',
    title = session
)

email <- glue::glue(
"
{description}

- **When**: {date_time}
- **Where**: {location}
- **Skill level**: {skill_level}

*Installation instructions*:

{installation}


")
