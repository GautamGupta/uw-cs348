-- Q1


-- 1.

SELECT DISTINCT s.snum, s.sname \
FROM student AS s \
WHERE year IN (3, 4)  \
  AND EXISTS( \
    -- Get students with such grades
    SELECT s.snum \
    FROM mark AS m240, mark as m245 \
    WHERE \
      s.snum = m240.snum  \
      AND m240.snum = m245.snum \
      AND m240.cnum = 'CS240' \
      AND m240.grade >= 85  \
      AND m245.cnum = 'CS245' \
      AND m245.grade >= 85  \
  )

-- 2.

SELECT DISTINCT p.pnum, p.pname \
FROM professor AS p \
WHERE p.dept != 'PM'  \
  AND EXISTS( \
    -- Filter on course
    SELECT c.pnum \
    FROM class AS c \
    WHERE p.pnum = c.pnum \
      AND c.cnum = 'CS245'  \
      AND NOT EXISTS( \
        -- Filter for current term ie. no marks data
        SELECT m.cnum \
        FROM mark AS m  \
        WHERE m.cnum = c.cnum \
          AND m.term = c.term \
          AND m.section = c.section \
      ) \
  )

-- 3.

SELECT DISTINCT s.snum, s.sname, s.year \
FROM student AS s, mark AS m1 \
WHERE m1.snum = s.snum  \
  AND m1.cnum = 'CS240' \
  AND m1.grade >= ( \
    -- Highest minus 3
    SELECT (m2.grade - 3) \
    FROM mark AS m2 \
    WHERE m2.cnum = 'CS240' \
      AND NOT EXISTS( \
        -- Exclude marks other than highest
        SELECT DISTINCT m3.grade  \
        FROM mark as m3 \
        WHERE m3.cnum = m2.cnum \
        AND m3.grade > m2.grade \
      ) \
    -- In case there are > 1 marks with same grade
    LIMIT 1 \
  )

-- 4.

SELECT DISTINCT s.snum, s.sname \
FROM student AS s \
WHERE s.year > 2  \
  AND s.snum NOT IN(  \
    SELECT DISTINCT m.snum  \
    FROM mark AS m  \
    WHERE m.grade < 85  \
      AND m.cnum LIKE 'CS%' \
  ) \
  AND s.snum NOT IN ( \
    SELECT DISTINCT e.snum  \
    FROM enrollment AS e, class AS c, professor AS p  \
    WHERE p.dept != 'CS'  \
      AND e.cnum = c.cnum \
      AND e.term = c.term \
      AND e.section = c.section \
      AND c.pnum = p.pnum \
  )

-- 5.

SELECT DISTINCT p.dept  \
FROM professor AS p \
WHERE EXISTS( \
  -- < Monday noon
  SELECT c.pnum \
  FROM class AS c, schedule AS s  \
  WHERE p.pnum = c.pnum \
    AND c.cnum = s.cnum \
    AND c.term = s.term \
    AND c.section = s.section \
    AND (s.day = 'Monday' AND s.time < '12:00') \
    AND NOT EXISTS (  \
      -- Filter for current term ie. no marks data
      SELECT m.cnum \
      FROM mark AS m  \
      WHERE c.cnum = m.cnum \
        AND c.term = m.term \
        AND c.section = m.section \
    ) \
  ) \
  AND EXISTS( \
    -- > Friday noon
    SELECT c.pnum \
    FROM class AS c, schedule AS s  \
    WHERE p.pnum = c.pnum \
      AND c.cnum = s.cnum \
      AND c.term = s.term \
      AND c.section = s.section \
      AND (s.day = 'Friday' AND s.time > '12:00') \
      AND NOT EXISTS (  \
        -- Filter for current term ie. no marks data
        SELECT m.cnum \
        FROM mark AS m  \
        WHERE c.cnum = m.cnum \
          AND c.term = m.term \
          AND c.section = m.section \
      ) \
  ) \
  ORDER BY p.dept

-- 6.

SELECT COUNT(DISTINCT p.pnum) * 1.0 / \
  ( \
    SELECT COUNT(DISTINCT p.pnum) \
    FROM professor AS p \
    WHERE p.dept = 'AM' \
      AND p.pnum IN ( \
        -- Profs with > 77 grade averages
        SELECT c.pnum \
        FROM class AS c, mark AS m  \
        WHERE c.cnum = m.cnum \
          AND c.term = m.term \
          AND c.section = m.section \
        GROUP BY c.pnum \
          HAVING AVG(m.grade) > 77  \
      ) \
  ) \
