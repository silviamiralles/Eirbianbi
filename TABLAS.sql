-------------------------------------------- TAULAS -----------------------------------------------------------------------
--Primer de tot fem drop i creacio de totes les taulas.

DROP TABLE IF EXISTS Loc_country CASCADE;
CREATE TABLE Loc_country(
  id_country SERIAL,
  country_code CHAR(2),
  country VARCHAR(255),
  PRIMARY KEY (country_code)
);

DROP TABLE IF EXISTS Loc_state CASCADE;
CREATE TABLE Loc_state(
  id_state SERIAL,
  state VARCHAR(255),
  PRIMARY KEY (id_state)
);

DROP TABLE IF EXISTS Loc_city CASCADE;
CREATE TABLE Loc_city (
  id_city SERIAL,
  zipcode VARCHAR(255),
  city VARCHAR(255),
  PRIMARY KEY (id_city)
);

DROP TABLE IF EXISTS Specification CASCADE; 
CREATE TABLE Specification(
  id_specification SERIAL,
  property_type VARCHAR(255),
  PRIMARY KEY (id_specification)
);

DROP TABLE IF EXISTS Apartment CASCADE;
CREATE TABLE Apartment (
  id_apartment SERIAL,
  listing_url VARCHAR(255),
  name VARCHAR(255),
  description TEXT,
  picture_url VARCHAR(255),
  neighbourhood_cleansed VARCHAR(255),
  id_city BIGINT,
  id_state INT,
  country_code CHAR(2),
  id_specification INT,
  street TEXT,
  price INT,
  price_m MONEY,
  weekly_price INT,
  monthly_price INT,
  cleaning_fee INT,
  security_deposit INT,
  accomodates INT,
  bathrooms FLOAT,
  bedrooms INT,
  beds INT,
  amentities TEXT,
  square_feet INT,
  minimum_nights INT,
  maximum_nights INT,
  PRIMARY KEY (id_apartment),
  FOREIGN KEY(id_city) REFERENCES Loc_city(id_city),
  FOREIGN KEY(id_state) REFERENCES Loc_state(id_state),
  FOREIGN KEY(country_code) REFERENCES Loc_country(country_code),
  FOREIGN KEY(id_specification) REFERENCES Specification (id_specification)
);

DROP TABLE IF EXISTS Host CASCADE;
CREATE TABLE Host(
	host_id SERIAL,
	host_url VARCHAR(255),
	host_name VARCHAR(255),
	host_since DATE,
	host_about TEXT,
	host_response_time VARCHAR(255),
	host_response_rate INT,
	host_is_superhost CHAR,
	host_picture_url VARCHAR(255),
	host_listing_cout INT,
	host_identity_verified BOOLEAN,
	id_apartment INT,
	PRIMARY KEY (host_id),
	FOREIGN KEY(id_apartment) REFERENCES Apartment(id_apartment)

);

DROP TABLE IF EXISTS Verification_table CASCADE; -- Taula verificacio NO neta
CREATE TABLE Verification_table(
	id_veri_brut SERIAL,
	host_verifications TEXT,
	host_verifications_x TEXT,
	host_identity_verified BOOLEAN
	
);

DROP TABLE IF EXISTS Verification_table_1 CASCADE; -- Taula de verificacio SI neta
CREATE TABLE Verification_table_1(
	id_veri_net SERIAL,
	host_verifications TEXT
);

DROP TABLE IF EXISTS Verification CASCADE; --Taula de Verificacions complerta
CREATE TABLE Verification(
	id_verification SERIAL,
	host_url VARCHAR(255),
	host_verifications TEXT,
	host_identity_verified BOOLEAN,
	PRIMARY KEY (id_verification)
	
);

DROP TABLE IF EXISTS Verification_Host CASCADE; 
CREATE TABLE Verification_Host(
	id_verification INT,
	host_id INT,
	PRIMARY KEY (id_verification,host_id),
	FOREIGN KEY (id_verification) REFERENCES Verification(id_verification),
	FOREIGN KEY (host_id) REFERENCES Host(host_id)
);

