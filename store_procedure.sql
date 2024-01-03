

DELIMITER //

CREATE PROCEDURE pHW_6_iagboada(IN mysemester VARCHAR(255), IN myyear VARCHAR(255))
BEGIN
    DECLARE student_count INT DEFAULT 0;

    IF myyear = '' OR myyear IS NULL THEN
        SELECT 'Please enter a valid year.' AS message;
    ELSEIF mysemester = '' OR mysemester IS NULL THEN
        SELECT 'Please enter a valid semester.' AS message;
    ELSE
        
       
        IF myyear = '*' AND mysemester = '*' THEN
            SELECT COUNT(*) INTO student_count FROM dreamhome.Students_Courses;
        ELSEIF myyear != '*' AND mysemester = '*' THEN
            SELECT COUNT(*) INTO student_count FROM dreamhome.Students_Courses sc WHERE sc.year = myyear;
        ELSEIF myyear != '*' AND mysemester != '*' THEN
            SELECT COUNT(*) INTO student_count FROM dreamhome.Students_Courses sc WHERE sc.semester = mysemester AND sc.year = myyear;
        END IF;
        
        
        IF student_count = 0 THEN
            SELECT CONCAT('Year: ', myyear, ', semester: ', mysemester, ' has no students in the system.') AS message;
        ELSE
           
            SELECT s.last_name, s.first_name, sc.year, sc.semester, c.cid, c.name, sc.grade
            FROM dreamhome.Students s
            JOIN dreamhome.Students_Courses sc ON s.sid = sc.sid
            JOIN dreamhome.Courses c ON sc.cid = c.cid
            WHERE (myyear = '*' OR sc.year = myyear) AND (mysemester = '*' OR sc.semester = mysemester)
            ORDER BY s.last_name, s.first_name, sc.year, sc.semester;
        END IF;
    END IF;
END //

DELIMITER ;


call CPS3740_2023F.pHW_6_iagboada('','');
+----------------------------+
| message                    |
+----------------------------+
| Please enter a valid year. |
+----------------------------+



call CPS3740_2023F.pHW_6_iagboada('Fall',null);
+----------------------------+
| message                    |
+----------------------------+
| Please enter a valid year. |
+----------------------------+


call CPS3740_2023F.pHW_6_iagboada('',2012);
+--------------------------------+
| message                        |
+--------------------------------+
| Please enter a valid semester. |
+--------------------------------+



call CPS3740_2023F.pHW_6_iagboada(null,2012);
+--------------------------------+
| message                        |
+--------------------------------+
| Please enter a valid semester. |
+--------------------------------+


call CPS3740_2023F.pHW_6_iagboada('*',2030);
+--------------------------------------------------------+
| message                                                |
+--------------------------------------------------------+
| Year: 2030, semester: * has no students in the system. |
+--------------------------------------------------------+



 call CPS3740_2023F.pHW_6_iagboada('Spring',2013);
+-------------------------------------------------------------+
| message                                                     |
+-------------------------------------------------------------+
| Year: 2013, semester: Spring has no students in the system. |
+-------------------------------------------------------------+


call CPS3740_2023F.pHW_6_iagboada('Fall',2014);
+-----------+------------+------+----------+---------+----------------------+-------+
| last_name | first_name | year | semester | cid     | name                 | grade |
+-----------+------------+------+----------+---------+----------------------+-------+
| Lee       | Claudia    | 2014 | Fall     | CPS2231 | Java2                | F     |
| Lee       | Sarah      | 2014 | Fall     | CPS3740 | Database Introductio | A     |
| Lin       | Andrew     | 2014 | Fall     | CPS2232 | Data Structure       | C     |
+-----------+------------+------+----------+---------+----------------------+-------+


 call CPS3740_2023F.pHW_6_iagboada('*',2014);
+-----------+------------+------+----------+---------+----------------------+-------+
| last_name | first_name | year | semester | cid     | name                 | grade |
+-----------+------------+------+----------+---------+----------------------+-------+
| Lee       | Claudia    | 2014 | Fall     | CPS2231 | Java2                | F     |
| Lee       | Sarah      | 2014 | Fall     | CPS3740 | Database Introductio | A     |
| Lin       | Andrew     | 2014 | Spring   | CPS2232 | Data Structure       | B+    |
| Lin       | Andrew     | 2014 | Fall     | CPS2232 | Data Structure       | C     |
| Lin       | Andrew     | 2014 | Spring   | CPS2231 | Java2                | A-    |
+-----------+------------+------+----------+---------+----------------------+-------+



