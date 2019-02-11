Heroku:

https://blogwithapitest.herokuapp.com

Примеры api запросов:

POST https://blogwithapitest.herokuapp.com/api/v1/authenticate/?email=mail@mail.com&password=password - запросить токен авторизации (истекает через 15 минут).

Для дальнейших запросов прописать токен в заголовке Autorization.

GET https://blogwithapitest.herokuapp.com/api/v1/posts/1 - получить пост по id.

GET https://blogwithapitest.herokuapp.com/api/v1/posts.json/?page=2&per_page=2 - получить посты (страница/на странице).

POST https://blogwithapitest.herokuapp.com/api/v1/posts.json/?title=title2&body=body2 - создать пост.

POST https://blogwithapitest.herokuapp.com/api/v1/reports/by_author.json/?start_date=2019-02-05&end_date=2019-02-09&email=valentinandreev@bk.ru - запросить отчет (для heroku использован sendgrid локально открывает через letter_opener).