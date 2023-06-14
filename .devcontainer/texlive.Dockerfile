# ============================================================================= #
# Version  v1.1.0                                                               #
# Date     2023.06.08                                                           #
# CoachCrew.tech                                                                #
# admin@CoachCrew.tech                                                          #
# ============================================================================= #


# ============================================================================= #
# TARGET: develop
# ============================================================================= #
FROM texlive/texlive@sha256:def547064eec3ba6eed2ac\
07354b55291f8bc97d446232b8a2b732ae9d20a346 as develop

ARG DOCKER_ENTRYPOINT

# Install essential tools ----------------------------------------------------- #
RUN apt-get update                             && \
    apt-get install -y --no-install-recommends    \
        sudo=1.9.13p3-1                           \
        tmux=3.3a-3                               \
        vim=2:9.0.1378-2                       && \
    apt-get clean all                          && \
    rm -rf /var/lib/apt/lists/*

# Install Dockerfile linter --------------------------------------------------- #
RUN curl -LO https://github.com/hadolint/\
hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64 && \
    cp hadolint-Linux-x86_64 /usr/bin/hadolint           && \
    chmod 755 /usr/bin/hadolint

COPY ${DOCKER_ENTRYPOINT} /root/
RUN chmod +x /root/develop-entrypoint.sh

ENTRYPOINT ["/root/develop-entrypoint.sh"]
