#!/bin/bash

set -x

source /opt/intel/openvino/bin/setupvars.sh && \
    /root/inference_engine_samples_build/intel64/Release/classification_sample_async \
    -d CPU \
    -i /opt/intel/openvino_2019.3.376/deployment_tools/demo/car.png \
    -m /root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml
