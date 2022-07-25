FROM debian:11

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    sed -i s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends python3-dev r-base-dev && \
    apt install -y --no-install-recommends libhdf5-dev libxml2-dev libssl-dev libcurl4-openssl-dev libhdf5-dev libxml2-dev libssl-dev libcurl4-openssl-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev && \
    apt install -y --no-install-recommends python3-pip sqlite3 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy==1.19.5 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple scipy==1.7.3 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple Cython && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple cellphonedb && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple leidenalg && \
    R -e 'install.packages(c("BiocManager", "devtools"))' && \
    R -e 'BiocManager::install(c("Seurat", "SingleR", "monocle", "org.Hs.eg.db", "glmGamPoi"))' && \
    R -e 'devtools::install_github("chris-mcginnis-ucsf/DoubletFinder")' && \
    R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rvcheck/rvcheck_0.1.8.tar.gz")' && \
    R -e 'BiocManager::install("clusterProfiler")' && \
    R -e 'install.packages(c("anndata", "hdf5r", "shinyWidgets", "DT"))' && \
    apt autoremove && apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
