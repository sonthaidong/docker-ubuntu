# Stage 1: Copy and extract Java
FROM ubuntu:jammy-20240808 AS stage-1

# Copy the necessary files to the image
COPY stuffs/jdk-11-linux-x64.tar.gz \
    stuffs/Miniconda3-linux-x86_64.sh \
    /opt/

# Extract the Java and Miniconda
RUN tar -xvzf /opt/jdk-11-linux-x64.tar.gz -C /opt \
    && rm /opt/jdk-11-linux-x64.tar.gz \
    && mv /opt/jdk* /opt/jdk-11 \
    && mkdir -p /opt/miniconda3 \
    && bash /opt/Miniconda3-linux-x86_64.sh -b -u -p /opt/miniconda3 \
    && rm /opt/Miniconda3-linux-x86_64.sh

# Stage 2: Final image
FROM ubuntu:jammy-20240808 AS final

# Set the maintainer of the image
LABEL developer="Shaun <the_sheep@gmail.com>"

# Copy the extracted Java from the builder stage
COPY --from=stage-1 /opt /opt

# Install the necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    vim \
    # wget \
    # curl \  
    # telnet \  
    # netcat \
    # openssl \
    openssh-client \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --badnames --uid 6868 shaun --comment 'This is a comment' \
    --base-dir /home --groups sudo --no-user-group --create-home \
    && echo 'shaun:shaun' | chpasswd \
    && echo 'root:root' | chpasswd \
    && update-alternatives --install /usr/bin/java java /opt/jdk-11/bin/java 11 \
    && update-alternatives --install /usr/bin/javac javac /opt/jdk-11/bin/javac 11 \
    && /opt/miniconda3/bin/conda init bash \ 
    && git config --global user.name "Shaun" \
    && git config --global user.email "the_sheep@gmail.com" \
    && git config --global init.defaultBranch main 

# Switch to the non-root user
USER shaun

COPY scripts/check.sh /home/shaun/

# Set the working directory
WORKDIR /home/shaun
