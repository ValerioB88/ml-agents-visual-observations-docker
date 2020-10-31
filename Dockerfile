FROM mmrl/dl-pytorch

USER root
RUN apt update

ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y libgconf-2-4 
RUN apt install -y libsoup2.4 
RUN apt install -y xorg 

RUN pip install -q mlagents==0.21 

RUN wget --output-document /libxfont.deb http://security.ubuntu.com/ubuntu/pool/main/libx/libxfont/libxfont1_1.5.1-1ubuntu0.16.04.4_amd64.deb 
RUN wget --output-document /xvfb.deb http://security.ubuntu.com/ubuntu/pool/universe/x/xorg-server/xvfb_1.18.4-0ubuntu0.10_amd64.deb 
RUN dpkg -i /libxfont.deb 
RUN dpkg -i /xvfb.deb 

RUN rm /libxfont.deb 
RUN rm /xvfb.deb 
ENV DISPLAY :1
