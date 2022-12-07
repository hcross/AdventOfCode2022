#!/bin/sh
rm -f day7.jar
kotlinc day7.kt -include-runtime -d day7.jar
java -jar day7.jar