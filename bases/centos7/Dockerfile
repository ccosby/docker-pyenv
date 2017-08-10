# Install pyenv on CentOS 7
FROM centos:7
MAINTAINER Chris Cosby <chris.cosby@aptplatforms.com>

RUN rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum clean all
RUN yum upgrade -y
RUN yum install -y gcc gcc-c++ make git patch openssl-devel zlib-devel readline-devel sqlite-devel bzip2-devel
RUN yum clean all
RUN rm -rf /var/cache/yum/* /var/lib/yum/repos/*

ARG PYENV_GIT=https://github.com/pyenv/pyenv.git

ENV HOME        /app
ENV PYENV_ROOT  $HOME/pyenv
ENV PATH        $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN      useradd -d /app -m pyuser
WORKDIR  $HOME
USER     pyuser

RUN rm -rf $PYENV_ROOT && git clone $PYENV_GIT $PYENV_ROOT
ADD info.py $HOME/info.py

CMD ["python", "info.py"]
