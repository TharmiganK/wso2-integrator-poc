-- =============================================================================
--  02_sample_data.sql  —  10 test employees covering all agent test scenarios
--
--  Employees are designed to exercise every inference path:
--    1001  Rajiv   — CEO, Grade 8, 15 yrs service → 25 days leave, gratuity eligible
--    1002  Priya   — CHRO, Grade 7, 13 yrs service → 25 days leave
--    1003  Kamal   — Sr Engineer, Grade 5, 7 yrs → 21 days, cert expiring soon
--    1004  Dilini  — HR BP, Grade 4, 6 yrs → 21 days, exceptional performer
--    1005  Tharindu— Engineer, Grade 3, 4 yrs → 17 days, on PIP
--    1006  Sanduni — Finance Analyst, Grade 3, 3 yrs → 17 days, sick leave used
--    1007  Amila   — Ops Manager, Grade 6, 9 yrs → 21 days
--    1008  Chamath — Junior Dev, Grade 2, 0.5 yrs → PROBATION, pro-rated leave
--    1009  Nethmi  — HR Coord, Grade 2, 2 yrs → 14 days
--    1010  Ishara  — Marketing, Grade 3, 1 yr → 14 days, pending leave
-- =============================================================================

-- ── DEPARTMENTS ───────────────────────────────────────────────────────────────
INSERT INTO department (dept_code, dept_name) VALUES ('EXEC','Executive');
INSERT INTO department (dept_code, dept_name) VALUES ('HR',  'Human Resources');
INSERT INTO department (dept_code, dept_name) VALUES ('ENG', 'Engineering');
INSERT INTO department (dept_code, dept_name) VALUES ('FIN', 'Finance');
INSERT INTO department (dept_code, dept_name) VALUES ('OPS', 'Operations');
INSERT INTO department (dept_code, dept_name) VALUES ('MKT', 'Marketing');

-- ── EMPLOYEES (emp_id 1001–1010 via IDENTITY START WITH 1001) ─────────────────

-- 1001 Rajiv Subramaniam — CEO (join 2010-01-01, ~15 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1001','Rajiv Subramaniam','196512345V','1965-03-15','MALE',
    '2010-01-01', '2010-04-01', 'ACTIVE');

-- 1002 Priya Fernando — CHRO (join 2012-06-01, ~13 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1002','Priya Fernando','197834567V','1978-07-22','FEMALE',
    '2012-06-01', '2012-09-01', 'ACTIVE');

-- 1003 Kamal Perera — Sr Engineer (join 2018-02-01, ~7 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1003','Kamal Perera','198956789V','1989-09-12','MALE',
    '2018-02-01', '2018-05-01', 'ACTIVE');

-- 1004 Dilini Jayawardena — HR BP (join 2019-07-15, ~6 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1004','Dilini Jayawardena','199267890V','1992-05-30','FEMALE',
    '2019-07-15', '2019-10-15', 'ACTIVE');

-- 1005 Tharindu Silva — Engineer (join 2021-03-01, ~4 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1005','Tharindu Silva','199578901V','1995-01-20','MALE',
    '2021-03-01', '2021-06-01', 'ACTIVE');

-- 1006 Sanduni Rathnayake — Finance Analyst (join 2022-01-10, ~3 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1006','Sanduni Rathnayake','199689012V','1996-08-14','FEMALE',
    '2022-01-10', '2022-04-10', 'ACTIVE');

-- 1007 Amila Bandara — Ops Manager (join 2016-05-01, ~9 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1007','Amila Bandara','198590123V','1985-12-03','MALE',
    '2016-05-01', '2016-08-01', 'ACTIVE');

-- 1008 Chamath Kulatunga — Junior Dev (join 2025-01-15, PROBATION)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, emp_status)
  VALUES ('ACME-1008','Chamath Kulatunga','200112345V','2001-06-10','MALE',
    '2025-01-15', 'PROBATION');

-- 1009 Nethmi Wijesinghe — HR Coordinator (join 2023-02-01, ~2 yrs)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1009','Nethmi Wijesinghe','199923456V','1999-10-07','FEMALE',
    '2023-02-01', '2023-05-01', 'ACTIVE');

