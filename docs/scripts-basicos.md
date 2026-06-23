 Scripts basicos y necesarios

1. `compile_kernel.sh`
2. `bootstrap_base.sh`
3. `build_image.sh`
4. `run_qemu.sh`

# Orden de ejecución  
para replicar borrerOS hay que ejecutar: 
1. `./kernel/compile_kernel.sh` 
2. `sudo ./scripts/bootstrap_base.sh + sudo chroot rootfs passwd root`
3. `sudo ./scripts/build_image.sh`
4. `./run_qemu.sh`

## Compile kernel 



