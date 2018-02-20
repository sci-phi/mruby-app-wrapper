FROM sciphi/mruby-base
LABEL maintainer "@sci_phi <phi.sanders@sciphi.me>"

# MRUBY_VERSION is configured in the sciphi/mruby-base image
ENV MRUBY_SRC_PATH "/usr/src/mruby-${MRUBY_VERSION}"

# Extend mruby functionality by customizing the build configuration
# Replace the default config with custom build_config.rb file ...

COPY templates/custom_build_config.rb "${MRUBY_SRC_PATH}/build_config.rb"
COPY templates/dockerized.gembox "${MRUBY_SRC_PATH}/mrbgems/dockerized.gembox"

# Clean the old build artifacts and perform a full rebuild...
RUN cd ${MRUBY_SRC_PATH} && ruby ./minirake clean && ruby ./minirake

# Replace the default tools to enable the customized versions
RUN cp ${MRUBY_SRC_PATH}/build/host/bin/* /usr/local/bin/.

# Entrypoints are inherited from sciphi/mruby-base image
# via Entrykit : "mruby", "mirb", "mrbc", "shell", etc.