-- 1010 Ishara Mendis — Marketing Executive (join 2024-06-01, ~1 yr)
INSERT INTO emp_master (employee_code, full_name, nic, dob, gender,
    join_date, confirmed_date, emp_status)
  VALUES ('ACME-1010','Ishara Mendis','199801234V','1998-03-25','FEMALE',
    '2024-06-01', '2024-09-01', 'ACTIVE');

-- ── EMP_JOB ───────────────────────────────────────────────────────────────────
-- dept_ids: EXEC=1, HR=2, ENG=3, FIN=4, OPS=5, MKT=6
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1001,1,'Chief Executive Officer','8','FULL_TIME_PERMANENT',NULL,'2010-01-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1002,2,'Chief Human Resources Officer','7','FULL_TIME_PERMANENT',1001,'2012-06-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1003,3,'Senior Software Engineer','5','FULL_TIME_PERMANENT',1001,'2018-02-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1004,2,'HR Business Partner','4','FULL_TIME_PERMANENT',1002,'2019-07-15');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1005,3,'Software Engineer','3','FULL_TIME_PERMANENT',1003,'2021-03-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1006,4,'Finance Analyst','3','FULL_TIME_PERMANENT',1002,'2022-01-10');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1007,5,'Operations Manager','6','FULL_TIME_PERMANENT',1001,'2016-05-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1008,3,'Junior Software Developer','2','FULL_TIME_PERMANENT',1003,'2025-01-15');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1009,2,'HR Coordinator','2','FULL_TIME_PERMANENT',1004,'2023-02-01');
INSERT INTO emp_job (emp_id,dept_id,job_title,grade,employment_type,manager_emp_id,effective_date)
  VALUES (1010,6,'Marketing Executive','3','FULL_TIME_PERMANENT',1002,'2024-06-01');

-- ── EMP_CONTACT ───────────────────────────────────────────────────────────────
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1001,'rajiv.s@acmecorp.com','+94771234001','Commercial Bank','1001000001');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1002,'priya.fernando@acmecorp.com','+94772234002','HNB','1002000002');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1003,'kamal.perera@acmecorp.com','+94773234003','Commercial Bank','1003000003');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1004,'dilini.j@acmecorp.com','+94774234004','NSB','1004000004');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1005,'tharindu.silva@acmecorp.com','+94775234005','HNB','1005000005');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1006,'sanduni.r@acmecorp.com','+94776234006','People Bank','1006000006');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1007,'amila.bandara@acmecorp.com','+94777234007','Commercial Bank','1007000007');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1008,'chamath.k@acmecorp.com','+94778234008','BOC','1008000008');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1009,'nethmi.w@acmecorp.com','+94779234009','NSB','1009000009');
INSERT INTO emp_contact (emp_id,work_email,mobile,bank_name,bank_account)
  VALUES (1010,'ishara.mendis@acmecorp.com','+94780234010','BOC','1010000010');

-- ── PAYROLL — last 3 months (Mar, Apr, May 2025) ─────────────────────────────
-- Basic salaries: G2=80k G3=120k G4=160k G5=220k G6=300k G7=450k G8=650k
DO $$
DECLARE
  ids   BIGINT[]   := ARRAY[1001,1002,1003,1004,1005,1006,1007,1008,1009,1010];
  bsals NUMERIC[]  := ARRAY[650000,450000,220000,160000,120000,120000,300000,80000,80000,120000];
  g     VARCHAR(5);
  trp   NUMERIC; mel NUMERIC; mob NUMERIC;
  epf_ee NUMERIC; epf_er NUMERIC; etf NUMERIC; tax NUMERIC;
  gross NUMERIC; net NUMERIC;
  cum_ee NUMERIC; cum_er NUMERIC; cum_et NUMERIC;
