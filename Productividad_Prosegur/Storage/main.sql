# Exploracion Base de datos
show databases;
create database st_prosegur_080525;
use st_prosegur_080525;

# Crear Tablas
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
correo varchar(250) not null,
ncontacto int not null,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
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
fec_actu timestamp,
fec_crea timestamp default CURRENT_TIMESTAMP()
);
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
/* Tabla de passwords para acceder al sistema.
 * En app: 
 * Cada vez que se actualiza el password guardar fecha en fec_actu
 * */
create table pass(
id int primary key auto_increment,
id_personal int not null,
pass varchar(250) not null,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);

insert into pass(id_personal,pass) values(1,'xrt600');
update pass set pass=123, fec_actu=now() where id=1;
select*from pass;
-- 
/* Tabla de Negocios:
 * Esta tabla si se debe poder editar y agregar nuevas filas.  
 * */
create table negocios(
id int primary key auto_increment,
nombre varchar(250),
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
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
fec_crea timestamp default CURRENT_TIMESTAMP() not null,
fec_ini_prog timestamp not null,
fec_fin_prog timestamp not null,
id_aprobado_por int,
fec_se_aprobo timestamp not null,
id_asignado_por int,
fec_se_asigno timestamp not null,
fec_inicio_real timestamp not null,
fec_fin_real timestamp not null,
responsablebusqueda int,
algunavez_standby int,
ndiaslab_standby int,
sino_adjuntos int
);
-- 
/* Tabla de Prioridad de un Requerimiento:
 * Esta tabla si se debe poder editar y agregar nuevas filas.  
 * */
create table prioridadreq(
id int primary key auto_increment,
nombre varchar(250) not null,
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
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);
-- 
/* Tabla de Archivos Adjuntos: 
 * No permite actualización, se eliminan los antiguos y se debe subir de nuevo
 * todos los archivos.   
 * */
create table adjuntos(
id int primary key auto_increment,
id_req int not null,
nombre_real varchar(250) not null,
nombre_hash varchar(250) not null,
fec_crea timestamp default current_timestamp()
);
-- 
/*Tabla de días en standby
 * */
create table standby(
id int primary key auto_increment,
id_req int not null,
id_responsablebusqueda int not null,
fec_ini timestamp not null,
fec_fin timestamp not null
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
correo varchar(250) not null,
ncontacto1 int not null,
ncontacto2 int not null,
ncontacto3 int not null,
id_actu int,
fec_actu timestamp,
fec_crea timestamp default current_timestamp()
);


show tables;
