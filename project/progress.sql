CREATE DATABASE dev_projects;

USE dev_projects;

CREATE TABLE developers
(
    id    INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name  VARCHAR(50)                             NOT NULL,
    email VARCHAR(50)                             NOT NULL
);

CREATE TABLE projects
(
    id                 INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name               VARCHAR(50)                             NOT NULL,
    brd_resolved       BOOLEAN,
    tech_spec_resolved BOOLEAN,
    official_start     TIMESTAMP,
    actual_start       TIMESTAMP
);

CREATE TABLE tickets
(
    id          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    jira_number VARCHAR(10),
    description VARCHAR(50),
    project     INT UNSIGNED,
    assignee    INT UNSIGNED,
    difficulty  ENUM ('1','2','3')                      NOT NULL,
    status      ENUM ('Open', 'In-progress', 'Resolved'),
    FOREIGN KEY (project) REFERENCES projects (id),
    FOREIGN KEY (assignee) REFERENCES developers (id)
);

CREATE TABLE reassigned
(
    ticket_id    INT UNSIGNED,
    changed_from INT UNSIGNED,
    changed_to   INT UNSIGNED,
    reason       TEXT,
    FOREIGN KEY (changed_from) REFERENCES developers (id),
    FOREIGN KEY (changed_to) REFERENCES developers (id)
);

-- Insert sample data into the developers table
INSERT INTO developers (name, email)
VALUES ('Alice Smith', 'alice.smith@example.com'),
       ('Bob Johnson', 'bob.johnson@example.com'),
       ('Carol Williams', 'carol.williams@example.com'),
       ('David Brown', 'david.brown@example.com'),
       ('Eva Davis', 'eva.davis@example.com');

-- Insert sample data into the projects table
INSERT INTO projects (name, brd_resolved, tech_spec_resolved, official_start, actual_start)
VALUES ('Project Phoenix', TRUE, FALSE, '2023-01-15 09:00:00', '2023-01-20 10:00:00'),
       ('Project Titan', FALSE, TRUE, '2023-02-10 10:00:00', '2023-02-15 11:00:00'),
       ('Project Odyssey', TRUE, TRUE, '2023-03-05 08:30:00', '2023-03-07 09:45:00');

-- Insert sample data into the tickets table
INSERT INTO tickets (jira_number, description, project, assignee, difficulty, status)
VALUES ('JIRA-101', 'Initial project setup', 1, 1, '1', 'Resolved'),
       ('JIRA-102', 'Design database schema', 1, 2, '2', 'In-progress'),
       ('JIRA-103', 'Implement login feature', 2, 3, '3', 'Open'),
       ('JIRA-104', 'Fix security vulnerability', 2, 4, '2', 'In-progress'),
       ('JIRA-105', 'Optimize query performance', 3, 5, '1', 'Open');

-- Insert sample data into the reassigned table
INSERT INTO reassigned (ticket_id, changed_from, changed_to, reason)
VALUES (2, 2, 3, 'Developer reassigned due to workload'),
       (4, 4, 2, 'Specialized skill required for ticket resolution');

DROP TABLE developers;
DROP TABLE projects;
DROP TABLE reassigned;
DROP TABLE tickets;
DROP DATABASE dev_projects;

