

ALTER TABLE dbdata MODIFY COLUMN Birth_date datetime;

DESCRIBE dbdata Birth_date;
UPDATE dbdata SET Birth_date = STR_TO_DATE('11/5/1992', '%m/%d/%Y');

/*setting similar date format to the entire date column */ 
SELECT * FROM dbdata WHERE STR_TO_DATE(Birth_date, '%m/%d/%Y') IS NULL;

/*Checked the date mistake here*/
UPDATE dbdata SET Birth_date = '2/28/1995' WHERE Birth_date = '2/29/1995';
SELECT EmployeeName, Birth_date FROM dbdata WHERE Birth_date ='2/28/1995';

/*Calculating age from birth date*/
SELECT *, 
       YEAR(CURDATE()) - YEAR(Birth_date) - (CASE WHEN MONTH(CURDATE()) < MONTH(Birth_date) 
                                         OR (MONTH(CURDATE()) = MONTH(Birth_date) AND DAY(CURDATE()) < DAY(Birth_date)) 
                                         THEN 1 ELSE 0 END) AS age
FROM dbdata;
SELECT * FROM dbdata;

/*1. Retrieve the Patient_id and ages of all patients.*/
SELECT Patient_id, YEAR(CURDATE()) - YEAR(Birth_date) - (CASE WHEN MONTH(CURDATE()) < MONTH(Birth_date) 
                                                          OR (MONTH(CURDATE()) = MONTH(Birth_date) AND DAY(CURDATE()) < DAY(Birth_date)) 
                                                          THEN 1 ELSE 0 END) AS calculated_age
FROM dbdata;


/*.2. Select all female patients who are older than 30.*/
SELECT EmployeeName
FROM dbdata
WHERE gender ="Female"
AND (YEAR(CURDATE()) - YEAR(Birth_date) - (CASE WHEN MONTH(CURDATE()) < MONTH(Birth_date) 
                                                OR (MONTH(CURDATE()) = MONTH(Birth_date) AND DAY(CURDATE()) < DAY(Birth_date)) 
                                                THEN 1 ELSE 0 END)) > 30;

/*3. Calculate the average BMI of patients.*/
SELECT avg(bmi) FROM dbdata;

/*4. List patients in descending order of blood glucose levels.*/
SELECT EmployeeName, blood_glucose_level FROM dbdata
ORDER BY blood_glucose_level DESC;
 
 /* 5. Find patients who have hypertension and diabetes.*/
 SELECT EmployeeName, Patient_id FROM dbdata WHERE hypertension = "TRUE" AND diabetes = "TRUE";
 
 /*6. Determine the number of patients with heart disease.*/
 SELECT COUNT(*) FROM dbdata WHERE heart_disease = "TRUE";
 
 /*7. Group patients by smoking history and count how many smokers and non-smokers there are.*/
SELECT smoking_history, COUNT(*) AS patient_count
FROM dbdata
GROUP BY smoking_history;

/* 8. Retrieve the Patient_id of patients who have a BMI greater than the average BMI */
SELECT Patient_id FROM dbdata WHERE bmi > (SELECT AVG(bmi) FROM dbdata);

/*9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1c level*/
SELECT Patient_id, EmployeeName, HbA1c_level
FROM dbdata
WHERE HbA1c_level = (SELECT MAX(HbA1c_level) FROM dbdata)
   OR HbA1c_level = (SELECT MIN(HbA1c_level) FROM dbdata)
GROUP BY Patient_id, EmployeeName, HbA1c_level;

/* 10. Calculate the age of patients in years (assuming the current date as of now)*/
SELECT patient_id, birth_date, TIMESTAMPDIFF(YEAR, Birth_date, CURDATE()) AS age_in_years 
FROM dbdata;

/*11. Rank patients by blood glucose level within each gender group*/
SELECT Patient_id, gender, blood_glucose_level,
    RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level) AS glucose_level_rank
FROM dbdata;

/*12. Update the smoking history of patients who are olderthan 40 to "Ex-smoker."*/

UPDATE dbdata
SET smoking_history = 'Ex-smoker'
WHERE TIMESTAMPDIFF(YEAR, Birth_date, CURDATE()) > 40;
-- NoOne is Ex-smoker in dbdata. 

INSERT INTO dbdata(EmployeeName, Patient_id, gender, Birth_date, hypertension, heart_disease, smoking_history, bmi, HbA1c_level, blood_glucose_level, diabetes) 
VALUES("SHRADDHA PATIL", 'PT0000', "Female", '1992-11-05' , 0,0, "never", 27.34,6.7,120,0);
COMMIT;
SELECT * FROM dbdata WHERE Patient_id = "PT0000";

/*14. Delete all patients with heart disease from the database*/
DELETE FROM dbdata WHERE heart_disease= 1; 

/*15. Find patients who have hypertension but not diabetes using the EXCEPT operator.*/
SELECT * FROM dbdata WHERE hypertension = 1 EXCEPT
SELECT * FROM dbdata WHERE diabetes = 1;

