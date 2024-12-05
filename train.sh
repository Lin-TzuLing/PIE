# !/bin/bash
source ~/.bashrc
torchrun  training/finetune-lora.py \
            --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
            --instance_data_dir="dataset/CheXpert-v1.0-small" \
            --instance_dataset="chexpert" \
            --output_dir="finetune_checkpoints" \
            --instance_prompt="A chest X-ray image" \
            --resolution=512 \
            --train_batch_size=8 \
            --gradient_accumulation_steps=2 \
            --learning_rate=5e-5 \
            --lr_warmup_steps=1000 \
            --max_train_steps=20000 \
            --lr_scheduler="cosine" \
            --checkpoints_total_limit=2 \
            --gradient_checkpointing \
            --mixed_precision bf16 \
            --center_crop \
            --checkpointing_steps 500 \


# --pretrained_model_name_or_path="CompVis/stable-diffusion-v1-4" \可換pretrained model


# accelerate launch --mixed_precision="fp16" training/train.py \
# accelerate launch training/finetune-lora.py \
# --mixed_precision="fp16" \
# --pretrained_model_name_or_path="CompVis/stable-diffusion-v1-4" \
# --instance_dataset="retinopathy" \
# --instance_data_dir="dataset/diabetic-retinopathy-224x224-gaussian-filtered_versions_2" \
# --instance_prompt="" \
# --dataloader_num_workers=8 \
# --train_batch_size=1 \
# --gradient_accumulation_steps=4 \
# --max_train_steps=15000 \
# --learning_rate=1e-04 \
# --max_grad_norm=1 \
# --lr_scheduler="cosine" \
# --lr_warmup_steps=0 \

