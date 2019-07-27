#!/usr/bin/env zsh

pgsql() {
  docker run --rm -d -p 5432:5432 \
    --name pg-docker \
    -v /scratch/share/docker/volumes/postgres:/var/lib/postgresql/data \
    postgres
}
