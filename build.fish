#!/usr/bin/env fish

# argv[1] -> zip name
# argv[2] -> any -> only pack

function build
set PREFIX $HOME
set CLANG "Clang"

set KSU_REPO "backslashxx/KernelSU"
set KSU_BRANCH "master"

#rm -rf out
#rm -rf error.log
#make O=out clean
#make mrproper

set CLANG_DIR $PREFIX/$CLANG
fish_add_path $CLANG_DIR/bin

echo $PATH

curl https://raw.githubusercontent.com/$KSU_REPO/refs/heads/$KSU_BRANCH/kernel/setup.sh | bash -s $KSU_BRANCH
git -C KernelSU/ reset --hard origin/$KSU_BRANCH

mkdir -p out

set args
set -a args ARCH=arm64
set -a args SUBARCH=arm64
set -a args O=out
set -a args CC="ccache clang"
set -a args AR="llvm-ar"
set -a args NM="llvm-nm"
set -a args LD="ld.lld -S"
set -a args OBJCOPY="llvm-objcopy"
set -a args OBJDUMP="llvm-objdump"
set -a args STRIP="llvm-strip"
set -a args CLANG_TRIPLE="aarch64-linux-gnu-"
set -a args CROSS_COMPILE="aarch64-linux-gnu-"
set -a args CROSS_COMPILE_ARM32="arm-linux-gnueabi-"
set -a args CROSS_COMPILE_COMPAT="arm-linux-gnueabi-"
set -a args LLVM=1
set -a args LLVM_IAS=1
set -a args INSTALL_MOD_STRIP=1
set -a args KBUILD_BUILD_USER=(git -C KernelSU/ rev-parse --short HEAD | string sub -l 7)
set -a args KBUILD_BUILD_HOST=(git rev-parse --short HEAD | string sub -l 7)

make moonstone_defconfig $args

make -j (nproc --all) $args

ccache -s
end # build

function pack
set OUTD out/arch/arm64/boot
set AK3 $HOME/AnyKernel3
cp $OUTD/Image $AK3/
cp $OUTD/dtb.img $AK3/dtb
cp $OUTD/dtbo.img $AK3/dtbo

if test $argv[1]
	cd $AK3 && zip -x "*.zip" -r9 $argv[1]-(date -u +"%Y%m%d-%H%M").zip *
	cd -
end
end # pack

if test $argv[2]
	pack $argv
else
	build $argv
	pack $argv
end

# EOF
