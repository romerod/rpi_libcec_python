FROM hypriot/rpi-alpine-scratch:v3.2

COPY Patch-CheckPlatformSupport-for-RPI.patch /tmp/Patch-CheckPlatformSupport-for-RPI.patch

RUN sed -i -e 's/v3\.2/v3.3/g' /etc/apk/repositories && \ 
    cat /etc/apk/repositories && \
    apk update && \
    apk upgrade --available && \
    apk add bash && \
    apk add python-dev && \
    apk add py-pip && \
    apk add raspberrypi && \
    apk add raspberrypi-libs && \
    apk add eudev && \
    apk add libuv && \
    apk add libxrandr && \
    apk add bzip2 && \
    apk add liblockfile && \
    apk add libstdc++ && \
    apk add --virtual build-dependencies gcc eudev-dev cmake liblockfile-dev libuv-dev libxrandr-dev swig git build-base bzip2-dev raspberrypi-dev && \
    rm -rf /var/cache/apk/* && \
    cd && \
    git clone https://github.com/Pulse-Eight/platform.git && \
    cd platform && \
    git checkout tags/p8-platform-2.0.1 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd && \
    git clone https://github.com/Pulse-Eight/libcec.git && \
    cd libcec && \
    git checkout tags/libcec-3.1.0 && \
    git apply /tmp/Patch-CheckPlatformSupport-for-RPI.patch && \
    mkdir build && \
    cd build && \
    # export LD_LIBRARY_PATH=/opt/vc/lib:${LD_LIBRARY_PATH} && \
    ln -sf /opt/vc/lib/libbcm_host.so /lib/libbcm_host.so && \
    ln -sf /opt/vc/lib/libvchiq_arm.so /lib/libvchiq_arm.so && \
    ln -sf /opt/vc/lib/libvcos.so /lib/libvcos.so && \
    cmake -DRPI_INCLUDE_DIR=/opt/vc/include -DRPI_LIB_DIR=/opt/vc/lib .. && \
    make -j4 && \
    make install && \
    apk del build-dependencies && \
    cd && \
    rm -rf platform && \
    rm -rf libcec

CMD ["/bin/bash"]
