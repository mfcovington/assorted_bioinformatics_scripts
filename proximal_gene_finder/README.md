# Usage

**proximal_gene_finder.pl** - Perl script to identify genes proximal to genomic regions of interest

    ./proximal_gene_finder.pl
        --range             Distance in bp from genome location to search for genes [2000]
        --gene_coords_file  File with gene coordinates [gene_coordinates_table.txt]
        --positions_file    File with genomic positions of interest [genome_locations.txt]
        --output_file       Output file [proximal_genes.txt]

# Sample Input Files

**gene_coordinates_table.txt** - Tab-delimited input file containing gene ID, chromosome ID, start, and end of each gene:

    Solyc00g005000.2.1  SL2.40ch00  16437   18189
    Solyc00g005020.1.1  SL2.40ch00  68062   68764
    Solyc00g005040.2.1  SL2.40ch00  550920  551576
    Solyc00g005050.2.1  SL2.40ch00  570544  575454
    Solyc00g005060.1.1  SL2.40ch00  723746  724018
    ...

**genome_locations.txt** - Tab-delimited input file containing chromosome ID and position around which to find proximal genes:

    SL2.40ch01  2565000
    SL2.40ch01  71000487
    SL2.40ch01  87600019
    SL2.40ch01  87630003
    SL2.40ch02  33900060
    ...

# Sample Output Files

**proximal_genes.txt** - Output file created by running `perl proximal_gene_finder.pl` with defaults:

    SL2.40ch01  2565000
    SL2.40ch01  71000487    Solyc01g079410.2.1
    SL2.40ch01  87600019    Solyc01g108570.2.1  Solyc01g108580.2.1
    SL2.40ch01  87630003    Solyc01g108610.2.1
    SL2.40ch02  33900060    Solyc02g069420.2.1  Solyc02g069430.2.1
    ...