call CPS3740_2023F.pHW_6_iagboada('*','*');
+-----------+------------+------+----------+---------+----------------------+-------+
| last_name | first_name | year | semester | cid     | name                 | grade |
+-----------+------------+------+----------+---------+----------------------+-------+
| Huang     | Austin     | 2013 | Fall     | CPS2231 | Java2                | A-    |
| Huang     | Austin     | 2016 | Fall     | CPS2232 | Data Structure       | C+    |
| Huang     | Austin     | 2017 | Spring   | CPS3500 | Web Programming      | C+    |
| Lee       | Claudia    | 2014 | Fall     | CPS2231 | Java2                | F     |
| Lee       | Claudia    | 2015 | Spring   | CPS2231 | Java2                | A     |
| Lee       | Claudia    | 2016 | Fall     | CPS5920 | Database Systems     | C     |
| Lee       | Claudia    | 2016 | Spring   | CPS5921 | Data Mining          | B     |
| Lee       | Sarah      | 2014 | Fall     | CPS3740 | Database Introductio | A     |
| Lee       | Sarah      | 2015 | Spring   | CPS2231 | Java2                | B     |
| Lin       | Andrew     | 2013 | Fall     | CPS2231 | Java2                | C     |
| Lin       | Andrew     | 2014 | Spring   | CPS2232 | Data Structure       | B+    |
| Lin       | Andrew     | 2014 | Fall     | CPS2232 | Data Structure       | C     |
| Lin       | Andrew     | 2014 | Spring   | CPS2231 | Java2                | A-    |
| Wu        | Helen      | 2016 | Spring   | CPS2231 | Java2                | A     |
+-----------+------------+------+----------+---------+----------------------+-------+






DELIMITER //

