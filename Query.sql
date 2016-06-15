/*1	Работа с типами данных Date, NULL значениями, трехзначная логика.
Возвращение определенных значений в результатах запроса в зависимости от полученных первоначальных значений результата запроса.
Выборка в результатах запроса только определенных колонок.*/

  /*1.1	Выбрать из таблицы Orders заказы, которые были доставлены после 5 мая 1998 года (колонка shippedDate) включительно и которые доставлены с shipVia >= 2. 
  Формат указания даты должен быть верным при любых региональных настройках.
  Этот метод использовать далее для всех заданий.
  Запрос должен выбирать только колонки orderID, shippedDate и shipVia. 
  Пояснить, почему сюда не попали заказы с NULL-ом в колонке shippedDate.*/

SELECT orderID, shippedDate, shipVia 
FROM Orders 
WHERE shippedDate >= TO_DATE('05.05.1998', 'DD.MM.YYYY') AND shipVia >= 2;

  /*Заказы с NULL значением не попали в селект потому, что выражение shippedDate >= TO_DATE('05.05.1998', 'DD.MM.YYYY') AND shipVia >= 2 на этих строках дает FALSE*/
  
  /*1.2	Написать запрос, который выводит только недоставленные заказы из таблицы Orders.
  В результатах запроса высвечивать для колонки shippedDate вместо значений NULL строку ‘Not Shipped’ – необходимо использовать CASЕ выражение.
  Запрос должен выбирать только колонки orderID и shippedDate.*/

SELECT orderID,
(CASE
  WHEN shippedDate IS NULL THEN 'Not Shipped'
END) AS SHIPPED
FROM Orders WHERE
shippedDate IS NULL;

  /*1.3	Выбрать из таблици Orders заказы, которые были доставлены после 5 мая 1998 года (shippedDate), не включая эту дату, или которые еще не доставлены.
  Запрос должен выбирать только колонки orderID (переименовать в Order Number) и shippedDate (переименовать в Shipped Date). 
  В результатах запроса  для колонки shippedDate вместо значений NULL выводить строку ‘Not Shipped’ (необходимо использовать функцию NVL), для остальных значений высвечивать дату в формате “ДД.ММ.ГГГГ”.*/

SELECT orderID AS "Order Number", NVL(TO_CHAR(shippedDate, 'DD.MM.YYYY'), 'Not Shipped') AS SHIPPED
FROM Orders 
WHERE 
shippedDate > TO_DATE('05.05.1998', 'DD.MM.YYYY') 
OR 
shippedDate IS NULL;

/*2	Использование операторов IN, DISTINCT, ORDER BY, NOT*/
  /*2.1	Выбрать из таблицы Customers всех заказчиков, проживающих в USA или Canada.
  Запрос сделать с только помощью оператора IN.
  Запрос должен выбирать колонки с именем пользователя и названием страны.
  Упорядочить результаты запроса по имени заказчиков и по месту проживания.*/

SELECT Contactname, Country
FROM Customers
WHERE Country IN ('USA', 'Canada') ORDER BY Country, Contactname;

  /*2.2	Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и Canada.
  Запрос сделать с помощью оператора IN.
  Запрос должен выбирать колонки с именем пользователя и названием страны а.
  Упорядочить результаты запроса по имени заказчиков в порядке убывания.*/

SELECT Contactname, Country
FROM Customers
WHERE Country NOT IN ('USA', 'Canada') ORDER BY Contactname DESC;

  /*2.3	Выбрать из таблицы Customers все страны, в которых проживают заказчики.
  Страна должна быть упомянута только один раз, Результат должен быть отсортирован по убыванию.
  Не использовать предложение GROUP BY.*/

SELECT DISTINCT Country 
FROM Customers
ORDER BY Country DESC;

/*3	Использование оператора BETWEEN, DISTINCT*/

  /*3.1	Выбрать все заказы из таблицы Order_Details (заказы не должны повторяться), где встречаются продукты с количеством от 3 до 10 включительно – это колонка Quantity в таблице Order_Details. 
  Использовать оператор BETWEEN.
  Запрос должен выбирать только колонку идентификаторы заказов.*/

SELECT DISTINCT *
FROM Order_Details WHERE QUANTITY BETWEEN 3 AND 10;

  /*3.2	Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона B и G.
  Использовать оператор BETWEEN. Проверить, что в результаты запроса попадает Germany. 
  Запрос должен выбирать только колонки сustomerID  и сountry.
  Результат должен быть отсортирован по значению столбца сountry.*/

SELECT CUSTOMERID, COUNTRY FROM Customers WHERE COUNTRY BETWEEN 'B' AND 'G'
UNION  ALL
SELECT CUSTOMERID, COUNTRY  FROM Customers WHERE COUNTRY LIKE 'G%'
ORDER BY COUNTRY;

  /*3.3	Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона B и G, не используя оператор BETWEEN.
  Запрос должен выбирать только колонки сustomerID  и сountry.
  Результат должен быть отсортирован по значению столбца сountry.
  С помощью опции “Execute Explain Plan” определить какой запрос предпочтительнее 3.2 или 3.3.
  В комментариях к текущему запросу необходимо объяснить результат.*/

SELECT CUSTOMERID, COUNTRY FROM Customers WHERE COUNTRY >= 'B' AND COUNTRY <= 'G' 
UNION  ALL
SELECT CUSTOMERID, COUNTRY  FROM Customers WHERE COUNTRY LIKE 'G%'
ORDER BY COUNTRY;

  /*В случаях 3.2 и 3.3 стоимость запроса будет одинакова, так как исходя из Explain Plan эти операции эквивалентны*/
  
/*4	Использование оператора LIKE*/

  /*4.1	В таблице Products найти все продукты (колонка productName), где встречается подстрока 'chocolade'. 
  Известно, что в подстроке 'chocolade' может быть изменена одна буква 'c' в середине - найти все продукты, которые удовлетворяют этому условию. 
  Подсказка: в результате должны быть найдены 2 строки.*/

SELECT *
FROM Products 
WHERE productName LIKE '%ho%olade%';

/*5	Использование агрегатных функций (SUM, COUNT)*/

  /*5.1	Найти общую сумму всех заказов из таблицы Order_Details с учетом количества закупленных товаров и скидок по ним. 
  Результат округлить до сотых и отобразить в стиле: $X,XXX.XX, где “$” - валюта доллары, “,” – разделитель групп разрядов,
  “.” – разделитель целой и дробной части, при этом дробная часть должна содержать цифры до сотых, пример: $1,234.00. 
  Скидка (колонка Discount) составляет процент из стоимости для данного товара.
  Для определения действительной цены на проданный продукт надо вычесть скидку из указанной в колонке unitPrice цены. 
  Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'.*/

SELECT TO_CHAR(SUM(UNITPRICE * QUANTITY * (1 - DISCOUNT)), '$9,999,999.99') AS Totals 
FROM Order_Details;

  /*5.2	По таблице Orders найти количество заказов, которые еще не были доставлены (т.е. в колонке shippedDate нет значения даты доставки). 
  Использовать при этом запросе только оператор COUNT. 
  Не использовать предложения WHERE и GROUP.*/

SELECT COUNT(*) - COUNT(shippedDate) AS Not_delivered FROM Orders;

  /*5.3	По таблице Orders найти количество различных покупателей (сustomerID), сделавших заказы. Использовать функцию COUNT и не использовать предложения WHERE и GROUP.*/

SELECT COUNT(DISTINCT CUSTOMERID) AS buyers_count FROM Orders;

/*6	Явное соединение таблиц, самосоединения, использование агрегатных функций и предложений GROUP BY и HAVING */

