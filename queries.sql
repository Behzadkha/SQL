
/*1*/
--Refrence for TIMESTAMP:http://www.mysqltutorial.org/mysql-timestamp.aspx
SELECT DISTINCT Passenger.PassengerID, FirstName, LastName, Sex, DateOfBirth
FROM Person, Passenger, Take
WHERE Passenger.PassengerID = ID AND
 TIMESTAMPDIFF(256,CHAR(TIMESTAMP(CURRENT TIMESTAMP) - TIMESTAMP(DateOfBirth,CURRENT TIME))) >= 18 AND
 Occupation LIKE '%Student' AND Take.passengerid = passenger.passengerid AND Take.flightnumber = 11 AND  DAY(Take.date) = 20 AND Month(Take.date) = 1;

/*2*/
SELECT air.carrier, air.name
FROM airline air, class , operate
WHERE air.carrier = operate.carrier AND class.date = operate.date AND class.flightnumber = operate.flightnumber AND
class.schedarrtime = operate.schedarrtime AND class.scheddeptime = operate.scheddeptime
GROUP BY air.carrier, air.name
HAVING SUM(class.fare) >= ALL (SELECT SUM(c.fare)
FROM airline,class c,operate o
WHERE airline.carrier = o.carrier AND c.date = o.date AND c.flightnumber = o.flightnumber AND c.schedarrtime = o.schedarrtime AND c.scheddeptime = o.scheddeptime
GROUP BY airline.carrier);

/*3*/
SELECT DISTINCT airline.carrier, airline.name, count(*)
FROM airline, operate o, flight f
WHERE airline.carrier = o.carrier AND f.flightnumber = o.flightnumber AND f.schedarrtime = o.schedarrtime AND f.scheddeptime = o.scheddeptime AND f.date = o.date AND  f.schedarrtime < f.arrtime
Group by airline.carrier, airline.name
ORDER BY count(*) DESC;

/*4*/
SELECT city.name
FROM city
WHERE (SELECT COUNT (*) FROM AirportInCity WHERE city.name = AirportInCity.name AND city.country = AirportInCity.country) >= 3;

/*5*/
SELECT route.origin, route.dest
FROM route, routeserve r
WHERE r.origin = route.origin AND r.dest = route.dest
GROUP BY route.origin, route.dest
HAVING COUNT(*) <= ALL(SELECT COUNT(*) FROM routeserve GROUP BY routeserve.origin, routeserve.dest);

SELECT DISTINCT airline.carrier, airline.name
FROM airline
WHERE airline.carrier IN
(SELECT o.carrier FROM operate o, flight, routeserve r
WHERE flight.flightnumber = r.flightnumber AND flight.date = r.date AND flight.schedarrtime = r.schedarrtime AND
flight.scheddeptime = r.scheddeptime AND o.flightnumber = flight.flightnumber AND o.date = flight.date AND 
o.scheddeptime = flight.scheddeptime AND o.schedarrtime = flight.schedarrtime
GROUP BY o.carrier
HAVING COUNT(DISTINCT r.flightnumber) = 1)
GROUP BY airline.carrier, airline.name;

SELECT DISTINCT airline.carrier, airline.name
FROM airline, operate, flight
WHERE airline.carrier = operate.carrier AND operate.flightnumber = flight.flightnumber
AND operate.date = flight.date AND operate.scheddeptime = flight.scheddeptime AND
operate.schedarrtime = flight.schedarrtime AND operate.carrier NOT IN
(SELECT DISTINCT o.carrier FROM routeserve rs, operate o, flight f
WHERE rs.flightnumber = f.flightnumber AND rs.date = f.date AND rs.scheddeptime = f.scheddeptime AND rs.schedarrtime = f.schedarrtime AND rs.origin NOT IN ('EWR','JFK') AND o.flightnumber = f.flightnumber AND o.date = f.date AND o.scheddeptime = f.scheddeptime AND o.schedarrtime = f.schedarrtime
);

