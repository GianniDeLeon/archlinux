#!/bin/bash
#cargando el idioma del teclado
loadkeys us
#Formateando las particiones
#boot
mkfs -t ext2 /dev/sda1
#root
mkfs -t ext4 /dev/sda2
#home
mkfs -t ext4 /dev/sda2
#swap
mkswap /dev/sda4
#activando swap
swapon /dev/sda4
#montando particiones
#raiz
mount /dev/sda2 /mnt
#creanod los directorios
mkdir /mnt/boot
mkdir /mnt/home
#montando las particiones faltantes
mount /dev/sda1 /mnt/boot
mount /dev/sda3 /mnt/home
#activando wifi
wifi-menu
#prueba de conexion
ping -c 3 www.google.com
#Borramos y copiamos la mirrorlist
rm /etc/pacman.d/mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist
#instalando el sistema
pacstrap /mnt base base-devel grub-bios networkmanager xf86-input-synaptics
#Etiquetas para discos SSD NODIRATIME y NOATIME
#generando fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
#enrando en subsistema Chroot
arch-chroot /mnt
#Colcoando el nombre al equipo
echo "Dell-XPS-13" >> /etc/hostname
#esableciendo horario Guatemala
ln -srf /usr/share/zoneinfo/America/Guatemala /etc/localtime
#configurando locacion
echo "LANG=es_GT.UTF-8" >> /etc/locale.conf
#activando localizacion
echo -e "es_GT.UTF-8 UTF-8/nes_GT ISO-8859-1" >> /etc/locale.gen
#generando localizacion
locale-gen
#estableciendo distribucion de nuestro teclado
echo "KEYMAP=us" >> /etc/vconsole.conf
#instalamos el grub en el disco de arranque
grub-install /dev/sda
#creamos el archivo de grub .cfg
grub-mkconfig -o /boot/grub/grub.cfg
#creamos el ramdisk
mkinitcpio -p linux
#establecemos contraseña
passwd
#Salimos de chroot
exit
#desmontamos las particiones
umount /mnt/{boot,home,}
#reiniciamos el sistema
reboot