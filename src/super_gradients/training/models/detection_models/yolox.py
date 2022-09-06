from super_gradients.training.models.detection_models.yolo_base import YoLoBase, YoLoDarknetBackbone
import numpy as np
import torch
from super_gradients.training.utils.utils import HpmStruct

import sys
import os
sys.path.insert(0, '/home/naveassaf/Workspace/rt-optimization')

from deci_common.data_types.enum.models_enums import QuantizationLevel
from deci_common.data_types.enum.model_frameworks import FrameworkType
from deci_optimize.converter import Converter

# ------------------------------------------------------------------------------------------ #
# YOLOX Nano
# ------------------------------------------------------------------------------------------ #
class YoloX_N(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 0.33
        arch_params.width_mult_factor = 0.25
        arch_params.yolo_type = 'yoloX'
        arch_params.depthwise = True
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)


class YoloX_N_First100(YoloX_N):
    def forward(self, x):
        return super().forward(x)[0][:, :100, :]

# ------------------------------------------------------------------------------------------ #
# YOLOX Tiny
# ------------------------------------------------------------------------------------------ #
class YoloX_T(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 0.33
        arch_params.width_mult_factor = 0.375
        arch_params.yolo_type = 'yoloX'
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)


class YoloX_T_First100(YoloX_T):
    def forward(self, x):
        return super().forward(x)[0][:, :100, :]

# ------------------------------------------------------------------------------------------ #
# YOLOX Small
# ------------------------------------------------------------------------------------------ #
class YoloX_S(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 0.33
        arch_params.width_mult_factor = 0.50
        arch_params.yolo_type = 'yoloX'
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)


class YoloX_S_First100(YoloX_S):
    def forward(self, x):
        return super().forward(x)[0][:, :100, :]


# ------------------------------------------------------------------------------------------ #
class YoloX_M(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 0.67
        arch_params.width_mult_factor = 0.75
        arch_params.yolo_type = 'yoloX'
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)


class YoloX_L(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 1.0
        arch_params.width_mult_factor = 1.0
        arch_params.yolo_type = 'yoloX'
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)


class YoloX_X(YoLoBase):
    def __init__(self, arch_params: HpmStruct):
        arch_params.depth_mult_factor = 1.33
        arch_params.width_mult_factor = 1.25
        arch_params.yolo_type = 'yoloX'
        super().__init__(backbone=YoLoDarknetBackbone, arch_params=arch_params)
