CREATE DATABASE helicopter;
use helicopter;

CREATE TABLE obstacle (
    id int auto_increment,
    x int,
    y int,
    width int,
    height int,
    images varchar(100),
    primary key(id)
);

CREATE TABLE heliport (
    id int auto_increment,
    x int,
    y int,
    arrive int,
    images varchar(100),
    primary key(id)
);

CREATE TABLE time(
    temps int
);

insert into time values(1);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
insert into heliport values(null,0,325,0,'depart.png');
insert into heliport values(null,700,325,1,'arrive.png');

insert into obstacle values(null,200,400,50,700,'obstacle.jpg');
insert into obstacle values(null,400,400,50,700,'obstacle.jpg');
insert into obstacle values(null,600,300,50,700,'obstacle.jpg');
