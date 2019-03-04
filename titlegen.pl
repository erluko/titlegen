#!/usr/bin/perl
use strict;
use Data::Dumper;

open WORDS,'<','words.txt';
my @LINES=<WORDS>;
map {$_=~tr/\r\n//d} @LINES;
close WORDS;

sub find_syns {
  my ($word) = @_;
  my @rows = map {split /,/} grep {/,$word,/} @LINES;
  return @rows;
}

my @commands=@ARGV;
my $seed=0;
my @order;
for(@commands){
  if (/^\d+$/) {
    $seed=$_;
  } else {
    push @order, [split /\./] ;
  }
}

my @out;
for (@order) {
  my ($start,$depth) = @$_;
  $depth = 0 unless $depth;
  srand($seed);
  my $word=$start;
  for(my $t=$depth;$t>=0;$t--){
    my @syns = find_syns($word) or last;
    $word = $syns[rand @syns] if @syns;
  }
  push @out,$word;
}
map {s/\b(.)/\U$1/g} @out;
print join ' ', @out;
print "\n";
