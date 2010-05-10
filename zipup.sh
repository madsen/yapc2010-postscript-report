#! /bin/sh

rm -f psreport.zip
zip -9Xr psreport.zip slides/*.html slides/pix slides/ui -x '*~'
