# Build Kimera-VIO On ubuntu 16

The below provides installation tips on installing dependencies following
[wiki page](https://github.com/MIT-SPARK/Kimera-VIO/blob/master/docs/kimera_vio_install.md).

* gtsam
use gtsam Eigen is desired, because the system Eigen on ubuntu 16 may be outdated.

Install command example
```
git clone git@github.com:borglab/gtsam.git
cd gtsam
git checkout ee069286b447ff58b809423cc77c777a02abdfe5

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/persist/kimera_vio_noros/devel -DCMAKE_BUILD_TYPE=Release -DGTSAM_USE_SYSTEM_EIGEN=OFF -DGTSAM_POSE3_EXPMAP=ON -DGTSAM_ROT3_EXPMAP=ON ..
make -j $(nproc) install

```
* opencv
If ros has been installed, you do not need to install opencv. And building opencv from source is error prone esp. in low bandwidth network.


* opengv
Remember to use the eigen in the gtsam source. The installed gtsam does not include the unsupported module of Eigen.
```
git clone https://github.com/laurentkneip/opengv.git
cd opengv
mkdir build && cd build
# Replace path to your GTSAM's Eigen
cmake .. -DEIGEN_INCLUDE_DIR=/jhuai/baselines/gtsam/gtsam/3rdparty/Eigen -DEIGEN_INCLUDE_DIRS=/jhuai/baselines/gtsam/gtsam/3rdparty/Eigen -DCMAKE_INSTALL_PREFIX=/persist/kimera_vio_noros/devel
make -j $(nproc) install
```

* DBoW2

git clone https://github.com/dorian3d/DBoW2.git
cd DBoW2
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/persist/kimera_vio_noros/devel
make -j $(nproc) install

* Kimera-RPGO
```
git clone https://github.com/MIT-SPARK/Kimera-RPGO.git
cd Kimera-RPGO
mkdir build
cd build
cmake .. -DGTSAM_DIR=/persist/kimera_vio_noros/devel/lib/cmake/GTSAM
make -j $(nproc)
```

* Kimera-VIO
```
git clone git@github.com:MIT-SPARK/Kimera-VIO.git Kimera-VIO
cd Kimera-VIO
mkdir build
cd build
cmake .. -DGTSAM_DIR=/persist/kimera_vio_noros/devel/lib/cmake/GTSAM -DEIGEN_INCLUDE_DIR=/jhuai/baselines/gtsam/gtsam/3rdparty/Eigen -DEIGEN_INCLUDE_DIRS=/jhuai/baselines/gtsam/gtsam/3rdparty/Eigen -DCMAKE_INSTALL_PREFIX=/persist/kimera_vio_noros/devel -Dopengv_DIR=/persist/kimera_vio_noros/devel/lib/cmake/opengv-1.0 -DDBoW2_DIR=/persist/kimera_vio_noros/devel/lib/cmake/DBoW2

make -j $(nproc)
```

# Build kimera-VIO on ubuntu 18
In this case, gtsam may use system wide Eigen and this avoids passing EIGEN_INCLUDE_DIR as cmake arguments.

# Run experiments
You need to copy the data to a SSD drive, otherwise the slow HDD may cause spurious shutdown of the front end queue and then the whole pipeline.
example call
```
cd kimera-VIO/build

./stereoVIOEuroc --dataset_type=0 --dataset_path=/persist/kimera_vio_noros/MH_01_easy --initial_k=50 --final_k=-1 --params_folder_path=../params/Euroc --use_lcd=0 --vocabulary_path=../vocabulary/ORBvoc.yml --flagfile=../params/Euroc/flags/stereoVIOEuroc.flags --flagfile=../params/Euroc/flags/Mesher.flags --flagfile=../params/Euroc/flags/VioBackEnd.flags --flagfile=../params/Euroc/flags/RegularVioBackEnd.flags --flagfile=../params/Euroc/flags/Visualizer3D.flags --logtostderr=1 --colorlogtostderr=1 --log_prefix=1 --v=0 --vmodule=Pipeline=0 --log_output=0 --log_euroc_gt_data=0 --log_backend_output=1 --compute_state_covariance=1 --save_frontend_images=0 --visualize_frontend_images=1 --output_path=../output_logs


```

log_output=1 cause the pipeline to halt.
compute_state_covariance cause crash with 
terminate called after throwing an instance of 'gtsam::InconsistentEliminationRequested'
  what():  An inference algorithm was called with inconsistent arguments.  The
factor graph, ordering, or variable index were inconsistent with each
other, or a full elimination routine was called with an ordering that
does not include all of the variables.



# Log covariance
```
check computeStateCovariance and logBackendOutput
```

