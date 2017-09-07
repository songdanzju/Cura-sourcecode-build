#the url to download the dependencies "sip" and "PyQt5" 
#https://riverbankcomputing.com/software/sip/download
#https://riverbankcomputing.com/software/pyqt/download5

# uninstall protoc 3.1.0, because protoc 3.2.0 is needed!
# !before any protobuf compile:
# sudo apt-get remove libprotobuf-dev
# cd cura_daniel/protobuf/
# make uninstall
# make clean
# rm -rf /usr/include/google/protobuf

cd /home/cyrus
mkdir cura_cyrus
cd cura_cyrus
#install qt5.8.0
/mnt/hgfs/Linux-Win/cura_dependence_packages/qt-opensource-linux-x64-5.8.0.run
cp /mnt/hgfs/Linux-Win/cura_dependence_packages/PyQt*.tar.gz .
cp /mnt/hgfs/Linux-Win/cura_dependence_packages/sip.tar.gz .
cp /mnt/hgfs/Linux-Win/cura_dependence_packages/cx_Freeze-5.0.tar.gz .
cp /mnt/hgfs/Linux-Win/cura_dependence_packages/cura_run.sh

# install the basic dependencies
sudo apt-get install -y git cmake cmake-gui autoconf libtool 
sudo apt-get install python3-setuptools curl python3-numpy python3-scipy 
#sudo apt-get install qml-module-qtquick-controls
sudo apt-get remove python3-pyqt5 python3-pyqt5.* python3-sip
sudo apt-get install libgl1-mesa-dev freeglut3-dev mesa-common-dev
sudo apt-get install python3-dev


##################### part1 ########################


# sip for pyqt5
tar -xvzf sip-4.19.2.tar.gz
cd sip-4.19.2
python3 configure.py -d /usr/lib/python3/dist-packages
make -j4
sudo make install
sudo make clean
cd..

tar -xvzf PyQt5_gpl-5.8.2.tar.gz
cd PyQt5_gpl-5.8.2
python3 configure.py --destdir /usr/lib/python3/dist-packages --qmake /home/cyrus/Qt5.8.0/5.8/gcc_64/bin/qmake
sudo make -j4
sudo make install
sudo make clean
cd ..



#git clone https://github.com/google/protobuf.git
#cd protobuf 
#git clone https://github.com/google/googlemock/archive/release-1.7.0.zip
#git clone https://github.com/google/googletest/archive/release-1.7.0.zip
tar -xvzf protobuf.tar.gz
unzip googlemock-release-1.7.0.zip
unzip googletest-release-1.7.0.zip
mv googlemock-release-1.7.0 protobuf/gmock
mv googletest-release-1.7.0 protobuf/gmock/gtest
cd protobuf
./autogen.sh
./configure --prefix=/usr
make -j4
sudo make install
sudo ldconfig
cd python
python3 setup.py build
sudo python3 setup.py install
cd ../..


sudo apt-get install libz-dev libffi-dev
tar -xvzf cx_Freeze-5.0.tar.gz
cd cx_Freeze-5.0
sudo python3 setup.py build
sudo python3 setup.py install
cd ..


########### check according to "Cura-build" #########
#git clone https://github.com/Ultimaker/cura-build.git
#cd cura-build
#mkdir build
#cd build
#cmake .. -DCMAKE_PREFIX_PATH=/usr/local/lib/cmake
###### dont do it  #########
#make
#make package
#####################################################




##################### part2 ########################
#git clone https://github.com/Ultimaker/libArcus
tar -xvzf libArcus.tar.gz
cd libArcus
mkdir build
cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DPYTHON_SITE_PACKAGES_DIR=/usr/lib/python3/dist-packages
cmake .. -DPYTHON_SITE_PACKAGES_DIR=/usr/lib/python3/dist-packages
make -j4
sudo make install
cd ../../



#git clone https://github.com/Ultimaker/CuraEngine.git
tar -xvzf CuraEngine.tar.gz
cd CuraEngine
mkdir build
cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=/usr
cmake ..
make -j4
sudo make install
cd ../../



#git clone https://github.com/Ultimaker/Uranium.git
tar -xvzf Uranium.tar.gz
cd Uranium
mkdir build
cd build
#cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DPYTHON_SITE_PACKAGES_DIR=/usr/lib/python3/dist-packages -DURANIUM_PLUGINS_DIR=/usr/lib/python3/dist-packages
cmake .. -DPYTHON_SITE_PACKAGES_DIR=/usr/lib/python3/dist-packages -DURANIUM_PLUGINS_DIR=/usr/lib/python3/dist-packages
sudo make install
cd ../..



#git clone https://github.com/Ultimaker/Cura.git
tar -xvzf Cura.tar.gz
cp -rv Uranium/resources/* Cura/resources/
cp -rv Uranium/plugins/* Cura/plugins/
sudo ln -s /home/cyrus/projects/cura_cyrus/CuraEngine/build/CuraEngine /usr/bin/CuraEngine
sudo ln -s /usr/local/lib/python3/dist-packages/UM/ /usr/lib/python3/dist-packages/UM


##################### just for check ##########################
#cd cura-build/build
#cmake .. -DCMAKE_PREFIX_PATH=/usr/local/lib/cmake
#cd ../..
#now you see all are well prepared
###### dont do it  #########
#make
#make package
###############################################################



######################## run Cura #############################

sudo ./cura_run.sh
#in which are as below:
#cd Cura
#export PYTHONPATH=/usr/lib/python3/dist-packages
#python3 cura_app.py
################################################################

##################### Configuring Cura #####################
# inserting the following line in home/cyrus/.config/cura/master/cura.cfg
sudo gedit home/cyrus/.config/cura/master/cura.cfg

# insert:
[backend]
location = /usr/bin/CuraEngine
############################################################


##################### to make image ###################################
#git clone -b appimagetool/master --single-branch --recursive https://github.com/probonopd/AppImageKit
#cd AppImageKit/
#sudo bash -ex install-build-deps.sh
#bash -ex build.sh
# using AppImage to make image
#######################################################################
