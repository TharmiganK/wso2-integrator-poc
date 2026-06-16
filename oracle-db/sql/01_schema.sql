-- =============================================================================
--  01_schema.sql  —  ACME HR Agent database schema
--  Runs inside FREEPDB1 as hr_user (created automatically by gvenzl image).
--  Contains exactly the tables and columns needed by the 5 MCP tools.
-- =============================================================================

-- ── DEPARTMENT ────────────────────────────────────────────────────────────────
CREATE TABLE department (
  dept_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  dept_code  VARCHAR2(10)  NOT NULL UNIQUE,
  dept_name  VARCHAR2(100) NOT NULL,
  hod_emp_id NUMBER
);

-- ── EMP_MASTER ────────────────────────────────────────────────────────────────
-- One row per employee, ever.
CREATE TABLE emp_master (
  emp_id         NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1001 PRIMARY KEY,
  employee_code  VARCHAR2(20)  NOT NULL UNIQUE,
  full_name      VARCHAR2(200) NOT NULL,
  nic            VARCHAR2(20),
  dob            DATE,
  gender         VARCHAR2(10),
  join_date      DATE          NOT NULL,
  confirmed_date DATE,
  emp_status     VARCHAR2(20)  DEFAULT 'PROBATION'
                 CHECK (emp_status IN ('PROBATION','ACTIVE','SUSPENDED','RESIGNED','TERMINATED'))
);

COMMENT ON COLUMN emp_master.join_date IS
  'Date employee started. Used to calculate years of service and leave entitlements.';

-- ── EMP_JOB ───────────────────────────────────────────────────────────────────
-- Current job record. is_current = 'Y' for the active row.
CREATE TABLE emp_job (
  job_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id          NUMBER        NOT NULL REFERENCES emp_master(emp_id),
  dept_id         NUMBER        NOT NULL REFERENCES department(dept_id),
  job_title       VARCHAR2(150) NOT NULL,
  grade           VARCHAR2(5)   NOT NULL,   -- '1' to '8'
  employment_type VARCHAR2(30)  DEFAULT 'FULL_TIME_PERMANENT',
  manager_emp_id  NUMBER        REFERENCES emp_master(emp_id),
  effective_date  DATE          NOT NULL,
  is_current      CHAR(1)       DEFAULT 'Y'
);

-- ── EMP_CONTACT ───────────────────────────────────────────────────────────────
CREATE TABLE emp_contact (
  emp_id        NUMBER        NOT NULL UNIQUE REFERENCES emp_master(emp_id),
  work_email    VARCHAR2(200) NOT NULL UNIQUE,
  mobile        VARCHAR2(30),
  bank_name     VARCHAR2(100),
  bank_account  VARCHAR2(50)
);

-- ── PAYROLL ───────────────────────────────────────────────────────────────────
-- One row per employee per month.
CREATE TABLE payroll (
  payroll_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id              NUMBER       NOT NULL REFERENCES emp_master(emp_id),
  pay_year            NUMBER(4)    NOT NULL,
  pay_month           NUMBER(2)    NOT NULL CHECK (pay_month BETWEEN 1 AND 12),
  basic_salary        NUMBER(12,2) NOT NULL,
  transport_allowance NUMBER(12,2) DEFAULT 0,
  meal_allowance      NUMBER(12,2) DEFAULT 0,
  mobile_allowance    NUMBER(12,2) DEFAULT 0,
  gross_salary        NUMBER(12,2) NOT NULL,
  epf_employee        NUMBER(12,2) DEFAULT 0,
  epf_employer        NUMBER(12,2) DEFAULT 0,
  etf_employer        NUMBER(12,2) DEFAULT 0,
  tax_deduction       NUMBER(12,2) DEFAULT 0,
  net_salary          NUMBER(12,2) NOT NULL,
  -- running EPF/ETF totals (updated each month)
  cumulative_epf_employee NUMBER(14,2) DEFAULT 0,
  cumulative_epf_employer NUMBER(14,2) DEFAULT 0,
  cumulative_etf          NUMBER(14,2) DEFAULT 0,
  payment_status      VARCHAR2(20) DEFAULT 'PAID',
  CONSTRAINT uq_payroll UNIQUE (emp_id, pay_year, pay_month)
);

-- ── LEAVE_BALANCE ─────────────────────────────────────────────────────────────
-- One row per employee per leave type per year.
CREATE TABLE leave_balance (
  balance_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id        NUMBER       NOT NULL REFERENCES emp_master(emp_id),
  leave_type    VARCHAR2(30) NOT NULL
                CHECK (leave_type IN ('ANNUAL','SICK','CASUAL','MATERNITY',
                                      'PATERNITY','BEREAVEMENT','STUDY','UNPAID')),
  year          NUMBER(4)    NOT NULL,
  entitled_days NUMBER(5,1)  NOT NULL,
  used_days     NUMBER(5,1)  DEFAULT 0,
  pending_days  NUMBER(5,1)  DEFAULT 0,
  carry_forward NUMBER(5,1)  DEFAULT 0,
  -- balance_days = entitled + carry_forward - used - pending (virtual)
  balance_days  NUMBER(5,1)  GENERATED ALWAYS AS
                (entitled_days + carry_forward - used_days - pending_days) VIRTUAL,
  CONSTRAINT uq_leave_bal UNIQUE (emp_id, leave_type, year)
);

