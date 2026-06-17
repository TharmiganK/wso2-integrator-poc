-- =============================================================================
--  01_schema.sql  —  ACME HR Agent database schema (PostgreSQL)
--  Runs inside acme_hr as hr_user via docker-entrypoint-initdb.d.
--  Contains exactly the tables and columns needed by the 5 MCP tools.
-- =============================================================================

-- ── DEPARTMENT ────────────────────────────────────────────────────────────────
CREATE TABLE department (
  dept_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  dept_code  VARCHAR(10)  NOT NULL UNIQUE,
  dept_name  VARCHAR(100) NOT NULL,
  hod_emp_id BIGINT
);

-- ── EMP_MASTER ────────────────────────────────────────────────────────────────
CREATE TABLE emp_master (
  emp_id         BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1001) PRIMARY KEY,
  employee_code  VARCHAR(20)  NOT NULL UNIQUE,
  full_name      VARCHAR(200) NOT NULL,
  nic            VARCHAR(20),
  dob            DATE,
  gender         VARCHAR(10),
  join_date      DATE         NOT NULL,
  confirmed_date DATE,
  emp_status     VARCHAR(20)  DEFAULT 'PROBATION'
                 CHECK (emp_status IN ('PROBATION','ACTIVE','SUSPENDED','RESIGNED','TERMINATED'))
);

COMMENT ON COLUMN emp_master.join_date IS
  'Date employee started. Used to calculate years of service and leave entitlements.';

-- ── EMP_JOB ───────────────────────────────────────────────────────────────────
CREATE TABLE emp_job (
  job_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id          BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  dept_id         BIGINT        NOT NULL REFERENCES department(dept_id),
  job_title       VARCHAR(150)  NOT NULL,
  grade           VARCHAR(5)    NOT NULL,
  employment_type VARCHAR(30)   DEFAULT 'FULL_TIME_PERMANENT',
  manager_emp_id  BIGINT        REFERENCES emp_master(emp_id),
  effective_date  DATE          NOT NULL,
  is_current      CHAR(1)       DEFAULT 'Y'
);

-- ── EMP_CONTACT ───────────────────────────────────────────────────────────────
CREATE TABLE emp_contact (
  emp_id        BIGINT        NOT NULL UNIQUE REFERENCES emp_master(emp_id),
  work_email    VARCHAR(200)  NOT NULL UNIQUE,
  mobile        VARCHAR(30),
  bank_name     VARCHAR(100),
  bank_account  VARCHAR(50)
);

-- ── PAYROLL ───────────────────────────────────────────────────────────────────
CREATE TABLE payroll (
  payroll_id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id                  BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  pay_year                SMALLINT      NOT NULL,
  pay_month               SMALLINT      NOT NULL CHECK (pay_month BETWEEN 1 AND 12),
  basic_salary            NUMERIC(12,2) NOT NULL,
  transport_allowance     NUMERIC(12,2) DEFAULT 0,
  meal_allowance          NUMERIC(12,2) DEFAULT 0,
  mobile_allowance        NUMERIC(12,2) DEFAULT 0,
  gross_salary            NUMERIC(12,2) NOT NULL,
  epf_employee            NUMERIC(12,2) DEFAULT 0,
  epf_employer            NUMERIC(12,2) DEFAULT 0,
  etf_employer            NUMERIC(12,2) DEFAULT 0,
  tax_deduction           NUMERIC(12,2) DEFAULT 0,
  net_salary              NUMERIC(12,2) NOT NULL,
  cumulative_epf_employee NUMERIC(14,2) DEFAULT 0,
  cumulative_epf_employer NUMERIC(14,2) DEFAULT 0,
  cumulative_etf          NUMERIC(14,2) DEFAULT 0,
  payment_status          VARCHAR(20)   DEFAULT 'PAID',
  CONSTRAINT uq_payroll UNIQUE (emp_id, pay_year, pay_month)
);

