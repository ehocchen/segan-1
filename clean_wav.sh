#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/cuda-8.0_cudnn5.1/lib64:${LD_LIBRARY_PATH}
export PATH=/usr/local/cuda-8.0_cudnn5.1/bin:$PATH

# guia file containing pointers to files to clean up
if [ $# -lt 1 ]; then
    echo 'ERROR: at least wavname must be provided!'
    echo "Usage: $0 <guia_file> [optional:save_path]"
    echo "If no save_path is specified, clean file is saved in current dir"
    exit 1
fi

NOISY_WAVNAME="$1"
SAVE_PATH="."
if [ $# -gt 1 ]; then
  SAVE_PATH="$2"
fi

#echo "INPUT NOISY WAV: $NOISY_WAVNAME"
#echo "SAVE PATH: $SAVE_PATH"
#mkdir -p $SAVE_PATH

export CUDA_VISIBLE_DEVICES='0,1'
python audio_gen.py --init_noise_std 0. --save_path pretrain/segan_v1.1 \
               --batch_size 100 --g_nl prelu --weights SEGAN-41700 \
               --preemph 0.95 --bias_deconv True \
               --bias_downconv True --bias_D_conv True \
               --test_dir $NOISY_WAVNAME --save_clean_path $SAVE_PATH
