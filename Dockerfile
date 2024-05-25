FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

#-----------------------------
# Environment Variables
#-----------------------------
ENV LC_ALL=C.UTF-8
ENV export LANG=C.UTF-8
# no need input key
ENV DEBIAN_FRONTEND noninteractive

#for mm
ENV FORCE_CUDA="1"
ENV MMCV_WITH_OPS=1

SHELL ["/bin/bash", "-c"]

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

#-----------------------------
# Install common pkg
#-----------------------------
RUN apt-get -y update
RUN apt-get -y install git ssh python3-pip wget net-tools vim curl make build-essential lsb-release libgl1-mesa-dev python3-wheel



#RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip3 install mmcv==2.0.0 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11/index.html

#RUN pip3 install torch wheel -q 
#RUN pip3 install opencv-python==4.9.0.80 \
#                 opencv-python-headless==4.2.0.34 \
#                 #timm==0.6.1 \
#                 transformers==4.36.2 \
#                 albumentations \
#                 gradio==4.16.0 \
#                 supervision \
#                 prettytable


RUN pip3 install --upgrade pip \
&& pip3 install   \
    gradio        \
    #setuptools \
    opencv-python \
    supervision   \
    mmengine      \
    setuptools \
    openmim       \
    transformers  \
    networkx==2.8.8 \
    requests==2.28.1 \
    && pip3 install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cu118 \
    wheel         \
    torch==2.0.0  \
    torchvision==0.15.1  \
    torchaudio    \
    && pip3 install mmdet \
    mmyolo        \
    && pip3 install git+https://github.com/lvis-dataset/lvis-api.git \
    && mim install mmcv==2.0.0

RUN cd / && git clone --recursive https://github.com/AILab-CVC/YOLO-World.git
WORKDIR /YOLO-World

RUN apt install unzip
RUN mkdir weights && curl -o weights/yolo_world_v2_s_obj365v1_goldg_pretrain-55b943ea.pth -L https://huggingface.co/wondervictor/YOLO-World/resolve/main/yolo_world_v2_s_obj365v1_goldg_pretrain-55b943ea.pth
RUN mkdir -p data/coco/lvis && curl -o data/coco/lvis/lvis_v1_minival_inserted_image_name.json -L https://huggingface.co/GLIPModel/GLIP/blob/main/lvis_v1_minival_inserted_image_name.json
RUN cd data/coco/ && wget http://images.cocodataset.org/zips/val2017.zip  && unzip val2017.zip

RUN chmod 775 tools/dist_train.sh
RUN apt install python-is-python3
