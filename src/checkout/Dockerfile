FROM node:20-alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./

# COPY --chown=node:node package*.json ./
# COPY --chown=node:node . .

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build
USER node


FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# We tell DNF not to install Recommends and Suggests packages, which are
# weak dependencies in DNF terminology, thus keeping our installed set of
# packages as minimal as possible.
RUN dnf --setopt=install_weak_deps=False install -q -y \
    nodejs20 \
    shadow-utils \
    && dnf clean all

RUN alternatives --install /usr/bin/node node /usr/bin/node-20 90

ENV APPUSER=appuser
ENV APPUID=1000
ENV APPGID=1000

RUN useradd \
    --home "/app" \
    --create-home \
    --user-group \
    --uid "$APPUID" \
    "$APPUSER"

WORKDIR /app
USER appuser

COPY --chown=appuser:appuser --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=appuser:appuser --from=build /usr/src/app/dist ./dist

RUN chown -R appuser:appuser /app

ENTRYPOINT ["node", "dist/main.js"]
# trigger build
