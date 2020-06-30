## Development Build 
FROM openvino-dev:latest as sampleapp-dev

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install networkx==2.3

RUN cd /opt/intel/openvino/deployment_tools/demo && \
    ./demo_security_barrier_camera.sh -d CPU -sample-options -no_show

## Runtime Build
FROM openvino-runtime:latest as sampleapp-runtime

RUN useradd -d /home/openvino -m -s /bin/bash openvino

# Copy Release Build
COPY --chown=openvino --from=sampleapp-dev /root/inference_engine_demos_build/intel64/Release/ \
    /home/openvino/inference_engine_demos_build/intel64/Release/

# Copy Models
COPY --chown=openvino --from=sampleapp-dev /root/openvino_models/ir/intel/license-plate-recognition-barrier-0001/FP16 \
    /home/openvino/openvino_models/ir/intel/license-plate-recognition-barrier-0001/FP16
COPY --chown=openvino --from=sampleapp-dev /root/openvino_models/ir/intel/vehicle-attributes-recognition-barrier-0039/FP16 \
    /home/openvino/openvino_models/ir/intel/vehicle-attributes-recognition-barrier-0039/FP16
COPY --chown=openvino --from=sampleapp-dev /root/openvino_models/ir/intel/vehicle-license-plate-detection-barrier-0106/FP16 \
    /home/openvino/openvino_models/ir/intel/vehicle-license-plate-detection-barrier-0106/FP16

# Copy Images
COPY --chown=openvino --from=sampleapp-dev /opt/intel/openvino/deployment_tools/demo/car_1.bmp \
    /opt/intel/openvino/deployment_tools/demo/car_1.bmp

# Copy Dependencies
# ldd /root/inference_engine_demos_build/intel64/Release/security_barrier_camera_demo | awk '{print $3}' | sort
COPY --chown=openvino --from=sampleapp-dev \
    /lib/x86_64-linux-gnu/libblkid.so.1 \
    /lib/x86_64-linux-gnu/libbsd.so.0 \
    /lib/x86_64-linux-gnu/libc.so.6 \
    /lib/x86_64-linux-gnu/libdbus-1.so.3 \
    /lib/x86_64-linux-gnu/libdl.so.2 \
    /lib/x86_64-linux-gnu/libexpat.so.1 \
    /lib/x86_64-linux-gnu/libgcc_s.so.1 \
    /lib/x86_64-linux-gnu/libgcrypt.so.20 \
    /lib/x86_64-linux-gnu/libgpg-error.so.0 \
    /lib/x86_64-linux-gnu/liblzma.so.5 \
    /lib/x86_64-linux-gnu/libm.so.6 \
    /lib/x86_64-linux-gnu/libmount.so.1 \
    /lib/x86_64-linux-gnu/libpcre.so.3 \
    /lib/x86_64-linux-gnu/libpthread.so.0 \
    /lib/x86_64-linux-gnu/libresolv.so.2 \
    /lib/x86_64-linux-gnu/librt.so.1 \
    /lib/x86_64-linux-gnu/libselinux.so.1 \
    /lib/x86_64-linux-gnu/libsystemd.so.0 \
    /lib/x86_64-linux-gnu/libuuid.so.1 \
    /lib/x86_64-linux-gnu/libz.so.1 \
    /opt/intel/openvino/deployment_tools/inference_engine/external/tbb/lib/libtbb.so.2 \
    /opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libinference_engine.so \
    /opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libinference_engine_legacy.so \
    /opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libinference_engine_transformations.so \
    /opt/intel/openvino/deployment_tools/ngraph/lib/libngraph.so \
    /opt/intel/openvino/opencv/lib/libopencv_core.so.4.3 \
    /opt/intel/openvino/opencv/lib/libopencv_highgui.so.4.3 \
    /opt/intel/openvino/opencv/lib/libopencv_imgcodecs.so.4.3 \
    /opt/intel/openvino/opencv/lib/libopencv_imgproc.so.4.3 \
    /opt/intel/openvino/opencv/lib/libopencv_videoio.so.4.3 \
    /usr/lib/x86_64-linux-gnu/libX11.so.6 \
    /usr/lib/x86_64-linux-gnu/libXau.so.6 \
    /usr/lib/x86_64-linux-gnu/libXcomposite.so.1 \
    /usr/lib/x86_64-linux-gnu/libXcursor.so.1 \
    /usr/lib/x86_64-linux-gnu/libXdamage.so.1 \
    /usr/lib/x86_64-linux-gnu/libXdmcp.so.6 \
    /usr/lib/x86_64-linux-gnu/libXext.so.6 \
    /usr/lib/x86_64-linux-gnu/libXfixes.so.3 \
    /usr/lib/x86_64-linux-gnu/libXi.so.6 \
    /usr/lib/x86_64-linux-gnu/libXinerama.so.1 \
    /usr/lib/x86_64-linux-gnu/libXrandr.so.2 \
    /usr/lib/x86_64-linux-gnu/libXrender.so.1 \
    /usr/lib/x86_64-linux-gnu/libatk-1.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libatk-bridge-2.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libatspi.so.0 \
    /usr/lib/x86_64-linux-gnu/libcairo-gobject.so.2 \
    /usr/lib/x86_64-linux-gnu/libcairo.so.2 \
    /usr/lib/x86_64-linux-gnu/libdatrie.so.1 \
    /usr/lib/x86_64-linux-gnu/libepoxy.so.0 \
    /usr/lib/x86_64-linux-gnu/libffi.so.6 \
    /usr/lib/x86_64-linux-gnu/libfontconfig.so.1 \
    /usr/lib/x86_64-linux-gnu/libfreetype.so.6 \
    /usr/lib/x86_64-linux-gnu/libgdk-3.so.0 \
    /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so.0  \
    /usr/lib/x86_64-linux-gnu/libgio-2.0.so.0  \
    /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0  \
    /usr/lib/x86_64-linux-gnu/libgmodule-2.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libgraphite2.so.3 \
    /usr/lib/x86_64-linux-gnu/libgtk-3.so.0 \
    /usr/lib/x86_64-linux-gnu/libharfbuzz.so.0 \
    /usr/lib/x86_64-linux-gnu/liblz4.so.1 \
    /usr/lib/x86_64-linux-gnu/libpango-1.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libpangoft2-1.0.so.0 \
    /usr/lib/x86_64-linux-gnu/libpixman-1.so.0 \
    /usr/lib/x86_64-linux-gnu/libpng16.so.16 \
    /usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
    /usr/lib/x86_64-linux-gnu/libthai.so.0 \
    /usr/lib/x86_64-linux-gnu/libwayland-client.so.0 \
    /usr/lib/x86_64-linux-gnu/libwayland-cursor.so.0 \
    /usr/lib/x86_64-linux-gnu/libwayland-egl.so.1 \
    /usr/lib/x86_64-linux-gnu/libxcb-render.so.0 \
    /usr/lib/x86_64-linux-gnu/libxcb-shm.so.0 \
    /usr/lib/x86_64-linux-gnu/libxcb.so.1 \
    /usr/lib/x86_64-linux-gnu/libxkbcommon.so.0 \
    /home/openvino/inference_engine_demos_build/intel64/Release/lib/

HEALTHCHECK --interval=5m --timeout=3s CMD true || exit 1

RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY ./run.sh /home/openvino/run.sh

USER openvino

CMD ["/home/openvino/run.sh"]
