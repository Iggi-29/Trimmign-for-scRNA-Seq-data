#!/bin/bash
 
set -e
set -u
set -o pipefail


# Activate conda environment where the program is stored
source /home/vant/anaconda3/etc/profile.d/conda.sh
conda activate ignasi

# Save paths to the and important files
bbduk=/home/vant/anaconda3/envs/ignasi/bin/bbduk.sh



# Create directories where the data will be stored
for folder in SRR*
do
cd ./${folder}
mkdir -p "out_${folder}"
cd ../
done

for folder in SRR*
do
cd "./${folder}"
here=$(pwd) 
samplename=$(basename ${folder} _1.fastq.gz)
$bbduk -Xmx1g in1="${here}/${samplename}_1.fastq.gz" out1="${here}/out_${folder}/${samplename}_trim_uno_1.fastq.gz" ftr=27 t=7 --ordered
cd ..
done
