# EVerest CI/CD

This repository should share all common used functionality for the
everest github ci/cd pipe

## Docker Images

### run-env-base

Based on `debian:12-slim`.

Deployed as `ghcr.io/everest/everest-ci/run-env-base`.

Includes all dependencies that are necessary to run EVerest.

### build-env-base

Based on `run-env-base`.

Deployed as `ghcr.io/everest/everest-ci/build-env-base`.

Includes all dependencies that are necessary to build EVerest.

### dev-env-base

Based on `build-env-base`.

Deployed as `ghcr.io/everest/everest-ci/dev-env-base`.

Include additional packages to develop EVerest.

### everest-clang-format

> [!NOTE]
> This image was moved from `ghcr.io/everest/clang-format` to
> `ghcr.io/everest/everest-ci/everest-clang-format`. The old image is
> deprecated and will be removed in the future.

Deployed as `ghcr.io/everest/everest-ci/everest-clang-format`.

Contains a fixed clang-format version in addition to a run-clang-format script. This image can be diretcly executed.
This image is used as base for a custom github action and can also be used to run clang-format locally.

### build-kit-base

> [!NOTE]
> The images `ghcr.io/everest/build-kit-alpine` and `ghcr.io/everest/build-kit-debian`
> are deprecated and will be removed in the future. Please use
> `ghcr.io/everest/everest-ci/build-kit-base` instead.

Based on `build-env-base`.

Deployed as `ghcr.io/everest/everest-ci/build-kit-base`.

This image includes a mechanic to run bash scripts in the build environment. It is used to run the build scripts in the CI/CD pipeline.
It is executed directly.
