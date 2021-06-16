FROM ubuntu:latest

# update
RUN apt-get -y update && apt-get -y upgrade

# install basic packages
RUN apt-get install -y \
sudo \
wget \
bzip2 \
vim 

###install anaconda3
WORKDIR /opt
# download anaconda package
# archive -> https://repo.continuum.io/archive/
RUN wget https://repo.continuum.io/archive/Anaconda3-2021.05-Linux-x86_64.sh && \
sh /opt/Anaconda3-2021.05-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2021.05-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH

# update pip and conda
RUN pip install --upgrade pip

# _/_/_/_/_/_/_/_/_/_/ jupyter _/_/_/_/_/_/_/_/
#参考URL	https://qiita.com/canonrock16/items/d166c93087a4aafd2db4
#		http://tonop.cocolog-nifty.com/blog/2020/07/post-a216ae.html
# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

##### ↓　anaconda versionあげたらインストールできなくなった・・（？
	# Variable Inppector (使用している変数一覧を表示)
#RUN	jupyter labextension install @lckr/jupyterlab_variableinspector
	# コード補完
#RUN	pip install autopep8
#RUN	pip install jupyterlab_code_formatter
#RUN	jupyter labextension install @ryantam626/jupyterlab_code_formatter
#RUN	jupyter serverextension enable --py jupyterlab_code_formatter


# _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

###install python packages
# install OpenCV
RUN apt-get install -y libsm6 libxext6 libxrender-dev libglib2.0-0 \
	&& pip install opencv-python \
	&& pip install opencv-contrib-python \
	&& apt-get install -y libgl1-mesa-dev \
# install other packages
	&& pip install category_encoders \
	&& pip install factor-analyzer \
	&& pip install graphviz \
	&& pip install dtreeviz \
	&& pip install lightgbm \
	&& pip install optuna \
	&& pip install xgboost \
	&& pip install catboost \
	# matplotlib japanese
	&& pip install -U pip \
	&& pip install fastprogress japanize-matplotlib


WORKDIR /
RUN mkdir /work


# install jupyterlab
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root", "--LabApp.token=''"]