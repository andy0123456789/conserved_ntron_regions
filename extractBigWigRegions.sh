#!/usr/bin/env bash
# bigWigRegions
# Kamil Slowikowski
#
# Depends on bigWigToBedGraph: http://hgdownload.cse.ucsc.edu/admin/exe/

if [[ $# -ne 2 ]]; then
    echo "bigWigRegions - Print bigWig data for each region in a bed file."
    echo -e "usage:\n   bigWigRegions in.bigWig in.bed > out.bedGraph"
    echo "   bigWigRegions in.bigWig <(zcat in.bed.gz) > out.bedGraph"
    exit 1
fi

bw="$1"
bed="$2"

[[ ! -e "$bw" ]] && echo "ERROR: Missing file '$bw'" && exit 1
[[ ! -e "$bed" ]] && echo "ERROR: Missing file '$bed'" && exit 1

# Write temporary files to RAM.
{
    IFS=$'\t'
    while read chrom beg end rest; do
        out="bigwig_intronic/${USER}_${$}_${chrom}_${beg}_${end}"
        ./bigWigToBedGraph -chrom=$chrom -start=$beg -end=$end "$bw" "$out"
    done < "$bed"
}

# Print the temporary files to stdout and then delete them.
# cat /dev/shm/bigWigRegions_${USER}_${$}_* | sort -k1V -k2n -k3n
# rm -f /dev/shm/bigWigRegions_${USER}_${$}_*
