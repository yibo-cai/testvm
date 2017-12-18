#!/bin/bash

IP=192.168.122.249
boot_timeout=60
check_timeout=90
rounds=50

function wait_vm_boot()
{
    echo "Waiting VM boots by ping $IP"
    i=1
    while [ $i -le $boot_timeout ]; do
        ping $IP -c1 -W1 > /dev/null 2>&1
        [ $? == 0 ] && { echo OK; return; } || printf x
        i=$((i+1))
    done
    echo "VM boot timeout!"
    exit 1
}

function check_vm()
{
    echo "Checking VM by ping $IP"
    i=1
    e=0
    while [ $i -le $check_timeout ]; do
        ping $IP -c1 -W1 > /dev/null 2>&1
        [ $? != 0 ] && { e=$((e+1)); printf x; } || { e=0; printf .; sleep 1; }
        [ $e -eq 10 ] && { echo -e "\nVM dead?"; exit 2; }
        i=$((i+1))
    done
    echo "OK"
}

function reboot_vm()
{
    echo "Rebooting VM"
    nc $IP 4444 # VM runs "nc -lvp 4444 -e /sbin/reboot"
    [ $? != 0 ] && { echo "FAILED"; exit 3; }
    i=0
    while [ $i -lt 8 ]; do
        printf .
        sleep 1
        i=$((i+1))
    done
    echo "OK"
}

loop=1
while [ $loop -le $rounds ]; do
    echo "==================== Round#$loop ===================="
    wait_vm_boot
    check_vm
    reboot_vm
    loop=$((loop+1))
done

echo "========================= DONE ========================="
