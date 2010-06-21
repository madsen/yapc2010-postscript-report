#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2010 Christopher J. Madsen
#
# Create image of Checkboxes
#---------------------------------------------------------------------

use strict;
use warnings;

use PostScript::Convert;
use PostScript::Report ();

my $size = 100;

# Describe the report:
my $desc = {
  default_field_type => 'Checkbox',

  row_height => $size,
  border     => 0,
  line_width => 5,

  report_header => [
    { value => \'1', width => $size },
    { _class => 'Spacer', width => $size/2 },
    { value => \'0', width => $size }
  ],
};

# Build the report and run it:

my $rpt = PostScript::Report->build($desc);

psconvert($rpt->run, 'slides/pix/checkbox.png', gs_param => [qw(-r20)]);

system qw(mogrify -trim slides/pix/checkbox.png);

# Local Variables:
# compile-command: "perl checkbox.pl"
# End:
