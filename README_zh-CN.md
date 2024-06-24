# Docker Image Sync

简体中文 | [English](./README.md)

## 配置阿里云镜像服务

登录阿里云镜像服务：https://cr.console.aliyun.com/

开启个人示例, 并从配置中取得需要的环境变量：

<div align='center'>
  <img src="./img/1.png" style="zoom:50%;" />
</div>


<div align='center'>
  <img src="./img/2.png" style="zoom:50%;" />
</div>


- <span style="font-family: 'Times New Roman', Times, serif;">ALIYUN_REGISTRY_PASSWORD</span>：固定密码，新建个人示例时创建.
- <span style="font-family: 'Times New Roman', Times, serif;">ALIYUN_NAME_SPACE</span>：命名空间, `solisamicus-images`.
- <span style="font-family: 'Times New Roman', Times, serif;">ALIYUN_REGISTRY_USER</span>：用户名, `solisamicus`.
- <span style="font-family: 'Times New Roman', Times, serif;">ALIYUN_REGISTRY</span>：仓库地址, `registry.cn-wulanchabu.aliyuncs.com`.

## Fork 项目

Fork 本仓库.

## 开启Github Actions

`Settings` -> `Secrets and variables` -> `Actions` -> `New Repository Secret`.

<div align='center'>
  <img src="./img/3.png" style="zoom:50%;" />
</div>


添加在上一步获取的四个环境变量.

> ALIYUN_NAME_SPACE
>
> ALIYUN_REGISTRY
>
> ALIYUN_REGISTRY_PASSWORD
>
> ALIYUN_REGISTRY_USER

<div align='center'>
  <img src="./img/4.png" style="zoom:50%;" />
</div>


### 添加 Docker 镜像

打开文件 `images.txt`  并添加你想要同步的仓库（使用`#` 添加注释）

:star:示例：

```
nginx
```

在文件成功提交后, Github Actions 将会自动开始构建过程.

<div align='center'>
  <img src="./img/5.png" style="zoom:50%;" />
</div>

查看阿里云容器镜像服务后你会看到同步过来的docker镜像

<div align='center'>
  <img src="./img/6.png" style="zoom:50%;" />
</div>


## 使用 Docker 镜像

返回阿里云镜像服务并检查镜像状态

> 你可以将镜像设为公开, 这样不用登录也能拉取此镜像了

在国内服务器上拉取镜像

```shell
docker pull ${ALIYUN_REGISTRY}/${ALIYUN_NAME_SPACE}/nginx
```

示例：

```
docker pull registry.cn-wulanchabu.aliyuncs.com/solisamicus-images/nginx
```

```shell
$ docker pull registry.cn-wulanchabu.aliyuncs.com/solisamicus-images/nginx
Using default tag: latest
latest: Pulling from solisamicus-images/nginx
2cc3ae149d28: Pull complete 
a97f9034bc9b: Pull complete 
9571e65a55a3: Pull complete 
0b432cb2d95e: Pull complete 
24436676f2de: Pull complete 
928cc9acedf0: Pull complete 
ca6fb48c6db4: Pull complete 
Digest: sha256:80550935209dd7f6b2d7e8401b9365837e3edd4b047f5a1a7d393e9f04d34498
Status: Downloaded newer image for registry.cn-wulanchabu.aliyuncs.com/solisamicus-images/nginx:latest
registry.cn-wulanchabu.aliyuncs.com/solisamicus-images/nginx:latest
```

### Multi-Architecture

```shell
--platform=linux/amd64 nginx:1.25.3
```

这会导致镜像名含有架构前缀:

```shell
registry.cn-wulanchabu.aliyuncs.com/solisamicus-images/linux_amd64_nginx:1.25.3
```

### Duplicate Image Names

```shell
namespace1/nginx:1.25.3
namespace2/nginx:1.25.3
```

这会导致镜像名前缀为命名空间以避免冲突:

```shell
registry.cn-wulanchabu.aliyuncs.com/solisamicus/namespace1_nginx:1.25.3
registry.cn-wulanchabu.aliyuncs.com/solisamicus/namespace2_nginx:1.25.3
```