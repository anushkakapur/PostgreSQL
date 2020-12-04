-- START Q1
SELECT CONCAT(e.firstname,' ', e.lastname)employeename, orderid, orderdate, companyname customername
FROM orders o 
JOIN employees e ON e.employeeid = o.employeeid
JOIN customers c ON c.customerid = o.customerid
LIMIT 10;
-- END Q1


-- START Q2
SELECT categoryname, supplierid, unitsinstock remainingunits
FROM products p 
JOIN categories c ON c.categoryid = p.categoryid
WHERE discontinued = 0 AND unitsinstock = 0;

-- END Q2

-- START Q3
SELECT c.customerid, companyname, contactname, contacttitle
FROM customers c
JOIN orders o ON o.customerid = c.customerid
GROUP BY c.customerid, companyname, contactname, contacttitle
HAVING COUNT(*) < 5;
-- END Q3

-- START Q4
SELECT categoryname, COUNT(*) numberofproducts
FROM products p 
JOIN categories c ON c.categoryid = p.categoryid
WHERE unitsinstock >0
GROUP BY categoryname;
-- END Q4

-- START Q5
SELECT COUNT(DISTINCT cu.customerid) num_customers
FROM products p 
JOIN categories c ON c.categoryid = p.categoryid 
JOIN order_details od ON od.productid = p.productid
JOIN orders o ON o.orderid = od.orderid
JOIN customers cu ON cu.customerid = o.customerid
WHERE categoryname = 'Seafood';
-- END Q5

-- START Q6
SELECT country, COUNT(DISTINCT no_order_customers.customerid) nonactive_customers
FROM (SELECT c.*
FROM customers c
LEFT JOIN orders o ON c.customerid = o.customerid
WHERE o.orderid IS NULL) no_order_customers
GROUP BY 1;
-- END Q6

-- START Q7
SELECT e.employeeid, CONCAT(e.firstname,' ',e.lastname),SUM(unitprice*quantity)
FROM employees e 
JOIN orders o ON e.employeeid = o.employeeid
JOIN order_details od ON od.orderid = o.orderid
GROUP BY e.employeeid
HAVING title NOT IN ('Vice President of Sales')
ORDER BY 3 DESC
LIMIT 3;
-- END Q7


-- START Q8 **FIX
SELECT companyname, COUNT(*), (SELECT COUNT(*)
							   FROM orders o
							   WHERE shippeddate<requireddate
							  )
FROM customers c
JOIN orders o ON o.customerid = c.customerid
GROUP BY companyname
ORDER BY 2 DESC;
-- END Q8


-- START Q9
SELECT companyname, COUNT(*) shipped_orders
FROM shippers s
JOIN orders o ON o.shipvia = s.shipperid
GROUP BY companyname
ORDER BY 2 
LIMIT 1;
-- END Q9


-- START Q10
SELECT CONCAT(e.firstname, ' ', e.lastname), COUNT(*) num_orders, CASE WHEN COUNT(*)>=75 THEN 'High Performer'
WHEN COUNT(*)>= 50 THEN 'Mid Tier'
ELSE 'Low Performer' END AS performance_rating
FROM employees e
JOIN orders o ON o.employeeid = e.employeeid
GROUP by firstname, lastname;
-- END Q10

