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
    J_ARG="--win-menu --win-dir-chooser --win-shortcut --icon logo/icon.ico"
          
  elif [ "$OS" == "linux" ]; then
      J_ARG="--linux-shortcut --icon logo/logo-728.png"
  else
      J_ARG="--icon logo/icon.icns"
  fi

  APP_VERSION=0.1.0

  jpackage \
    --input target/jpackage-input \
    --dest target \
    --main-jar deathstar.standalone.jar \
    --name "deathstar" \
    --main-class clojure.main \
    --arguments -m \
    --arguments deathstar.main \
    --resource-dir logo \
    --java-options -Xmx2048m \
    --app-version ${APP_VERSION} \
    $J_ARG
  
}

"$@"