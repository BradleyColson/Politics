CREATE TABLE fec_contributions (
    CMTE_ID VARCHAR(9) NOT NULL,
    AMNDT_IND CHAR(1),
    RPT_TP VARCHAR(3),
    TRANSACTION_PGI VARCHAR(5),
    IMAGE_NUM VARCHAR(18),
    TRANSACTION_TP VARCHAR(3),
    ENTITY_TP VARCHAR(3),
    NAME VARCHAR(200),
    CITY VARCHAR(30),
    STATE VARCHAR(2),
    ZIP_CODE VARCHAR(9),
    EMPLOYER VARCHAR(100),
    OCCUPATION VARCHAR(100),
    TRANSACTION_DT DATE,
    TRANSACTION_AMT DECIMAL(14, 2),
    OTHER_ID VARCHAR(9),
    TRAN_ID VARCHAR(32),
    FILE_NUM INT,
    MEMO_CD CHAR(1),
    MEMO_TEXT VARCHAR(100),
    SUB_ID BIGINT PRIMARY KEY
);

-- Ensure your table is ready for the data types
ALTER TABLE fec_contributions MODIFY SUB_ID BIGINT;
ALTER TABLE fec_contributions MODIFY TRANSACTION_DT VARCHAR(20);

TRUNCATE TABLE fec_contributions;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Politics_Fixed.txt'
INTO TABLE fec_contributions
CHARACTER SET utf8
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';




SHOW WARNINGS;

-- 1. Clear the table if it has empty rows
TRUNCATE TABLE fec_contributions;

-- 2. Make the problematic columns "flexible"
ALTER TABLE fec_contributions MODIFY SUB_ID BIGINT;
ALTER TABLE fec_contributions MODIFY TRANSACTION_DT VARCHAR(20);
ALTER TABLE fec_contributions MODIFY TRANSACTION_AMT VARCHAR(50);

SELECT COUNT(*) FROM fec_contributions;

select *
from fec_contributions;

-- To find the Top 10 individual donors
SELECT 
    NAME, 
    EMPLOYER, 
    OCCUPATION, 
    SUM(TRANSACTION_AMT) AS Total_Contributed,
    COUNT(*) AS Number_of_Donations
FROM fec_contributions
GROUP BY NAME, EMPLOYER, OCCUPATION
ORDER BY Total_Contributed DESC
LIMIT 10;

-- Find hot spots

SELECT 
    STATE, 
    CITY, 
    SUM(TRANSACTION_AMT) AS Total_State_Funds,
    round(AVG(TRANSACTION_AMT),2) AS Average_Donation
FROM fec_contributions
WHERE STATE IS NOT NULL
GROUP BY STATE, CITY
ORDER BY Total_State_Funds DESC
LIMIT 10;

-- Donation distrubution size

SELECT 
    CASE 
        WHEN TRANSACTION_AMT < 200 THEN 'Small ($0-$199)'
        WHEN TRANSACTION_AMT BETWEEN 200 AND 1000 THEN 'Medium ($200-$1000)'
        WHEN TRANSACTION_AMT BETWEEN 1001 AND 2900 THEN 'Large ($1001-$2900)'
        ELSE 'Max/High (>$2900)'
    END AS Donor_Bracket,
    COUNT(*) AS Donation_Count,
    SUM(TRANSACTION_AMT) AS Total_Value
FROM fec_contributions
GROUP BY Donor_Bracket
ORDER BY Total_Value DESC;

-- Which donors from which city

SELECT 
    STATE, 
    CITY, 
    EMPLOYER, 
    OCCUPATION, 
    SUM(TRANSACTION_AMT) AS Total_Donations,
    COUNT(*) AS Number_of_Donations
FROM fec_contributions
WHERE STATE IS NOT NULL 
  AND EMPLOYER NOT IN ('NOT EMPLOYED', 'NONE', 'RETIRED') -- Filters out non-corporate data
GROUP BY STATE, CITY, EMPLOYER, OCCUPATION
ORDER BY Total_Donations DESC
LIMIT 20;