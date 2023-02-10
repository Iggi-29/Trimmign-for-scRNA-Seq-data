#!/bin/bash
 
set -e
set -u
set -o pipefail


# Activate conda environment where the program is stored
source /home/ignasi/anaconda3/etc/profile.d/conda.sh
conda activate ignasi

# Save paths to the important files
bbduk=/home/ignasi/anaconda3/envs/ignasi/bin/bbduk.sh
adapters=/home/ignasi/anaconda3/envs/ignasi/opt/bbmap-39.01-0/resources/adapters.fa


# Create directories where the data will be stored
for folder in SRR*
do
cd ./${folder}
mkdir -p "out_${folder}"
mkdir -p "stats_${folder}"
cd ../
done

# Do the bbduk action
for folder in SRR*
do
cd "./${folder}"
here=$(pwd) 
samplename=$(basename ${folder} _1.fastq.gz)
$bbduk -Xmx1g in1="${here}/${samplename}_1.fastq.gz" in2="${here}/${samplename}_2.fastq.gz" out1="${here}/out_${folder}/${samplename}_trim_1.fastq.gz" out2="${here}/out_${folder}/${samplename}_trim_2.fastq.gz" ref=${adapters} ktrim=r k=27 hdist=1 mink=20 trimq=20 qtrim=rl skipr1=t minlength=26 stats="${here}/stats_${folder}/${samplename}_trimming_stats.txt"
cd ..
done
