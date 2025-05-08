# Exploracion Base de datos
show databases;
create database st_prosegur_080525;
use st_prosegur_080525;

# Crear Tablas
-- 
create table permisos(
id int primary key auto_increment,
permisos int not null,
descripcion varchar(250) not null,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
create table pass(
id int primary key auto_increment,
id_personal int not null,
pass varchar(250) not null,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
create table personal_rrhh(
id int primary key auto_increment,
nombre  varchar(250) not null,
apellido_p  varchar(250) not null,
apellido_m  varchar(250) not null,
puesto  varchar(250) not null,
cargo  varchar(250) not null,
negocio_ensucontrato int not null,
negocio_entornolaboral int not null,
permisos int not null,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
create table negocios(
id int primary key auto_increment,
n_negocio varchar(250),
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 


show tables;
