create database Henry;
use Henry;
create table Carrera (
	idCarrera int not null auto_increment,
    Nombre varchar(50) not null,
    primary key (idCarrera)
);
create table Instructor (
	idInstructor int not null auto_increment,
    Cedula_de_identidad varchar(20) not null,
    Nombre varchar(30) not null,
    Apellido varchar(30) not null,
    Fecha_nacimiento date not null,
    Fecha_de_incorporacion date,
    primary key (idInstructor)
    );
create table Cohorte (
	idCohorte int not null auto_increment,
    Codigo varchar(15) not null,
    idCarrera int not null,
    Fecha_inicio date not null,
    Fecha_finalizacion date,
    idInstructor int not null,
    primary key (idCohorte),
    foreign key (idCarrera) references Carrera (idCarrera),
    foreign key (idInstructor) references Instructor (idInstructor)
);
create table Alumno (
	idAlumno int not null auto_increment,
    Cedula_de_identidad varchar(20) not null,
	Nombre varchar(30) not null,	
    Apellido varchar(30) not null,
    Fecha_nacimiento date not null,
    Fecha_ingreso date,
    idCohorte int not null,
    primary key (idAlumno),
    foreign key (idCohorte) references Cohorte (idCohorte)
);