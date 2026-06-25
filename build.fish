#!/usr/bin/env fish

# argv[1] -> any -> only pack

set -g NAME "Protium"
set -g DEFCONFIG "moonstone_defconfig"
set -g AK3 $HOME/AnyKernel3
set -g CLANG_DIR $HOME/Clang
set -g OUTD out/arch/arm64/boot

set -g KSU_REPO "Baka-SU/BakaSU"
set -g KSU_BRANCH "main"

function build
fish_add_path -g $CLANG_DIR/bin
echo $PATH

curl https://raw.githubusercontent.com/$KSU_REPO/refs/heads/$KSU_BRANCH/kernel/setup.sh | bash -s $KSU_BRANCH
git -C KernelSU/ reset --hard origin/$KSU_BRANCH
git -C KernelSU/ stash pop

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
set -a args KBUILD_BUILD_VERSION=1
set -a args KBUILD_BUILD_TIMESTAMP="Thu Jan 1 00:00:00 UTC 1970"

make $DEFCONFIG $args

make -j (nproc --all) $args || exit

ccache -s
end # build

function pack
cp $OUTD/Image $AK3/
cp $OUTD/dtb.img $AK3/dtb
cp $OUTD/dtbo.img $AK3/dtbo

cd $AK3 && zip -x "*.zip" -r9 $NAME-(date -u +"%Y%m%d-%H%M").zip * && cd -
end # pack

if test $argv[1]
	pack
else
	build
	pack
end

# EOF
