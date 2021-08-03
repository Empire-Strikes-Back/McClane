#!/bin/bash


repl(){
  clj \
    -X:repl deps-repl.core/process \
    :main-ns figwheel-calva-docker.main \
    :port 7788 \
    :host '"0.0.0.0"' \
    :repl? true \
    :nrepl? false
}

main(){
  clojure \
    -J-Dclojure.core.async.pool-size=1 \
    -J-Dclojure.compiler.direct-linking=false \
    -M -m figwheel-calva-docker.main
}


uberjar(){
  clojure \
    -X:uberjar hf.depstar/uberjar \
    :aot true \
    :jar out/figwheel-calva-docker.standalone.jar \
    :verbose false \
    :main-class figwheel-calva-docker.main
  mkdir -p out/jpackage-input
  mv out/figwheel-calva-docker.standalone.jar out/jpackage-input/
}

j-package(){
  OS=${1:?"Need OS type (windows/linux/mac)"}

  echo "Starting compilation..."

  if [ "$OS" == "windows" ]; then
    J_ARG="--win-menu --win-dir-chooser --win-shortcut"
          
  elif [ "$OS" == "linux" ]; then
      J_ARG="--linux-shortcut"
  else
      J_ARG=""
  fi

  jpackage \
    --input out/jpackage-input \
    --dest out \
    --main-jar figwheel-calva-docker.standalone.jar \
    --name "figwheel-calva-docker" \
    --main-class clojure.main \
    --arguments -m \
    --arguments figwheel-calva-docker.main \
    --app-version "1" \
    $J_ARG
  
}

"$@"