#!/bin/bash

REPO_URL="https://github.com/<Ваше_Имя_Пользователя>/shvirtd-example-python.git"
TARGET_DIR="/opt/shvirtd-example-python"

echo "Клонирование репозитория..."
if [ -d "$TARGET_DIR" ]; then
    echo "Папка $TARGET_DIR существует. Извлечение данных..."
    cd $TARGET_DIR
    sudo git pull
else
    echo "Клонирование репозитория из $REPO_URL"
    sudo git clone $REPO_URL $TARGET_DIR
    cd $TARGET_DIR
fi

echo "Запуск проекта с помощью Docker Compose в фоне..."
sudo docker compose up -d

echo "Список контейнеров..."
sudo docker compose ps