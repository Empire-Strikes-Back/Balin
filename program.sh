#!/bin/bash


install(){
  npm i --no-package-lock
}

copy(){
  mkdir -p out/jar/ui/
  mkdir -p out/jar/src/Balin/
  cp src/Balin/index.html out/jar/ui/index.html
  cp src/Balin/style.css out/jar/ui/style.css
  cp package.json out/jar/package.json
  cp out/identicon/icon.png out/jar/icon.png
}

shadow(){
  clj -A:shadow:main:ui -M -m shadow.cljs.devtools.cli "$@"
}

repl(){
  install
  copy
  shadow clj-repl
  # (shadow/watch :main)
  # (shadow/watch :ui)
  # (shadow/repl :main)
  # :repl/quit
}

identicon(){
  clojure \
    -X:Zazu Zazu.core/process \
    :word '"Balin"' \
    :filename '"out/identicon/icon.png"' \
    :size 256
}

compile(){
  shadow release :ui :main
}

out(){
  rm -rf out

  install
  identicon
  copy
}

jar(){
  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  echo Balin-$COMMIT_COUNT-$COMMIT_HASH.zip
  cd out/jar
  zip -r ../Balin-$COMMIT_COUNT-$COMMIT_HASH.zip ./ && \
  cd ../../
}

package(){

  convert out/identicon/icon.png -define icon:auto-resize=256,64,48,32,16 out/identicon/icon.ico
  png2icns out/identicon/icon.icns out/identicon/icon.png
  
  # rm -rf out/zip

  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  ln -s ../../node_modules out/jar/node_modules
  npx electron-packager out/jar \
    "Balin-$COMMIT_COUNT-$COMMIT_HASH" \
    --overwrite \
    --asar \
    --executable-name=Balin \
    --app-name=Balin \
    --build-version="$COMMIT_COUNT-$COMMIT_HASH" \
    --icon=out/identicon/icon.png \
    --out=out/zip \
    --platform=darwin,linux,win32 \
    --arch=x64
}

zip_files(){
  rm -rf out/zip/*.zip
  for dir in out/zip/*; do
    echo $dir
    cd $dir
    zip -qr ../../../$dir ./
    cd ../../../
  done
}

release(){
  out
  compile
  package
  zip_files
}

tag(){
  COMMIT_HASH=$(git rev-parse --short HEAD)
  COMMIT_COUNT=$(git rev-list --count HEAD)
  TAG="$COMMIT_COUNT-$COMMIT_HASH"
  git tag $TAG $COMMIT_HASH
  echo $COMMIT_HASH
  echo $TAG
}

"$@"