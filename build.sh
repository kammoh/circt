#!/bin/bash
set -e

[ -z $CIRCT_ROOT ] && CIRCT_ROOT=$PWD
echo CIRCT_ROOT=$CIRCT_ROOT

[ -z $INSTALL_PREFIX ] && INSTALL_PREFIX=$CIRCT_ROOT/inst
mkdir -p $CIRCT_ROOT/inst
LLVM_ROOT=$CIRCT_ROOT/llvm

LLVM_BUILD_DIR=$CIRCT_ROOT/llvm/build

BUILD_STAGE=install

if [ "$BUILD_LLVM" != "0" ]
then
echo "Building LLVM"
cmake -B $LLVM_BUILD_DIR -G Ninja $LLVM_ROOT/llvm \
    -DLLVM_ENABLE_PROJECTS="mlir" \
    -DLLVM_TARGETS_TO_BUILD="host" \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_ENABLE_IDE=ON \
    -DLLVM_ENABLE_LTO=OFF \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX
cmake --build $LLVM_BUILD_DIR --target $BUILD_STAGE
fi

CIRCT_BUILD_DIR=$CIRCT_ROOT/build
# cd $CIRCT_ROOT

cmake -B $CIRCT_BUILD_DIR -G Ninja $CIRCT_ROOT \
    -DCIRCT_BUILD_TOOLS=ON \
    -DCIRCT_ENABLE_FRONTENDS=ON \
    -DCIRCT_INCLUDE_TOOLS=ON \
    -DCIRCT_RELEASE_TAG=main \
    -DCIRCT_SLANG_FRONTEND_ENABLED=OFF \
    -DCIRCT_RELEASE_TAG_ENABLED=ON \
    -DCIRCT_BINDINGS_PYTHON_ENABLED=OFF \
    -DMLIR_DIR=$LLVM_BUILD_DIR/lib/cmake/mlir \
    -DLLVM_DIR=$LLVM_BUILD_DIR/lib/cmake/llvm \
    -DLLVM_ENABLE_ASSERTIONS=OFF \
    -DLLVM_ENABLE_LTO=OFF \
    -DLLVM_ENABLE_IDE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX

cmake --build $CIRCT_BUILD_DIR --target $BUILD_STAGE


