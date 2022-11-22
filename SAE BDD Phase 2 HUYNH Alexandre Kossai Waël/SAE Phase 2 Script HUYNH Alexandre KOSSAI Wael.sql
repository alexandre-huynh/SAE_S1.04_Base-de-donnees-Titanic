--Réinitialisation

drop table survivant;
drop table passager;
drop table ticket;

--Creation des tables

CREATE TABLE ticket(Name varchar(100) primary key, Pclass int, Ticket varchar(20), 
                    Fare float, Cabin varchar(20), Embarked varchar(1));

CREATE TABLE passager(PassengerId int primary key, Name varchar(100), Sex varchar(6), Age float, SibSp int, Parch int, 
                      foreign key (Name) references ticket(Name));

CREATE TABLE survivant(PassengerId int, Name varchar(100), Survived int, 
                       foreign key (PassengerId) references passager(passengerid),
                       foreign key (Name) references ticket(name));

SELECT * from ticket;
SELECT * from passager;
SELECT * from survivant;
SELECT * from passager natural join survivant natural join ticket;

--Exemple avec le passager n°1

INSERT INTO ticket VALUES ('Braund, Mr. Owen Harris', 3, 'A/5 21171', 7.25, null, 'S');
INSERT INTO passager VALUES (1,(select name from ticket), 'male', 22, 1, 0);
INSERT INTO survivant VALUES ((select passengerid from passager),(select name from ticket),0);

SELECT * from ticket;
SELECT * from passager;
SELECT * from survivant;
SELECT * from passager natural join survivant natural join ticket;

--Alimentation avec données titanic_train.csv

\copy ticket from '/Users/Asus/Documents/ticket.txt'
\copy passager from '/Users/Asus/Documents/passager.txt'
\copy survivant from '/Users/Asus/Documents/survivant.txt'


SELECT * from ticket;
SELECT * from passager;
SELECT * from survivant;
SELECT * from passager natural join survivant natural join ticket;
