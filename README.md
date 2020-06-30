# openvino-docker

> Intel® OpenVINO™ Toolkit environment.

This repository provides a base development and runtime environment to run inference models with OpenVINO.

## Building the Docker Image

```sh
docker-compose build
```

The following images should be present:

```sh

REPOSITORY          TAG                 IMAGE ID            CREATED                  SIZE
sampleapp-runtime   latest              b971577f2ebc        Less than a second ago   308MB
sampleapp-dev       latest              597daf163f04        6 seconds ago            2.78GB
openvino-runtime    latest              76d99d3603d1        2 minutes ago            195MB
openvino-dev        latest              01e98e0da9f1        2 minutes ago            2.55GB
ubuntu              18.04               ccc6e87d482b        2 weeks ago              64.2MB
```

* `ubuntu:18.04` is the base image for the development and runtime images
* `openvino-dev:latest` is the development OpenVINO image. Contains the OpenVINO SDK, as well as usefull tools like the
  [Model Optimizer](https://docs.openvinotoolkit.org/latest/_docs_MO_DG_Deep_Learning_Model_Optimizer_DevGuide.html) and
  [Deployment Manager](https://docs.openvinotoolkit.org/latest/_docs_install_guides_deployment_manager_tool.html)
* `openvino-runtime:latest` is the runtime OpenVINO image. It contains the minimal dependencies to run OpenVINO
  applications.
* `sampleapp-dev:latest` is the sample OpenVINO application development image. It contains application build
  dependencies and compiled binaries.
* `sampleapp-runtime:latest` is the sample OpenVINO application runtime image. It contains the application runtime
  dependencies and release binaries

## Using the image

### Run the sample OpenVINO application

You can directly run the sample OpenVINO application:

To run a container based on this image:

```sh
docker-compose run --rm sampleapp-runtime:latest /home/openvino/run.sh
```

The inference output should be visible in the terminal:

```sh
[setupvars.sh] OpenVINO environment initialized
+ /root/inference_engine_samples_build/intel64/Release/classification_sample_async -d CPU -i /opt/intel/openvino_2019.3.376/deployment_tools/demo/car.png -m /root/openvino_models/ir/public/squeezenet1.1/FP16/squeezenet1.1.xml
[ INFO ] InferenceEngine: 
    API version ............ 2.1
    Build .................. custom_releases/2019/R3_ac8584cb714a697a12f1f30b7a3b78a5b9ac5e05
    Description ....... API

[ INFO ] Parsing input parameters
[ INFO ] Parsing input parameters
[ INFO ] Files were added: 1
[ INFO ]     /opt/intel/openvino_2019.3.376/deployment_tools/demo/car.png
[ INFO ] Creating Inference Engine
    CPU
    MKLDNNPlugin version ......... 2.1
    Build ........... 32974

[ INFO ] Loading network files
[ INFO ] Preparing input blobs
[ WARNING ] Image is resized from (787, 259) to (227, 227)
[ INFO ] Batch size is 1
[ INFO ] Loading model to the device
[ INFO ] Create infer request
[ INFO ] Start inference (10 asynchronous executions)
[ INFO ] Completed 1 async request execution
[ INFO ] Completed 2 async request execution
[ INFO ] Completed 3 async request execution
[ INFO ] Completed 4 async request execution
[ INFO ] Completed 5 async request execution
[ INFO ] Completed 6 async request execution
[ INFO ] Completed 7 async request execution
[ INFO ] Completed 8 async request execution
[ INFO ] Completed 9 async request execution
[ INFO ] Completed 10 async request execution
[ INFO ] Processing output blobs

Top 10 results:

Image /opt/intel/openvino_2019.3.376/deployment_tools/demo/car.png

classid probability label
------- ----------- -----
817     0.6853039   sports car, sport car
479     0.1835192   car wheel
511     0.0917195   convertible
436     0.0200692   beach wagon, station wagon, wagon, estate car, beach waggon, station waggon, waggon
751     0.0069603   racer, race car, racing car
656     0.0044177   minivan
717     0.0024739   pickup, pickup truck
581     0.0017788   grille, radiator grille
468     0.0013083   cab, hack, taxi, taxicab
661     0.0007443   Model T

[ INFO ] Execution successful
[ INFO ] This sample is an API example, for any performance measurements please use the dedicated benchmark_app tool
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

```bash
docker update --cpu-shares 1024 --memory 100m  --memory-swap 100m  --pids-limit 1024 sampleapp-runtime
```
