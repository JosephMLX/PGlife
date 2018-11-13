#!/bin/bash

cat data | sort | uniq -c | sort -n
