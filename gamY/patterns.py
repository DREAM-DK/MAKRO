import re

# Top level patterns for all commands. Used to recursively parse script.
PATTERN_STRINGS = {
    # "env_variable": r"""(?:[^\s\*][^\n]*)?(\%(\S+?)\%)""",
    "env_variable": r"""\%(\S+?)\%""",

    "user_function": r"""
        @(\S+?)  # Function name
        \(
            ([^)]*?)  # Arguments
        \)
    """,

    "set": r"""

                \$set(global|local|)
                \s*
                (\S+)
                \s+
                ([^\s\;]+)
            """,

    "eval": r"""

                \$eval(global|local|)
                \s*
                (\S+)
                \s+
                ([^\;]+)
            """,

    "import": r"""
        \$Import
        \s+
        ([^\s;]+)                # File name
    """,

    "block": r"\$Block\s+(.+?)\s+(.*?)\$EndBlock",

    "group": r"\$Group\s+(.+?)\s+(.*?;)",  # 1) name, 2) content

    "pgroup": r"\$PGroup\s+(.+?)\s+(.*?;)",

    "display": r"""
        \$Display\s
            (.+?;)      # Variables and groups to be displayed
    """,

    "display_all": r"""
        \$Display_all
            (.+?;)      # Variables and groups to be displayed
    """,

    "model": r"\$Model\s+(.+?)\s+(.*?);",

    "solve": r"\$Solve\s+(.*?);",

    "fix": r"""
                        (\$(?:UN)?FIX)          # Fix or unfix command
                        (?:[(\[] (
                            -? (?:\d+\.?\d*|INF|EPS) (?: \,\s*-?(?:\d+\.?\d*|INF|EPS) )?       # Optional arguments
                        ) [)\]])?
                        \s+
                        (.+?;)                  # Content
                    """,


    "if": r"""
                    \$If(?P<if_id>\d*)\s+
                    ([^:]*?)             # Condition
                    \:
                    (.*?)
                    \$EndIF(?P=if_id)\b
                """,

    "define_function": r"""

                        \$Function(?P<function_id>\d*)\s+
                        (\S+?)        # Name $1
                        [(\[]([^)\]]*)[)\]]  # Arguments  $2
                        (?:\:)?\s+
                        (.*?)         # Expression $3
                        \$EndFunction(?P=function_id)\b
    """,

    "for_loop": r"""

                        \$For(?P<for_id>\d*)
                        \s+
                        (.+?) # The iterator
                        \s+
                        in
                        \s+
                        ([^\:]*?)  # The iterable
                        :
                        (.*?)
                        \$EndFor(?P=for_id)\b
    """,


    "loop": r"""
                        \$Loop(?P<loop_id>\d*)
                        \s*
                        (.*?)               # Group name
                        [:]
                        (.*?)
                        \$EndLoop(?P=loop_id)\b
                    """,
    "replace": r"""
                        \$Replace
                        [(\[]
                        ('.*?'|".*?")       # String to find
                        ,\s*
                        ('.*?'|".*?")       # Replacement string
                        (,\s*\d+)?          # Max replacements
                        [)\]]
                        (.*?)
                        \$EndReplace
                    """,
    "regex": r"""
                        \$Regex(?P<regex_id>\d*)
                        [(\[]\s*
                        ('.*?'|".*?"|[^,]+)       # String to find
                        ,\s*
                        ('.*?'|".*?")             # Replacement string
                        (,\s*\d+)?                # Max replacements
                        [)\]]
                        (.*?)
                        \$EndRegex(?P=regex_id)\b
                    """,

}

# Compile regex patterns
PATTERNS = {k: re.compile(v, re.VERBOSE | re.IGNORECASE | re.MULTILINE | re.DOTALL) for k, v in PATTERN_STRINGS.items()}
# Create combined pattern that matches any of the patterns
PATTERNS["Any"] = re.compile("|".join(PATTERN_STRINGS.values()), re.VERBOSE | re.IGNORECASE | re.MULTILINE | re.DOTALL)


PATTERNS["TopDown"] = re.compile("|".join((  # Remember to also add these to the list in gamY
        PATTERN_STRINGS["if"],
        PATTERN_STRINGS["for_loop"],
        PATTERN_STRINGS["loop"],
        PATTERN_STRINGS["define_function"],
    )),
    re.VERBOSE | re.IGNORECASE | re.MULTILINE | re.DOTALL
)
