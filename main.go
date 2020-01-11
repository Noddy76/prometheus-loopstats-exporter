/*
Copyright 2020 James Grant

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"

	"github.com/hpcloud/tail"
)

func main() {
	t, err := tail.TailFile("/var/log/ntpstats/loopstats", tail.Config{Follow: true, ReOpen: true, Poll: true})

	if err != nil {
		log.Fatal(err)
	}

	for line := range t.Lines {
		fmt.Println(line.Text)
		file, err := ioutil.TempFile("/var/lib/prometheus/node-exporter/", "ntp_loopstats.prom")
		if err != nil {
			log.Fatal(err)
		}
		defer os.Remove(file.Name())

		s := strings.Split(line.Text, " ")

		fmt.Fprintf(file, "ntp_loopstats_day %s\n", s[0])
		fmt.Fprintf(file, "ntp_loopstats_second %s\n", s[1])
		fmt.Fprintf(file, "ntp_loopstats_offset %s\n", s[2])
		fmt.Fprintf(file, "ntp_loopstats_drift_compensation %s\n", s[3])
		fmt.Fprintf(file, "ntp_loopstats_estimated_error %s\n", s[4])
		fmt.Fprintf(file, "ntp_loopstats_stability %s\n", s[5])
		fmt.Fprintf(file, "ntp_loopstats_polling_interval %s\n", s[6])

		if err := file.Close(); err != nil {
			log.Fatal(err)
		}

		if err := os.Rename(file.Name(), "/var/lib/prometheus/node-exporter/ntp_loopstats.prom"); err != nil {
			log.Fatal(err)
		}

		if err := os.Chmod("/var/lib/prometheus/node-exporter/ntp_loopstats.prom", 0666); err != nil {
			log.Fatal(err)
		}
	}
}
