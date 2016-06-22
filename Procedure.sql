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

CREATE OR REPLACE PROCEDURE ShippedOrdersDiff(different OUT NUMBER) IS
sd VARCHAR2(32767);
CURSOR resCursor IS
  (SELECT orderID, orderDate, shippedDate, (shippedDate - orderDate) ShippedDelay FROM Orders);

BEGIN
  IF (different IS NULL) THEN
    different := 35;
  END IF;

  FOR i IN resCursor
    LOOP
      IF (i.ShippedDelay >= different OR i.ShippedDelay IS NULL) THEN
        IF (i.ShippedDelay IS NULL) THEN
          sd := 'Not shipped'; 
            ELSE
          sd := i.shippedDate;
        END IF;
        SYS.DBMS_OUTPUT.PUT_LINE(i.orderID || ' Order date: ' || i.orderDate || ' Shipped date: ' ||
        sd || ' Shipped delay: ' || i.ShippedDelay || ' Specified delay' || TO_CHAR(different));
      END IF;
    END LOOP;
END;
/

    /*13.3	Написать процедуру, которая выводит всех подчиненных заданного продавца, как непосредственных, так и подчиненных его подчиненных.
    В качестве входного параметра процедуры используется employeeID. 
    Необходимо вывести столбцы employeeID, имена подчиненных и уровень вложенности согласно иерархии подчинения.
    Продавец, для которого надо найти подчиненных также должен быть высвечен. Название процедуры SubordinationInfo.
    Необходимо использовать конструкцию START WITH … CONNECT BY. 
    Подсказка: для вывода результатов можно использовать DBMS_OUTPUT.
    Продемонстрировать использование процедуры. 
    Написать проверочный запрос, который вывод всё дерево продавцов.*/
    
CREATE OR REPLACE PROCEDURE SubordinationInfo(empID IN OUT NUMBER) IS
CURSOR resCursor IS
  (SELECT FIRSTNAME || ' ' || LASTNAME boss, NULL inferior, NULL lvl
  FROM EMPLOYEES
  WHERE EMPLOYEEID = empID
  UNION ALL
  SELECT FIRSTNAME || ' ' || LASTNAME boss, res.n inferior, res.l lvl FROM EMPLOYEES e
    INNER JOIN
      (SELECT REPORTSTO r, FIRSTNAME || '' || LASTNAME n, level l  
      FROM EMPLOYEES
      CONNECT BY PRIOR EMPLOYEEID = REPORTSTO
      START WITH REPORTSTO = empID) res
    ON e.EMPLOYEEID = res.r);

BEGIN
  FOR i IN resCursor
    LOOP
      IF (i.inferior IS NULL) THEN
        SYS.DBMS_OUTPUT.PUT_LINE('Boss: ' || i.BOSS);
      ELSE
        SYS.DBMS_OUTPUT.PUT_LINE('Boss: ' || i.BOSS || ' /Inferior: ' || i.inferior || ' /Level: ' || i.lvl);
      END IF;
    END LOOP;
END;
/

  /*13.4	Написать функцию, которая определяет, есть ли у продавца подчиненные и возвращает их количество - тип данных INTEGER.
  В качестве входного параметра функции используется employeeID.
  Название функции IsBoss.
  Продемонстрировать использование функции для всех продавцов из таблицы Employees.*/

CREATE OR REPLACE FUNCTION IsBoss(empID IN INTEGER) RETURN INTEGER 
IS
c INTEGER := 0;
CURSOR resCursor IS
  (SELECT e.FIRSTNAME || ' ' || e.LASTNAME 
  FROM EMPLOYEES e
  WHERE e.REPORTSTO = empID);

BEGIN
  FOR i IN resCursor
    LOOP
      c := c + 1;
    END LOOP;
    RETURN(c);
END IsBoss;
/