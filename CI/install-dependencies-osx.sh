# Exit if something fails
set -e

# Echo all commands before executing
set -v

#git fetch --unshallow

# Leave obs-studio folder
cd ../

brew update

brew install jack speexdsp ccache swig mbedtls wget https://raw.githubusercontent.com/Homebrew/homebrew-core/8d4d48f0bb552b7b107119aeef59f141ce1f72c3/Formula/qt.rb &


# Install Packages app so we can build a package later
# http://s.sudre.free.fr/Software/Packages/about.html
wget --retry-connrefused --waitretry=1 https://s3-us-west-2.amazonaws.com/obs-nightly/Packages.pkg
sudo installer -pkg ./Packages.pkg -target /

#Base OBS Deps and ccache

export PATH=/usr/local/opt/ccache/libexec:$PATH
ccache -s || echo "CCache is not available."

# Fetch and untar prebuilt OBS deps that are compatible with older versions of OSX
wget --retry-connrefused --waitretry=1 https://s3-us-west-2.amazonaws.com/obs-nightly/osx-deps.tar.gz
tar -xf ./osx-deps.tar.gz -C /tmp

# Fetch libwebrtc 73 Community Edition
ifileid="1cmt4_-6RM9fr_xOVuGha4Wj7fthZf9OY"
filename="libWebRTC-73.0-x64-Rel-COMMUNITY-BETA.tar.gz"
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o ${filename}
tar -xf ./libWebRTC-73.0-x64-Rel-COMMUNITY-BETA.tar.gz -C /tmp

# Fetch vlc codebase
wget --retry-connrefused --waitretry=1 -O vlc-master.zip https://github.com/videolan/vlc/archive/master.zip
unzip -q ./vlc-master.zip

# Get sparkle
wget --retry-connrefused --waitretry=1 -O sparkle.tar.bz2 https://github.com/sparkle-project/Sparkle/releases/download/1.16.0/Sparkle-1.16.0.tar.bz2
mkdir ./sparkle
tar -xf ./sparkle.tar.bz2 -C ./sparkle
sudo cp -R ./sparkle/Sparkle.framework /Library/Frameworks/Sparkle.framework

