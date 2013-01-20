#!/usr/bin/env perl
# proximal_gene_finder.pl
# Mike Covington
# created: 2013-01-19
#
# Description:
#
use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Scalar::Util 'looks_like_number';
use Set::IntervalTree;

my $range            = 2000;
my $gene_coords_file = "gene_coordinates_table.txt";
my $positions_file   = "genome_locations.txt";

my $options = GetOptions(
    "range=i"            => \$range,
    "gene_coords_file=s" => \$gene_coords_file,
    "positions_file=s"   => \$positions_file,
);

open my $gene_coords_fh, "<", $gene_coords_file;
open my $positions_fh,   "<", $positions_file;

# build hash of gene interval trees by chromosome
my %trees;
while (<$gene_coords_fh>) {
    my ( $gene, $chr, $start, $end ) = split;
    ignore_header( $_, $end ) and next;
    $trees{$chr} = Set::IntervalTree->new unless exists $trees{$chr};
    $trees{$chr}->insert( $gene, $start, $end );
}

# find genes that intersect with intervals of interest
while (<$positions_fh>) {
    my ( $chr, $pos ) = split;
    ignore_header( $_, $pos ) and next;
    my $results = $trees{$chr}->fetch( $pos - $range, $pos + $range );
    say join "\t", $chr, $pos, sort @$results;
}

sub ignore_header {
    my ( $line, $num ) = @_;
    if ( !looks_like_number $num ) {
        print "Ignored: $_";
    }
}
