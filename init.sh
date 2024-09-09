#!/bin/bash

# Exit script on error
set -e

# Add custom environment variables to .bashrc
echo 'export CXXFLAGS="-fPIC"' >> ~/.bashrc
echo 'export CFLAGS="-fPIC"' >> ~/.bashrc
echo "export NCURSES_HOME=\$HOME/ncurses" >> ~/.bashrc
echo 'export PATH=$NCURSES_HOME/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$NCURSES_HOME/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export CPPFLAGS="-I$NCURSES_HOME/include" LDFLAGS="-L$NCURSES_HOME/lib"' >> ~/.bashrc

# Source .bashrc to update current session
source ~/.bashrc

# Create directories, download, and install ncurses
mkdir -p ~/tools/ncurses && cd ~/tools/ncurses
wget https://mirrors.tuna.tsinghua.edu.cn/gnu/ncurses/ncurses-6.5.tar.gz
tar -xzvf ncurses-6.5.tar.gz
cd ncurses-6.5
./configure --prefix="$HOME/ncurses" --with-shared --with-termlib --without-debug --enable-widec --with-versioned-syms
make && make install

# Create directories, download, and install zsh
mkdir -p ~/tools/zsh-5.9 && cd ~/tools/zsh-5.9
wget -O zsh.tar.xz https://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.9.tar.xz
xz -d zsh.tar.xz && tar -xvf zsh.tar
cd zsh-5.9
./configure --prefix=$HOME/tools/zsh-5.9
make && make install

# Add zsh to PATH in .bashrc
echo 'export PATH=$HOME/tools/zsh-5.9/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install oh-my-zsh
# sh -c "$(wget -O- https://gh-proxy.com/https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/tools
wget https://gh-proxy.com/https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sed -i 's|https://github.com|https://gh-proxy.com/https://github.com|g' install.sh
sed -i 's|https://raw.githubusercontent.com|https://gh-proxy.com/https://raw.githubusercontent.com|g' install.sh
chmod +x install.sh
./install.sh
rm install.sh

# Install zsh plugins
git clone https://gh-proxy.com/https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://gh-proxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/wting/autojump.git ~/tools/autojump
cd ~/tools/autojump && ./install.py

# Update .zshrc to include plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump)/g' ~/.zshrc

# p10k
git clone --depth=1 https://gh-proxy.com/https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Add custom environment variables to .zshrc
echo 'export CXXFLAGS="-fPIC"' >> ~/.zshrc
echo 'export CFLAGS="-fPIC"' >> ~/.zshrc
echo "export NCURSES_HOME=\$HOME/ncurses" >> ~/.zshrc
echo 'export PATH=$NCURSES_HOME/bin:$PATH' >> ~/.zshrc
echo 'export LD_LIBRARY_PATH=$NCURSES_HOME/lib:$LD_LIBRARY_PATH' >> ~/.zshrc
echo 'export CPPFLAGS="-I$NCURSES_HOME/include" LDFLAGS="-L$NCURSES_HOME/lib"' >> ~/.zshrc

# Source .zshrc to update current session
source ~/.zshrc

# conda
cd ~/tools
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b

~/miniconda3/bin/conda init zsh
~/miniconda3/bin/conda init bash

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/

conda config --set show_channel_urls yes

conda clean -i

# no cmake on A100 server, please uncomment below to install cmake
# cmake
# wget https://gh-proxy.com/https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3.tar.gz
# tar -xzvf cmake-3.30.3.tar.gz
# cd cmake-3.30.3
# ./bootstrap --prefix=$HOME/tools/cmake
# make && make install
# echo 'export PATH=$HOME/tools/cmake/bin:$PATH' >> ~/.zshrc
# source ~/.zshrc

# install nvtop
# cd ~/tools
# git clone https://gh-proxy.com/https://github.com/Syllo/nvtop.git
# cd nvtop
# git checkout 3.0.2
# mkdir build
# cd build
# cmake .. -DNVIDIA_SUPPORT=ON -DAMDGPU_SUPPORT=OFF -DINTEL_SUPPORT=OFF -DMSM_SUPPORT=OFF \
# 		-DCMAKE_C_FLAGS="-I$HOME/ncurses/include/ncursesw" \
# 		-DCURSES_LIBRARY=$HOME/ncurses/lib/libncursesw.a \
#       -DCURSES_INCLUDE_PATH=$HOME/ncurses/include \
#       -DCMAKE_EXE_LINKER_FLAGS="-L$HOME/ncurses/lib -lncursesw -ltinfow"
# make && make DESTDIR=~/nvtop install
# echo 'export PATH=$HOME/nvtop/usr/local/bin:$PATH' >> ~/.zshrc
# source ~/.zshrc

# for htop
# echo "export LD_PRELOAD=$NCURSES_HOME/lib/libtinfow.so.6" >> ~/.zshrc
# source ~/.zshrc

# other useful scripts
# conda create -n exp python=3.11
# conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia # note cuda driver version
# pip install accelerate transformers dataset gitpython tensorboardX datasets tensorboard scikit-learn evaluate matplotlib seaborn
