Тест сборки для работы на сервисе fly.io

Сборка основана на PHP 8.1 FPM + Caddy

### Запуск на fly.io
```
fly deploy
```
### Локальный запуск
```
docker build -t fly-test-image .
docker run -it --rm --name fly-test-container -p 80:8080 fly-test-image
```