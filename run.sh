files=(dataset/CheXpert-v1.0-small/valid/*/*/*)  # 获取文件列表
total=${#files[@]}  # 总任务数


# 1. only load lora
# for all clean(valid) pictures
current=0
for valid in $(ls dataset/CheXpert-v1.0-small/valid/*/*/*); do
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"

    extracted_filename=$(echo "$valid" | sed -E 's|.*/valid/||; s|.jpg*$||')

    python run_pie.py \
        --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
        --image_path=$valid \
        --finetune_lora_path="lora_checkpoints" \
        --prompt="A chest X-ray image" \
        --step=10 \
        --strength=0.5 \
        --guidance_scale=27.5 \
        --seed=42 \
        --resolution=512 \
        --output_dir="simulation_lora/$extracted_filename" 

done
echo


# 2. load finetune trainFromScratch
current=0
for valid in $(ls dataset/CheXpert-v1.0-small/valid/*/*/*); do
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"

    extracted_filename=$(echo "$valid" | sed -E 's|.*/valid/||; s|.jpg*$||')

    python run_pie.py \
    --pretrained_model_name_or_path="trainFromScratch_checkpoints/" \
    --image_path=$valid \
    --prompt="A chest X-ray image" \
    --step=10 \
    --strength=0.5 \
    --guidance_scale=27.5 \
    --seed=42 \
    --resolution=512 \
    --output_dir="simulation_trainFromScratch/$extracted_filename" 

done
echo


# 3. load pretrained no finetune
current=0
for valid in $(ls dataset/CheXpert-v1.0-small/valid/*/*/*); do
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"

    extracted_filename=$(echo "$valid" | sed -E 's|.*/valid/||; s|.jpg*$||')

    python run_pie.py \
    --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
    --image_path=$valid \
    --prompt="A chest X-ray image" \
    --step=10 \
    --strength=0.5 \
    --guidance_scale=27.5 \
    --seed=42 \
    --resolution=512 \
    --output_dir="simulation_pretrained/$extracted_filename/"

done
echo


# --finetuned_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
# "Intermittent dry cough with mild chest discomfort lasting for about one week. Chest X-ray revealed a faint patchy opacity in the left lower lung, with no significant consolidation or pleural effusion. Diagnosis: Upper respiratory tract infection with mild bronchitis." \

# --pretrained_model_name_or_path="IrohXu/stable-diffusion-mimic-cxr-v0.1" \
#  --mask_path="./assets/example_inputs/mask.png" \
# --image_path="./assets/example_inputs/health.jpg" \
# --image_path="dataset/chest-xray-pneumonia-ver2/chest_xray/train/NORMAL/IM-0115-0001.jpeg" \