-- ── LEAVE_REQUEST ─────────────────────────────────────────────────────────────
CREATE TABLE leave_request (
  request_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           NUMBER       NOT NULL REFERENCES emp_master(emp_id),
  leave_type       VARCHAR2(30) NOT NULL,
  start_date       DATE         NOT NULL,
  end_date         DATE         NOT NULL,
  days_count       NUMBER(5,1)  NOT NULL,
  half_day_flag    CHAR(1)      DEFAULT 'N',
  reason           VARCHAR2(500),
  status           VARCHAR2(20) DEFAULT 'PENDING'
                   CHECK (status IN ('PENDING','APPROVED','REJECTED','CANCELLED','TAKEN')),
  approver_emp_id  NUMBER       REFERENCES emp_master(emp_id),
  approved_at      TIMESTAMP,
  rejection_reason VARCHAR2(500),
  submitted_at     TIMESTAMP    DEFAULT SYSTIMESTAMP
);

-- ── PERFORMANCE ───────────────────────────────────────────────────────────────
CREATE TABLE performance (
  perf_id          NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           NUMBER       NOT NULL REFERENCES emp_master(emp_id),
  review_year      NUMBER(4)    NOT NULL,
  review_cycle     VARCHAR2(5)  NOT NULL CHECK (review_cycle IN ('Q1','Q2','Q3','APR')),
  rating           NUMBER(2,1)  CHECK (rating BETWEEN 1 AND 5),
  reviewer_emp_id  NUMBER       REFERENCES emp_master(emp_id),
  goals_summary    VARCHAR2(2000),
  pip_active_flag  CHAR(1)      DEFAULT 'N',
  pip_start_date   DATE,
  pip_end_date     DATE,
  pip_outcome      VARCHAR2(20),
  review_date      DATE,
  status           VARCHAR2(20) DEFAULT 'FINAL',
  CONSTRAINT uq_perf UNIQUE (emp_id, review_year, review_cycle)
);

-- ── TRAINING ──────────────────────────────────────────────────────────────────
CREATE TABLE training (
  training_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id          NUMBER        NOT NULL REFERENCES emp_master(emp_id),
  course_name     VARCHAR2(300) NOT NULL,
  provider        VARCHAR2(200),
  completion_date DATE,
  cert_name       VARCHAR2(300),
  cert_expiry     DATE,
  ld_spend        NUMBER(12,2)  DEFAULT 0,
  year            NUMBER(4)     NOT NULL,
  status          VARCHAR2(20)  DEFAULT 'COMPLETED'
);

-- ── DISCIPLINARY ──────────────────────────────────────────────────────────────
CREATE TABLE disciplinary (
  action_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           NUMBER        NOT NULL REFERENCES emp_master(emp_id),
  action_stage     VARCHAR2(30)  NOT NULL,
  issue_date       DATE          NOT NULL,
  expiry_date      DATE,
  incident_summary VARCHAR2(1000),
  is_active        CHAR(1)       DEFAULT 'Y',
  hr_reference     VARCHAR2(50)
);

-- ── Useful view: full employee context in one query ───────────────────────────
CREATE OR REPLACE VIEW v_employee_context AS
SELECT
  m.emp_id,
  m.employee_code,
  m.full_name,
  m.join_date,
  m.emp_status,
  m.confirmed_date,
  j.job_title,
  j.grade,
  j.employment_type,
  j.manager_emp_id,
  mgr.full_name       AS manager_name,
  d.dept_name,
  d.dept_code,
  c.work_email,
  c.mobile,
  -- years of service computed at query time
  TRUNC(MONTHS_BETWEEN(SYSDATE, m.join_date) / 12) AS years_of_service,
  TRUNC(MONTHS_BETWEEN(SYSDATE, m.join_date))       AS months_of_service
FROM  emp_master  m
JOIN  emp_job     j   ON j.emp_id  = m.emp_id AND j.is_current = 'Y'
JOIN  department  d   ON d.dept_id = j.dept_id
LEFT JOIN emp_master  mgr ON mgr.emp_id = j.manager_emp_id
LEFT JOIN emp_contact c   ON c.emp_id   = m.emp_id;

-- ── Indexes ───────────────────────────────────────────────────────────────────
CREATE INDEX idx_job_current   ON emp_job(emp_id, is_current);
CREATE INDEX idx_pay_emp_month ON payroll(emp_id, pay_year, pay_month);
CREATE INDEX idx_lbal_emp_year ON leave_balance(emp_id, year);
CREATE INDEX idx_lreq_emp      ON leave_request(emp_id, status);
CREATE INDEX idx_perf_emp_year ON performance(emp_id, review_year);
CREATE INDEX idx_train_emp_yr  ON training(emp_id, year);

COMMIT;
