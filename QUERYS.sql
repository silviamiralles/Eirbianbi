-----------------------------------------------------------QUERIES MODIFICACIO DE TAULES----------------------------------------------------------------------
-----------------------------------------------------------QUERIES FASE 2-------------------------------------------------------------------------------------

--#&& 
/* QUERY 1:
 correcte
*/
SELECT lc.city AS name, AVG((100*(7*a.price::float - a.weekly_price::float))/(7*a.price::float)) AS savings_percentage
FROM Apartment AS a, Loc_city AS lc,Host AS h
WHERE a.id_city = lc.id_city AND 
h.id_apartment = a.id_apartment AND h.host_identity_verified = 't' AND
a.weekly_price IS NOT NULL AND
a.price IS NOT NULL
GROUP BY lc.city
ORDER BY savings_percentage DESC
LIMIT 3;

--Comprovacion 1)
SELECT a.city AS name, AVG((100*(7*a.price::float - a.weekly_price::float))/(7*a.price::float)) AS savings_percentage
FROM imp_apartament AS a
WHERE a.city LIKE 'Cranbourne South' AND
a.weekly_price IS NOT NULL AND
a.price IS NOT NULL 
GROUP BY a.city;



--#&& 
/* QUERY 2:
 Tal com es pot veure a la comprovacio coincideix el nom del apartament i el preu,
 tan amb les nostres taules com ambb les taules d'importacio.
*/
SELECT a.name, (a.price_m/a.square_feet) AS price_m2, COUNT( ar.id_apartment) AS reviews
FROM  Apartment AS a,  Apartment_Reviewer AS ar,Reviewer AS r, Specification AS s
WHERE (a.id_apartment = ar.id_apartment) AND (ar.id_reviewer = r.reviewer_id)
AND (s.id_specification = a.id_specification) AND (s.property_type ='Guesthouse') AND(a.square_feet > 0) 
GROUP BY a.name, price_m2 HAVING COUNT( ar.id_apartment) > 200
ORDER BY price_m2
LIMIT 1; 

--Comprovacion 1)
SELECT a.name, a.price,a.square_feet, (a.price_m/a.square_feet) AS price_m2, COUNT(ar.id_apartment) AS contador
FROM Apartment AS a,Apartment_Reviewer AS ar
WHERE a.name LIKE 'The Stables, Island of Richmond' AND a.id_apartment = ar.id_apartment 
GROUP BY a.id_apartment;



--#&& 
/* QUERY 3:
*/

SELECT a.name, a.listing_url, ((price::money *6*5)+a.cleaning_fee::money +(0.1*a.security_deposit::money )) AS price
FROM Apartment AS a, Host AS h, Amentite_Apartment AS aa, Amentite AS am
WHERE a.neighbourhood_cleansed  LIKE 'Port Phillip' AND 
price IS NOT NULL AND
a.bathrooms > 1.5 AND 
a.accomodates = 6 AND
a.minimum_nights <=5 AND
h.id_apartment = a.id_apartment AND 
h.host_response_rate > 90 AND 
aa.id_apartment = a.id_apartment
AND am.id_amentitie = aa.id_amentitie
AND am.amentities LIKE 'Balcony'
GROUP BY a.id_apartment
ORDER BY price ASC LIMIT 1;


--Verificacio: Mostrem que el pis que s'ens mostra (el indicat) cumpleix totes les característiqus demanades 

SELECT a.name, a.listing_url,a.bathrooms,a.accomodates,a.minimum_nights, ((price::money *6*5)+a.cleaning_fee::money +(0.1*a.security_deposit::money )) AS price
FROM imp_apartament AS a, imp_host AS h
WHERE a.neighbourhood_cleansed  LIKE 'Port Phillip' AND 
price IS NOT NULL AND
a.bathrooms >= 1.5 AND 
a.accomodates = 6 AND
a.minimum_nights <=5 AND
h.listing_url = a.listing_url AND 
(h.host_response_rate > 90) AND
a.name LIKE '%Spacious Designer Apartment near Albert Park%'
ORDER BY price ASC LIMIT 1;

