/*Contexto del escenario
Continuando con la administración de la base de datos tienda_informatica, el departamento de seguridad de la empresa exige endurecer las directivas de acceso para cumplir estrictamente con las normativas de auditoría vigentes. Se requiere configurar cuentas con caducidad de credenciales, control estricto de tiempo de sesión, roles, vistas de seguridad y un análisis crítico de los privilegios asignados en MariaDB / MySQL.*/


/*Tarea 1: Creación de usuarios y políticas de conexión y caducidad*/
/*1. Creación de cuentas base: Crea un usuario llamado gestor_tienda que únicamente pueda conectarse desde la máquina local con la contraseña segura (explica qué requisitos estableces para que la contraseña sea segura). Crea un segundo usuario llamado auditor_externo que pueda conectarse desde cualquier dirección IP de la red.*/
CREATE USER 'gestor_tienda'@'localhost' IDENTIFIED BY 'Gest2026!';
CREATE USER 'auditor_externo'@'%' IDENTIFIED BY 'Ext2026!';
-- localhost es para que el usuario sea unicamente local y el % es para que se pueda conectar desde fuera. La contraseña de cada uno es segura porque tienen mayusculas, minusculas, numeros y simbolos

/*2. Directiva de caducidad de credenciales: Configura el usuario auditor_externo para que su contraseña caduque obligatoriamente cada 30 días, obligándole a reestablecerla pasado dicho plazo para evitar vulnerabilidades por credenciales estáticas.*/
ALTER USER 'auditor_externo'@'%' PASSWORD EXPIRE INTERVAL 30 DAY;
-- El usuario si o si debera modificar la contraseña tras 30 dias (PASSWORD EXPIRE INTERVAL)

/*3. Directiva de control de sesión: Establece una restricción técnica para que las conexiones activas del usuario gestor_tienda no puedan superar 1 hora de inactividad o tiempo de vida activo, forzando la reautenticación tras dicho periodo.*/
SET GLOBAL wait_timeout = 3600;
-- Tiene que ser si o si para todos los usuarios. Se mide en segundos (3600s = 1hora)

/*Tarea 2: Creación y asignación de roles*/
/*1. Definición de rol operativo: Crea un rol denominado rol_consultor.*/
CREATE ROLE 'rol_consultor'; 

/*2. Concesión de privilegios al rol: Otorga al rol rol_consultor permisos de solo lectura sobre toda la base de datos tienda_informatica.*/


/*3. Asignación y rol por defecto: Asigna el rol rol_consultor al usuario auditor_externo y configúralo explícitamente como rol por defecto para su sesión de trabajo.*/


/*Tarea 3: Seguridad mediante Vistas y Privilegios Granulares
Para proteger la información interna y confidencial de la empresa, el usuario gestor_tienda bajo ningún concepto debe tener acceso directo a la tabla completa de técnicos. Se debe proceder de la siguiente manera:*/
/*1. Creación de la vista de enmascaramiento: Crea una vista llamada v_tecnicos_activos que muestre únicamente el identificador, el nombre y la especialidad de los técnicos, ocultando por completo la columna de salarios.*/

/*2. Privilegio granular: Concede al usuario gestor_tienda permisos exclusivos de consulta sobre dicha vista v_tecnicos_activos.*/

/*3. Prueba de denegación: Comprueba y documenta qué ocurre si el usuario gestor_tienda intenta consultar directamente la tabla base tecnicos.*/


/*Tarea 4: Consistencia y control con WITH CHECK OPTION*/
/*1. Vista con restricción de dominio: Crea una vista llamada v_articulos_gama_baja basada en la tabla articulos que filtre aquellos productos cuyo precio sea inferior o igual a 50.00 euros (precio <= 50.00), incorporando obligatoriamente la cláusula WITH CHECK OPTION.*/

/*2. Demostración técnica: Razona y demuestra técnicamente qué sucede si el administrador o un usuario con permisos intenta realizar una inserción de un artículo con un precio de 75.00 euros a través de dicha vista.*/


/*Tarea 5: Auditoría, Resolución de Incidencias y Reflexión Crítica (Apartado de Análisis y Razonamiento)*/
/*1. Auditoría de privilegios efectivos: Imagina que el auditor externo reporta que no puede ver los cambios recientes en la base de datos. Escribe la sentencia SQL que utilizarías para comprobar los privilegios exactos y los roles activos que tiene asignados en este momento el usuario auditor_externo desde el servidor.*/

/*2. Reflexión sobre el Principio de Mínimo Privilegio: Explica razonadamente por qué en un entorno de producción nunca se debe otorgar el permiso ALL PRIVILEGES a los usuarios finales de una aplicación web o de gestión, y qué relación directa guarda esta mala práctica con las inyecciones SQL o brechas de seguridad.*/

/*3. Análisis de comportamiento del CHECK OPTION: Si un analista junior elimina la cláusula WITH CHECK OPTION en la v_articulos_gama_baja pensando que "mejora el rendimiento de las consultas", ¿qué brecha lógica o inconsistencia de datos podría introducir en la tabla base articulos al insertar registros mediante la vista? Justifica tu respuesta.*/