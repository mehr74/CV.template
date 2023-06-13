# ============================================================================= #
# Version  v1.1.0                                                               #
# Date     2023.06.08                                                           #
# CoachCrew.tech                                                                #
# admin@CoachCrew.tech                                                          #
# ============================================================================= #


# ============================================================================= #
# TARGET: develop
# ============================================================================= #
FROM texlive/texlive:latest as Develop

ARG DOCKER_ENTRYPOINT

# Install essential tools ----------------------------------------------------- #
RUN apt-get update                             && \
    apt-get install -y --no-install-recommends    \
        sudo                                      \
        tmux                                      \
        vim                                    && \
    apt-get clean all                          && \
    rm -rf /var/lib/apt/lists/*

COPY ${DOCKER_ENTRYPOINT} /root/
RUN chmod +x /root/develop-entrypoint.sh

ENTRYPOINT ["/root/develop-entrypoint.sh"]
