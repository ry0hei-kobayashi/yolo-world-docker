FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

#-----------------------------
# Environment Variables
#-----------------------------
ENV LC_ALL=C.UTF-8
ENV export LANG=C.UTF-8
# no need input key
ENV DEBIAN_FRONTEND noninteractive
ENV MMCV_WITH_OPS=1
ENV FORCE_CUDA=1
SHELL ["/bin/bash", "-c"]

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

#-----------------------------
# Install common pkg
#-----------------------------
RUN apt-get -y update
RUN apt-get -y install git ssh python3-pip wget net-tools vim curl make build-essential lsb-release libgl1-mesa-dev

RUN pip3 install --upgrade pip

RUN pip3 install setuptools \
		 urllib3 \
		 pyopenssl \
		 ndg-httpsclient \
                 pyasn1

RUN cd / && git clone --recursive https://github.com/AILab-CVC/YOLO-World.git
WORKDIR /YOLO-World

RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip3 install mmcv==2.0.0 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11/index.html

RUN pip3 install torch wheel -q 
RUN pip3 install opencv-python==4.9.0.80 \
                 opencv-python-headless==4.2.0.34 \
                 #timm==0.6.1 \
                 transformers==4.36.2 \
                 albumentations \
                 gradio==4.16.0 \
                 supervision \
                 prettytable

RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip3 install mmdet==3.0.0 --no-deps \
                 mmengine==0.10.3 --no-deps \
                 mmyolo==0.6.0 --no-deps 

RUN chmod 775 tools/dist_train.sh
RUN apt install python-is-python3