DROP TABLE IF EXISTS amentiti_table CASCADE; -- Conte els arrays nets i bruts
CREATE TABLE amentiti_table(
	amentities TEXT,
	amenti_array TEXT
);

DROP TABLE IF EXISTS amentitie_table_1 CASCADE;
CREATE TABLE amentitie_table_1(
	amentitie TEXT
);


DROP TABLE IF EXISTS Amentite CASCADE;
CREATE TABLE Amentite(
	id_amentitie SERIAL,
	Amentities TEXT,
	PRIMARY KEY (id_amentitie)

);

DROP TABLE IF EXISTS Amentite_Apartment CASCADE;
CREATE TABLE Amentite_Apartment(
	id_amentitie INT,
	id_apartment INT,
	PRIMARY KEY (id_apartment,id_amentitie),
	FOREIGN KEY (id_apartment) REFERENCES Apartment(id_apartment),
	FOREIGN KEY (id_amentitie) REFERENCES Amentite(id_amentitie)

);

DROP TABLE IF EXISTS Person CASCADE;
CREATE TABLE Person(
  id_person SERIAL,
  reviewer_id INT,
  person_name VARCHAR(255),
  PRIMARY KEY (id_person)
);

DROP TABLE IF EXISTS Reviewer CASCADE;
CREATE TABLE Reviewer(
	reviewer_id SERIAL,
	id_person INT,
	reviewer_name VARCHAR(255),
	listing_url VARCHAR(255),
	name VARCHAR(255),
	description TEXT,
	picture_url VARCHAR(255),
	street VARCHAR(255),
	neighborhood_cleased VARCHAR(255),
	city VARCHAR(255),
	comments TEXT,
	date_review DATE,
	PRIMARY KEY (reviewer_id),
	FOREIGN KEY (id_person) REFERENCES Person (id_person)
);

DROP TABLE IF EXISTS Apartment_Reviewer CASCADE;
CREATE TABLE Apartment_Reviewer(
	id_apartment INT,
	id_reviewer INT,
	PRIMARY KEY (id_apartment, id_reviewer),
	FOREIGN KEY (id_apartment) REFERENCES Apartment(id_apartment),
	FOREIGN KEY (id_reviewer) REFERENCES Reviewer(reviewer_id)
);
----------------------------------------------- INSERTS ----------------------------------------------
--Fem l'insert de la localitzacio de country.
INSERT INTO Loc_country (country_code, country)
SELECT DISTINCT country_code, country
FROM imp_apartament;

--Comprobem que s'ompli.
SELECT * FROM Loc_country;

--Fem l'insert de la localitzacio de state.
INSERT INTO Loc_state (state)
SELECT DISTINCT state
FROM imp_apartament;

--Comprobem que s'ompli.
SELECT * FROM Loc_state;

--Fem l'insert de la localitzacio de city.
INSERT INTO Loc_city (city, zipcode)
SELECT DISTINCT city, zipcode
FROM imp_apartament;

--Comprobem que s'ompli.
SELECT * FROM Loc_city;

--Fem l'insert de specification on hi ha els tipus d'apartament que pot haver-hi.
INSERT INTO Specification (property_type)
SELECT DISTINCT property_type
FROM imp_apartament;

--Comprobem que s'ompli.
SELECT * FROM Specification;

