# SVG to PDF Converter API

Этот проект представляет собой REST API для загрузки SVG-файлов и их конвертации в PDF с функциями добавления водяного знака и полей для обрезки.

## Задача

- Загрузка SVG-файлов
- Конвертация в PDF
- Поддержка водяного знака (watermark)
- Добавление полей для обрезки (cropping fields)

---

## Стек

- Ruby on Rails 8
- PostgreSQL
- ActiveStorage (s3 сложнее покрыть тестами)
- Prawn + prawn-svg
- RSpec + FactoryBot
- Swagger (Rswag)
- Slim + JS (минимальный веб-интерфейс)

---

## Документация API

http://localhost:3000/api-docs/index.html

---

## Установка

```bash
git clone git@github.com:TimDelRey/svg2pdf-convert.git
cd svg2pdf-convert
bundle install
bin/setup
```

#### Автор
Ким Тимур [Telegram](https://t.me/@Thunder_Tim) | [GitHub](https://github.com/TimDelRey)