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
wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.5.tar.gz
tar -xzvf ncurses-6.5.tar.gz
cd ncurses-6.5
./configure --prefix="$HOME/ncurses" --with-shared --without-debug --enable-widec
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

# Source .bashrc to update current session
source ~/.bashrc

# Install oh-my-zsh
sh -c "$(wget -O- https://gh-proxy.com/https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
git clone https://gh-proxy.com/https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://gh-proxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Update .zshrc to include plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

# Source .zshrc to update current session
source ~/.zshrc