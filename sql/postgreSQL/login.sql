CREATE TABLE userlogin_email (
    userid  bigserial PRIMARY KEY ,
    fullname VARCHAR(30) NOT NULL ,
    gender VARCHAR (10) NOT  NULL ,
    email VARCHAR (50) NOT NULL ,
    password TEXT  NOT NULL ,
    birthday DATE NOT NULL ,
    address VARCHAR (100) NOT NULL ,
    image BYTEA NOT  NULL ,
    firstlogin DATE  ,
    lastlogin DATE  
);

CREATE TABLE userlogin_phonenumber (
    userid  bigserial PRIMARY KEY ,
    fullname VARCHAR(30) NOT NULL ,
    gender VARCHAR (10) NOT NULL ,
    phonenumber VARCHAR (50) NOT NULL ,
    password TEXT  NOT NULL ,
    birthday DATE NOT NULL ,
    address VARCHAR (100) NOT NULL ,
    image BYTEA NOT NULL ,
    firstlogin DATE  ,
    lastlogin DATE  
);