/*Fem l'insert d'apartment, com tenim una relacio 1:N 
amb les taules Loc_city, Loc_state i Loc_country passem les pk's com fk´s
i en el cas de specification tambe posem con a fk la seva pk perque tenim una relacio 1:1
*/
INSERT INTO Apartment(listing_url, name, description, picture_url, neighbourhood_cleansed, id_city, id_state, country_code, id_specification, street,price, price_m, weekly_price, monthly_price, cleaning_fee, security_deposit, accomodates, bathrooms, bedrooms, beds, amentities, square_feet, minimum_nights, maximum_nights)
SELECT ia.listing_url, ia.name, ia.description, ia.picture_url, ia.neighbourhood_cleansed, lci.id_city, ls.id_state, lc.country_code, s.id_specification,ia.street, ia.price, ia.price::money, ia.weekly_price, ia.monthly_price, ia.cleaning_fee, ia.security_deposit, ia.accomodates, ia.bathrooms, ia.bedrooms, ia.beds, ia.amentities, ia.square_feet, ia.minimum_nights, ia.maximum_nights
FROM imp_apartament AS ia, Loc_city AS lci, Loc_state AS ls, Loc_country AS lc, Specification AS s
WHERE (lci.city = ia.city AND lci.zipcode = ia.zipcode) AND (ls.state = ia.state) AND (lc.country_code = ia.country_code) AND (s.property_type LIKE ia.property_type);

SELECT * FROM Apartment;

/*Fem l'insert de host, com tenim una relacio 1:N 
amb la taula Apartment posem la pk com fk i utilitzem 
productes cartesiands per vincularles.
*/
INSERT INTO Host( host_url, host_name, host_since,
host_about, host_response_time, host_response_rate, host_is_superhost,
host_picture_url,host_listing_cout, host_identity_verified, id_apartment) 
SELECT DISTINCT ih.host_url, ih.host_name, ih.host_since,
ih.host_about, ih.host_response_time, ih.host_response_rate, ih.host_is_superhost,
ih.host_picture_url, ih.host_listing_cout, ih.host_identity_verified, a.id_apartment
FROM imp_host AS ih, Apartment AS a, imp_apartament AS ia
WHERE a.listing_url = ia.listing_url AND  ia.listing_url = ih.listing_url;

SELECT * FROM Host;

/*Insertem el host_verification dues vegades 
per poder tenir l'array net i el buit relacionats, 
ademes afegim el boolea.
*/
INSERT INTO Verification_table ( host_verifications, host_verifications_x, host_identity_verified)
SELECT DISTINCT regexp_split_to_table(host_verifications, ','), host_verifications, host_identity_verified
FROM imp_host;

/*Del array que volem netejar anem treien 
tots els signes inecesaris com son els [] i les cometes.
*/
UPDATE Verification_table
SET host_verifications = TRIM('[]'  FROM  host_verifications);

