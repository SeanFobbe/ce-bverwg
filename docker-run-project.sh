#!/bin/bash
set -e

time docker build -t ce-bverwg:4.2.2 .

time docker-compose run --rm ce-bverwg Rscript run_project.R
