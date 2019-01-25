#!/usr/bin/env bash



if ! [ -f "$HOME/cache/${SONAR_ANALYSER_TOOL_ZIP}" ]; then
  echo "Downloading Sonar analyzer tool ..."
  wget $SONAR_ANALYSER_TOOL_URL -O "$HOME/cache/$SONAR_ANALYSER_TOOL_ZIP"
else
  echo "Sonar analyzer tool zip already exists in the cache; skipping download."
fi

if ! [ -f "$HOME/cache/${SONAR_BUILD_TOOL_ZIP}" ]; then
  echo "Downloading Sonar build wrapper tool ..."
  wget $SONAR_BUILD_TOOL_URL -O "$HOME/cache/$SONAR_BUILD_TOOL_ZIP"
else
  echo "Sonar build wrapper tool zip already exists in the cache; skipping download."
fi

if ! [ -d "$HOME/${SONAR_TOOLS_DIR}" ]; then
    mkdir "$HOME/${SONAR_TOOLS_DIR}"
    echo "Uncompressing sonar build wrapper tool archive into " $HOME/${SONAR_TOOLS_DIR}
    unzip $HOME/cache/${SONAR_BUILD_TOOL_ZIP} -d $HOME/${SONAR_TOOLS_DIR}

    echo "Uncompressing sonar analyzer tool archive into " $HOME/${SONAR_TOOLS_DIR}
    unzip $HOME/cache/${SONAR_ANALYSER_TOOL_ZIP} -d $HOME/${SONAR_TOOLS_DIR}
    if [ -f "$HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/sonar-scanner.properties" ]; then
        echo "Deleting existing conf file"
        rm $HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/sonar-scanner.properties
    fi
    echo "Copying conf file"
    cp ../sonar-scanner.properties $HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/

else
    echo "Sonar tools dir already exists; skipping uncompress step."
fi

echo "Cleaning before build ..."
make clean

echo "Running  build with sonar ..."
"$HOME/${SONAR_TOOLS_DIR}"/build-wrapper-linux-x86/build-wrapper-linux-x86-64 \
        --out-dir "${SONAR_BUILD_OUTPUT_DIR}" make all

# Execute some tests with coverage
make test

find $directory -type f -name "*.gcov"


if ! [ -f "$HOME/cache/${SONAR_ANALYSER_TOOL_ZIP}" ]; then
  echo "Downloading Sonar analyzer tool ..."
  wget $SONAR_ANALYSER_TOOL_URL -O "$HOME/cache/$SONAR_ANALYSER_TOOL_ZIP"
else
  echo "Sonar analyzer tool zip already exists in the cache; skipping download."
fi

echo "current folder"
echo $PWD

if ! [ -d "$HOME/${SONAR_TOOLS_DIR}" ]; then
    mkdir "$HOME/${SONAR_TOOLS_DIR}"

    echo "Uncompressing sonar analyzer tool archive into " $HOME/${SONAR_TOOLS_DIR}
    unzip $HOME/cache/${SONAR_ANALYSER_TOOL_ZIP} -d $HOME/${SONAR_TOOLS_DIR}
    if [ -f "$HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/sonar-scanner.properties" ]; then
        echo "Deleting existing conf file"
        rm $HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/sonar-scanner.properties
    fi
    echo "Copying conf file"
    echo "current folder"
    echo $PWD
    cp ../sonar-scanner.properties $HOME/${SONAR_TOOLS_DIR}/sonar-scanner-3.2.0.1227-linux/conf/
else
    echo "Sonar tools dir already exists; skipping uncompress step."
fi



echo "Running Sonar Analysis"
"$HOME/${SONAR_TOOLS_DIR}"/sonar-scanner-3.2.0.1227-linux/bin/sonar-scanner -X

