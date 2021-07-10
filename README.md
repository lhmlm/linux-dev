# linux-dev docker images

## Images

| branch | docker Tag |
| :----- | :--------- |
| master | latest     |
| base   | base       |
| aosp   | aosp       |


## Branches

base  
└─ jsapp: haasui/coral  
   └─ aosp(master)  


## Build & Run

- build
  ```bash
  docker build -t linux-dev-base:base .
  ```

- run
  ```bash
  docker run -u thead -it --rm linux-dev-base:base
  ```
