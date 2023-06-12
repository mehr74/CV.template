# Version  v1.0.0
# Date     2023.06.08
# CoachCrew.tech
# admin@CoachCrew.tech

FROM ubuntu:latest as Develop

ARG DOCKER_ENTRYPOINT

# Install nodejs -------------------------------------------------------------- #
RUN apt-get update      && \
    apt-get install -y     \
        build-essential    \
        curl               \
        git                \
        python3            \
        python3-pip        \
        sudo               \
        tar                \
        texlive-latex-full \
        tmux               \
        unzip              \
        vim                \
        zip

COPY ${DOCKER_ENTRYPOINT} /root/
RUN chmod +x /root/develop-entrypoint.sh

ENTRYPOINT ["/root/develop-entrypoint.sh"]
