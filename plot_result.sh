files_lora=(simulation_lora/*/*)  # 获取文件列表
files_trainFromScratch=(simulation_trainFromScratch/*/*)  # 获取文件列表
files_pretrained=(simulation_pretrained/*/*)  # 获取文件列表
total=${#files_lora[@]}  # 总任务数

# 1. only lora
current=0
for path in "${files_lora[@]}"; do
       
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"
    
    valid=${path%:}
    
    for sub_valid in $(ls -d $valid/*/); do
        python plot_confidence.py \
        --model_path="ce_finetuned_model.pth" \
        --image_dir=$sub_valid \
        --plot_path="$sub_valid/plot.png" 
    done  
done


# 2. load finetune trainFromScratch
current=0
for path in "${files_trainFromScratch[@]}"; do
       
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"
    
    valid=${path%:}
    
    for sub_valid in $(ls -d $valid/*/); do
        python plot_confidence.py \
        --model_path="ce_finetuned_model.pth" \
        --image_dir=$sub_valid \
        --plot_path="$sub_valid/plot.png" 
    done  
done


# 3. load pretrained no finetune
current=0
for path in "${files_pretrained[@]}"; do
       
    current=$((current + 1))
    percent=$((current * 100 / total))
    bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
    printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"
    
    valid=${path%:}
    
    for sub_valid in $(ls -d $valid/*/); do
        python plot_confidence.py \
        --model_path="ce_finetuned_model.pth" \
        --image_dir=$sub_valid \
        --plot_path="$sub_valid/plot.png" 
    done  
done


# 1. only lora
# current=0
# for path in $(ls simulation_lora/*/*/*); do
#     # 排除 plot.txt 和 plot.png
#     # if [[ "$filename" != "plot.txt" && "$filename" != "plot.png" ]]; then
       
#     current=$((current + 1))
#     percent=$((current * 100 / total))
#     bar=$(printf "%-${percent}s" "#" | tr ' ' '#') # 绘制进度条
#     printf "\r[%-50s] %d%% (%d/%d)" "$bar" "$percent" "$current" "$total"

#     # 將每個子資料夾路徑賦值給新變數
#     # for subdir in $subdirs; do    
#         # echo $subdir
#         # continue
    
#     valid=${path%:}

#     python plot_confidence.py \
#         --model_path="ce_finetuned_model.pth" \
#         --image_dir=$valid\
#         --plot_path="$valid/plot.png"

#     break
# done