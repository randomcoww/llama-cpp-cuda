ARG BASE_IMAGE
FROM $BASE_IMAGE

WORKDIR /app

RUN set -x \
  \
  && TARGETARCH=$(arch) \
  && TARGETARCH=${TARGETARCH/x86_64/amd64} && TARGETARCH=${TARGETARCH/aarch64/arm64} \
  \
  && TINI_VERSION=$(curl -L https://api.github.com/repos/krallin/tini/releases/latest | grep tag_name | cut -d '"' -f 4) \
  && curl -L -o /tini \
    https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TARGETARCH} \
  && chmod +x /tini \
  \
  && VERSION=$(curl -L https://api.github.com/repos/mostlygeek/llama-swap/releases/latest | grep tag_name | cut -d '"' -f 4 | tr -d 'v') \
  && curl -L -o llama_swap.tar.gz \
    https://github.com/mostlygeek/llama-swap/releases/download/v${VERSION}/llama-swap_${VERSION}_linux_${TARGETARCH}.tar.gz \
  && tar xzf llama_swap.tar.gz llama-swap \
  && rm llama_swap.tar.gz

ENTRYPOINT [ "/tini" "--" ]