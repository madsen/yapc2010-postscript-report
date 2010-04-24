#! /usr/bin/perl
#---------------------------------------------------------------------
# Copyright 2010 Christopher J. Madsen
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# Insert code snippets into a slide presentation
#---------------------------------------------------------------------

use strict;
use warnings;
use 5.010;

use autodie ':io';
use File::Slurp 'read_file';
use PPI::HTML;

my $formatter = PPI::HTML->new( line_numbers => 0, page => 0 );

my $inFN  = shift @ARGV // die;
my $outFN = shift @ARGV;

unless (defined $outFN) {
  ($outFN = $inFN) =~ s/\.in$/.html/ or die;
}

open(my $in,  '<', $inFN);
open(my $out, '>', $outFN);

while (<$in>) {
  if (m!<code src="([^"]+)" section="([^"]+)" />!) {
    print_code($1, $2);
  } else {
    print $out $_;
  }
} # end while <$in>

close $in;
close $out;

#---------------------------------------------------------------------
sub print_code
{
  my ($fn, $section) = @_;

  my $code = read_file($fn);

  $code =~ m/
    ^\#\#BEGIN \s+ $section \s* \n
    (.+)
    ^\#\#END \s+ $section \s* \n
    /xsm
        or die "Unable to find $section in $fn";

  $code = $1;

  my $html = $formatter->html(\$code);

  # Fix word => value:
  $html =~ s!<span class="word">(?=[^<>\s]+</span>\s*<span class="operator">=&gt;</span>)!<span class="single">!g;

  $html =~ s/(?<=<span class=\")/PL/g;
  $html =~ s/<br>\n?/\n/g;

  print $out qq'<pre class="perlcode">$html</pre>\n';
} # end print_code
