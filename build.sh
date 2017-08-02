#!/bin/bash
mkdir -p $HOME/bin
mkdir -p $HOME/omni
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > $HOME/bin/repo && chmod a+x $HOME/bin/repo
export CCACHE_DIR=$HOME/.ccache
export USE_CCACHE=1
export TO_OR=$(nproc --all)
export PATH=$PATH:$HOME/omni/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin
export PATH=$PATH:$HOME/omni/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin
# Resize the Java Heap size
export _JAVA_OPTIONS="-Xmx4096m"
 
# Resize the Jack Heap size
export ANDROID_JACK_VM_ARGS="-Xmx4096m -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
cd $HOME/omni
mkdir -p .repo/local_manifests
curl https://gist.githubusercontent.com/FacuM/bd9873e76d40969a77f2414d7a44f9de/raw/7eee62e22900dca55d67e0cabee1004a44c61bdb/local_manifest.xml > .repo/local_manifests/local_manifest.xml
repo init -u git://github.com/omnirom/android.git -b android-7.1
repo sync -j$(nproc --all)
. build/envsetup.sh
#make clean && make clobber
brunch harpia
cd out/target/product/harpia
sshpass -p $PASSWORD scp omni-7.1.2* $USER@uploads.androidfilehost.com:/
cd $HOME
rm -Rf omni