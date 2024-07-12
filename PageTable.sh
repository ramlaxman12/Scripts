#!/bin/bash
for i in {1..1000}; do cat /proc/meminfo | grep -i PageT; sleep 1; done
