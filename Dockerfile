FROM julia:buster

# install R and other packages
RUN echo "deb [trusted=yes] http://cran.asia/bin/linux/debian buster-cran35/" >> /etc/apt/sources.list && \
        apt update && \
        apt -y upgrade && \
        apt -y install \
                gdal-bin \
                git \
                libcurl4-openssl-dev \
                libgdal-dev \
                libproj-dev \
                libssl-dev \
                libudunits2-dev \
                libv8-dev \
                libxml2-dev \
                locales \
                proj-bin \
                r-base \
                sudo \
                tzdata \
                wget && \
        rm -rf /var/lib/apt/lists/*

# set up a non root user
# from https://code.visualstudio.com/docs/remote/containers-advanced#_adding-a-nonroot-user-to-your-dev-container
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# set locale
# from https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# set timezone
# from https://bobcares.com/blog/change-time-in-docker-container/
ENV TZ Asia/Kuala_Lumpur

# install some libraries
WORKDIR /tmp

# install some R libraries
COPY ./scripts/install_libraries.R .
RUN Rscript  install_libraries.R

# install miniconda3 to use jupyter notebook
ENV PATH /opt/conda/bin:$PATH

# based on: https://hub.docker.com/r/continuumio/anaconda3/dockerfile
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    /opt/conda/bin/conda install -y jupyter

USER user

# install the R kernel for user "user"
RUN echo "IRkernel::installspec()" | R --vanilla

# for installing RCall in Julia
ENV R_HOME  /usr/lib/R

# for IJulia.jl and Interact.jl
ENV JUPYTER /home/user/conda/bin/jupyter