--#&& 
/* QUERY 4:
Com no sabem quina data es va considera com actual per realitzar 
la query hem decidit fer un cas generic, es a dir considera l'any qu estem com a actual 
i el dia el 1 de gener perque es l'inici del any. Per tan fa 5 anys seria el 1 de gener del 2015.
*/
UPDATE Host
SET host_is_superhost = 'f'
WHERE (host_since) >= '01/01/2015';

SELECT COUNT( distinct host_id) AS normal_hosts
FROM Host
WHERE host_is_superhost = 'f'; --MOSTREM EL NORMALHOST

UPDATE Host
SET host_is_superhost = 't'
WHERE (host_since) < '01/01/2015';

SELECT COUNT( distinct host_id) AS superhosts
FROM Host
WHERE host_is_superhost = 't'; --MOSTREM EL SUPERHOST



--Comprovacion SUPERHOST) 7513 // 7513

SELECT COUNT(*) FROM Host WHERE (host_since) < '01/01/2015';

--Comprovacion NORMALHOST) 15213 // 15213
SELECT COUNT(*) FROM Host WHERE (host_since) >= '01/01/2015';

--#&& 
/* QUERY 5:
*/
SELECT DISTINCT a.street, COUNT(a.street) AS num, AVG(a.price)::money AS price
FROM Apartment AS a
GROUP BY a.street HAVING  AVG(a.price)<=100
ORDER BY num DESC
LIMIT 3;

--Verification
SELECT street, COUNT(street) AS num, AVG(price)::money AS price
FROM imp_apartament 
WHERE street LIKE '%Brunswick, VIC, Australia%'
GROUP BY street;

--#&& 
/* QUERY 6:
En comparacio a la query del enunciat ens surt diferent perque la Laurie te el matixex
numero de reviews que el Michel, i tal com es pot veure en la comprovacio a les taules import 
també aparteix la Laurie abans que el Michel. Si en lloc de un limit 3 fem un limit 4 
podem veure que el seguent amb el mateix numero de reviews es el Michel.
*/
SELECT distinct p.person_name, a.listing_url, COUNT(r.reviewer_id) AS num_reviews
FROM Apartment_Reviewer AS ar, Reviewer AS r,Apartment as a, Person AS p
WHERE r.reviewer_id = ar.id_reviewer AND a.id_apartment = ar.id_apartment
AND p.id_person = r.id_person
GROUP BY ( p.id_person, p.person_name, a.id_apartment)
ORDER BY num_reviews DESC
LIMIT 3;


--Comprovacion 1)
SELECT distinct r.reviewer_name, a.listing_url, COUNT(r.reviewer_id) AS num_reviews
FROM imp_apartament AS a, imp_review AS r
WHERE a.listing_url = r.listing_url
GROUP BY (r.reviewer_id, r.reviewer_name, a.id)
ORDER BY num_reviews DESC
LIMIT 3;

--#&&
/* QUERY 7:
correcte
*/ 

SELECT DISTINCT a.id_apartment, a.name, ((a.price*a.accomodates)+a.cleaning_fee+(0.1*a.security_deposit))::money as price
FROM Apartment AS a,Loc_city AS lc, Amentite_Apartment AS aa, Amentite AS am, Host AS h, Verification_host AS vh, Verification AS v
WHERE a.accomodates >=2 AND a.id_city = lc.id_city AND
lc.city LIKE 'Saint Kilda' AND aa.id_apartment = a.id_apartment AND aa.id_amentitie = am.id_amentitie AND
am.amentities LIKE '%Kitchen%' AND a.beds >= 2 AND a.maximum_nights >= 2 AND a.minimum_nights <= 2  AND 
h.id_apartment = a.id_apartment AND vh.host_id = h.host_id AND 
vh.id_verification = v.id_verification AND v.host_verifications LIKE '%phone%'
GROUP BY  a.id_apartment HAVING ((a.price*a.accomodates)+a.cleaning_fee+(0.1*security_deposit)) <= 5000
ORDER BY price DESC;


