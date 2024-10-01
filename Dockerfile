# Use a base image with Ubuntu
FROM ubuntu:latest

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    emacs \
    ripgrep \
    fd-find \
    texlive-full \
    aspell \
    graphviz \
    default-jre \
    plantuml \
    inkscape \
    libtool \
    cmake \
    texlive-xetex \
    sudo \
    && rm -rf /var/lib/apt/lists/*

ARG HOST_UID=1000
ARG HOST_GID=1000

# Create a non-root user for better security practices
RUN if getent group $HOST_GID; then \
        groupmod -n user $(getent group $HOST_GID | cut -d: -f1); \
    else \
        groupadd -g $HOST_GID user; \
    fi && \
    if id -u $HOST_UID >/dev/null 2>&1; then \
        usermod -l user -g $HOST_GID -d /home/user -m $(id -un $HOST_UID); \
    else \
        useradd -u $HOST_UID -g $HOST_GID -m user; \
    fi && \
    echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chmod 644 /usr/share/plantuml/plantuml.jar
RUN chown user:user /usr/share/plantuml/plantuml.jar
USER user
WORKDIR /home/user

# Install Doom Emacs
RUN git clone --depth 1 https://github.com/hlissner/doom-emacs /home/user/.emacs.d
RUN /home/user/.emacs.d/bin/doom install --env --no-fonts --no-hooks --force

# Add python execs and emacs to the PATH
ENV PATH="/home/user/.emacs.d/bin:/home/user/.local/bin:${PATH}"
RUN mkdir -p /home/user/.doom.d

# Copy your Doom Emacs configuration
COPY --chown=user:user deps/emacs/* /home/user/.doom.d/

# Install Doom Emacs packages
RUN doom sync
