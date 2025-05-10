#

###

### Mysql
* Las tablas dinámicas (que permiten creación y edición de filas) deben tener `fec_actu`, las que no (estáticas) solo tiene `fec_crea`.

* 

* 

* 

* 

* Para actualizar un registro luego de hacer un `insert`, por ejemplo, usar trigger, pero lo mejor es hacerlo desde la aplicación:
```sql
-- 1. Agregar la columna 'codigo' a la tabla 'negocios'
ALTER TABLE negocios
ADD COLUMN codigo VARCHAR(255);

-- 2. Crear el trigger que se ejecuta DESPUÉS de cada inserción
DELIMITER //
CREATE TRIGGER generar_codigo_negocio
AFTER INSERT ON negocios
FOR EACH ROW
BEGIN
    -- Actualizar la columna 'codigo' de la nueva fila insertada
    UPDATE negocios
    SET codigo = CONCAT('NEG', NEW.id, DATE_FORMAT(NEW.fec_crea, '%Y%m%d%H%i%s'))
    WHERE id = NEW.id;
END;
//
DELIMITER ;
```