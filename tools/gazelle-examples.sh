#!/bin/bash

for d in $(find examples -name WORKSPACE -exec dirname {} \; ); do \
    (cd ${d} && bazel run //:gazelle) ; \
done
