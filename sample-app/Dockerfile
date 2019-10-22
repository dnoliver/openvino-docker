FROM openvino-dev:latest as sampleapp-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install networkx==2.3

RUN cd /opt/intel/openvino/deployment_tools/demo && \
    ./demo_squeezenet_download_convert_run.sh

FROM openvino-runtime:latest as sampleapp-runtime

COPY --from=sampleapp-dev /root/inference_engine_samples_build/intel64/Release/ /root/inference_engine_samples_build/intel64/Release/

COPY --from=sampleapp-dev /root/openvino_models/ir/FP16/public/squeezenet1.1/ /root/openvino_models/ir/FP16//public/squeezenet1.1/

ADD ./run.sh /root/run.sh

CMD ["/root/run.sh"]
