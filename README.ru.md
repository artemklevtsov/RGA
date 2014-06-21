# RGA

Данный пакет предназначен для работы с API **Google Analytics** в **R**.

Основные возможности:

* Поддержка OAuth 2.0 аутентификации;
* Доступ к API конфигурации (информация об аккаунтах, профилях, целях, сегментах);
* Доступ к API базовых отчётов и отчётов многоканальных последовательностей;
* Поддержка пакетной обработки запросов (позволяет преодолеть ограничение на количество возвращаемых строк на один запрос).
* Доступ к метаданным API отчётов.

## Установка

**Внимание:** Пакет **RGA** находится в разработке и не доступен через сеть **CRAN**.

Установить актуальную версию пакета `RGA` можно установить с помощью функции `install_bitbucket` из пакета `devtools`:

```R
devtools::install.packages("devtools", dependencies = TRUE)
```
Другой способ установки пакета `RGA` (с помощью команд в терминале):

```bash
git clone https://unikum@bitbucket.org/unikum/rga.git
R CMD build rga
R CMD INSTALL rga_*.tar.gz
```

## Подготовка

### Получение ключей для доступа к API Google Analytics

Прежде чем приступить к работе с пакетом `RGA`, необходимо создать новое приложение в [Google Developers Console](https://console.developers.google.com) и получить **Client ID** (идентификатор клиента) и **Client secret** (секретный ключ клиента) для доступа к API Google Analytics.

Пошаговая инструкция приведена ниже:

1. Создание нового проекта (можно пропустить, если проект уже создан):
    * Откройте страницу https://console.developers.google.com/project;
    * В левой верхней части страницы нажмите на красную кнопку с надписью **Create Project**;
    * Во всплывающем окне в поле **PROJECT NAME** введите название проекта;
    * Подтвердите создание проекта, нажав на кнопку **Create**.
1. Активация доступа к API Google Analytics:
    * Выберите проект в списке проектов на странице https://console.developers.google.com/project;
    * На боковой панели слева выберите пункт **APIs & auth**;
    * на вкладке **APIs** активируйте **Analytics API**, нажав на кнопку с надписью `OFF` (убедитесь, что вместо надписи `OFF` появилось `ON`).
1. Создание нового приложения:
    * В боковой панели слева выберите пункт **APIs & auth**, подпункт **Credentials**;
    * В левой части страницы нажмите на кнопку с надписью **Create new Client ID**;
    * Во всплывающем окне выберите пункт **Installed application** в списке **APPLICATION TYPE** и пункт **Other** в списке **INSTALLED APPLICATION TYPE**.
    * Подтвердите создание приложения, нажав на кнопку с надписью **Create Client ID**.
1. Получение Client ID и Client secret:
    * Выберите проект в списке проектов на странице https://console.developers.google.com/project;
    * В боковой панели слева выберите пункт **APIs & auth**, подпункт **Credentials**;
    * В таблице с названием **Client ID for native application** скопируйте значения полей **Client ID** и **Client secret**.

Теперь вы в любой момент можете вернуться на страницу **Credentials** и узнать **Client ID** и **Client secret**.

## Работа с пакетом

### Получение токена доступа

Перед осуществление любых запросов к API, необходимо пройти авторизацию и получить токен доступа. Осуществить это можно с помощью следующей команды:

```R
authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
```

После выполнения данной команды будет открыт интернет браузер со страницей запроса подтверждения разрешения на доступ к данным Google Analytics. Необходимо авторизоваться под своей **учётной записью Google** и подтвердить разрешение на доступ к данным Google Analytics. Отметим, что пакет `RGA` запрашивает доступ **только для чтения** данных.

Если аргументу `cache` было присвоено значения `TRUE` (по умолчанию) и не изменялся параметр `httr_oauth_cache`, то после успешной авторизации в рабочей директории будет создан файл `.httr-oauth` с данными для доступа к Google API, который будет использоваться между сессиями, т.е. при последующем вызове функции `authorize` авторизация больше не требуется. С помощью аргумента `cache` можно также отменить создание файла (значение `FALSE`) или задать альтернативный путь к файлу хранения (для этого необходимо явно указать путь и имя файла).

Токен доступа может быть также сохранён в переменной и использован в качестве аргумента для функций, осуществляющих запросы к API Google Analytics:

```R
ga_token <- authorize(client.id = "My_Client_ID", client.secret = "My_Client_secret")
get_profiles(token = ga_token)
```
Это может быть полезно, если вы работаете одновременно с несколькими учётными записями.

Отметим, что помимо явного указания аргументов `client.id` и `client.secret`, их значения могут быть заданны через переменные среды: `RGA_CONSUMER_ID` и `RGA_CONSUMER_SECRET`. В данном случае указание аргументов `client.id` и `client.secret` при вызове функции `authorize` не требуется.

Установка переменных сред отличается для разных операционных систем, поэтому пользователю необходимо обратиться к соответствующим справочным материалам (см. список ссылок в конце данного руководства). Также существует способ установки переменных сред при запуске R-сессий с помощью файлов `.Renviron’ в рабочей или домашней директории пользователя. Содержимое файла может выглядеть примерно так:

```txt
RGA_CONSUMER_ID="My_Client_ID"
RGA_CONSUMER_SECRET="My_Client_secret"
```

Переменные среды можно также установить непосредственно из R-сессии с помощью функции `Sys.setenv`. Например:

```R
Sys.setenv(RGA_CONSUMER_ID = "My_Client_ID", RGA_CONSUMER_SECRET = "My_Client_secret")
```

Эту строку можно добавить в в файл `.Rprofile` в текущей или домашней директории пользователя, чтобы данные переменные автоматически устанавливались при запуске R-сессии.

### Получение доступа к API конфигурации

Для доступа к API конфигурации Google Analytics в пакете `RGA` предусмотрены следующие функции: `get_accounts`, `get_webproperties`, `get_profiles`, `get_goals` и `get_segments`. Каждая из этих функций возвращает таблицу данных (`data.frame`), с соответствующим содержимым.

Рассмотрим подробнее данные функции.

* `get_accounts` - получение списка аккаунтов, к которым пользователь имеет доступ;
* `get_webproperties` - получение списка ресурсов (Web Properties), к которым пользователь имеет доступ;
* `get_profiles` - получение списка ресурсов (Web Properties) и представлений (Views, Profiles) сайтов, к которым пользователь имеет доступ;
* `get_goals` - получение списка целей, к которым пользователь имеет доступ;
* `get_segments` - получение списка сегментов, к которым пользователь имеет доступ.

Для функций `get_webproperties`, `get_profiles` и `get_goals` можно указать дополнительные аргументы: `account.id`, `webproperty.id` и`profile.id`, указывающих, соответственно, идентификатор аккаунта, ресурса или представления (профиля), для которого необходимо получить информацию (см. страницы помощи к соответствующим функциям). Пример получения информации по всем представлениям, доступным пользователю:

```R
get_profiles()
```

### Получение доступа к метаданным API отчётов

При работе с API отчётов иногда бывает необходимо получить справочную информацию о тех или иных параметрах запроса к API. Для получения списка всех показателей (metrics) и измерений (dimensions) пакет `RGA` предоставляет набор данных (dataset) `ga`, который доступен после загрузки пакета.

Доступ к к набору данных осуществляется аналогично доступу к любому объекту в R - по имени переменной:

```R
ga
```

Набор данных `ga` содержит следующие столбцы:

* `id` - кодовое название параметра (показателя или измерения) (используется для запросов);
* `type` - тип параметра: показатель (METRIC) или измерение (DIMENSION);
* `dataType` - тип данных: STRING, INTEGER, PERCENT, TIME, CURRENCY, FLOAT;
* `group` - группа параметров (например, User, Session, Traffic Sources);
* `status` - статус: актуальный (PUBLIC) или устаревший (DEPRECATED);
* `uiName` - имя параметра (не используется для запросов);
* `description` - описание параметра.
* `allowedInSegments` - может ли параметр использоваться в сегментах;
* `replacedBy` - название заменяющего параметра, если параметр объявлен устаревшим;
* `calculation` - формула расчёта значения параметра, если параметр вычисляется на основе данных других параметр;
* `minTemplateIndex` - если параметр содержит числовой индекс, минимальный индекс для параметра;
* `maxTemplateIndex` - если параметр содержит числовой индекс, максимальный индекс для параметра;
* `premiumMinTemplateIndex` - если параметр содержит числовой индекс, минимальный индекс для параметра;
* `premiumMaxTemplateIndex` - если параметр содержит числовой индекс, максимальный индекс для параметра;

Несколько примеров использования метаданных Google Analytics API.

Список всех устаревших и заменяющих их параметров:

```R
subset(ga, status == "DEPRECATED", c(id, replacedBy))
```

Список всех параметров из определённой группы:

```R
subset(ga, group == "Traffic Sources", c(id, type))
```

Список параметров, вычисляемых на основании других параметров:

```R
subset(ga, !is.na(calculation), c(id, calculation))
```

Список параметров, которые разрешено использовать в сегментах:

```R
subset(ga, allowedInSegments, id)
```

### Получение доступа к API отчётов

Доступ к API очтётов осуществляется с помощью функции `get_report`. При этом параметры для запроса к Google Analytics можно передавать как напрямую через аргументы функции `get_report`, так и через промежуточный объект `GAQuery`, который создаётся с помощью функции `set_query`.

Доступны следующие параметры для запросов к API отчётов:

* `profile.id` - ID профиля (представления) Google Analytics. Может быть получен с помощью функции `get_progiles` или через веб-интерфейс Google Analytics.
* `start.date` - дата начала сбора данных в формате YYYY-MM-DD. Также разрешены значения: "today", "yesterday", "ndaysAgo", где `n` обозначает количество дней.
* `end.date` - дата окончания сбора данных в формате YYYY-MM-DD. Также разрешены значения: "today", "yesterday", "ndaysAgo", где `n` обозначает количество дней.
* `metrics` - разделённый запятыми список значений показателей (metrics), например, "ga:sessions,ga:bounces". Количество показателей не может превышать 10 показателей на один запрос.
* `dimensions` - разделённый запятыми список значений измерений (dimensions), например, "ga:browser,ga:city". Количество измерений не может превышать 7 измерений на один запрос.
* `sort` - разделённый запятыми список показателей (metrics) и измерений (dimensions), определяющих порядок и направление сортировки данных. Обратный порядок сортировки указывается с помощью знака `-` перед соответствующим показателем.
* `filters` - разделённый запятыми список фильтров показателей (metrics) и измерений (dimensions), которые будут наложены при отборе данных.
* `segment` - сегменты, которые будут применены при извлечении данных.
* `start.index` - индекс первого возвращаемого результата (номер строки).
* `max.results` - максимальное количество полей (строк) возвращаемых результатов.

Аргументы `profile.id`, `start.date`, `end.date` и `metrics` являются обязательными. Обратим внимание, что все аргументы, за исключением `profile.id`, которая может как символьной строкой, так и числом, должны быть символьным строками единичной длинны.

Помимо этого, функция `get_report` поддерживает следующие аргументы:

* `type` - тип отчёта: "ga" - базовый отчёт (core report) и "mcf" - отчёт многоканальных последовательностей (multi-channel funnels).
* `query` - объекта класса `GAQuery`, содержащий параметры запроса. Может быть получен с помощью функции `set_query`.
* `token` - объект класса `Token2.0`, содержащий данные о токене доступа. Может быть получен с помощью функции `authorize`.
* `batch` - логический аргумент, включающий режим пакетной обработки запросов. Требуется, если количество полей (строк) превышает 10000 (ограничение Google).
* `messages` - логический аргумент, включающий отображение дополнительные сообщения в ходе запроса данных.

Обратим внимание, что если вы используете показатели (metrics) и измерения (dimensions) отчёта многоканальных последовательностей, например, "mcf:totalConversions", то аргументу `type` должно быть присвоено значение "mcf".

Пример получения данных за последние 30 дней:

```R
ga_data <- get_report(profile.id = XXXXXXXX, start.date = "30daysAgo", end.date = "yesterday",
                      metrics = "ga:users,ga:sessions,ga:pageviews")
```

Тот же эффект можно достичь через промежуточную переменную `query`:

```R
query <- set_query(profile.id = XXXXXXXX, start.date = "30daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews")
print(query)
ga_data <- get_report(query)
```

Переменная `ga_data` является таблицей данных (`data.frame`) и содержит в качестве столбцов те показатели (metrics) и измерения (dimensions), которые были заданы при запросе.

Обратите внимание, что после создания объекта `query`, мы можем изменять его параметры, присваивая им значения аналогично спискам:

```R
query$dimensions <- "ga:date"
query$filters <- "ga:sessions > 1000"
print(query)
```

Удалить то или иное значение объекта `query` можно, присвоив ему значение `NULL`:

```R
query$filters <- NULL
print(query)
```

Иногда необходимо получить данные за весь период отслеживания через сервис Google Analytics. Для этих целей пакет `RGA` предоставляет функцию `get_firstdate`, которая принимает в качестве обаятельного аргумента ID профиля (представления):

```R
first_date <- get_firstdate(profile.id = XXXXXXXX, token = token)
```

Теперь мы можем использовать переменную `first_date` в качестве аргумента `start.date` при вызове функции `get_report`:

```R
ga_data <- get_report(profile.id = XXXXXXXX, start.date = first_date, end.date = "yesterday",
                      metrics = "ga:users,ga:sessions,ga:pageviews")
```

## Ссылки

* [Google Developers Console](https://console.developers.google.com/project);

### Google Analytics API

* [Management API Reference](https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/)
* [Core Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/core/v3/reference)
* [Multi-Channel Funnels Reporting API Reference Guide](https://developers.google.com/analytics/devguides/reporting/mcf/v3/reference)
* [Metadata API Reference](https://developers.google.com/analytics/devguides/reporting/metadata/v3/reference/)
* [Configuration and Reporting API Limits and Quotas](https://developers.google.com/analytics/devguides/reporting/metadata/v3/limits-quotas)

### Environment variables

* [Setting environment variables in Windows XP](http://support.microsoft.com/kb/310519)
* [Setting environment variables in earlier versions of OSX](https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/EnvironmentVars.html)
* [Setting environment variables in Ubuntu Linux](https://help.ubuntu.com/community/EnvironmentVariables)
