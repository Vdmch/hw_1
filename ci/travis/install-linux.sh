sudo apt-get update -y


sudo apt-get install build-essential
sudo apt-get install cmake libgtest-dev
cd /usr/src/gtest
sudo cmake CMakeLists.txt
sudo make
sudo cp *.a /usr/lib

sudo apt-get install clang-tools
sudo apt-get install valgrind
sudo apt-get install cppcheck

sudo pip install scan-build
sudo pip install cpplint
sudo pip install gcovr
