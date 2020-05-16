# Лабораторная работа 2

## Задание

Добавить к своему сайту динамического контента, используя RDS

## Решение

1. Создать базу данных MySQL с помощью сервиса Amazon RDS, руководствуясь [видео](https://www.youtube.com/watch?v=UA0DRv-0ZZc&list=PLg5SS_4L6LYsxrZ_4xE_U95AtGsIB96k9).
1. Войти в существующий Instance EC2 с первой лабораторной работы, используя SSH-клиент.
   1. Установить Node.js на Instance.
   1. Загрузить билд разработанной игры "2048" на Instance в директорию _/usr/share/nginx/html_.
   1. Проверить, что игра доступна по ip-адресу Instance'а.
   1. Загрузить исходный код разработанного сервера для разработанной игры "2048" на Instance.
   1. Выполнить команду _npm i_ в директории с исходным кодом сервера.
   1. Выполнить команду _npm start_ в директории с исходным кодом сервера.
1. Проверить, что игра взаимодействует с сервером и с базой данных.