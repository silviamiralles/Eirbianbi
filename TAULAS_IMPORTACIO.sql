
--------------------------------------------TAULAS IMPORTACIO--------------------------------------------------------------------

--Creem la taula importacio dels apartamets.
DROP TABLE IF EXISTS imp_apartament CASCADE;
CREATE TABLE imp_apartament(
  id BIGINT,
  listing_url VARCHAR(255),
  name VARCHAR(255),
  description TEXT,
  picture_url VARCHAR(255),
  street TEXT,
  neighbourhood_cleansed VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(255),
  zipcode VARCHAR(255), 
  country_code CHAR(2),
  country VARCHAR(255),
  property_type VARCHAR(255),
  accomodates INT,
  bathrooms FLOAT,
  bedrooms INT,
  beds INT,
  amentities TEXT,
  square_feet INT,
  price VARCHAR(255), 
  weekly_price VARCHAR(255),
  monthly_price VARCHAR(255),
  security_deposit VARCHAR(255),
  cleaning_fee VARCHAR(255),
  minimum_nights INT,
  maximum_nights INT,
  PRIMARY KEY(id)
);

--Importem tota la informacio a la taula import.
COPY imp_apartament FROM '/Users/Shared/apartments.csv' DELIMITER ',' csv header;
SELECT * FROM imp_apartament;

--Creem la taula importacio dels hosts.
DROP TABLE IF EXISTS imp_host CASCADE;
CREATE TABLE imp_host(
	listing_url VARCHAR(255),
	name VARCHAR(255),
	description TEXT,
	picture_url VARCHAR(255),
	host_id BIGINT,
	host_url VARCHAR(255),
	host_name VARCHAR(255),
	host_since DATE,
	host_about TEXT,
	host_response_time VARCHAR(255),
	host_response_rate VARCHAR(255),
	host_is_superhost CHAR,
	host_picture_url VARCHAR(255),
	host_listing_cout INT,
	host_verifications TEXT,
	host_identity_verified BOOLEAN,
	PRIMARY KEY(listing_url)

);
--Importem tota la informacio a la taula import.
COPY imp_host FROM '/Users/Shared/hosts.csv' DELIMITER ',' csv header;
SELECT * FROM imp_host;

--Creem la taula importacio dels reviews.
DROP TABLE IF EXISTS imp_review CASCADE;
CREATE TABLE imp_review(
	id BIGINT,
	listing_url VARCHAR(255),
	name VARCHAR(255),
	description TEXT,
	picture_url VARCHAR(255),
	street VARCHAR(255),
	neighborhood_cleased VARCHAR(255),
	city VARCHAR(255),
	date_review DATE,
	reviewer_id BIGINT,
	reviewer_name  VARCHAR(255),
	comments TEXT

);
--Importem tota la informacio a la taula review.
COPY imp_review FROM '/Users/Shared/review.csv' DELIMITER ',' csv header;
SELECT * FROM imp_review;

/*Eliminem tots els signes de $, , i els decimals de tots els apartats relacionats amb 
el price de la tabla import apartment per poder declara totes les variables com a int.
*/

UPDATE imp_apartament SET price = REPLACE(price, '$', '');
UPDATE imp_apartament SET weekly_price = REPLACE(weekly_price, '$', '');
UPDATE imp_apartament SET monthly_price = REPLACE(monthly_price, '$', '');
UPDATE imp_apartament SET security_deposit = REPLACE(security_deposit, '$', '');
UPDATE imp_apartament SET cleaning_fee = REPLACE(cleaning_fee, '$', '');

UPDATE imp_apartament SET price = REPLACE(price, ',', '');
UPDATE imp_apartament SET weekly_price = REPLACE(weekly_price, ',', '');
UPDATE imp_apartament SET monthly_price = REPLACE(monthly_price, ',', '');
UPDATE imp_apartament SET security_deposit = REPLACE(security_deposit, ',', '');
UPDATE imp_apartament SET cleaning_fee = REPLACE(cleaning_fee, ',', '');

UPDATE imp_apartament SET price = REPLACE(price, '.00', '');
UPDATE imp_apartament SET weekly_price = REPLACE(weekly_price, '.00', '');
UPDATE imp_apartament SET monthly_price = REPLACE(monthly_price, '.00', '');
UPDATE imp_apartament SET security_deposit = REPLACE(security_deposit, '.00', '');
UPDATE imp_apartament SET cleaning_fee = REPLACE(cleaning_fee, '.00', '');

ALTER TABLE imp_apartament ALTER COLUMN price TYPE INT USING price::integer;
ALTER TABLE imp_apartament ALTER COLUMN weekly_price TYPE INT USING weekly_price::integer;
ALTER TABLE imp_apartament ALTER COLUMN monthly_price TYPE INT USING monthly_price::integer;
ALTER TABLE imp_apartament ALTER COLUMN security_deposit TYPE INT USING security_deposit::integer;
ALTER TABLE imp_apartament ALTER COLUMN cleaning_fee TYPE INT USING cleaning_fee::integer;

/*Eliminem tots els signes de % i N/A de tots 
els apartats de host_response_rate i host_response_time
de la tabla import host i canviem la declaracio de host_response_rate
com a int i de host_response_time com a varchar(255).
*/
UPDATE imp_host SET host_response_rate = REPLACE(host_response_rate, '%', '');
UPDATE imp_host SET host_response_rate = REPLACE(host_response_rate, 'N/A', '-1');
UPDATE imp_host SET host_response_time = REPLACE(host_response_time, 'N/A', '-1');

ALTER TABLE imp_host ALTER COLUMN host_response_rate TYPE INT USING host_response_rate::integer;
ALTER TABLE imp_host ALTER COLUMN host_response_time TYPE VARCHAR(255) USING host_response_time::varchar(255);

SELECT * FROM imp_host;