BEGIN
  FOR i IN 1..array_length(ids, 1) LOOP
    SELECT grade INTO g FROM emp_job WHERE emp_id = ids[i] AND is_current = 'Y';
    trp := CASE WHEN g >= '6' THEN 18000 WHEN g >= '4' THEN 15000 ELSE 15000 END;
    mel := 5000;
    mob := CASE WHEN g >= '8' THEN 10000 WHEN g >= '6' THEN 6000 WHEN g >= '4' THEN 4000 ELSE 0 END;
    cum_ee := 0; cum_er := 0; cum_et := 0;
    FOR m IN 1..3 LOOP
      epf_ee := ROUND((bsals[i] * 0.08)::NUMERIC, 2);
      epf_er := ROUND((bsals[i] * 0.12)::NUMERIC, 2);
      etf    := ROUND((bsals[i] * 0.03)::NUMERIC, 2);
      tax    := CASE WHEN bsals[i] >= 500000 THEN ROUND((bsals[i] * 0.24)::NUMERIC, 2)
                     WHEN bsals[i] >= 300000 THEN ROUND((bsals[i] * 0.18)::NUMERIC, 2)
                     WHEN bsals[i] >= 150000 THEN ROUND((bsals[i] * 0.06)::NUMERIC, 2)
                     ELSE 0 END;
      gross  := bsals[i] + trp + mel + mob;
      net    := gross - epf_ee - tax;
      cum_ee := cum_ee + epf_ee;
      cum_er := cum_er + epf_er;
      cum_et := cum_et + etf;
      INSERT INTO payroll (emp_id, pay_year, pay_month, basic_salary,
          transport_allowance, meal_allowance, mobile_allowance,
          gross_salary, epf_employee, epf_employer, etf_employer,
          tax_deduction, net_salary,
          cumulative_epf_employee, cumulative_epf_employer, cumulative_etf,
          payment_status)
        VALUES (ids[i], 2025, 2+m, bsals[i],
          trp, mel, mob, gross, epf_ee, epf_er, etf, tax, net,
          cum_ee, cum_er, cum_et,
          CASE WHEN m = 3 THEN 'PENDING' ELSE 'PAID' END);
    END LOOP;
  END LOOP;
END;
$$;

-- ── LEAVE_BALANCE 2026 ────────────────────────────────────────────────────────

-- Rajiv (15 yrs → 25 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days,carry_forward)
  VALUES (1001,'ANNUAL',2026,25,3,0,7);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days)
  VALUES (1001,'SICK',2026,14,0,0);

-- Priya (13 yrs → 25 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,carry_forward)
  VALUES (1002,'ANNUAL',2026,25,2,7);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1002,'SICK',2026,14,0);

-- Kamal (7 yrs → 21 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days,carry_forward)
  VALUES (1003,'ANNUAL',2026,21,6,2,7);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1003,'SICK',2026,14,3);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1003,'CASUAL',2026,7,1);

-- Dilini (6 yrs → 21 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,carry_forward)
  VALUES (1004,'ANNUAL',2026,21,3,0);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1004,'SICK',2026,14,1);

-- Tharindu (4 yrs → 17 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days)
  VALUES (1005,'ANNUAL',2026,17,4,3);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1005,'SICK',2026,14,5);

-- Sanduni (3 yrs → 17 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days)
  VALUES (1006,'ANNUAL',2026,17,0,5);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1006,'SICK',2026,14,1);

-- Amila (9 yrs → 21 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,carry_forward)
  VALUES (1007,'ANNUAL',2026,21,8,7);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1007,'SICK',2026,14,2);

-- Chamath (PROBATION → no leave yet)

-- Nethmi (2 yrs → 14 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1009,'ANNUAL',2026,14,1);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1009,'SICK',2026,14,0);

-- Ishara (1 yr → 14 days)
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days,pending_days)
  VALUES (1010,'ANNUAL',2026,14,2,0);
INSERT INTO leave_balance (emp_id,leave_type,year,entitled_days,used_days)
  VALUES (1010,'SICK',2026,14,0);

-- ── LEAVE_REQUEST — history and pending ───────────────────────────────────────
-- Kamal: taken annual leave Jan, sick Feb, pending June
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1003,'ANNUAL','2025-01-06','2025-01-10',5,'Family vacation',
    'TAKEN',1001,TIMESTAMP '2024-12-20 10:00:00');
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1003,'SICK','2025-02-12','2025-02-14',3,'Flu',
    'TAKEN',1001,TIMESTAMP '2025-02-12 08:00:00');
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status)
  VALUES (1003,'ANNUAL','2025-06-16','2025-06-17',2,'Personal','PENDING');

