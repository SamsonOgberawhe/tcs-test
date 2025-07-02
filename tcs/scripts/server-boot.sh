#!/bin/bash

# start tcs mysql
service tcs_data start

# start tcs tomcat
service tcs_tomcat start
service tcs_update_tomcat start
