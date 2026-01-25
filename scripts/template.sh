#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TRG_DIR="$DIR/../src/articles"
TEMPLATE="$DIR/../templates/article.html"
MAIN_PAGE_PATH="$DIR/../src/index.html"
if [ ! -f "$TEMPLATE" ]; then
    echo "Ошибка: файл $TEMPLATE не найден в текущей директории"
    exit 1
fi

DATE=$(date +"%Y-%m-%d")
PATH_VAR="${DATE}_how_Google_indexing_my_sites"
TITLE_VAR="Как Google индексирует мои сайты (продолжение)"
DESCR_VAR="Продолжаю разбираться как часто и когда Google индексирует мои сайты"
PREV_POST="src/articles/2026-01-25_Google_links_warnings/index.html"
H1=".COM vs .ONLINE: кто быстрее?"


POST_URL="/src/articles/$PATH_VAR/index.html"
PREV_POST_PATH="$DIR/../$PREV_POST"
PREV_LINK="/$PREV_POST"
PREV_TITLE=$(cat "$PREV_POST_PATH"| rg title | sed -n 's/.*<title>\([^|]*\)[[:space:]]*|[[:space:]]*.*<\/title>.*/\1/p' )
# Запрашиваем данные у пользователя
# read -p "Введите PATH (относительный путь без index.html, например 'articles/new_post'): " PATH_VAR
# read -p "Введите TITLE: " TITLE_VAR
# read -p "Введите DESCR: " DESCR_VAR

# Проверяем, введены ли все значения
# if [ -z "$PATH_VAR" ] || [ -z "$TITLE_VAR" ] || [ -z "$DESCR_VAR" ]; then
#     echo "Ошибка: все поля должны быть заполнены"
#     exit 1
# fi

# Создаем директорию, если её нет
FULL_PATH=$TRG_DIR/$PATH_VAR
mkdir -p "$FULL_PATH"

# Определяем путь к выходному файлу
OUTPUT_FILE="$FULL_PATH/index.html"
echo "$OUTPUT_FILE"

# Заменяем переменные в шаблоне и сохраняем результат
sed -e "s|{{DATE}}|$DATE|g" \
    -e "s|{{PATH}}|$PATH_VAR|g" \
    -e "s|{{TITLE}}|$TITLE_VAR|g" \
    -e "s|{{DESCR}}|$DESCR_VAR|g" \
    -e "s|{{H1}}|$H1|g" \
    -e "s|{{PREV_LINK}}|$PREV_LINK|g" \
    -e "s|{{PREV_TITLE}}|$PREV_TITLE|g" \
    "$TEMPLATE" > "$OUTPUT_FILE"

# Проверяем успешность создания файла
if [ $? -eq 0 ]; then
    echo "✓ Файл успешно создан: $OUTPUT_FILE"
    echo "Содержимое:"
    echo "POST_URL:"$POST_URL
    echo "  DATE:  $DATE"
    echo "  PATH:  $PATH_VAR"
    echo "  TITLE: $TITLE_VAR"
    echo "  H1: $H1"
    echo "  DESCR: $DESCR_VAR"
    echo "  PREV_LINK: $PREV_LINK"
    echo "  PREV_TITLE: $PREV_TITLE"
else
    echo "✗ Ошибка при создании файла"
    exit 1
fi
echo update link in previuos article: $PREV_POST_PATH
if grep -q 'id="next"' "$PREV_POST_PATH"
then
    echo "В файле уже есть ссылка с id=\"next\""
else
  echo добавляю ссылку в предыдущий пост
  sed -i "/<\/main>/i<p><a id=\"next\" href=\"$POST_URL\">Далее: $TITLE_VAR</a></p>" "$PREV_POST_PATH"
fi

echo добавляем ссылку на главную
if rg "$POST_URL" "$MAIN_PAGE_PATH"
then
  echo Already exists
else
  sed -i "/<ul id=\"articles\">/a<li><a href=\"$POST_URL\">$DATE: $TITLE_VAR</a></li>" "$MAIN_PAGE_PATH"
fi


# Проверяем, есть ли тег </head> в файле
# if ! grep -q '</head>' "$$PREV_POST_PATH"; then
#     echo "Ошибка: в файле нет тега </head>"
#     exit 1
# fi