-- Initialisation

CREATE TABLE ticket(Name varchar(100) primary key, Pclass int, Ticket varchar(20), 
                    Fare float, Cabin varchar(20), Embarked varchar(1));

CREATE TABLE passager(PassengerId int primary key, Name varchar(100), Sex varchar(6), Age float, SibSp int, Parch int, 
                      foreign key (Name) references ticket(Name));

CREATE TABLE survivant(PassengerId int, Name varchar(100), Survived int, 
                       foreign key (PassengerId) references passager(passengerid),
                       foreign key (Name) references ticket(name));

\copy ticket from '/Users/Asus/Documents/ticket.txt'
\copy passager from '/Users/Asus/Documents/passager.txt'
\copy survivant from '/Users/Asus/Documents/survivant.txt'

SELECT * from ticket;
SELECT * from passager;
SELECT * from survivant;

-- Requetes imposées

-- Combien de classes de passagers différentes y avait-il à bord du Titanic ?

select count(*) as classes_de_passagers
    from (select distinct pclass from ticket) as liste_classes;

-- Combien de passagers y avait-il dans chaque classe?

select pclass, count(*) as passagers
    from ticket
    group by pclass
    order by pclass;

-- Combien de femmes et d'hommes y avait-il dans chaque classe?

select ticket.pclass, passager.sex, count(*) as passagers
    from ticket natural join passager
    group by ticket.pclass,passager.sex
    order by ticket.pclass,passager.sex;

-- Comptez le nombre et le pourcentage de survivants et de passagers morts.

select survivant.survived, count(*) as passagers, (count(*) * 100 / (select count(*) from survivant)) as pourcentage
    from survivant
    group by survived;

-- Visualiser la répartition des passagers survivants et morts par classe

select ticket.pclass, survivant.survived, count(*) as passagers
    from ticket natural join survivant
    group by pclass, survived
    order by pclass, survived;

-- Visualiser la répartition des passagers survivants et des passagers décédés selon le sexe

select ticket.pclass, survivant.survived, passager.sex, count(*) as passagers
    from ticket natural join passager natural join survivant
    group by pclass, survived, sex
    order by pclass;

-- Requetes inventées

-- Donnez l'identifiant et le nom de tous les passagers survivants.

select passengerid,name 
    from survivant
    where survived=1;

-- Donnez le nom, le ticket et l'âge des hommes agés de plus ou égal 50 ans qui ont fait embarcation depuis le port de Cherbourg (C).

select ticket.name,ticket.ticket, passager.age
    from ticket natural join passager
    where ticket.embarked='C'and passager.age>=50 and passager.sex='male';

-- Donnez l'âge du passager le plus âgé.

select max(age) as age
    from passager;

-- Combien y'avait-il de mineurs parmi les passagers (strictement moins de 18 ans) ?

--Les passagers dont l'age est inconnu ont un age de 0.0
select count(*) as mineurs
    from passager
    where age>0.0 and age<18;

-- Combien y'avait-il de femmes parmi les passagers ?

select sex, count(*) as passagers
    from passager
    where sex='female'
    group by sex;

-- Combien y'avait-il de survivants au naufrage du Titanic ?

select survived, count(*) as passagers
    from survivant
    where survived=1
    group by survived;

-- Combien y'avait-il de femmes mineures qui ont survécus au naufrage ?

select count(*) as mineures_survivantes
    from passager natural join ticket natural join survivant
    where survived=1 and sex='female' and age<18;

-- A combien s'élève les profits réalisés à partir de la vente des tickets pour le voyage à bord du Titanic ?

select sum(fare) as benefices 
    from ticket;

--Commandes de réinitialisations

--delete from survivant;
--delete from passager;
--delete from ticket;

--drop table survivant;
--drop table passager;
--drop table ticket;
