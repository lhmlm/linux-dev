# linux-dev-base docker image

## images

| branch | docker Tag |
| :----- | :--------- |
| master | latest     |
| base   | base       |


## branches

master --- base
           ├─ jsapp: haasui/coral
           ├─ yocto
           └─


## build & run

- build
  ```bash
  docker build -t linux-dev-base:base .
  ```

- run
  ```bash
  docker run -u thead -it --rm linux-dev-base:base
  ```
