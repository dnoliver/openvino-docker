FROM openvino/ubuntu18_dev:2020.2 AS openvino-dev

# Create minimal deployment package with accelerators and cpu support
# NOTE: OpenCV is not included
RUN /opt/intel/openvino_2020.2.120/deployment_tools/tools/deployment_manager/deployment_manager.py \
        --targets cpu gpu vpu gna hddl --output_dir /tmp --archive_name openvino_deploy_package

# [legacy builder] Copying non-root owned files between stages fails with userns
# https://github.com/moby/moby/issues/34645USER root
USER root
RUN chown root:root /tmp/openvino_deploy_package.tar.gz
USER openvino

## Minimal base runtime image
FROM ubuntu:18.04 AS openvino-runtime

RUN useradd -d /home/openvino -m -s /bin/bash openvino
COPY --chown=openvino --from=openvino-dev /tmp/openvino_deploy_package.tar.gz /tmp
RUN mkdir -p /opt/intel/openvino && tar xzf /tmp/openvino_deploy_package.tar.gz -C /opt/intel/openvino
RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> /root/.bashrc
RUN chown openvino:openvino -R /opt/intel/openvino
USER openvino
CMD ["/bin/bash"]
