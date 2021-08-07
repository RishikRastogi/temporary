# sync rom
repo init --depth=1 --no-repo-verify -u git://github.com/lighthouse-os/manifest.git -b raft -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/Stealth1226/local_manifest --depth 1 -b raft-j7 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build rom
source build/envsetup.sh
lunch lighthouse_on7xelte-userdebug
export SKIP_ABI_CHECKS=true
export TZ=Asia/Dhaka #put before last build command
mka lighthouse

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
