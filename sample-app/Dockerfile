## Development 
FROM openvino-dev:latest as sampleapp-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install networkx==2.3

RUN cd /opt/intel/openvino/deployment_tools/demo && \
    ./demo_squeezenet_download_convert_run.sh


## Runtime
FROM openvino-runtime:latest as sampleapp-runtime

COPY --from=sampleapp-dev /root/inference_engine_samples_build/intel64/Release/ /root/inference_engine_samples_build/intel64/Release/

COPY --from=sampleapp-dev /root/openvino_models/ir/FP16/public/squeezenet1.1/ /root/openvino_models/ir/FP16//public/squeezenet1.1/

COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/libinference_engine.so /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/libinference_engine.so
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_imgcodecs.so.4.1 /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_imgcodecs.so.4.1
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_imgproc.so.4.1 /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_imgproc.so.4.1
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_core.so.4.1 /opt/intel/openvino_2019.3.334/opencv/lib/libopencv_core.so.4.1
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/openvx/lib/libtbb.so.2 /opt/intel/openvino_2019.3.334/openvx/lib/libtbb.so.2
COPY --from=sampleapp-dev /opt/intel/openvino/deployment_tools/demo/car.png /opt/intel/openvino/deployment_tools/demo/car.png
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/plugins.xml /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/plugins.xml
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/libMKLDNNPlugin.so /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/lib/intel64/libMKLDNNPlugin.so
COPY --from=sampleapp-dev /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/external/mkltiny_lnx/lib/libmkl_tiny_tbb.so /opt/intel/openvino_2019.3.334/deployment_tools/inference_engine/external/mkltiny_lnx/lib/libmkl_tiny_tbb.so

ADD ./run.sh /root/run.sh

CMD ["/root/run.sh"]