SELECT DISTINCT airline.carrier, airline.name
FROM airline
WHERE airline.carrier IN
(SELECT o.carrier FROM operate o, flight, routeserve r
WHERE flight.flightnumber = r.flightnumber AND flight.date = r.date AND flight.schedarrtime = r.schedarrtime AND
flight.scheddeptime = r.scheddeptime AND o.flightnumber = flight.flightnumber AND o.date = flight.date AND 
o.scheddeptime = flight.scheddeptime AND o.schedarrtime = flight.schedarrtime
GROUP BY o.carrier
HAVING COUNT(DISTINCT r.flightnumber) <= 2
)
GROUP BY airline.carrier, airline.name;


/*6*/
SELECT airline.carrier,airline.name, COUNT(*)
FROM airline, take, operate
WHERE airline.carrier = operate.carrier AND operate.schedarrtime = take.schedarrtime AND operate.date = take.date AND operate.flightnumber = take.flightnumber AND operate.scheddeptime = take.scheddeptime AND take.date BETWEEN DATE('2013-01-01') and DATE('2013-01-03')
GROUP BY airline.carrier, airline.name;

SELECT DISTINCT routeserve.origin, routeserve.dest
FROM take, routeserve
WHERE take.date = routeserve.date AND take.schedarrtime = routeserve.schedarrtime AND routeserve.scheddeptime = take.scheddeptime
AND routeserve.flightnumber = take.flightnumber AND routeserve.dest <> 'LAX'
GROUP BY routeserve.origin, routeserve.dest
HAVING COUNT(take.passengerid) > 500;

SELECT DISTINCT aircity.name
FROM airportincity aircity
WHERE (SELECT COUNT(*) FROM take, routeserve
WHERE aircity.code = routeserve.dest AND take.date = routeserve.date AND take.scheddeptime = routeserve.scheddeptime AND take.flightnumber = routeserve.flightnumber AND  take.schedarrtime = routeserve.schedarrtime
GROUP BY routeserve.dest) >= ALL(SELECT COUNT(*) FROM take t, routeserve r, airportincity air
WHERE air.code = r.dest AND  t.flightnumber = r.flightnumber AND t.date = r.date AND t.schedarrtime = r.schedarrtime AND t.scheddeptime = r.scheddeptime
GROUP BY r.dest);

/*7*/
SELECT DISTINCT pass.passengerid, person.firstname, person.lastname
FROM person ,passenger pass, routeserve r, routeserve rb, take t, take tb
WHERE person.id = pass.passengerid AND pass.passengerid = t.passengerid AND pass.passengerid = tb.passengerid
AND MONTH(t.date) = '01' AND MONTH(tb.date) = '01' AND  r.dest = rb.origin AND r.origin = rb.dest AND t.flightnumber = r.flightnumber AND t.date = r.date AND t.scheddeptime = r.scheddeptime AND t.schedarrtime = r.schedarrtime AND tb.flightnumber = rb.flightnumber AND tb.date = rb.date AND tb.scheddeptime = rb.scheddeptime AND tb.schedarrtime = rb.schedarrtime;

/*8*/
SELECT DISTINCT person.id, person.firstname, person.lastname
FROM passenger, person ,take, flight f, routeserve r, route, airport , airportincity a
WHERE a.name = 'Los Angeles' AND person.id = passenger.passengerid AND take.passengerid = passenger.passengerid AND
take.flightnumber = f.flightnumber AND take.date = f.date AND take.schedarrtime = f.schedarrtime AND take.scheddeptime = f.scheddeptime
AND r.flightnumber = f.flightnumber AND r.date = f.date AND r.schedarrtime = f.schedarrtime AND r.scheddeptime = f.scheddeptime 
AND route.origin = r.origin AND route.dest = r.dest AND airport.code = route.origin AND a.code = airport.code
GROUP BY person.id, person.firstname, person.lastname
HAVING COUNT(*) >= 3;

