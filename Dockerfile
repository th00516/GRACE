FROM debian:11

WORKDIR /root

SHELL ["/bin/bash", "-c"]

ENV PATH "/root/miniconda3/bin:/root/nextflow.dir/bin:$PATH"

RUN ln -sf /bin/bash /bin/sh && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    mkdir -p /root/nextflow.dir/bin

#### copy pre-downloaded nextflow-all file into specific directory ####
COPY ./nextflow-all/nextflow-22.10.7-all /root/nextflow.dir/bin/nextflow
########

RUN cd /root && \

    #### for Chinese user ####
    sed -i s/deb.debian.org/mirrors.bfsu.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/mirrors.bfsu.edu.cn/g /etc/apt/sources.list && \
    ########

    apt update && apt dist-upgrade -y && \

    apt install -y wget openjdk-17-jre && \

    #### nextflow ####

    ## nextflow-all cannot be download from github in China ##
    # wget -O nextflow.dir/bin/nextflow https://github.com/nextflow-io/nextflow/releases/download/v22.10.7/nextflow-22.10.7-all
    ####

    chmod +x nextflow.dir/bin/nextflow && \
    echo 'export PATH="/root/nextflow.dir/bin:${PATH}"' >> .bashrc && \
    ########

    #### miniconda3 ####
    wget 'https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh' && \
    bash ./Miniconda3-py39_23.1.0-1-Linux-x86_64.sh -b && \
    rm -f Miniconda3-py39_23.1.0-1-Linux-x86_64.sh && \
    source '/root/miniconda3/etc/profile.d/conda.sh' && \
    conda init bash && \
    ########

#### for Chinese user ####
    echo $'\
channels:\n\
  - defaults\n\
show_channel_urls: true\n\
default_channels:\n\
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/main\n\
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/r\n\
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/msys2\n\
custom_channels:\n\
  conda-forge: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  msys2: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  bioconda: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  menpo: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  pytorch: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  pytorch-lts: https://mirrors.bfsu.edu.cn/anaconda/cloud\n\
  simpleitk: https://mirrors.bfsu.edu.cn/anaconda/cloud\
' > .condarc && \
########
    conda activate base && \

    ########
    conda install -y zip && \
    conda install -y hdf5 && \
    conda install -y cmake && \
    ########

    ########
    conda install -y r-essentials && \
    conda install -y r-reticulate && \
    conda install -y r-biocmanager && \
    conda install -y r-devtools && \

    conda install -y r-systemfonts && \
    conda install -y r-hdf5r && \
    conda install -y r-dbi && \
    conda install -y r-shiny && \
    conda install -y r-shinywidgets && \
    conda install -y r-plotly && \
    conda install -y r-dt && \
    ########

    #### for Chinese user ####
    pip3 config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple && \

    echo $'\
options("repos" = c(CRAN="https://mirrors.bfsu.edu.cn/CRAN/"))\n\
options(BioC_mirror="https://mirrors.bfsu.edu.cn/bioconductor")\
' > .Rprofile && \
    ########

    #### R Anndata ####
    conda create -y -n r-reticulate python=3.9 && \

    conda activate r-reticulate && \
    ## GPU acceleration for scvi-tools ##
    # pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
    ####
    pip install anndata scvi-tools && \
    conda deactivate && \

    R -e 'install.packages("anndata")' && \

    export RETICULATE_MINICONDA_PATH="/root/miniconda3" && \
    ########

    #### Update packages ####
    R -e 'install.packages("ggplot2")' && \
    R -e 'install.packages("RcppCNPy")' && \
    ########

    #### Bio-tools ####
    R -e 'BiocManager::install("Seurat")' && \

    R -e 'BiocManager::install("glmGamPoi")' && \
    R -e 'BiocManager::install("org.Hs.eg.db")' && \
    R -e 'BiocManager::install("org.Mm.eg.db")' && \
    R -e 'BiocManager::install("ComplexHeatmap")' && \
    R -e 'BiocManager::install("ggblur")' && \

    R -e 'BiocManager::install("SingleR")' && \
    R -e 'BiocManager::install("clusterProfiler")' && \

    R -e 'devtools::install_github("chris-mcginnis-ucsf/DoubletFinder")' && \
    R -e 'devtools::install_github("ShellyCoder/cellcall")' && \
    R -e 'devtools::install_github("sqjin/CellChat")' && \
    ########

    #### fix up monocle2 ####
    wget https://bioconductor.org/packages/release/bioc/src/contrib/monocle_2.26.0.tar.gz && \
    tar zxf monocle_2.26.0.tar.gz && \
    sed -i s/if\(class\(projection\)/#if\(class\(projection\)/ monocle/R/order_cells.R && \
    R CMD INSTALL monocle && \
    rm -rf monocle monocle_2.26.0.tar.gz && \
    ########

    #### leidenalg ####
    pip install leidenalg && \
    ########

    #### put SPRING into GRACE/grace/utils ####
    conda create -y -n spring python=2.7 && \

    conda activate spring && \
    pip install pandas matplotlib scikit-learn && \
    conda deactivate && \
    ########

    #### CellphoneDB ####
    conda create -y -n cellphonedb python=3.7 && \

    conda activate cellphonedb && \
    conda install -y r-essentials && \
    pip install cellphonedb && \
    cellphonedb database download --version v3.0.0 && \
    conda deactivate && \
    ########

    apt autoremove --purge && apt autoclean
