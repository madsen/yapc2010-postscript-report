#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2010 Christopher J. Madsen
#
# Create images showing the various sections of a report
#---------------------------------------------------------------------

use strict;
use warnings;

use Image::Magick;
use PostScript::Convert;
use PostScript::Report ();

my $reportWidth = 484;
my $numWidth    = 100;

# Describe the report:
my $desc = {
  fonts => {
    text      => 'Helvetica-72',
  },

  font       => 'text',
  align      => 'center',

  padding_bottom => 20,
  padding_side   => 8,

  top_margin    => 36,
  left_margin   => 36,
  right_margin  => 92,
  bottom_margin => 36,
  row_height    => 80,

  report_header => { value => \'Report Header' },
  report_footer => { value => \'Report Footer' },
  page_header   => { value => \'Page Header' },
  page_footer   => { value => \'Page Footer' },

  detail => [
    [ HBox => { border => 0, padding_bottom => 15 },
      { _class => 'Spacer', width => $numWidth },
      { value => \'Detail', width => $reportWidth - 2 * $numWidth },
      { value => 0, align => 'left', width => $numWidth },
  ] ],
};

# Build the report and run it:

my @rows = map { [ $_ ] } 1 .. 16;

foreach my $section (qw(report_header page_header detail
                        page_footer report_footer)) {

  my $rpt = PostScript::Report->build($desc);

  $rpt->$section->_set_background('#ff0');

  $rpt->run(\@rows);
  $rpt->output("sections.ps");

  psconvert($rpt, 'sections-%d.png', gs_param => [qw(-r44)]);

  my $page = Image::Magick->new;
  $page->Set(size => '964x450');
  $page->ReadImage('xc:white');
  $page->Set(units => 'PixelsPerInch');
  $page->Set(density => '44x44');

  foreach my $n (1 .. 3) {
    my $img = Image::Magick->new;
    my $result = $img->Read(filename => "sections-$n.png");
    die "Error $result" unless $result+0;

    $page->Composite(image => $img, compose => 'Atop',
                     x=> 330 * ($n-1) - 18, y => -18);

  }

  $page->Write(filename => "slides/pix/$section.png");
} # end foreach $section
