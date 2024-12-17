import argparse
import os
import numpy as np
from PIL import Image
import cv2
import torch
import torch.nn as nn
from torch.utils.data import Dataset
from sklearn.metrics import roc_auc_score
import matplotlib.pyplot as plt

from libauc.datasets import CheXpert
from libauc.models import densenet121 as DenseNet121

os.environ["CUDA_VISIBLE_DEVICES"] = "2"

def parse_args(input_args=None):
    parser = argparse.ArgumentParser(description="Plot the classification confidence score results")
    parser.add_argument(
        "--model_path",
        type=str,
        default=None,
        required=True,
        help="Path to confidence model.",
    )
    parser.add_argument(
        "--image_dir",
        type=str,
        default=None,
        required=True,
        help="Path to input image sequence folder",
    )
    parser.add_argument(
        "--plot_path",
        type=str,
        default="./plot.png",
        help="The output path.",
    )
    parser.add_argument(
        "--num",
        type=int,
        default=10,
        help="The number of images to draw the plot.",
    )
    parser.add_argument(
        "--resolution",
        type=int,
        default=224,
        help=(
            "The resolution for input size for confidence model"
        ),
    )
    args = parser.parse_args()
    return args

def main(args):
    IMG_PATH = args.image_dir
    count = args.num
    image_size = args.resolution
    sigmoid = nn.Sigmoid()

    model = DenseNet121(pretrained=False, last_activation=None, activations='relu', num_classes=1)
    checkpoint = torch.load(args.model_path, weights_only=True)
    model.load_state_dict(checkpoint)
    model = model.cuda()
    model.eval()

    index = []
    value = []

    # first_img, last_img = None, None
    for i in range(0, count+1):
        image_path = os.path.join(IMG_PATH, str(i) + ".png")
        image = cv2.imread(image_path, 0)

        image = Image.fromarray(image)
        image = np.array(image)
        image = cv2.cvtColor(image, cv2.COLOR_GRAY2RGB)

        image = cv2.resize(image, dsize=(image_size, image_size), interpolation=cv2.INTER_LINEAR)  
        image = image / 255.0
        mean = np.array([[[0.485, 0.456, 0.406]]])
        std =  np.array([[[0.229, 0.224, 0.225]]]) 
        image = (image-mean)/std
        image = image.transpose((2, 0, 1)).astype(np.float32)
        image = torch.from_numpy(image)
        image = image.unsqueeze(0)
        image = image.cuda()

        # if i == 0: 
        #     first_img = image
        # if i == count:
        #     last_img = image
            
        with torch.no_grad():  
            index.append(i)
            value.append(sigmoid(model(image)).cpu().numpy()[0][0])
        
        # print("Image: ", i, " Confidence: ", value[-1])
         
    # pred_first = model(first_img.cpu().detach().numpy())
    # pred_last = model(last_img.cpu().detach().numpy())
                
    # val_auc =  roc_auc_score(test_true, test_pred) 
    # print ('Epoch=%s, BatchID=%s, Val_AUC=%.4f, lr=%.4f'%(epoch, idx, val_auc,  optimizer.lr))
    # print('ok args.plot_path:', args.plot_path)
    # exit()
    
    plt.plot(index, value)
    plt.savefig(args.plot_path)
    with open(args.plot_path.replace(".png", ".txt"), "w") as f:
        f.write("image_step, confidence_value\n")
        for i, v in zip(index, value):
            f.write(f"{i}, {v}\n")

if __name__ == "__main__":
    args = parse_args()
    main(args)