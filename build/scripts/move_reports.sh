#!/bin/bash

   while read report; do
      cp "$report.report" unfiled\$public
   done < reports.txt
