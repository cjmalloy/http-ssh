# HTTP+SSH
HTTP tunnels over SSH

## Start server

```shell
docker run -p 8022:22 -e AUTHORIZED_KEYS="$(< authorized_keys)" -it ghcr.io/cjmalloy/http-ssh
```

## Connect proxy to server

```shell
docker run -e T_REMOTE=localhost:80 -e T_USER=root@localhost -e T_PORT=8022 -e KEY="$(< id_rsa)" -p 8099:80 --net=host -it ghcr.io/cjmalloy/http-ssh
```