/*Verificació: Comprovem que tots els caps compleixen les especificacions de l'enunciat desde les tables importacio, 
per exemple el Huge, stylish, central 3 br apartment with pool te 12 accomodate, city Saint Kailda
amntitie = kitchen, 8 beds, maximum_nights 1125, minimum_nights 2, host verification = phone i el price inferior a 5000.
*/
SELECT DISTINCT a.id, a.name, a.accomodates, (0.1*a.security_deposit) AS security_deposit, a.city,(a.amentities LIKE '%Kitchen%') AS amentitie_kitchen,
a.beds, a.maximum_nights, a.minimum_nights, (h.host_verifications LIKE '%phone%') AS host_verifications_phone, ((a.price*a.accomodates)+a.cleaning_fee+(0.1*a.security_deposit))::money as price
FROM imp_apartament AS a, imp_host AS h
WHERE a.accomodates >=2 AND
a.city LIKE 'Saint Kilda' AND 
a.amentities LIKE '%Kitchen%' AND a.beds >= 2 AND a.maximum_nights >= 2 AND a.minimum_nights <= 2  AND 
h.listing_url = a.listing_url 
AND h.host_verifications LIKE '%phone%' 
GROUP BY  a.id, h.host_verifications HAVING ((a.price*a.accomodates)+a.cleaning_fee+(0.1* a.security_deposit)) <= 5000
ORDER BY price DESC;


--#&& 
/* QUERY 8:
*/

DROP TABLE IF EXISTS Score_Table CASCADE;
CREATE TABLE Score_Table(
	id_score SERIAL,
	id_apartment INT,
	host_id INT,
	num_verifi INT,
	num_apart INT,
	apart_price INT,
	is_super_host CHAR,
	PRIMARY KEY (id_score),
	FOREIGN KEY (id_apartment) REFERENCES Apartment (id_apartment),
	FOREIGN KEY (host_id) REFERENCES Host (host_id)
);
INSERT INTO Score_Table (host_id, id_apartment, apart_price, is_super_host, num_verifi, num_apart)
SELECT DISTINCT h.host_id, a.id_apartment, a.price, h.host_is_superhost, COUNT(h.host_id), h.host_listing_cout
FROM Host AS h, Apartment AS a, Verification_Host AS vh, Verification AS v
WHERE h.host_id = vh.host_id AND h.id_apartment = a.id_apartment AND vh.id_verification = v.id_verification
GROUP BY h.host_id, a.id_apartment;

SELECT * FROM Score_Table ;

SELECT DISTINCT h.host_name, SUM((1/st.apart_price::float)*(1+(CASE WHEN st.is_super_host = 'true' then 1 else 0 end)) * st.num_verifi * st.num_apart) AS score
FROM Host AS h, Score_Table  AS st
WHERE h.host_id = st.host_id AND (st.apart_price <> '0') 
GROUP BY h.host_name
ORDER BY score DESC
LIMIT 3;


--Comprovacio 1) Valeria

--Numero d'apartament de la Valeria
Select COUNT(h.host_id)
FROM imp_host AS h, imp_apartament AS a
WHERE h.listing_url= a.listing_url AND host_response_time <> '-1'
AND h.host_name LIKE 'Valeria';

-- Num de verificacions de la Valeria
Select distinct h.host_name, v.host_verifications
FROM Host AS h, Apartment AS a, Verification AS v, Verification_host AS vh
WHERE h.host_id = vh.host_id AND vh.id_verification = v.id_verification AND
h.id_apartment = a.id_apartment AND h.host_name LIKE 'Valeria';

