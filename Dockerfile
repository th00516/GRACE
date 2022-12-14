FROM debian:11

RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    sed -i s/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    sed -i s/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
    apt update && \
    apt install -y --no-install-recommends python3-dev r-base-dev openjdk-11-jre && \
    apt install -y --no-install-recommends libhdf5-dev libxml2-dev libgit2-dev libssl-dev libcurl4-openssl-dev libgeos-dev \
                                           libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev \
                                           libpng-dev libtiff5-dev libjpeg-dev && \
    apt install -y --no-install-recommends python3-pip sqlite3 file && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy==1.19.5 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple scipy==1.7.3 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple markupsafe==2.0.1 && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple Cython && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple cellphonedb && \
    python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple leidenalg && \
    R -e 'install.packages(c("BiocManager", "devtools"), repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN")' && \
    R -e 'options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor", repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN"); \
                  BiocManager::install(c("Seurat", "SingleR", "monocle", "org.Hs.eg.db", "glmGamPoi"))' && \
    R -e 'devtools::install_github("chris-mcginnis-ucsf/DoubletFinder")' && \
    R -e 'install.packages("https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/reticulate/reticulate_1.24.tar.gz")' && \
    R -e 'install.packages("https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/contrib/Archive/rvcheck/rvcheck_0.1.8.tar.gz")' && \
    R -e 'options(BioC_mirror = "https://mirrors.tuna.tsinghua.edu.cn/bioconductor", repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN"); \
                  BiocManager::install("clusterProfiler")' && \
    R -e 'install.packages(c("anndata", "hdf5r", "shinyWidgets", "DT"), repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN")' && \
    apt autoremove && apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf ~/.cache
    mkdir -p ~/.locale/bin
    cd ~/.locale/bin
    curl -s https://get.nextflow.io | bash
