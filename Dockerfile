FROM ubuntu:18.04 AS openvino-dev

ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/16057/l_openvino_toolkit_p_2019.3.376.tgz

ARG INSTALL_DIR=/opt/intel/openvino

ARG TEMP_DIR=/tmp/openvino_installer

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cpio \
        curl \
        git \
        lsb-release \
        pciutils \
        python3.6 \
        python3.6-dev \
        python3-pip \
        python3-setuptools \
        sudo \
        wget && \
        rm -rf /var/lib/apt/lists/* && \
        pip3 install numpy

# Download and install OpenVINO
RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR && \
    wget -c $DOWNLOAD_LINK && \
    tar xf l_openvino_toolkit_p_2019.3.376.tgz && \
    cd l_openvino_toolkit_p_2019.3.376 && \
    ./install_openvino_dependencies.sh && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh --silent silent.cfg && \
    rm -rf $TEMP_DIR

# Model Optimizer prerequisites
RUN cd $INSTALL_DIR/deployment_tools/model_optimizer/install_prerequisites && \
    ./install_prerequisites.sh

# Create minimal deployment package with accelerators and cpu support
# NOTE: OpenCV is not included
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh" && \
    $INSTALL_DIR/deployment_tools/tools/deployment_manager/deployment_manager.py \
        --targets cpu gpu vpu gna hddl --output_dir /tmp --archive_name openvino_deploy_package

## Minimal base runtime image
FROM ubuntu:18.04 AS openvino-runtime

COPY --from=openvino-dev /tmp/openvino_deploy_package.tar.gz /tmp
RUN mkdir -p /opt/intel && tar xzf /tmp/openvino_deploy_package.tar.gz -C /opt/intel
RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> /root/.bashrc
CMD ["/bin/bash"]
