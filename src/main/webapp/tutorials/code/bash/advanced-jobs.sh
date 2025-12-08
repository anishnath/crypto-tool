#!/usr/bin/env bash

# Background jobs and wait

long_task() {
  echo "[$1] start"; sleep "$2"; echo "[$1] done"
}

long_task A 1 &
pid1=$!
long_task B 2 &
pid2=$!

echo "Waiting for jobs $pid1 and $pid2"
wait "$pid1" "$pid2"
echo "All jobs finished"