/*9*/
SELECT airport.code, airport.name
FROM airport, routeserve, take
WHERE airport.code = routeserve.origin AND routeserve.flightnumber = take.flightnumber AND routeserve.date = take.date AND routeserve.schedarrtime = take.schedarrtime AND routeserve.scheddeptime = take.scheddeptime AND  take.date BETWEEN DATE ('2013-01-01') and ('2013-01-07')
GROUP BY airport.code, airport.name
HAVING COUNT(*) > 1000;

/*10*/
SELECT routeserve.origin, routeserve.dest, COUNT(airline.carrier)
FROM routeserve, route, airline, flight, operate
WHERE routeserve.origin = route.origin AND routeserve.dest = route.dest AND routeserve.date = flight.date AND routeserve.flightnumber = flight.flightnumber AND flight.schedarrtime = routeserve.schedarrtime AND flight.scheddeptime = routeserve.scheddeptime AND flight.date = operate.date AND flight.flightnumber = operate.flightnumber AND flight.schedarrtime = operate.schedarrtime AND flight.scheddeptime = operate.scheddeptime AND airline.carrier = operate.carrier
Group by routeserve.origin, routeserve.dest
Having COUNT(airline.carrier) >= 5;

SELECT route.origin, route.dest
FROM route, routeserve rs, flight, class
WHERE route.origin = rs.origin AND route.dest = rs.dest AND flight.date = rs.date AND flight.flightnumber = rs.flightnumber  AND flight.schedarrtime = rs.schedarrtime AND flight.scheddeptime = rs.scheddeptime AND flight.date = class.date AND flight.schedarrtime = class.schedarrtime AND flight.scheddeptime = class.scheddeptime AND flight.flightnumber = class.flightnumber
GROUP BY route.origin, route.dest
HAVING SUM(class.fare) >= ALL(SELECT SUM(class.fare) FROM class, flight
WHERE flight.flightnumber = class.flightnumber AND flight.date = class.date AND flight.schedarrtime = class.schedarrtime AND
flight.scheddeptime = class.scheddeptime
GROUP BY class.flightnumber);

/*11*/
SELECT DISTINCT a.carrier, a.name
FROM airline a, airline air,operate op, operate o, class, class c, routeserve rs, routeserve r
WHERE a.carrier = op.carrier AND class.date = op.date AND class.scheddeptime = op.scheddeptime AND class.schedarrtime = op.schedarrtime AND class.flightnumber = op.flightnumber AND rs.date = op.date AND rs.scheddeptime = op.scheddeptime AND rs.schedarrtime = op.schedarrtime AND rs.flightnumber = op.flightnumber AND air.carrier = o.carrier  AND c.date = o.date AND c.scheddeptime = o.scheddeptime AND c.schedarrtime = o.schedarrtime AND c.flightnumber = o.flightnumber  AND r.date = o.date AND r.scheddeptime = o.scheddeptime AND r.schedarrtime = o.schedarrtime AND r.flightnumber = o.flightnumber
AND c.fare = class.fare AND a.carrier <> air.carrier  AND r.origin = rs.origin AND r.dest = rs.dest;

/*12*/
SELECT DISTINCT person.id, person.firstname, person.lastname
FROM person ,passenger
WHERE person.id = passenger.passengerid AND NOT EXISTS (SELECT take.passengerid FROM take WHERE
passenger.passengerid = take.passengerid);

SELECT DISTINCT person.id, person.firstname, person.lastname
FROM person, take, passenger p, routeserve r, airportincity a
WHERE person.id = p.passengerid AND take.passengerid = p.passengerid AND r.date = take.date AND
r.flightnumber = take.flightnumber AND r.schedarrtime = take.schedarrtime AND r.scheddeptime = take.scheddeptime AND a.code = r.dest AND a.name <> person.city;

/*13*/
SELECT a.carrier, airplane.Tailnum
FROM AirlineOwnAirplane a RIGHT OUTER JOIN airplane on airplane.tailnum = a.tailnum
GROUP BY a.carrier, airplane.Tailnum;