-- Tharindu: taken March, sick April, pending July
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1005,'ANNUAL','2025-03-17','2025-03-21',5,'New Year trip',
    'TAKEN',1003,TIMESTAMP '2025-03-10 09:00:00');
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1005,'SICK','2025-04-02','2025-04-04',3,'Dengue',
    'TAKEN',1003,TIMESTAMP '2025-04-02 07:00:00');
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1005,'SICK','2025-04-07','2025-04-08',2,'Extended recovery',
    'TAKEN',1003,TIMESTAMP '2025-04-07 07:00:00');
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status)
  VALUES (1005,'ANNUAL','2025-07-07','2025-07-09',3,'Trip','PENDING');

-- Sanduni: approved July leave
INSERT INTO leave_request (emp_id,leave_type,start_date,end_date,days_count,reason,status,approver_emp_id,approved_at)
  VALUES (1006,'ANNUAL','2025-07-14','2025-07-18',5,'Annual leave',
    'APPROVED',1002,TIMESTAMP '2025-05-20 14:00:00');

-- ── PERFORMANCE 2024 APR + 2025 Q1 ───────────────────────────────────────────
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,review_date,status)
  VALUES (1003,2024,'APR',4,1001,
    'Delivered microservices migration ahead of schedule; zero P1 incidents in H2.',
    '2024-12-15','FINAL');
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,review_date,status)
  VALUES (1004,2024,'APR',5,1002,
    'Led onboarding overhaul; reduced time-to-productivity by 30%.',
    '2024-12-10','FINAL');
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,pip_active_flag,pip_start_date,pip_end_date,pip_outcome,review_date,status)
  VALUES (1005,2024,'APR',2,1003,
    'Sprint targets missed in Q3/Q4; code review participation below standard.',
    'Y','2025-01-15','2025-04-15','IN_PROGRESS','2024-12-18','FINAL');
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,review_date,status)
  VALUES (1006,2024,'APR',3,1002,
    'Month-end close accuracy 99.8%; prepared board packs on time.',
    '2024-12-17','FINAL');
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,review_date,status)
  VALUES (1007,2024,'APR',3,1001,
    'Warehouse digitalisation Phase 1 complete; SLA compliance 96%.',
    '2024-12-12','FINAL');
-- 2025 Q1
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,review_date,status)
  VALUES (1003,2025,'Q1',4,1001,
    'API Gateway v2 delivered; performance benchmarks exceeded.',
    '2025-04-05','FINAL');
INSERT INTO performance (emp_id,review_year,review_cycle,rating,reviewer_emp_id,goals_summary,pip_active_flag,pip_start_date,pip_end_date,pip_outcome,review_date,status)
  VALUES (1005,2025,'Q1',2,1003,
    'PIP mid-point: deadline compliance at 65% (target 90%).',
    'Y','2025-01-15','2025-04-15','IN_PROGRESS','2025-04-08','FINAL');

-- ── TRAINING ─────────────────────────────────────────────────────────────────
-- Kamal: AWS cert expiring soon (within 90 days of June 2025 test date)
INSERT INTO training (emp_id,course_name,provider,completion_date,cert_name,cert_expiry,ld_spend,year,status)
  VALUES (1003,'AWS Solutions Architect Professional','AWS','2022-08-15',
    'AWS Certified Solutions Architect Professional','2025-08-15',85000,2022,'COMPLETED');
INSERT INTO training (emp_id,course_name,provider,completion_date,ld_spend,year,status)
  VALUES (1003,'System Design Masterclass','Educative.io','2024-07-31',12000,2024,'COMPLETED');
INSERT INTO training (emp_id,course_name,provider,completion_date,ld_spend,year,status)
  VALUES (1003,'Tech Leaders Summit 2025','SLT Innovation','2025-02-21',35000,2025,'COMPLETED');

-- Dilini: SHRM cert active
INSERT INTO training (emp_id,course_name,provider,completion_date,cert_name,cert_expiry,ld_spend,year,status)
  VALUES (1004,'SHRM-CP Certification','SHRM','2024-06-30',
    'SHRM Certified Professional','2027-06-30',95000,2024,'COMPLETED');
INSERT INTO training (emp_id,course_name,provider,completion_date,ld_spend,year,status)
  VALUES (1004,'HR Analytics with Power BI','DataCamp','2025-03-31',22000,2025,'COMPLETED');

-- Tharindu: basic online course
INSERT INTO training (emp_id,course_name,provider,completion_date,ld_spend,year,status)
  VALUES (1005,'Docker & Kubernetes Fundamentals','Udemy','2025-02-28',8500,2025,'COMPLETED');