UPDATE Verification_table
SET host_verifications = REPLACE(host_verifications, '''', '');

--Comprovem que es guarda l'array net i el brut.
SELECT * FROM Verification_table; 

--Insertem nomes l'array net.
INSERT INTO Verification_table_1 ( host_verifications)
SELECT DISTINCT  vt.host_verifications 
FROM Verification_table AS vt ;

--Comprovem que es guarda l'array net.
SELECT * FROM Verification_table_1; 

/*Fem l'insert de la verification utilitzant les dos tables anteriors 
per passar l'array net i utilitzem els productes cartesians per vincular 
host, imp_host, la verificacion_table (ambb l'array net i el brut) 
i la taula verification_table_1 amb l'array net.
*/
INSERT INTO Verification ( host_url,host_verifications ,host_identity_verified)
SELECT DISTINCT ih.host_url,v1.host_verifications, ih.host_identity_verified 
FROM imp_host AS ih, Verification_table AS vt, Host AS h, Verification_table_1 AS v1
WHERE (ih.host_url = h.host_url) AND (vt.host_verifications_x = ih.host_verifications)
AND (vt.host_verifications = v1.host_verifications)AND (h.host_identity_verified  = vt.host_identity_verified );

--Comprovem que s'omple la tuala verification.
SELECT DISTINCT * FROM Verification;

--Insertem el id de la taula verification i el id de la taula host fent productes cartesians.
INSERT INTO Verification_Host (id_verification,host_id)
SELECT  DISTINCT v.id_verification,h.host_id 
FROM Verification AS v, imp_host AS ih, Host AS h
WHERE v.host_url = ih.host_url AND ih.host_picture_url= h.host_picture_url;

--Comprovem que s'omple la tuala verification_host.
SELECT * FROM Verification_Host; 

/*Insertem amentities dues vegades 
per poder tenir l'array net
*/
INSERT INTO amentiti_table(amentities, amenti_array)
SELECT DISTINCT regexp_split_to_table(amentities, ','), a.amentities
FROM imp_apartament AS a;

/*Del array que volem netejar anem treien 
tots els signes inecesaris com son els {} i les cometes.
*/
UPDATE amentiti_table
SET amentities = TRIM('{}'  FROM  amentities);

UPDATE amentiti_table
SET amentities = TRIM('""'  FROM  amentities);

--Comprovem que es guarda l'array net i el brut.
SELECT * FROM amentiti_table; 

--Insertem nomes l'array net.
INSERT INTO amentitie_table_1 (amentitie) 
SELECT DISTINCT amentities
FROM amentiti_table; 

--Comprovem que es guarda l'array net.
SELECT* FROM amentitie_table_1;

/*Fem l'insert de la amentites utilitzant les dos tables anteriors 
per passar l'array net i utilitzem els productes cartesians per vincular.
*/
INSERT INTO Amentite( amentities) 
SELECT DISTINCT amentitie 
FROM amentitie_table_1 AS am1;

--Comprovem que s'omple la taula amentite.
SELECT * FROM Amentite;

/*Fem l'insert dels dos id de les taules amentite i apartment 
fent productes cartesians per vincular cada fragment de les amentities amb el seu apartament.
*/
INSERT INTO Amentite_Apartment (id_amentitie,id_apartment)
SELECT  DISTINCT am.id_amentitie,ap.id_apartment
FROM Amentite AS am, imp_apartament AS ia, Apartment AS ap
WHERE ('%'|| ap.amentities ||'%') LIKE ('%'||  am.Amentities ||'%') AND ia.listing_url= ap.listing_url;

--Comprovem que s'omple la taula amentite_apartment.
SELECT * FROM Amentite_Apartment;

/*Fem l'insert de la tabla person per agrupar els reviews per persona*/
INSERT INTO Person (person_name, reviewer_id)
SELECT DISTINCT reviewer_name, reviewer_id
FROM imp_review;

--Comprovem que s'omple la taula person.
SELECT * FROM Person;

/*Fem l'insert de la tabla reviewer*/
INSERT INTO Reviewer (id_person, reviewer_name, listing_url, name, description, picture_url, street, neighborhood_cleased, city,comments,date_review)
SELECT p.id_person, ir.reviewer_name, ir.listing_url, ir.name, ir.description, ir.picture_url, ir.street, ir.neighborhood_cleased, ir.city,ir.comments,ir.date_review
FROM imp_review AS ir, person AS p
WHERE ir.reviewer_id = p.reviewer_id;

--Comprovem que s'omple la taula reviewer.
SELECT * FROM Reviewer
ORDER BY id_person;

/*Fem l'insert de la tabla apartment_reviewer per vincula 
els reviews a quin apartament correspon*/
INSERT INTO Apartment_Reviewer(id_apartment,id_reviewer)
SELECT DISTINCT a.id_apartment ,r.reviewer_id
FROM Apartment AS a, Reviewer AS r, imp_review AS ir 
WHERE r.picture_url = ir.picture_url AND a.listing_url = r.listing_url;

--Comprovem que s'omple la taula apartment_reviewer.
SELECT * FROM Apartment_Reviewer;

--Eliminem les taules que ja no ens calen.
DROP TABLE amentiti_table;
DROP TABLE amentitie_table_1;
DROP TABLE Verification_table;
DROP TABLE Verification_table_1;

--Eliminem les columnes que no son necesaries.
ALTER TABLE Verification DROP COLUMN host_url;
ALTER TABLE Apartment DROP COLUMN amentities;


