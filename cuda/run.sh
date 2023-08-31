#!/usr/bin/env bash

nvidia-smi --query-gpu=uuid,serial --format=csv | awk -v host=`hostname` 'NR>1{print host,$0,"CONTAINER"}'
