FROM ubuntu:latest

# update
RUN apt-get -y update && apt-get -y upgrade

# install basic packages
RUN apt-get install -y \
  sudo \
  wget \
  bzip2 \
  vim \
  zip \
  unzip

###install anaconda3
WORKDIR /opt
# download anaconda package
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.continuum.io/archive/Anaconda3-2022.05-Linux-x86_64.sh && \
  sh /opt/Anaconda3-2022.05-Linux-x86_64.sh -b -p /opt/anaconda3 && \
  rm -f Anaconda3-2022.05-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH

# update pip and conda
RUN pip install --upgrade pip \
  && conda update conda

# _/_/_/_/_/_/_/_/_/_/ jupyter _/_/_/_/_/_/_/_/
#参考URL	https://qiita.com/canonrock16/items/d166c93087a4aafd2db4
#		http://tonop.cocolog-nifty.com/blog/2020/07/post-a216ae.html
# Install nodejs
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sL https://deb.nodesource.com/setup_14.x
RUN apt-get install -y nodejs
RUN pip install --no-cache-dir \
  black \
  jupyterlab \
  jupyterlab_code_formatter \
  jupyterlab-git \
  lckr-jupyterlab-variableinspector \
  jupyterlab_widgets \
  ipywidgets \
  import-ipynb \
  jupyterlab-unfold

# gitをインストールするとtzdataのtimezone設定を要求されてビルドが止まるので対応
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y tzdata
RUN sudo apt-get install -y git-all

# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

###install python packages

RUN apt-get install -y libsm6 libxext6 libxrender-dev libglib2.0-0 \
  && pip install category_encoders \
  && pip install catboost \
  && pip install dtreeviz \
  && pip install factor-analyzer \
  && pip install fastprogress japanize-matplotlib \
  && pip install graphviz \
  && pip install imbalanced-learn \
  && pip install ipynb_path \
  && pip install lightgbm \
  && pip install matplotlib-venn \
  # ----opencv郡 libgl1-mesa-dev opencv用に必要---
  && pip install opencv-python \
  && pip install opencv-contrib-python \
  && apt-get install -y libgl1-mesa-dev \
  # -------------------------------------------
  && pip install optuna \
  && pip install pandas-profiling \
  # ----------sweetviz郡------------
  && pip install sweetviz \
  # sweetviz フォント用↓
  && sudo apt install fonts-noto-cjk \
  # ------------------------------
  && pip install xgboost

WORKDIR /
RUN mkdir /work

# TODO 暫定対策 markupsafeにsoft_unicodeがありそれをimportしているが、最新versionのmarkupsafeからsoft_unicodeがremoveされた模様。 markupsafeを古いversionに戻してあげる
# ImportError: cannot import name 'soft_unicode' from 'markupsafe' (/opt/anaconda3/lib/python3.9/site-packages/markupsafe/__init__.py)
RUN pip install MarkupSafe==2.0.1

# install jupyterlab
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root", "--LabApp.token=''"]