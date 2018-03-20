#!/bin/bash
#iniciamos networkmanager
systemctl start NetworkManager.service
#activamos networkmanager
systemctl enable NetworkManager.service
#creamo el usuario
useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash mrrobot
#colocamos contrase;a al usuario
passwd mrrobot
#descomentamos la linea whell all all
nano /etc/sudoers
#conectamos a una red wifi
echo "Escriba el nombre de la red"
read ssid
echo "Escriba su contase;a"
read pass
nmcli dev wifi connect $ssid password $pass
#Borramos y copiamos la mirrorlist
rm /etc/pacman.d/mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist
rm /etc/pacman.conf
cp pacman.conf /etc/pacman.conf
#instalamos los paquetes necesarios
sudo pacman -S xorg-server xorg-xinit mesa mesa-demos xf86-video-intel xdg-user-dirs yaourt
#copiamos el archivo de configuracion del teclado
cp 10-keyboard.conf /etc/X11/xorg.conf.d/10-keyboard.conf
#generamos carpetas personales
xdg-user-dirs-update
#instalando kde
echo "Instalando PLASMA"
pacman -S  plasma plasma-wayland-session kde-applications kde-l10n-es