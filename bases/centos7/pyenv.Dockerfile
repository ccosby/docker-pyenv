FROM ${REPO}:${REPOTAG}

RUN pyenv install ${PYTHON_VERSION}
RUN pyenv global ${PYTHON_VERSION}
RUN pyenv rehash

USER root
RUN yum clean all
RUN yum remove -y gcc gcc-c++ make git patch *-devel kernel-headers glibc-headers
RUN rm -rf /var/cache/yum/* /var/lib/yum/repos/*

USER pyuser
