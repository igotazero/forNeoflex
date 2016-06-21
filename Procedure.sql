/*13	Разработка функций и процедур*/

  /*13.1	Написать процедуру, которая возвращает самый крупный заказ для каждого из продавцов за определенный год. 
  В результатах не может быть несколько заказов одного продавца, должен быть только один и самый крупный. 
  В результатах запроса должны быть выведены следующие колонки: колонка с именем и фамилией продавца (firstName и lastName – пример: Nancy Davolio), номер заказа и его стоимость.
  В запросе надо учитывать Discount при продаже товаров. Процедуре передается год, за который надо сделать отчет, и количество возвращаемых записей. 
  Результаты запроса должны быть упорядочены по убыванию суммы заказа. Название процедуры GreatestOrders.
  Необходимо продемонстрировать использование этой процедуры.
  Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
  Также помимо демонстрации вызова процедуры в скрипте Query.sql надо написать отдельный ДОПОЛНИТЕЛЬНЫЙ проверочный запрос для тестирования правильности работы процедуры GreatestOrders. 
  Проверочный запрос должен выводить в удобном для сравнения с результатами работы процедур виде для определенного продавца для всех его заказов за определенный указанный
  год в результатах следующие колонки: имя продавца, номер заказа, сумму заказа.
  Проверочный запрос не должен повторять запрос, написанный в процедуре, - он должен выполнять только то, что описано в требованиях по нему.
  ВСЕ ЗАПРОСЫ ПО ВЫЗОВУ ПРОЦЕДУР ДОЛЖНЫ БЫТЬ НАПИСАНЫ В ФАЙЛЕ Query.sql – см. пояснение ниже в разделе: 
  */

CREATE OR REPLACE PROCEDURE GreatestOrders(year VARCHAR2, countN NUMBER) IS
n NUMBER := countN;
CURSOR resCur IS
SELECT res2.name, orient.idOri, res2.summ FROM
(SELECT res1.name, MAX(sum) summ FROM
  (SELECT e.LASTNAME || ' ' || e.FIRSTNAME name, res.SUM FROM EMPLOYEES e
  LEFT JOIN
  (SELECT * FROM ORDERS oo WHERE TO_CHAR(oo.ORDERDATE, 'YYYY') = year) o ON e.EMPLOYEEID = o.EMPLOYEEID
  LEFT JOIN
  (SELECT ORDERID id, SUM(UNITPRICE * QUANTITY * (1 - DISCOUNT)) sum FROM ORDER_DETAILS GROUP BY ORDERID) res ON res.id = o.ORDERID) res1
GROUP BY res1.name) res2
LEFT JOIN
(SELECT ord.ORDERID idOri, SUM(ord.UNITPRICE * ord.QUANTITY * (1 - ord.DISCOUNT)) sumOri FROM ORDER_DETAILS ord GROUP BY ord.ORDERID) orient
ON orient.sumOri = res2.summ ORDER BY res2.summ DESC;

BEGIN
  FOR i IN resCur
    LOOP
       n := n - 1;
       IF (n < 0) THEN
       EXIT;
       END IF;
      SYS.DBMS_OUTPUT.PUT_LINE(i.NAME || '/' || i.idOri || '/' || i.summ);
    END LOOP;
END GreatestOrders;
/

  /*13.2	Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях (разница между orderDate и shippedDate). 
  В результатах должны быть возвращены заказы, срок которых превышает переданное значение или еще недоставленные заказы.
  Значению по умолчанию для передаваемого срока 35 дней. Название процедуры ShippedOrdersDiff.
  Процедура должна выводить следующие колонки:
  orderID, orderDate, shippedDate, ShippedDelay (разность в днях между shippedDate и orderDate), specifiedDelay (переданное в процедуру значение). 
  Результат должен быть отсортирован по shippedDelay. 
  Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
  Необходимо продемонстрировать использование этой процедуры.
  */