AS ratio  \
FROM professor AS p \
WHERE p.dept = 'PM' \
  AND p.pnum IN ( \
    -- Profs with > 77 grade averages
    SELECT c.pnum \
    FROM class AS c, mark AS m  \
    WHERE c.cnum = m.cnum \
      AND c.term = m.term \
      AND c.section = m.section \
    GROUP BY c.pnum \
      HAVING AVG(m.grade) > 77  \
  )

-- 7.

-- rough:
-- WITH view AS ( \
  -- SELECT p1.pnum AS pnum1, p2.pnum AS pnum2, c.cnum AS cnum, c.term AS term, COUNT(*) AS enroll_count, AVG(m.grade) AS avg_final_grade \
  -- FROM professor as p1, professor AS p2, course AS c, enrollment AS e, mark AS m \
  -- WHERE p1.pnum != p2.pnum \
    -- AND c.cnum = m.cnum \
    -- AND c.term = m.term \
    -- AND c.section = m.section \
    -- -- enrollment can also be for curernt term, for which marks won't exist \
    -- AND c.cnum = e.cnum \
    -- AND c.term = e.term \
    -- AND c.section = e.section \
-- ) \
-- GROUP BY p1.pnum, p2.pnum, c.term, c.section; \
-- SELECT DISTINCT v.pnum1, v.pnum2, v.cnum, v.term, AVG(v.enroll_count) AS avg_enroll_count, AVG(v.avg_final_grade) \
-- FROM view AS v \
-- GROUP BY v.pnum1, v.pnum2, v.cnum, v.term

-- 8.

SELECT c.term, COUNT(e.snum) * 1.0 / (  \
  SELECT COUNT(e2.snum) \
  FROM class AS c2, enrollment AS e2  \
  WHERE c.term = c2.term  \
    AND c2.cnum = e2.cnum \
    AND c2.term = e2.term \
    AND c2.section = e2.section \
    GROUP BY c2.term  \
) * 100 AS percentage \
FROM class AS c, enrollment AS e, professor AS p  \
WHERE c.cnum = e.cnum \
  AND c.term = e.term \
  AND c.section = e.section \
  AND c.pnum = p.pnum \
  AND p.pnum NOT IN ( \
    SELECT p.pnum \
    FROM professor AS p \
    WHERE p.dept = 'CS' OR p.dept = 'CO'  \
  ) \
GROUP BY c.term \
ORDER BY  \
  SUBSTRING(c.term, 2, 5) ASC,  \
  CASE  \
    WHEN c.term LIKE 'W%' THEN 1  \
    WHEN c.term LIKE 'S%' THEN 2  \
    WHEN c.term LIKE 'F%' THEN 3  \
  END

-- 9.

-- Professor info, Class primary key, Metrics
SELECT p.pnum, p.pname, c.cnum, c.term, c.section, MIN(m.grade) AS min_grade, MAX(m.grade) AS max_grade \
FROM class AS c, mark AS m, professor AS p \
WHERE p.dept = 'CS' \
  AND c.pnum = p.pnum \
  -- Both Monday and Friday
  AND EXISTS( \
    SELECT s.cnum \
    FROM schedule AS s  \
    WHERE s.cnum = c.cnum \
      AND s.term = c.term \
      AND s.section = c.section \
      AND s.day = 'Monday'  \
  ) \
  AND EXISTS( \
    SELECT s.cnum \
    FROM schedule AS s  \
    WHERE s.cnum = c.cnum \
      AND s.term = c.term \
      AND s.section = c.section \
      AND s.day = 'Friday'  \
  ) \
  AND m.cnum = c.cnum \
  AND m.term = c.term \
  AND m.section = c.section \
GROUP BY p.pnum, p.pname, c.cnum, c.term, c.section

-- 10.

SELECT DISTINCT COUNT(DISTINCT p.pnum) * 1.0 / (  \
  SELECT COUNT(DISTINCT p.pnum) \
  FROM professor AS p \
  WHERE p.dept IN ('AM', 'PM')  \
) * 100 AS percentage \
FROM professor AS p \
WHERE p.dept IN ('AM', 'PM')  \
  AND p.pnum NOT IN(  \
    -- Profs who have taught 2 diff courses in 1 term
    SELECT pc.pnum  \
    FROM class AS c1, class AS c2, professor AS pc  \
    WHERE c1.pnum = pc.pnum \
      AND c2.pnum = pc.pnum \
      AND c1.term = c2.term \
      AND c1.cnum != c2.cnum  \
  )