CREATE FUNCTION fHW_7_iagboada(type INT, keyword VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(4000); 

   
    IF type NOT IN (1, 2) THEN
        RETURN 'Please input a valid type.';
    END IF;

   
    IF keyword IS NULL OR TRIM(keyword) = '' THEN
        RETURN 'Please input a valid keyword.';
    END IF;

   
    IF type = 1 THEN
        SELECT GROUP_CONCAT(CONCAT(c.cid, ':', c.name) ORDER BY c.cid SEPARATOR ', ') INTO result
        FROM dreamhome.Courses c
        WHERE c.name LIKE CONCAT('%', keyword, '%');

     
        IF result IS NULL OR result = '' THEN
            SET result = CONCAT('No course found that contains the keyword: ', keyword);
        END IF;
    END IF;


    IF type = 2 THEN
        SELECT GROUP_CONCAT(CONCAT(c.cid, ':', s.sid) ORDER BY c.cid, s.sid SEPARATOR ', ') INTO result
        FROM dreamhome.Students_Courses sc
        JOIN dreamhome.Students s ON s.sid = sc.sid
        JOIN dreamhome.Courses c ON c.cid = sc.cid
        WHERE c.name LIKE CONCAT('%', keyword, '%');

      
        IF result IS NULL OR result = '' THEN
            SET result = CONCAT('No course found that contains the keyword: ', keyword);
        END IF;
    END IF;

  
    RETURN result;
END //

DELIMITER ;




 select CPS3740_2023F.fHW_7_iagboada(0,'') as output;
+----------------------------+
| output                     |
+----------------------------+
| Please input a valid type. |
+----------------------------+


select CPS3740_2023F.fHW_7_iagboada(4,'') as output;
+----------------------------+
| output                     |
+----------------------------+
| Please input a valid type. |
+----------------------------+


select CPS3740_2023F.fHW_7_iagboada(1,'') as output;
+-------------------------------+
| output                        |
+-------------------------------+
| Please input a valid keyword. |
+-------------------------------+



select CPS3740_2023F.fHW_7_iagboada(2,null) as output;
+-------------------------------+
| output                        |
+-------------------------------+
| Please input a valid keyword. |
+-------------------------------+



select CPS3740_2023F.fHW_7_iagboada(1, 'Z') as output;
+----------------------------------------------+
| output                                       |
+----------------------------------------------+
| No course found that contains the keyword: Z |
+----------------------------------------------+


select CPS3740_2023F.fHW_7_iagboada(2, 'X') as output;
+----------------------------------------------+
| output                                       |
+----------------------------------------------+
| No course found that contains the keyword: X |
+----------------------------------------------+


select CPS3740_2023F.fHW_7_iagboada(1,'M') as output;
+------------------------------------------------------------------------+
| output                                                                 |
+------------------------------------------------------------------------+
| CPS3500:Web Programming, CPS5920:Database Systems, CPS5921:Data Mining |
+------------------------------------------------------------------------+



select CPS3740_2023F.fHW_7_iagboada(2,'D') as output;
+------------------------------------------------------------------------------------+
| output                                                                             |
+------------------------------------------------------------------------------------+
| CPS2232:1001, CPS2232:1004, CPS2232:1004, CPS3740:1007, CPS5920:1003, CPS5921:1003 |
+------------------------------------------------------------------------------------+






DELIMITER $$

CREATE FUNCTION fHW_8_iagboada(year VARCHAR(255), sid VARCHAR(255))
RETURNS VARCHAR(255)
BEGIN
    DECLARE total_payment INT; 
    DECLARE no_record_message VARCHAR(255);
    DECLARE credits INT;
    
   
    IF year IS NULL OR TRIM(year) = '' THEN
        RETURN 'Please input a valid year.';
    END IF;
    IF sid IS NULL OR TRIM(sid) = '' THEN
        RETURN 'Please input a valid student id.';
    END IF;

    
    IF year = '*' AND sid = '*' THEN
        SELECT SUM(c.credits) INTO credits
        FROM dreamhome.Students_Courses sc
        JOIN dreamhome.Courses c ON sc.cid = c.cid;
    ELSEIF year = '*' THEN
        SELECT SUM(c.credits) INTO credits
        FROM dreamhome.Students_Courses sc
        JOIN dreamhome.Courses c ON sc.cid = c.cid
        WHERE sc.sid = sid;
    ELSEIF sid = '*' THEN
        SELECT SUM(c.credits) INTO credits
        FROM dreamhome.Students_Courses sc
        JOIN dreamhome.Courses c ON sc.cid = c.cid
        WHERE sc.year = year;
    ELSE
        SELECT SUM(c.credits) INTO credits
        FROM dreamhome.Students_Courses sc
        JOIN dreamhome.Courses c ON sc.cid = c.cid
        WHERE sc.sid = sid AND sc.year = year;
    END IF;

   
    IF credits IS NULL THEN
        SET no_record_message = CONCAT('No record found for student id: ', sid, ' at year: ', year);
        RETURN no_record_message;
    ELSE
        SET total_payment = credits * 100; 
        RETURN CONCAT(total_payment); 
    END IF;
END$$

DELIMITER ;


select CPS3740_2023F.fHW_8_iagboada('',1002) as output;
+----------------------------+
| output                     |
+----------------------------+
| Please input a valid year. |
+----------------------------+


select CPS3740_2023F.fHW_8_iagboada(null,1002) as output;
+----------------------------+
| output                     |
+----------------------------+
| Please input a valid year. |
+----------------------------+



select CPS3740_2023F.fHW_8_iagboada(2017,'') as output;
+----------------------------------+
| output                           |
+----------------------------------+
| Please input a valid student id. |
+----------------------------------+


 select CPS3740_2023F.fHW_8_iagboada(2017,null) as output;
+----------------------------------+
| output                           |
+----------------------------------+
| Please input a valid student id. |
+----------------------------------+



select CPS3740_2023F.fHW_8_iagboada(2000,1001) as output;
+----------------------------------------------------+
| output                                             |
+----------------------------------------------------+
| No record found for student id: 1001 at year: 2000 |
+----------------------------------------------------+



select CPS3740_2023F.fHW_8_iagboada(2016,1001) as output;
+--------+
| output |
+--------+
| 400    |
+--------+



select CPS3740_2023F.fHW_8_iagboada(2016,'*') as output;
+--------+
| output |
+--------+
| 1400   |
+--------+



 select CPS3740_2023F.fHW_8_iagboada('*',1001) as output;
+--------+
| output |
+--------+
| 1100   |
+--------+



 select CPS3740_2023F.fHW_8_iagboada('*','*') as output;
+--------+
| output |
+--------+
| 5200   |
+--------+






DELIMITER //

CREATE FUNCTION fHW_9_iagboada (N INT)
RETURNS VARCHAR(255)
BEGIN
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE total INT DEFAULT 0;
    DECLARE i INT DEFAULT 1;
    
    IF N <= 0 THEN
        RETURN 'Please input a positive number.';
    END IF;
    
    IF N > 0 AND N <= 3 THEN
        WHILE i <= N DO
            SET total = total + (i * i);
            SET result = CONCAT(result, i, '*', i, IF(i < N, '+', ''));
            SET i = i + 1;
        END WHILE;
        RETURN CONCAT(result, '=', total);
    END IF;
    
    IF N >= 4 THEN
        SET result = '1*1+2*2+...';
        SET total = 5; -- Since 1*1 + 2*2 = 5
        SET i = 3;
        WHILE i <= N DO
            SET total = total + (i * i);
            SET i = i + 1;
        END WHILE;
        RETURN CONCAT(result, '+', N, '*', N, '=', total);
    END IF;
END //

DELIMITER ;




select CPS3740_2023F.fHW_9_iagboada(0) as output;
+---------------------------------+
| output                          |
+---------------------------------+
| Please input a positive number. |
+---------------------------------+



select CPS3740_2023F.fHW_9_iagboada(1) as output;
+--------+
| output |
+--------+
| 1*1=1  |
+--------+



select CPS3740_2023F.fHW_9_iagboada(3) as output;
+----------------+
| output         |
+----------------+
| 1*1+2*2+3*3=14 |
+----------------+



select CPS3740_2023F.fHW_9_iagboada(6) as output;
+--------------------+
| output             |
+--------------------+
| 1*1+2*2+...+6*6=91 |
+--------------------+



select CPS3740_2023F.fHW_9_iagboada(7) as output;
+---------------------+
| output              |
+---------------------+
| 1*1+2*2+...+7*7=140 |
+---------------------+













