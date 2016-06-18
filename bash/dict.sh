#!/bin/bash

curl "dict://dict.org/d:$1:*" | less
