# Prometheus Loopstats Exporter

![GitHub license](https://img.shields.io/github/license/Noddy76/prometheus-loopstats-exporter.svg)

## Overview

A tool to export NTPd's `loopstats` to the Prometheus Node Exporter.

This tool should be run as a system daemon and will follow
`/var/log/ntpstats/loopstats` and present the values to the Node Exporter by
writing the values in the correct format into the file
`/var/lib/prometheus/node-exporter/ntp_loopstats.prom`.

The metric names are:

* `ntp_loopstats_day`
* `ntp_loopstats_second`
* `ntp_loopstats_offset`
* `ntp_loopstats_drift_compensation`
* `ntp_loopstats_estimated_error`
* `ntp_loopstats_stability`
* `ntp_loopstats_polling_interval`

## Legal

This project is available under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

Copyright 2020 James Grant
