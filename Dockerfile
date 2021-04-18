## Dockerfile to make "docker-l4n"
## This file makes a container image of docker-lin4neuro with Japanese environment
## K. Nemoto 19 Apr 2021

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

## General
# Change default sh from Dash to Bash
#RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# XFCE
RUN apt-get update && \
    sed -i 's|http://us.|http://ja.|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-indicator-plugin \
    xfce4-power-manager-plugins lightdm lightdm-gtk-greeter         \
    shimmer-themes network-manager-gnome xinit build-essential      \
    dkms thunar-archive-plugin file-roller gawk fonts-noto          \
    xdg-utils 

# Python
RUN apt-get install -y pkg-config libopenblas-dev liblapack-dev    \
    libhdf5-serial-dev graphviz python3-venv python3-pip python3-dev  \
     python3-tk python-numpy

# Install utilities
RUN apt-get install -y at-spi2-core bc curl wget dc          \
    default-jre evince exfat-fuse exfat-utils gedit          \
    gnome-system-monitor gnome-system-tools                  \
    imagemagick rename ntp tree unzip vim git    \
    xfce4-screenshooter zip ntp tcsh xterm            \
    libopenblas-base apturl gnupg software-properties-common \
    unar firefox && \
    apt-get purge -y xscreensaver


# Japanese environment 
RUN apt-get install -y language-pack-ja manpages-ja \
    fcitx fcitx-mozc fcitx-config-gtk \
    nkf firefox-locale-ja im-config && update-locale LANG=ja_JP.UTF-8



##### Lin4Neuro #####
RUN mkdir /etc/skel/git && cd /etc/skel/git && \
    git clone https://gitlab.com/kytk/lin4neuro-bionic.git
ENV parts=/etc/skel/git/lin4neuro-bionic/lin4neuro-parts

# Icons and Applications
RUN mkdir -p /etc/skel/.local/share && \ 
    cp -r ${parts}/local/share/icons /etc/skel/.local/share/ && \
    cp -r ${parts}/local/share/applications /etc/skel/.local/share/

# Customized menu
RUN mkdir -p /etc/skel/.config/menus && \
    cp ${parts}/config/menus/xfce-applications.menu /etc/skel/.config/menus

# Neuroimaging.directory
RUN mkdir -p /etc/skel/.local/share/desktop-directories && \
    cp ${parts}/local/share/desktop-directories/Neuroimaging.directory \
       /etc/skel/.local/share/desktop-directories


# Background image and remove an unnecessary image file
RUN cp ${parts}/backgrounds/deep_ocean.png /usr/share/backgrounds 


# Customized panel, desktop, and theme
RUN cp -r ${parts}/config/xfce4 /etc/skel/.config

RUN echo "alias open='xdg-open &> /dev/null'" >> /etc/skel/.bash_aliases

# DCMTK
RUN apt-get install -y dcmtk

# Talairach Daemon
RUN cp -r ${parts}/tdaemon /usr/local && \
    echo '' >> /etc/skel/.bash_aliases && \
    echo '#tdaemon' >> /etc/skel/.bash_aliases && \
    echo "alias tdaemon='java -jar /usr/local/tdaemon/talairach.jar'" >> /etc/skel/.bash_aliases

# VirtualMRI
RUN cd /usr/local && \
    wget http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/vmri.zip && \
    unzip vmri.zip && rm vmri.zip

# Mango
RUN cd /usr/local && \
    wget http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/mango_unix.zip && \
    unzip mango_unix.zip && rm mango_unix.zip && \
    echo '' >> /etc/skel/.bash_aliases && \
    echo '#Mango' >> /etc/skel/.bash_aliases && \
    echo 'export PATH=$PATH:/usr/local/Mango' >> /etc/skel/.bash_aliases

# MRIcroGL
RUN cd /usr/local &&  \
    wget http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/MRIcroGL_linux.zip && unzip MRIcroGL_linux.zip && rm MRIcroGL_linux.zip && \
    echo '' >> /etc/skel/.bash_aliases && \
    echo '#MRIcroGL' >> /etc/skel/.bash_aliases && \
    echo 'export PATH=$PATH:/usr/local/MRIcroGL' >> /etc/skel/.bash_aliases && \
    echo 'export PATH=$PATH:/usr/local/MRIcroGL/Resources' >> /etc/skel/.bash_aliases

# MRIcron
RUN cd /usr/local && wget http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/MRIcron_linux.zip && \
    unzip MRIcron_linux.zip && rm MRIcron_linux.zip && \
    cd mricron && \
    find . -name 'dcm2niix' -exec rm {} \; && \
    find . -name '*.bat' -exec rm {} \; && \
    find . -type d -exec chmod 755 {} \; && \
    find Resources -type f -exec chmod 644 {} \; && \
    chmod 755 /usr/local/mricron/Resources/pigz_mricron && \
    echo '' >> /etc/skel/.bash_aliases && \
    echo '#MRIcron' >> /etc/skel/.bash_aliases && \
    echo 'export PATH=$PATH:/usr/local/mricron' >> /etc/skel/.bash_aliases

# Surf-Ice
RUN cd /usr/local && wget http://www.lin4neuro.net/lin4neuro/neuroimaging_software_packages/surfice_linux.zip && \
    unzip surfice_linux.zip && rm surfice_linux.zip && \
    cd Surf_Ice && \
    find . -type d -exec chmod 755 {} \; && \
    find . -type f -exec chmod 644 {} \; && \
    chmod 755 surfice* && \
    chmod 644 surfice_Linux_Installation.txt && \
    echo '' >> /etc/skel/.bash_aliases && \
    echo '#Surf_Ice' >> /etc/skel/.bash_aliases && \
    echo 'export PATH=$PATH:/usr/local/Surf_Ice' >> /etc/skel/.bash_aliases

# Change login shell to bash
RUN chsh -s /bin/bash
##### Lin4Neuro settings end #####


# TigerVNC and nonVNC
RUN apt-get install -y tigervnc-standalone-server tigervnc-common \
    novnc websockify

ARG UID=1000
RUN useradd -m -u ${UID} brain && echo "brain:lin4neuro" | chpasswd && adduser brain sudo

USER brain

COPY vncsettings.sh /home/brain
COPY jpsettings.sh /home/brain

