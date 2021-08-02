#! /bin/sh
#
# run.sh
# Copyright (C) 2021 adrian <adrian@arco>
#
# Distributed under terms of the MIT license.
#


docker run --rm -it --net host -v "$PWD/otel-config.yaml:/etc/otel/config.yaml" otel/opentelemetry-collector:latest
