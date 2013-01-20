#!/usr/bin/env perl
# proximal_gene_finder.pl
# Mike Covington
# created: 2013-01-19
#
# Description: Perl script to identify genes proximal to genomic regions of interest
#
use strict;
use warnings;
use autodie;
use feature 'say';
use Getopt::Long;
use Scalar::Util 'looks_like_number';
use Set::IntervalTree;

my $usage = <<USAGE;

$0
    --range             Distance in bp from genome location to search for genes [2000]
    --gene_coords_file  File with gene coordinates [gene_coordinates_table.txt]
    --positions_file    File with genomic positions of interest [genome_locations.txt]
    --output_file       Output file [proximal_genes.txt]

USAGE

my $range            = 2000;
my $gene_coords_file = "gene_coordinates_table.txt";
my $positions_file   = "genome_locations.txt";
my $output_file      = "proximal_genes.txt";
my $help;

my $options = GetOptions(
    "range=i"            => \$range,
    "gene_coords_file=s" => \$gene_coords_file,
    "positions_file=s"   => \$positions_file,
    "output_file=s"      => \$output_file,
    "help"               => \$help,
);

die $usage if $help;

# build hash of gene interval trees by chromosome
open my $gene_coords_fh, "<", $gene_coords_file;
my %trees;
while (<$gene_coords_fh>) {
    my ( $gene, $chr, $start, $end ) = split;
    ignore_header( $_, $end ) and next;
    $trees{$chr} = Set::IntervalTree->new unless exists $trees{$chr};
    $trees{$chr}->insert( $gene, $start, $end );
}
close $gene_coords_fh;

# find genes that intersect with intervals of interest
open my $positions_fh, "<", $positions_file;
open my $output_fh,    ">", $output_file;
while (<$positions_fh>) {
    my ( $chr, $pos ) = split;
    ignore_header( $_, $pos ) and next;
    my $results = $trees{$chr}->fetch( $pos - $range, $pos + $range );
    say $output_fh join "\t", $chr, $pos, sort @$results;
}
close $positions_fh;
close $output_fh;

sub ignore_header {
    my ( $line, $num ) = @_;
    if ( !looks_like_number $num ) {
        print "Ignored: $_";
    }
}
