#!/bin/bash

repl(){
    clj -A:repl
}

main(){
  clojure -M:main
}


uberjar(){

  lein with-profiles +prod uberjar
  mkdir -p target/jpackage-input
  mv target/deathstar.standalone.jar target/jpackage-input/
  #  java -Dclojure.core.async.pool-size=1 -jar target/deathstar.standalone.jar
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