#!/usr/bin/perl
#
# A simple script to search for a given DVD
# title, return all the relevant IMDB IDs.
#  Written by John Resig
#    phytar@csh.rit.edu
#

my $token = 'AMAZONTOKEN';
my $title = join( ' ', @ARGV );

use Net::Amazon::DVD2IMDB;

my $ua = new Net::Amazon::DVD2IMDB( token => $token );

print map { "$_\n" } @{$ua->convert( $title )};
