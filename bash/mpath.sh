#!/bin/bash

MPATH="$(command manpath)"
echo -e ${MPATH//:/'\n'}
