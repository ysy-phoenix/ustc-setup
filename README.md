## 背景

1. 没有 sudo 权限；
2. 不允许科学上网。

## 替代方案

- [github 代理](https://gh-proxy.com/)
- [huggingface 镜像](https://hf-mirror.com/)
- 安装 zsh：见 `init.sh

## 服务器连接

通过外网 IP + 外网端口连接

```bash
ssh -p [port] [username]@[ip_address]
# login via password
```

复制公钥到服务器

```bash
ssh-copy-id -p [port] [username]@[ip_address]

# .ssh/config
Host [alias]
    HostName [ip_address]
    Port [port]
    User [username]
    IdentityFile [path/to/private_key]
```