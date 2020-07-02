# openvino-docker

> Intel® OpenVINO™ Toolkit environment.

This repository provides a base development and runtime environment to run inference models with OpenVINO.

## Building the Docker Image

```sh
docker-compose build
```

The following images should be present:

```sh
TORY              TAG                 IMAGE ID            CREATED             SIZE
sampleapp-runtime       latest              6cbf5648c776        5 minutes ago       374MB
sampleapp-dev           latest              7847ff3e7322        5 minutes ago       5.3GB
openvino-runtime        latest              91fae2abce05        20 minutes ago      275MB
openvino-dev            latest              86f0d5e563f8        38 minutes ago      5.05GB
ubuntu                  18.04               8e4ce0a6ce69        2 weeks ago         64.2MB
openvino/ubuntu18_dev   2020.2              bf7a4dff2d97        2 months ago        5GB
```

* `ubuntu:18.04` is the base image for the runtime images.
* `openvino/ubuntu18_dev:2020.2` is the base image for the development images.
* `openvino-dev:latest` is the development OpenVINO image. Contains the OpenVINO SDK, as well as usefull tools like the
  [Model Optimizer](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_Deep_Learning_Model_Optimizer_DevGuide.html) and
  [Deployment Manager](https://docs.openvinotoolkit.org/latest/_docs_install_guides_deployment_manager_tool.html).
* `openvino-runtime:latest` is the runtime OpenVINO image. It contains the minimal dependencies to run OpenVINO
  applications.
* `sampleapp-dev:latest` is the sample OpenVINO application development image. It contains application build
  dependencies and compiled binaries.
* `sampleapp-runtime:latest` is the sample OpenVINO application runtime image. It contains the application runtime
  dependencies and release binaries.

## Using the image

### Run the sample OpenVINO application

You can directly run the sample OpenVINO application:

To run a container based on this image:

```sh
docker-compose run --rm sampleapp-runtime
```

The inference output should be visible in the terminal:

```sh
[setupvars.sh] OpenVINO environment initialized
[ INFO ] InferenceEngine: 0x7f72c75bd030
[ INFO ] Files were added: 1
[ INFO ]     /opt/intel/openvino/deployment_tools/demo/car_1.bmp
[ INFO ] Loading device CPU
        CPU
        MKLDNNPlugin version ......... 2.1
        Build ........... 42025

[ INFO ] Loading detection model to the CPU plugin
[ INFO ] Loading Vehicle Attribs model to the CPU plugin
[ INFO ] Loading Licence Plate Recognition (LPR) model to the CPU plugin
[ INFO ] Number of InferRequests: 1 (detection), 3 (classification), 3 (recognition)
[ INFO ] 4 streams for CPU
[ INFO ] Display resolution: 1920x1080
[ INFO ] Number of allocated frames: 3
[ INFO ] Resizable input with support of ROI crop and auto resize is disabled
[0,1] element, prob = 1    (232,119)-(277,347)
[2,2] element, prob = 0.943026    (330,410)-(63,26)
Vehicle Attributes results:black;car
License Plate Recognition results:<Hebei>MD711
36.6FPS for (1 / 1) frames
Detection InferRequests usage: 0.0%

[ INFO ] Execution successful
```

### Use the image in another container

You can use this Docker image as a base image and use it in multiple Dockerfiles. Use multi-stage build and the
`openvino-dev` and `openvino-runtime` image in your dockerfile:

```dockerfile
## Development Build 
FROM openvino-dev:latest as myapp-dev

RUN <Application Build Steps>

## Runtime Build
FROM openvino-runtime:latest as myapp-dev

COPY --from=myapp-dev <Application Executables>

CMD ["/myapp"]
```

An example of this process is present in the `sample-app` folder

## Limits

Define CPU, memory, and PID limits for the sampleapp-runtime service

```bash
docker-compose up -d sampleapp-runtime
docker update --cpu-shares 1024 --memory 200m --memory-swap 200m --pids-limit 1024 sampleapp-runtime
```
