# Used to build the `plantuml` image to easily build local PlantUML diagrams.
# The `plantuml` shell alias depends on this image.
# To rebuild, run from this directory:
#     docker build -f plantuml.Dockerfile -t plantuml .

FROM amazoncorretto:latest

WORKDIR /workspace

RUN yum update -y && \
    yum install -y graphviz fonts-noto-cjk wget && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV GRAPHVIZ_DOT=/usr/bin/dot

RUN wget 'https://github.com/plantuml/plantuml/releases/download/v1.2023.12/plantuml.jar'

ENTRYPOINT [ "java", "-jar", "/workspace/plantuml.jar", "-progress" ]
CMD [ "/assets" ]
