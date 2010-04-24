#! /usr/bin/perl
#---------------------------------------------------------------------
# This example report is hereby placed in the public domain.
# You may copy from it freely.
#
# Simple example
#---------------------------------------------------------------------

use strict;
use warnings;

use PostScript::Report;

##BEGIN report_desc
# Describe the report:
my $report_desc = {
  columns => {
    data => [
      [ 'Line' =>  25 ],
      [ 'Text' => 443 ], # 25 + 443 = 468pt = 6.5in
    ], # end data
  }, # end columns
}; # end $report_desc
##END report_desc

##BEGIN rows
# Data for the report:
my @rows = (
  [ 1, 'Hello, world!' ],
  [ 2, 'This is a simple report.' ],
);
##END rows

##BEGIN run
# Build the report and run it:
my $rpt = PostScript::Report->build($report_desc);

$rpt->run(\@rows)->output("hello_world.ps");
##END run

# $rpt->dump;

# Create PNG for slide:
use PostScript::Convert;

psconvert($rpt, 'slides/pix/hello_world.png',
          gs_param => [qw(-r150)]);

system qw(mogrify -trim -bordercolor white -border 2x2
          slides/pix/hello_world.png);
