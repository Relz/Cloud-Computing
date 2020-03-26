# Лабораторная работа 1

## Задание

Поднять минимальный статичный сайт на EC2

## Решение

1. Зарегистрировать бесплатный аккаунт (Free Tier) на AWS, руководствуясь [видео](https://www.youtube.com/watch?v=O1_--7IvP5g&list=PLg5SS_4L6LYsxrZ_4xE_U95AtGsIB96k9).
1. Настроить профиль, руководствуясь [видео](https://www.youtube.com/watch?v=NBBIjFUQ2W0&list=PLg5SS_4L6LYsxrZ_4xE_U95AtGsIB96k9).
1. Создать Web Сервер на базе _Amazon Linux 2 AMI (HVM), SSD Volume Type_, руководствуясь [видео](https://www.youtube.com/watch?v=LjKGaco0QeQ&list=PLg5SS_4L6LYsxrZ_4xE_U95AtGsIB96k9).
    1. Запустить Instance, взяв за основу _Amazon Linux 2 AMI (HVM), SSD Volume Type_.
    1. Войти в Instance, используя SSH-клиент.
    1. Установить Nginx на Instance.
    1. Проверить, что стартовая страница Nginx отображается при заходе на ip-адрес Instance'а.
1. Настроить доступ к Instance через FileZilla.
1. Сверстать простенький статичный сайт на HTML+JS+CSS, назвать "about_alexey_starovoytov".
1. Загрузить сайт на Instance
1. Проверить, что сайт доступен по ip-адресу Instance'а.
