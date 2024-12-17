# !/bin/bash
source ~/.bashrc
# 載入 Pyenv 的初始化腳本
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export HF_HOME=./cache/
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


# 啟用目標環境
pyenv activate PIE
# or run "source train.sh"

torchrun --nproc_per_node=2 training/finetune-lora.py \
python training/finetune-lora.py \
            --output_dir="lora_checkpoints" \
            --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
            --instance_data_dir="dataset/CheXpert-v1.0-small" \
            --instance_dataset="chexpert" \
            --instance_prompt="A chest X-ray image" \
            --resolution=512 \
            --train_batch_size=8 \
            --gradient_accumulation_steps=2 \
            --learning_rate=5e-5 \
            --lr_warmup_steps=1000 \
            --max_train_steps=3000 \
            --lr_scheduler="cosine" \
            --checkpoints_total_limit=2 \
            --gradient_checkpointing \
            --mixed_precision bf16 \
            --center_crop \
            --checkpointing_steps 500 \