--Comprobacio del calcul: 
SELECT SUM((1/a.price::float)*(1+(CASE WHEN h.host_is_superhost = 't' then 1 else 0 end))*89*8) AS score
FROM imp_host AS h, imp_apartament AS a
WHERE h.listing_url = a.listing_url AND (a.price <> '0') 
AND h.host_id = 90729398
GROUP BY h.host_name;


--#&& 
/* QUERY 9:
*/

DROP TABLE IF EXISTS tabla_final CASCADE;
CREATE TABLE tabla_final(
	id SERIAL,
	reviewer_id INT,
	reviewer_name VARCHAR(255),
	comments TEXT,
	puntos INT,
	PRIMARY KEY (id),
	FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id)
);


INSERT INTO tabla_final (reviewer_id,reviewer_name,comments)
SELECT reviewer_id, reviewer_name, comments
FROM Reviewer AS r;

UPDATE tabla_final
SET puntos = 15
WHERE CHAR_LENGTH(comments) >= 100;

UPDATE tabla_final
SET puntos = 10
WHERE CHAR_LENGTH(comments) < 100;

SELECT * FROM tabla_final;

DROP TABLE IF EXISTS tabla_sum CASCADE; 
CREATE TABLE tabla_sum(
	reviewer_name VARCHAR(255),
	id_person INT,
	puntos_c INT,
	PRIMARY KEY (reviewer_name, id_person),
	FOREIGN KEY (id_person) REFERENCES Person (id_person)
);
INSERT INTO tabla_sum (reviewer_name, id_person, puntos_c)
SELECT tf.reviewer_name, p.id_person, SUM(tf.puntos)
FROM tabla_final AS tf, Reviewer AS r, Person AS p
WHERE tf.reviewer_id = r.reviewer_id AND r.id_person = p.id_person
GROUP BY tf.reviewer_name,p.id_person;

SELECT DISTINCT * FROM tabla_sum 
ORDER BY puntos_c DESC
LIMIT 10;

--Verificacio: Laurie

SELECT DISTINCT Count(r.reviewer_id)
FROM Person AS p, Reviewer AS r
WHERE p.id_person = 209773 AND
p.id_person = r.id_person AND CHAR_LENGTH(r.comments) >= 100;

-- 94 reviews a 15 punts la review obtenim 1410 punts.

SELECT DISTINCT Count(r.reviewer_id)
FROM Person AS p, Reviewer AS r
WHERE p.id_person = 209773 AND
p.id_person = r.id_person AND CHAR_LENGTH(r.comments) < 100;

-- 11 reviews a 10 punts la review obtenim 110 punts
--Es a dir, que en total tenim 1520 punts 

--#&& 
/* QUERY 10: */

SELECT a.name, a.price_m AS price, s.property_type, COUNT(r.reviewer_id) AS review, lc.city
FROM  Apartment AS a,  Apartment_Reviewer AS ar,Reviewer AS r, Specification AS s, Loc_city AS lc
WHERE a.id_apartment = ar.id_apartment
AND (ar.id_reviewer = r.reviewer_id)
AND (s.id_specification = a.id_specification)
AND (lc.id_city = a.id_city)
AND (lc.city LIKE 'F%')
AND (s.property_type ='House')
AND(a.square_feet >0) 
GROUP BY a.name, a.price_m , a.square_feet ,  s.property_type, lc.city HAVING COUNT(r.reviewer_id) > 30
ORDER BY review DESC;

--Comprobacio 1)

SELECT a.name, CONCAT('$', + a.price* 1.00) , a.property_type, COUNT(r.reviewer_id) AS review, a.city
FROM  imp_apartament AS a, imp_review AS r
WHERE a.listing_url = r.listing_url
AND (a.city LIKE 'F%')
AND (a.property_type ='House')
AND(a.square_feet >0) 
GROUP BY a.name, a.price , a.square_feet ,  a.property_type, a.city HAVING COUNT(r.reviewer_id) > 30
ORDER BY review DESC;