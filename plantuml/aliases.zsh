alias plantuml="docker run -v $(pwd)/doc/design/:/assets plantuml"
alias plantuml-server="docker run -d -p 3124:8080 plantuml/plantuml-server:jetty"
