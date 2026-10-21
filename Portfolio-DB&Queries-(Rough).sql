-- Creates the database
CREATE DATABASE portfolio_website;
USE portfolio_website;

-- 1. USER TABLE
CREATE TABLE `User` (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. PORTFOLIO TABLE
CREATE TABLE Portfolio (
    portfolio_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    visibility ENUM('public', 'private') DEFAULT 'private',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)
        REFERENCES `User`(user_id)
        ON DELETE CASCADE
);

-- 3. PROJECT TABLE
CREATE TABLE Project (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    project_url VARCHAR(255),
    project_date DATE,
    project_type VARCHAR(50),
    FOREIGN KEY (portfolio_id)
        REFERENCES Portfolio(portfolio_id)
        ON DELETE CASCADE
);

-- 4. EDUCATION TABLE
CREATE TABLE Education (
    education_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    institution VARCHAR(150) NOT NULL,
    degree VARCHAR(100),
    field_of_study VARCHAR(100),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id)
        REFERENCES `User`(user_id)
        ON DELETE CASCADE
);

-- 5. EXPERIENCE TABLE
CREATE TABLE Experience (
    experience_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    company VARCHAR(150) NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (user_id)
        REFERENCES `User`(user_id)
        ON DELETE CASCADE
);

-- 6. SKILL TABLE
CREATE TABLE Skill (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL UNIQUE,
    skill_category VARCHAR(100)
);

-- 7. USER_SKILL TABLE
CREATE TABLE User_Skill (
    user_id INT NOT NULL,
    skill_id INT NOT NULL,
    proficiency_level ENUM(
        'Beginner',
        'Intermediate',
        'Advanced',
        'Expert'
    ) DEFAULT 'Beginner',
    PRIMARY KEY (user_id, skill_id),
    FOREIGN KEY (user_id)
        REFERENCES `User`(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (skill_id)
        REFERENCES Skill(skill_id)
        ON DELETE CASCADE
);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Inserting fake data to test different tables
-- Add a test user
INSERT INTO `User`
    (first_name, last_name, email, password_hash, bio)
VALUES
    ('Test', 'Student', 'student@example.com',
     'replace_with_test_password_hash',
     'Business student interested in marketing and technology');

-- Add a portfolio for the test user
INSERT INTO Portfolio
    (user_id, title, description, visibility)
VALUES
    (1, 'Professional Portfolio',
     'A collection of academic and professional work',
     'public');

-- Add a project
INSERT INTO Project
    (portfolio_id, project_name, description,
     project_url, project_date, project_type)
VALUES
    (1, 'Marketing Research Project',
     'Research and analysis completed for a college course',
     'https://example.com/project',
     '2026-04-15', 'Marketing');

-- Add education
INSERT INTO Education
    (user_id, institution, degree, field_of_study,
     start_date, end_date)
VALUES
    (1, 'Example University', 'Bachelor of Science',
     'Business', '2023-09-01', '2027-05-15');

-- Add experience
INSERT INTO Experience
    (user_id, company, job_title, description,
     start_date, end_date)
VALUES
    (1, 'Example Company', 'Marketing Intern',
     'Assisted with research and campaign planning',
     '2026-01-15', NULL);

-- Add skills
INSERT INTO Skill (skill_name, skill_category)
VALUES
    ('Microsoft Excel', 'Technical'),
    ('SQL', 'Technical'),
    ('Communication', 'Professional');

-- Connect the user to two skills
INSERT INTO User_Skill
    (user_id, skill_id, proficiency_level)
VALUES
    (1, 1, 'Advanced'),
    (1, 2, 'Beginner');

----------------------------------------------------------------------------------------------------------------------------------------------
-- Testing results

-- Test 1 - Displaying user portfolio
SELECT
    u.first_name,
    u.last_name,
    p.title,
    p.description,
    p.visibility
FROM `User` u
JOIN Portfolio p ON u.user_id = p.user_id
WHERE u.user_id = 1;

-- Test 2 - Show all projects to unique portfolio
SELECT
    project_name,
    description,
    project_url,
    project_date
FROM Project
WHERE portfolio_id = 1;

-- Test 3 - Display Education and Experience
SELECT institution, degree, field_of_study
FROM Education
WHERE user_id = 1;

SELECT company, job_title, description
FROM Experience
WHERE user_id = 1;

-- Test 4 - Display users skills
SELECT
    s.skill_name,
    s.skill_category,
    us.proficiency_level
FROM User_Skill us
JOIN Skill s ON us.skill_id = s.skill_id
WHERE us.user_id = 1;

-- Test 5 - Add new project
INSERT INTO Project
    (portfolio_id, project_name, description, project_type)
VALUES
    (1, 'Database Design Project',
     'Designed and tested a relational database',
     'Technology');
     
-- Test 6 - Changing Portfolio visibility
UPDATE Portfolio
SET visibility = 'private'
WHERE portfolio_id = 1;

SELECT portfolio_id, title, visibility
FROM Portfolio
WHERE portfolio_id = 1;