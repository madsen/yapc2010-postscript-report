#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2010 Christopher J. Madsen
#
# Create image of FieldTL
#---------------------------------------------------------------------

use strict;
use warnings;

use PostScript::Convert;
use PostScript::Report ();

# Describe the report:
my $desc = {
  row_height => 18,
  border     => 1,

  report_header =>
    { _class => 'FieldTL', label => 'Label', value => \'Value displayed here',
      width => 100 },
};

# Build the report and run it:

my $rpt = PostScript::Report->build($desc);

psconvert($rpt->run, 'slides/pix/fieldTL.png', gs_param => [qw(-r130)]);

system qw(mogrify -trim slides/pix/fieldTL.png);

# Local Variables:
# compile-command: "perl fieldTL.pl"
# End:
