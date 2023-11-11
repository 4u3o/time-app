# Минималистичное Rack-приложение

Отвечает на `URL GET /time` с параметром строки запроса format и возвращать время в заданном формате,
например:
```text
/time?format=year%2Cmonth%2Cday
```


Доступные форматы времени: year, month, day, hour, minute, second.
## Запуск
```shell
rackup
```
