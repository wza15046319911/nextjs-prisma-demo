#!/bin/bash

# 停止并移除所有容器和默认网络
docker-compose down

# 可选：删除所有相关镜像，确保镜像名与你的实际使用相符
docker rmi $(docker images 'my-project' -q)

# 强制重新构建服务，无视缓存
docker-compose build --no-cache

# 启动服务
docker-compose up -d