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

RUN wget 'https://downloads.sourceforge.net/project/plantuml/1.2022.6/plantuml.1.2022.6.jar'

ENTRYPOINT [ "java", "-jar", "/workspace/plantuml.1.2022.6.jar", "-progress" ]
CMD [ "/assets" ]
