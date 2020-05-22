#!/bin/bash

openscad -v 2>&1 >/dev/null | awk '{print $3}'