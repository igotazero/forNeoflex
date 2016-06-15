/*1	Работа с типами данных Date, NULL значениями, трехзначная логика.
Возвращение определенных значений в результатах запроса в зависимости от полученных первоначальных значений результата запроса.
Выборка в результатах запроса только определенных колонок.*/

/*1.1	Выбрать из таблицы Orders заказы, которые были доставлены после 5 мая 1998 года (колонка shippedDate) включительно и которые доставлены с shipVia >= 2. 
Формат указания даты должен быть верным при любых региональных настройках.
Этот метод использовать далее для всех заданий.
Запрос должен выбирать только колонки orderID, shippedDate и shipVia. 
Пояснить, почему сюда не попали заказы с NULL-ом в колонке shippedDate. 
*/

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

/**/


