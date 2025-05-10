# Exploracion Base de datos
show databases;
create database st_prosegur_080525;
use st_prosegur_080525;

# Crear Tablas
-- 
/* En esta tabla no se debe permitir la edición.
 * Los permisos deben ser similares a linux:
 * Sobre los propios Requerimientos 1=Visualizar, 2=1+Crear/Editar, 3=2+Eliminar
 * Sobre los Requerimientos de subordinados 1=Visualizar, 2=1+Crear/Editar, 3=2+Eliminar
 * Permisos sería: propio_subordinado, ejemplo: 11 ó 21 ó 31 ó 32 ó 33
 * En app:
 * longtext se restringe a 1000 caracteres.
 * Los botones se muestran o bloquean según permisos.
 * */
create table permisos(
id int primary key auto_increment,
permisos int not null,
descripcion longtext not null,
fec_crea timestamp default current_timestamp()
);
select*from permisos;
-- 
/* Tabla de Negocios:
 * Esta tabla si se debe poder editar y agregar nuevas filas.  
 * */
create table negocios(
id int primary key auto_increment,
nombre varchar(250),
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
/* Tabla Personal de RRHH
 * Requiere tablas: negocio, permisos
 * */
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
email varchar(250) not null,
numcontacto int not null,
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp(),
FOREIGN KEY (permisos) REFERENCES permisos(id),
FOREIGN KEY (negocio_ensucontrato) REFERENCES negocios(id),
FOREIGN KEY (negocio_entornolaboral) REFERENCES negocios(id)
);
-- 
/* Tabla de relaciones Superior y Subordinado
 * Las relaciones siempre son verticales de arriba hacia abajo
 * Se establecen relacion de responsabilidad de Superior a Subordinado
 * Jefe de RRHH es el administrador del sistema
 * Jefe de RRHH es el Superior de todo el personal 
 * debe ser el rango más alto para poder asignar requerimientos al Gerente de RRHH
 * */
create table superiorsubordinado(
id int primary key auto_increment,
superior int not null,
subordinado int not null,
id_actu int,
fec_actu timestamp,
fec_crea timestamp default CURRENT_TIMESTAMP(),
FOREIGN KEY (superior) REFERENCES personal_rrhh(id),
FOREIGN KEY (subordinado) REFERENCES personal_rrhh(id)
);
-- 
/* Tabla de passwords para acceder al sistema.
 * En app: 
 * Cada vez que se actualiza el password guardar fecha en fec_actu
 * */
create table pass(
id int primary key auto_increment,
id_personal_rrhh int not null unique,
pass varchar(250) not null,
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp(),
FOREIGN KEY (id_personal_rrhh) REFERENCES personal_rrhh(id)
);

insert into pass(id_personal,pass) values(1,'xrt600');
update pass set pass=123, fec_actu=now() where id=1;
select*from pass;
-- 
/* Tabla de Prioridad de un Requerimiento:
 * Esta tabla si se debe poder editar y agregar nuevas filas.  
 * */
