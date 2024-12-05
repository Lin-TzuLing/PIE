import os
import numpy as np
import pandas as pd
import torch
from torch.utils.data import Dataset
from PIL import Image
from torchvision import transforms

# self-import
from sklearn.model_selection import train_test_split

class Retinopathy(Dataset):
    def __init__(self, path, split="train", transform=None):
        super().__init__()
   
        csvpath = os.path.join(path, 'trainLabels.csv')
        self.csvpath = csvpath
        self.imgpath = os.path.join(path, 'gaussian_filtered_images')
        
        self.transform = transform
        csv = pd.read_csv(self.csvpath)
        # print(csv[:5])
        # exit()
        
        class_counts = csv['diagnosis'].value_counts()
        print("Class counts before sampling:")
        print(class_counts)

        train, test = train_test_split(csv, test_size=0.1, stratify=csv['diagnosis'], random_state=42)
        print(f"Train size: {len(train)}, Test size: {len(test)}")

        if split == "train":
            self.csv = train
        else:   
            self.csv = test
            
        self.pathologies = ["No DR", "Mild", "Moderate", "Severe", "Proliferative DR"]
        self.pathologies_map = {0:"No_DR", 1:"Mild", 2:"Moderate", 3:"Severe", 4:"Proliferate_DR"}
        
        
    def __len__(self):
        return len(self.csv.index)

    def __getitem__(self, idx):
        imgid = self.csv['id_code'].iloc[idx]
        level = self.csv['diagnosis'].iloc[idx]      
        
        img_path = os.path.join(self.imgpath, self.pathologies_map[level], imgid+'.png')
        img = Image.open(img_path)
        if not img.mode == "RGB":
            img = img.convert("RGB")
        if self.transform is not None:
            img = self.transform(img)

        if level == 0:
            metadata = {'img_path': img_path, "pathologies": "healthy"}
        else:
            metadata = {'img_path': img_path, "pathologies": "diabetic"}
        
        return img, level, metadata
    

if __name__=="__main__":
    Retinopathy(path="dataset/diabetic-retinopathy-224x224-gaussian-filtered_versions_2", split="train")