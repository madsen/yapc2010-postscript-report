#! /usr/bin/perl
#---------------------------------------------------------------------
# This example code is hereby placed in the public domain.
# You may copy from it freely.
#
# Miscellaneous code snippets for slides
#---------------------------------------------------------------------

die "This is not a runnable example";


##BEGIN data
# Data global to the report:
my %data = (
  customer => 'John Doe',
  address  => '123 Main St.',
);

# Line-based data for the report:
my @rows = (
  [ 1, 'Hello, world!' ],
  [ 2, 'This is a simple report.' ],
);

$rpt->run(\%data, \@rows);
##END data

#---------------------------------------------------------------------
##BEGIN pdf
use PostScript::Convert;

psconvert($rpt->run(\@data), 'report.pdf');
##END pdf
