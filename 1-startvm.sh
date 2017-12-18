set -x

sudo virt-install --name __testvm888__ --disk ./testvm.qcow2 --memory 8192 --boot loader=/usr/share/AAVMF/AAVMF_CODE.fd,loader_ro=yes,loader_type=pflash,nvram=./testvm_VARS.fd --import
