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

-- Procedure to re-assign ticket. Called using ticket's id, new assignee's dev id and reason for re-assignment.
-- Can't re-assign ticket to the same assignee
DELIMITER $$
CREATE PROCEDURE
    reassign_ticket(IN ticket_id INT, IN new_assignee INT, IN reason TEXT)
BEGIN

    DECLARE current_assignee INT;
    SELECT tickets.assignee INTO current_assignee FROM tickets WHERE tickets.id = ticket_id;

    IF current_assignee <> new_assignee THEN
        UPDATE tickets SET tickets.assignee = new_assignee WHERE tickets.id = ticket_id;
        INSERT INTO reassigned VALUES (ticket_id, current_assignee, new_assignee, reason);
    END IF;

END $$
DELIMITER ;

CREATE VIEW dev_summary AS
SELECT
       d.name                                  AS "Developer",
       COUNT(DISTINCT t.project)               AS "Total Projects",
       COUNT(t.id)                             AS "Total Tickets",
       SUM(IF(t.status = 'Open', 1, 0))        AS "Open Tickets",
       SUM(IF(t.status = 'In-Progress', 1, 0)) AS "In-Progress Tickets",
       SUM(IF(t.status = 'Resolved', 1, 0))    AS "Resolved Tickets",
       SUM(IF(t.difficulty = '1', 1, 0))       AS "Level 1 Tickets",
       SUM(IF(t.difficulty = '2', 1, 0))       AS "Level 2 Tickets",
       SUM(IF(t.difficulty = '3', 1, 0))       AS "Level 3 Tickets",
       -- Count tickets that were re-assigned away from the developer
       (SELECT COUNT(*)
        FROM reassigned r
        WHERE r.changed_from = d.id)           AS "Tickets dropped",
       -- Count tickets that were re-assigned to the developer
       (SELECT COUNT(*)
        FROM reassigned r
        WHERE r.changed_to = d.id)             AS "Tickets picked up"
FROM developers d
         LEFT JOIN tickets t
                   ON d.id = t.assignee
GROUP BY d.id, d.name;