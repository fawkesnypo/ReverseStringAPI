FROM ubuntu:latest
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install lsb-release -y \
    && apt-get install software-properties-common -y \
    && apt-get clean all \
    && add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" \ 
    && apt-get update \ 
    && apt-get install fpc -y \
COPY --chmod=+x ReverseStringAPI.lpr /ReverseStringAPI.lpr 
COPY --chmod=+x ReverseStringAPI.lpi /ReverseStringAPI.lpi
COPY --chmod=+x user.pas /user.pas
RUN fpc ReverseStringAPI.lpr
CMD ["./ReverseStringAPI"]