import torch
import torch.nn as nn
import math 

class LoRALayer(nn.Module):
    def __init__(self, base_layer, r=4, alpha=1.0):
        super().__init__()
        self.base_layer = base_layer
        self.r = r
        self.alpha = alpha
        
        self.lora_A = nn.Parameter(torch.zeros(base_layer.to_out[0].out_features, r))
        self.lora_B = nn.Parameter(torch.zeros(r, base_layer.to_out[0].in_features))
        
        nn.init.kaiming_uniform_(self.lora_A, a=math.sqrt(5))
        nn.init.zeros_(self.lora_B)

    def forward(self, x):
        lora_update = (self.lora_A @ self.lora_B) * self.alpha
        return self.base_layer(x) + x @ lora_update.T
