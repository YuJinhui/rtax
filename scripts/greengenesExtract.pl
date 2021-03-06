#!/usr/bin/env perl

use strict;
use warnings;

open( FASTA, ">greengenes.fasta" )    || die("Can't write to greengenes.fasta");
open( TAX,   ">greengenes.taxonomy" ) || die("Can't write to greengenes.taxonomy");

my $fieldname = "gg_norm_tax_string";

while (<STDIN>) {

    # read in by blocks
    if ( $_ =~ /^BEGIN$/ ) {
        my $prokMSAid = "NONE";
        my $tax       = "NONE";
        my $seq       = "NONE";

        until ( $_ =~ /^END$/ ) {
            if (/^prokMSA_id=(.+)/) {
                $prokMSAid = $1;
            }
            elsif (/^$fieldname=(.+)/) {
                $tax = $1;
            }
            elsif (/aligned_seq=(.+)/) {
                $seq = $1;
            }

            if ( $seq ne "NONE" && $seq ne "unaligned" ) {
                print FASTA ">$prokMSAid\n$seq\n";

                # don't include taxonomy info if there is no sequence anyway
                # and certainly not if there is no taxonomy data
                if ( $tax ne "" && $tax ne "NONE" ) {
                    print TAX "$prokMSAid\t$tax\n";
                }
            }

            $_ = <STDIN>;
        }
    }

    # else ignore anything outside a BEGIN/END block

}

close FASTA;
close TAX;