create table prioridadreq(
id int primary key auto_increment,
nombre varchar(250) not null, -- Alta ó Normal
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
/* Tabla de Tipo de Requerimiento:
 * Esta tabla si se debe poder editar y agregar nuevas filas.  
 * */
create table tiporeq(
id int primary key auto_increment,
nombre varchar(250) not null, -- Administrativo u Operacional
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
/*Tabla de Solicitantes: Clientes del Servicio de Busqueda de Personal
 * */
create table solicitantes(
id int primary key auto_increment,
nombre  varchar(250) not null,
apellido_p  varchar(250) not null,
apellido_m  varchar(250) not null,
puesto  varchar(250) not null,
negocio int not null,
email1 varchar(250) not null,
email2 varchar(250) not null,
numcontacto1 int not null,
numcontacto2 int not null,
numcontacto3 int not null,
fec_actu_solicitante timestamp,
id_actu_personal_rrhh int,
fec_actu_personal_rrhh timestamp,
fec_crea timestamp default current_timestamp(),
FOREIGN KEY (negocio) REFERENCES negocios(id)
);
-- 
/* Tabla de requerimientos de busqueda
 * Crear tablas adicionales para: tipo,prioridad, standby, adjuntos
 * Inicio y Finalización real de un Requerimiento solo puede ser modificado por quien este asignado.
 * El Estado del Requerimeinto se calcula con las fechas en la app no en la base de datos.
 * */ 
create table requerimientos(
id int primary key auto_increment,
tipo int, -- Tipo de Requerimiento. Si es Adminstrativo u Operaciones.
prioridad int, -- Alta o Normal.
nombre varchar(250) not null,
puesto varchar(250) not null,
nvacantes int not null,
perfil longtext not null,
detalles longtext not null,
id_solicitante int not null,
id_crea_personal_rrhh int null,
fec_crea timestamp default CURRENT_TIMESTAMP() not null,
fec_ini_prog timestamp not null,
fec_fin_prog timestamp not null,
id_aprobado_por int null,
fec_se_aprobo timestamp,
id_asignado_por int null,
fec_se_asigno timestamp,
fec_inicio_real timestamp,
fec_fin_real timestamp,
responsablebusqueda int null,
algunavez_standby int default 0,
ndiaslab_standby int default 0,
tiene_adjuntos int default 0,
fec_actu_solicitante timestamp,
id_actu_personal_rrhh int,
fec_actu_personal_rrhh timestamp,
FOREIGN KEY (tipo) REFERENCES tiporeq(id),
FOREIGN KEY (prioridad) REFERENCES prioridadreq(id),
FOREIGN KEY (id_solicitante) REFERENCES solicitantes(id),
FOREIGN KEY (id_crea_personal_rrhh) REFERENCES personal_rrhh(id),
FOREIGN KEY (id_aprobado_por) REFERENCES personal_rrhh(id),
FOREIGN KEY (id_asignado_por) REFERENCES personal_rrhh(id),
FOREIGN KEY (responsablebusqueda) REFERENCES personal_rrhh(id)
);
/* Tabla de Archivos Adjuntos: 
 * No permite actualización, se eliminan los antiguos y se debe subir de nuevo
 * todos los archivos.   
 * */
create table adjuntos(
id int primary key auto_increment,
id_req int not null,
nombre_real varchar(250) not null,
nombre_hash varchar(250) not null,
fec_crea timestamp default current_timestamp(),
FOREIGN KEY (id_req) REFERENCES requerimientos(id)
);
-- 
/*Tabla de días en standby
 * */
create table standby(
id int primary key auto_increment,
id_req int not null,
id_responsablebusqueda int not null,
fec_ini timestamp not null,
fec_fin timestamp not null,
FOREIGN KEY (id_req) REFERENCES requerimientos(id),
FOREIGN KEY (id_responsablebusqueda) REFERENCES personal_rrhh(id)
);
drop table standby;
-- 
/*Tabla de Postulantes
 * */
create table postulantes(
id int primary key auto_increment,
nombre  varchar(250) not null,
apellido_p  varchar(250) not null,
apellido_m  varchar(250) not null,
id_req  int null,
email1 varchar(250) not null,
email2 varchar(250) not null,
numcontacto1 int not null,
numcontacto2 int not null,
numcontacto3 int not null,
fec_actu_postulante timestamp,
id_actu_personal_rrhh int,
fec_actu_personal_rrhh timestamp,
fec_crea timestamp default current_timestamp()
);

# Gestion de Tablas
show tables;
select*from negocios;
select*from pass;
select*from permisos;
select*from personal_rrhh;
select*from postulantes;
select*from prioridadreq;
select*from requerimientos;
select*from solicitantes;
select*from adjuntos;
select*from standby;
select*from superiorsubordinado;
select*from tiporeq;

drop table negocios;
drop table pass;
drop table permisos;
drop table personal_rrhh;
drop table postulantes;
drop table prioridadreq;
drop table requerimientos;
drop table solicitantes;
drop table adjuntos;
drop table standby;
drop table superiorsubordinado;
drop table tiporeq;

# -------------------------------------------
# Test
# -------------------------------------------


create table cliente(
id int primary key auto_increment,
nombre varchar(250),
fec_crea timestamp default CURRENT_TIMESTAMP()
);

drop table mascota ;

create table mascota(
id int primary key auto_increment,
mascota varchar(250),
id_cliente int,
fec_crea timestamp default CURRENT_TIMESTAMP(),
foreign key (id_cliente) references cliente(id) on delete cascade on update cascade
) comment 'Tabla de mascotas' ;

insert into cliente values(null,'Lili',default);
insert into cliente values(null,'Alina',default);
insert into cliente values(null,'Julia',default);

insert into mascota values(null,'Sparky',1,default);
insert into mascota values(null,'Sparky2',2,default);
insert into mascota values(null,'Sparky3',3,default);
insert into mascota values(null,'Sparky4',1,default);

select*from cliente;
select*from mascota;
delete from mascota where id=2;
update cliente set id=100 where id=2;

delete from cliente where id=1;


select * 
from cliente
inner join mascota on cliente.id=mascota.id_cliente;

# ----------------------------------------

select*from cliente;
desc cliente;

create view Vista_1 as 
select*from cliente where fec_crea like '%13%';

show tables;
drop view Vista_1;

select * from Vista_1;



