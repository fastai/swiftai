# README
# If you ever intend to add anything via the ADD verb, please remove the wildcard from .dockerignore


FROM ubuntu:18.04

# Update base
RUN apt update
RUN apt upgrade -y

# Install deps and useful utils
RUN apt install -y apt-utils clang curl git libblocksruntime-dev libpython-dev libpython3.6 libxml2 python3 python3-pip

# Install S4TF
WORKDIR /root
RUN curl https://storage.googleapis.com/swift-tensorflow-artifacts/nightlies/latest/swift-tensorflow-DEVELOPMENT-ubuntu18.04.tar.gz > swift.tar.gz
RUN tar -xf swift.tar.gz
ENV PATH="/root/usr/bin:${PATH}"

# Install swift-jupyter and register
RUN git clone https://github.com/google/swift-jupyter.git
WORKDIR /root/swift-jupyter
RUN pip3 install jupyter
RUN python3 register.py --sys-prefix --swift-toolchain /root

# Install fastai since nbs use it
RUN pip3 install fastai

# Set default workdir to swiftai
WORKDIR /root/swiftai

# Good practice to expose ports for future automated tooling
EXPOSE 8888

# Bind to all available interfaces
CMD jupyter notebook --ip=0.0.0.0 --allow-root
