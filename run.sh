python run_pie.py \
    --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
    --image_path="dataset/CheXpert-v1.0-small/valid/patient64559/study1/view1_frontal.jpg" \
    --finetune_lora_path="finetune_checkpoints/checkpoint-3500" \
    --prompt="A chest X-ray image" \
    --step=10 \
    --strength=0.5 \
    --guidance_scale=27.5 \
    --seed=42 \
    --resolution=512 \
    # --finetuned_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
    # "Intermittent dry cough with mild chest discomfort lasting for about one week. Chest X-ray revealed a faint patchy opacity in the left lower lung, with no significant consolidation or pleural effusion. Diagnosis: Upper respiratory tract infection with mild bronchitis." \

    # --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
    #  --mask_path="./assets/example_inputs/mask.png" \
    # --image_path="./assets/example_inputs/health.jpg" \
    # --image_path="dataset/chest-xray-pneumonia-ver2/chest_xray/train/NORMAL/IM-0115-0001.jpeg" \