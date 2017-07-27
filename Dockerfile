FROM alpine:3.6 as builder

WORKDIR /tmp
ARG VW_VERSION
RUN apk add --update \
            alpine-sdk \
            autoconf \
            automake \
            boost-dev \
            curl \
            file \
            g++ \
            gcc \
            git \
            libgcc \
            libstdc++ \
            libtool \
            linux-headers \
            m4 \
            make \
            musl-dev \
            paxctl \
            python-dev \
            wget \
            zlib-dev
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git &&\
    cd  vowpal_wabbit &&\
    git checkout ${VW_VERSION} &&\
    git status &&\
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/gcc/x86_64-alpine-linux-musl/6.3.0/include" &&\
    sed -i 's/^..BOOST_DIR_ARG.*/  BOOST_DIR_ARG\=\"\-\-with\-boost\-libdir\=\/usr\/lib\"/g' ./autogen.sh &&\
    ./autogen.sh --prefix=/vw &&\
    make &&\
    make install
RUN ls -R /vw
RUN /vw/bin/vw --version


FROM alpine:3.6
COPY --from=builder /vw /vw
RUN cp -rf /vw/* /usr/

RUN apk add --no-cache \
            libstdc++ \
            boost-dev &&\
    adduser -D vw && \
    cp -rf /vw/* /usr/

USER vw

EXPOSE 26542
ENTRYPOINT ["/usr/bin/vw"]

CMD [ "--help" ]
