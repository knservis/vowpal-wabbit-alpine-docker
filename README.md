# vowpal-wabbit-alpine-docker
Docker container with Vowpal Wabbit based on alpine image.

Build:

```bash
VERSION="master" # git tag, branch or commit
docker build -t vowpal-wabbit:${VERSION} --build-arg VW_VERSION="${VERSION}"
docker run --t vowpal-wabbit:${VERSION} --version
```
