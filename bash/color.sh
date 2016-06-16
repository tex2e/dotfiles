#!/bin/bash
#:readme:
#
# ## color(1) -- ANSI color code cheat sheet
#
# [code](color.sh)
#
# ### SYNOPSIS
#
#     color
#
# ### Description
#
# display ANSI Color code sheet (16colors)
#
# #### Text attributes
# - 0  All attributes off
# - 1  Bold on
# - 4  Underscore (on monochrome display adapter only)
# - 5  Blink on
# - 7  Reverse video on
# - 8  Concealed on
#
# #### Foreground colors
# - 30   Black
# - 31   Red
# - 33   Brown
# - 32   Green
# - 34   Blue
# - 35   Purple
# - 36   Cyan
# - 37   White
#
# #### Background colors
# - 40   Black
# - 41   Red
# - 42   Green
# - 43   Yellow
# - 44   Blue
# - 45   Magenta
# - 46   Cyan
# - 47   White
#

echo -e "\

Syntax:

  \\\\033[00m
  \\\\033[00;00m
    :

Attribute codes:

  none    0  \033[0mnone\033[0m
  bold    1  \033[1mbold\033[0m
  under   4  \033[4munderscore\033[0m
  blink   5  \033[5mblink\033[0m
  reverse 7  \033[7mreverse\033[0m

Text color and background color codes:

              white 47    black 40    none  00
  black  30  \033[47;30m  Black   \033[0m  \033[40;30m  Black   \033[0m  \033[00;30m  Black   \033[0m
  red    31  \033[47;31m  Red     \033[0m  \033[40;31m  Red     \033[0m  \033[00;31m  Red     \033[0m
  green  32  \033[47;32m  Green   \033[0m  \033[40;32m  Green   \033[0m  \033[00;32m  Green   \033[0m
  yellow 33  \033[47;33m  Yellow  \033[0m  \033[40;33m  Yellow  \033[0m  \033[00;33m  Yellow  \033[0m
  blue   34  \033[47;34m  Blue    \033[0m  \033[40;34m  Blue    \033[0m  \033[00;34m  Blue    \033[0m
  purple 35  \033[47;35m  Purple  \033[0m  \033[40;35m  Purple  \033[0m  \033[00;35m  Purple  \033[0m
  cyan   36  \033[47;36m  Cyan    \033[0m  \033[40;36m  Cyan    \033[0m  \033[00;36m  Cyan    \033[0m
  white  37  \033[47;37m  White   \033[0m  \033[40;37m  White   \033[0m  \033[00;37m  White   \033[0m
"
