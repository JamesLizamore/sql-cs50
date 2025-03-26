-- Insert sample data into the developers table
INSERT INTO developers (name, email)
VALUES ('Alice Smith', 'alice.smith@example.com'),
       ('Bob Johnson', 'bob.johnson@example.com'),
       ('Carol Williams', 'carol.williams@example.com'),
       ('David Brown', 'david.brown@example.com'),
       ('Eva Davis', 'eva.davis@example.com');

-- Insert sample data into the projects table
INSERT INTO projects (name, brd_resolved, tech_spec_resolved, official_start, actual_start)
VALUES ('Project Phoenix', TRUE, FALSE, '2023-01-15 09:00:00', '2023-01-14 10:00:00'),
       ('Project Titan', FALSE, TRUE, '2023-02-10 10:00:00', '2023-02-10 10:00:00'),
       ('Project Odyssey', TRUE, TRUE, '2023-03-05 08:30:00', '2023-03-02 09:45:00');

-- Insert sample data into the tickets table
INSERT INTO tickets (jira_number, description, project, assignee, difficulty, status)
VALUES ('JIRA-101', 'Initial project setup', 1, 1, '1', 'Resolved'),
       ('JIRA-102', 'Design database schema', 1, 2, '2', 'In-progress'),
       ('JIRA-103', 'Implement login feature', 2, 3, '3', 'Open'),
       ('JIRA-104', 'Fix security vulnerability', 2, 4, '2', 'In-progress'),
       ('JIRA-105', 'Optimize query performance', 3, 5, '1', 'Open'),
       ('JIRA-106', 'Enhance dashboard UI', 2, 5, '2', 'Open'),
       ('JIRA-107', 'Update API endpoints', 3, 3, '3', 'In-progress'),
       ('JIRA-108', 'Refactor authentication', 1, 4, '2', 'Resolved'),
       ('JIRA-109', 'Improve load testing scripts', 2, 2, '1', 'Open'),
       ('JIRA-110', 'Fix mobile responsiveness', 3, 1, '1', 'In-progress'),
       ('JIRA-111', 'Implement caching strategy', 1, 5, '3', 'Resolved'),
       ('JIRA-112', 'Code cleanup and refactor', 2, 4, '1', 'Open'),
       ('JIRA-113', 'Integrate analytics tool', 1, 2, '2', 'Resolved'),
       ('JIRA-114', 'Optimize DB queries', 3, 3, '3', 'In-progress'),
       ('JIRA-115', 'Update security protocols', 2, 1, '2', 'Open');


-- Insert sample data into the re-assigned table
INSERT INTO reassigned (ticket_id, changed_from, changed_to, reason)
VALUES (2, 2, 3, 'Developer reassigned due to workload'),
       (4, 4, 2, 'Specialized skill required for ticket resolution');

SELECT * FROM developers;
SELECT * FROM projects;
SELECT * FROM reassigned;
SELECT * FROM tickets;

SELECT d.name, p.name, t.description
FROM developers d
         JOIN tickets t ON d.id = t.assignee
         JOIN projects p ON t.project = p.id;

SELECT count(id) AS "Open Tickets"
FROM tickets
WHERE assignee = 1
  AND status = 'Open';

SELECT count(id) AS "In-Progress Tickets"
FROM tickets
WHERE assignee = 2
  AND status = 'In-Progress';

SELECT p.name as "Project Name", count(*) AS "Total Tickets"
FROM projects p
         JOIN tickets t
              ON p.id = t.project
GROUP BY p.id;

SELECT *
FROM dev_summary;

CALL reassign_ticket(3, 1, 'Carol on leave');