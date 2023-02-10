#!/bin/bash
set -e
set -u
set -o pipefail

# Activate conda environment where the program is stored
source /home/vant/anaconda3/etc/profile.d/conda.sh
conda activate ignasi

# Save paths to important files
adapters=/home/vant/anaconda3/envs/ignasi/opt/bbmap-39.01-0/resources/adapters2.fa

# Create directories where the data will be stored
for folder in SRR*
do
cd ./${folder}
mkdir -p "out_${folder}"
mkdir -p "stats_${folder}"
cd ../
done

# Do the action
for folder in SRR*
do
cd ./${folder}
here=$(pwd)
samplename=$(basename ${folder} _1.fastq.gz)
fastp -i "${here}/${samplename}_1.fastq.gz" -I "${here}/${samplename}_2.fastq.gz" -o "${here}/out_${folder}/${samplename}_trim_1.fastq.gz" -O "${here}/out_${folder}/${samplename}_trim_2.fastq.gz" --length_required 28 --adapter_fasta ${adapters} --cut_front --cut_front_window_size=4 --cut_front_mean_quality 10 --cut_right --cut_right_window_size 4 --cut_right_mean_quality 10 --thread 7 --html "${here}/stats_${folder}/${samplename}_trimming_stats.html"
cd ..
done