-- ── LEAVE_BALANCE ─────────────────────────────────────────────────────────────
CREATE TABLE leave_balance (
  balance_id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id        BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  leave_type    VARCHAR(30)   NOT NULL
                CHECK (leave_type IN ('ANNUAL','SICK','CASUAL','MATERNITY',
                                      'PATERNITY','BEREAVEMENT','STUDY','UNPAID')),
  year          SMALLINT      NOT NULL,
  entitled_days NUMERIC(5,1)  NOT NULL,
  used_days     NUMERIC(5,1)  DEFAULT 0,
  pending_days  NUMERIC(5,1)  DEFAULT 0,
  carry_forward NUMERIC(5,1)  DEFAULT 0,
  balance_days  NUMERIC(5,1)  GENERATED ALWAYS AS
                (entitled_days + carry_forward - used_days - pending_days) STORED,
  CONSTRAINT uq_leave_bal UNIQUE (emp_id, leave_type, year)
);

-- ── LEAVE_REQUEST ─────────────────────────────────────────────────────────────
CREATE TABLE leave_request (
  request_id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  leave_type       VARCHAR(30)   NOT NULL,
  start_date       DATE          NOT NULL,
  end_date         DATE          NOT NULL,
  days_count       NUMERIC(5,1)  NOT NULL,
  half_day_flag    CHAR(1)       DEFAULT 'N',
  reason           VARCHAR(500),
  status           VARCHAR(20)   DEFAULT 'PENDING'
                   CHECK (status IN ('PENDING','APPROVED','REJECTED','CANCELLED','TAKEN')),
  approver_emp_id  BIGINT        REFERENCES emp_master(emp_id),
  approved_at      TIMESTAMP,
  rejection_reason VARCHAR(500),
  submitted_at     TIMESTAMP     DEFAULT NOW()
);

-- ── PERFORMANCE ───────────────────────────────────────────────────────────────
CREATE TABLE performance (
  perf_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  review_year      SMALLINT      NOT NULL,
  review_cycle     VARCHAR(5)    NOT NULL CHECK (review_cycle IN ('Q1','Q2','Q3','APR')),
  rating           NUMERIC(2,1)  CHECK (rating BETWEEN 1 AND 5),
  reviewer_emp_id  BIGINT        REFERENCES emp_master(emp_id),
  goals_summary    VARCHAR(2000),
  pip_active_flag  CHAR(1)       DEFAULT 'N',
  pip_start_date   DATE,
  pip_end_date     DATE,
  pip_outcome      VARCHAR(20),
  review_date      DATE,
  status           VARCHAR(20)   DEFAULT 'FINAL',
  CONSTRAINT uq_perf UNIQUE (emp_id, review_year, review_cycle)
);

-- ── TRAINING ──────────────────────────────────────────────────────────────────
CREATE TABLE training (
  training_id     BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id          BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  course_name     VARCHAR(300)  NOT NULL,
  provider        VARCHAR(200),
  completion_date DATE,
  cert_name       VARCHAR(300),
  cert_expiry     DATE,
  ld_spend        NUMERIC(12,2) DEFAULT 0,
  year            SMALLINT      NOT NULL,
  status          VARCHAR(20)   DEFAULT 'COMPLETED'
);

-- ── DISCIPLINARY ──────────────────────────────────────────────────────────────
CREATE TABLE disciplinary (
  action_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  emp_id           BIGINT        NOT NULL REFERENCES emp_master(emp_id),
  action_stage     VARCHAR(30)   NOT NULL,
  issue_date       DATE          NOT NULL,
  expiry_date      DATE,
  incident_summary VARCHAR(1000),
  is_active        CHAR(1)       DEFAULT 'Y',
  hr_reference     VARCHAR(50)
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
  mgr.full_name                                                       AS manager_name,
  d.dept_name,
  d.dept_code,
  c.work_email,
  c.mobile,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.join_date))::INT             AS years_of_service,
  (EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.join_date)) * 12
   + EXTRACT(MONTH FROM AGE(CURRENT_DATE, m.join_date)))::INT        AS months_of_service
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
