FROM openvino/ubuntu18_dev:2020.2 AS openvino-dev

# Create minimal deployment package with accelerators and cpu support
# NOTE: OpenCV is not included
RUN /opt/intel/openvino_2020.2.120/deployment_tools/tools/deployment_manager/deployment_manager.py \
        --targets cpu gpu vpu gna hddl --output_dir /tmp --archive_name openvino_deploy_package

## Minimal base runtime image
FROM ubuntu:18.04 AS openvino-runtime

COPY --from=openvino-dev /tmp/openvino_deploy_package.tar.gz /tmp
RUN mkdir -p /opt/intel/openvino && tar xzf /tmp/openvino_deploy_package.tar.gz -C /opt/intel/openvino
RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> /root/.bashrc
CMD ["/bin/bash"]
