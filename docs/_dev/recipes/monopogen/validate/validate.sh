#!/usr/bin/env bash

path="$CONDA_PREFIX/Monopogen"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${path}/apps

chmod +x ${path}/src/Monopogen.py
chmod +x ${path}/apps/samtools
ln -sf "$CONDA_PREFIX/bin/samtools" "$CONDA_PREFIX/Monopogen/apps/samtools"


# bam list required for preProcess step
bam_lst="${path}/bam.lst"
echo "A,${path}/example/A.bam" > $bam_lst
echo "B,${path}/example/B.bam" >> $bam_lst
mkdir -p out
python  ${path}/src/Monopogen.py  preProcess -b ${bam_lst} -o ${path}/out -a ${path}/apps



# region list required for germline step
echo "chr20" > ${path}/region.lst
python ${path}/src/Monopogen.py  germline  \
    -a ${path}/apps -t 1 -r  ${path}/region.lst \
    -p ${path}/example/ \
    -g ${path}/example/chr20_2Mb.hg38.fa -s all -o ${path}/out
