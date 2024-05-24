-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2024-05-22 20:53:02 COT
--   sitio:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2



CREATE USER hr IDENTIFIED BY ACCOUNT UNLOCK ;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE hr.cargo (
    id_cargo          NUMBER(*, 0) NOT NULL,
    cedula_empleado   NUMBER(*, 0) NOT NULL,
    nombre_cargo      VARCHAR2(20 BYTE) NOT NULL,
    descripcion       VARCHAR2(100 BYTE) NOT NULL,
    salario           NUMBER(10, 2) NOT NULL,
    horario           VARCHAR2(100 BYTE) NOT NULL,
    estado_cargo      VARCHAR2(100 BYTE) NOT NULL,
    id_departamentofk NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.cargo.id_cargo IS
    'Es un autoincrement para que se cree por cada cargo';

CREATE UNIQUE INDEX hr.cargo_pk ON
    hr.cargo (
        id_cargo
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.cargo
    ADD CONSTRAINT cargo_pk PRIMARY KEY ( id_cargo )
        USING INDEX hr.cargo_pk;

CREATE TABLE hr.cliente (
    id_cliente       NUMBER(*, 0) NOT NULL,
    nombre_cliente   VARCHAR2(100 BYTE) NOT NULL,
    cedula_cliente   NUMBER(*, 0) NOT NULL,
    telefono_cliente NUMBER(*, 0) NOT NULL,
    email_cliente    VARCHAR2(200 BYTE) NOT NULL,
    dir_res_cliente  VARCHAR2(200 BYTE) NOT NULL,
    fk_id_leads      NUMBER NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.cliente.id_cliente IS
    'Ser�a de tipo autoincrement en funci�n de el orden de la creaci�n del mismo y su inserci�n a la base de datos';

CREATE UNIQUE INDEX hr.id_cliente ON
    hr.cliente (
        id_cliente
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.cliente
    ADD CONSTRAINT cliente_pk PRIMARY KEY ( id_cliente )
        USING INDEX hr.id_cliente;

CREATE TABLE hr.contrato (
    id_contrato   NUMBER(*, 0) NOT NULL,
    cedula        NUMBER(*, 0) NOT NULL,
    fecha_inicio  VARCHAR2(20 BYTE) NOT NULL,
    fecha_fin     VARCHAR2(50 BYTE) NOT NULL,
    tipo_contrato VARCHAR2(20 BYTE) NOT NULL,
    salario       VARCHAR2(20 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.contrato_pk ON
    hr.contrato (
        id_contrato
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.contrato
    ADD CONSTRAINT contrato_pk PRIMARY KEY ( id_contrato )
        USING INDEX hr.contrato_pk;

CREATE TABLE hr.cuentas_por_cobrar (
    id_cuentas_pc     NUMBER(*, 0) NOT NULL,
    monto_pendiente   NUMBER(*, 0) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    fk_id_transaccion NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008555 ON
    hr.cuentas_por_cobrar (
        id_cuentas_pc
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.cuentas_por_cobrar
    ADD CONSTRAINT cuentas_por_cobrar_pk PRIMARY KEY ( id_cuentas_pc )
        USING INDEX hr.sys_c008555;

CREATE TABLE hr.cuentas_por_pagar (
    id_cuentas_pp     NUMBER(*, 0) NOT NULL,
    numero_factura    NUMBER(*, 0) NOT NULL,
    monto_pendiente   NUMBER(*, 0) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    proveedor_debe    VARCHAR2(100 BYTE) NOT NULL,
    estado            VARCHAR2(100 BYTE) NOT NULL,
    fk_id_transaccion NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008538 ON
    hr.cuentas_por_pagar (
        id_cuentas_pp
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.cuentas_por_pagar
    ADD CONSTRAINT cuentas_por_pagar_pk PRIMARY KEY ( id_cuentas_pp )
        USING INDEX hr.sys_c008538;

CREATE TABLE hr.departamento (
    id_departamento     NUMBER(*, 0) NOT NULL,
    nombre_departamento VARCHAR2(50 BYTE) NOT NULL,
    supervisor          VARCHAR2(50 BYTE) NOT NULL,
    ubicacion           VARCHAR2(100 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.departamento.id_departamento IS
    'Es de tipo autoincrement en funci�n de el orden de la creaci�n del mismo y su inserci�n a la base de datos';

CREATE UNIQUE INDEX hr.departamento_pk ON
    hr.departamento (
        id_departamento
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.departamento
    ADD CONSTRAINT departamento_pk PRIMARY KEY ( id_departamento )
        USING INDEX hr.departamento_pk;

CREATE TABLE hr.despidos (
    id_despidos   NUMBER(*, 0) NOT NULL,
    nombre        VARCHAR2(20 BYTE) NOT NULL,
    cedula        NUMBER(*, 0) NOT NULL,
    fecha_despido VARCHAR2(20 BYTE) NOT NULL,
    razon_despido VARCHAR2(50 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.despidos_pk ON
    hr.despidos (
        id_despidos
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.despidos
    ADD CONSTRAINT despidos_pk PRIMARY KEY ( id_despidos )
        USING INDEX hr.despidos_pk;

CREATE TABLE hr.empleados (
    id_empleado           NUMBER(*, 0) DEFAULT 1 NOT NULL,
    nombre_empleado       VARCHAR2(100 BYTE) NOT NULL,
    cedula_empleado       NUMBER(*, 0) NOT NULL,
    fkcargo_empleado      NUMBER(*, 0) NOT NULL,
    fecha_nacimiento      DATE NOT NULL,
    fecha_inicio_contrato DATE NOT NULL,
    salario_empleado      NUMBER(*, 2) NOT NULL,
    fk_id_contrato        NUMBER(*, 0) NOT NULL,
    id_transaccion        NUMBER(*, 0) NOT NULL,
    fk_id_despido         NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    )
NO INMEMORY;

COMMENT ON COLUMN hr.empleados.id_empleado IS
    'Es tipo autoincrement en funci�n de el orden de la creacion del mismo y su inserci�n a la base de datos';

CREATE UNIQUE INDEX hr.empleados_pk ON
    hr.empleados (
        id_empleado
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT )
        LOGGING;

ALTER TABLE hr.empleados
    ADD CONSTRAINT empleados_pk PRIMARY KEY ( id_empleado )
        USING INDEX hr.empleados_pk;

CREATE TABLE hr.factura (
    id_factura       NUMBER NOT NULL,
    fk_id_venta      NUMBER(*, 0) NOT NULL,
    fecha_de_emision DATE NOT NULL,
    descripcion      VARCHAR2(80 BYTE) NOT NULL,
    total            FLOAT(126) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.factura_pk ON
    hr.factura (
        id_factura
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.factura
    ADD CONSTRAINT factura_pk PRIMARY KEY ( id_factura )
        USING INDEX hr.factura_pk;

CREATE TABLE hr.formacion (
    id_formacion NUMBER(*, 0) NOT NULL,
    cedula       NUMBER(*, 0) NOT NULL,
    nombre_curso VARCHAR2(50 BYTE) NOT NULL,
    tiempo_curso VARCHAR2(50 BYTE) NOT NULL,
    estado       VARCHAR2(50 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.formacion_pk ON
    hr.formacion (
        id_formacion
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.formacion
    ADD CONSTRAINT formacion_pk PRIMARY KEY ( id_formacion )
        USING INDEX hr.formacion_pk;

CREATE TABLE hr.horarios_laborales (
    id_horarios             NUMBER(*, 0) NOT NULL,
    nombre_horario          VARCHAR2(100 BYTE) NOT NULL,
    hora_inicio             VARCHAR2(30 BYTE) NOT NULL,
    hora_finalizacion       VARCHAR2(30 BYTE) NOT NULL,
    dias_laborales          NUMBER(*, 0) NOT NULL,
    descansos               NUMBER(*, 0) NOT NULL,
    duracion_horario        NUMBER(*, 0) DEFAULT 8 NOT NULL,
    tipo_horario            VARCHAR2(20 BYTE) NOT NULL,
    fk_asignacion_empleados NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.horarios_laborales.id_horarios IS
    'Es de tipo autoincrement en funcion de el orden de la creacion del mismo y su insercion a la base de datos';

CREATE UNIQUE INDEX hr.horarios_laborales_pk ON
    hr.horarios_laborales (
        id_horarios
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.horarios_laborales
    ADD CONSTRAINT horarios_laborales_pk PRIMARY KEY ( id_horarios )
        USING INDEX hr.horarios_laborales_pk;

CREATE TABLE hr.informe_financiera (
    id_informe         NUMBER(*, 0) NOT NULL,
    nombre_informe     VARCHAR2(100 BYTE) NOT NULL,
    detalle_informe    VARCHAR2(100 BYTE) NOT NULL,
    nombre_responsable VARCHAR2(100 BYTE) NOT NULL,
    fecha              DATE NOT NULL,
    tipo_informe       VARCHAR2(100 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008500 ON
    hr.informe_financiera (
        id_informe
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.informe_financiera
    ADD CONSTRAINT informe_financiera_pk PRIMARY KEY ( id_informe )
        USING INDEX hr.sys_c008500;

CREATE TABLE hr.leads (
    id_lead         NUMBER NOT NULL,
    apellido        VARCHAR2(80 BYTE) NOT NULL,
    telefono        NUMBER NOT NULL,
    estado_del_lead VARCHAR2(80 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.leads_pk ON
    hr.leads (
        id_lead
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.leads
    ADD CONSTRAINT leads_pk PRIMARY KEY ( id_lead )
        USING INDEX hr.leads_pk;

CREATE TABLE hr.nomina (
    id_nomina          NUMBER(*, 0) NOT NULL,
    nombre_empleado    NVARCHAR2(20) NOT NULL,
    fk_cedula_empleado NUMBER(*, 0) NOT NULL,
    fecha              NUMBER(*, 0) NOT NULL,
    salario            DATE NOT NULL,
    horas_trabajadas   NUMBER NOT NULL,
    deducciones        NUMBER(20) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.nomina_pk ON
    hr.nomina (
        id_nomina
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.nomina
    ADD CONSTRAINT nomina_pk PRIMARY KEY ( id_nomina )
        USING INDEX hr.nomina_pk;

CREATE TABLE hr.oportunidad_de_venta (
    id_oportunidad          NUMBER NOT NULL,
    fk_id_cliente           NUMBER(*, 0) NOT NULL,
    nombre_oportunidad      VARCHAR2(100 BYTE) NOT NULL,
    estado_oportunidad      VARCHAR2(100 BYTE) NOT NULL,
    descripcion_oportunidad VARCHAR2(100 BYTE) NOT NULL,
    fecha_oportunidad       VARCHAR2(100 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.oportunidad_de_venta_pk ON
    hr.oportunidad_de_venta (
        id_oportunidad
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.oportunidad_de_venta
    ADD CONSTRAINT oportunidad_de_venta_pk PRIMARY KEY ( id_oportunidad )
        USING INDEX hr.oportunidad_de_venta_pk;

CREATE TABLE hr.permisos (
    id_departamento NUMBER(*, 0) NOT NULL,
    tipo_permiso    VARCHAR2(20 BYTE) NOT NULL,
    descripcion     VARCHAR2(100 BYTE) NOT NULL,
    fk_id_empleado  NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.permisos_pk ON
    hr.permisos (
        id_departamento
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.permisos
    ADD CONSTRAINT permisos_pk PRIMARY KEY ( id_departamento )
        USING INDEX hr.permisos_pk;

CREATE TABLE hr.presupuesto (
    id_presupuesto    NUMBER(*, 0) NOT NULL,
    a�o_fiscal        DATE NOT NULL,
    cantidad_asignada NUMBER(*, 0) NOT NULL,
    cantidad_gastada  NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008544 ON
    hr.presupuesto (
        id_presupuesto
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.presupuesto
    ADD CONSTRAINT presupuesto_pk PRIMARY KEY ( id_presupuesto )
        USING INDEX hr.sys_c008544;

CREATE TABLE hr.proveedor (
    id_proveedor           NUMBER(*, 0) NOT NULL,
    nombre_proveedor       VARCHAR2(100 BYTE) NOT NULL,
    num_contacto_proveedor NUMBER(*, 0) NOT NULL,
    email_proveedor        VARCHAR2(100 BYTE) NOT NULL,
    fk_cuentas_por_pagar   NUMBER(*, 0) NOT NULL,
    direccion              VARCHAR2(100 BYTE) NOT NULL,
    tipo_proveedor         VARCHAR2(100 BYTE) NOT NULL,
    condiciones_pago       VARCHAR2(20 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.proveedor.id_proveedor IS
    'Ser�a de tipo autoincrement en funci�n de el orden de la creaci�n del mismo y su inserci�n a la base de datos';

CREATE UNIQUE INDEX hr.id_proveedor ON
    hr.proveedor (
        id_proveedor
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.proveedor
    ADD CONSTRAINT proveedor_pk PRIMARY KEY ( id_proveedor )
        USING INDEX hr.id_proveedor;

CREATE TABLE hr.proyecto (
    id_proyecto    NUMBER(*, 0) NOT NULL,
    nombre         VARCHAR2(100 BYTE) NOT NULL,
    estado         VARCHAR2(100 BYTE) NOT NULL,
    fk_id_empleado NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    )
NO INMEMORY;

COMMENT ON COLUMN hr.proyecto.id_proyecto IS
    'seria de tipo secuencial en funcion del orden de la creacion del mismo y su inserci�n en la base de datos ';

CREATE UNIQUE INDEX hr.proyecto_pk ON
    hr.proyecto (
        id_proyecto
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT )
        LOGGING;

ALTER TABLE hr.proyecto
    ADD CONSTRAINT proyecto_pk PRIMARY KEY ( id_proyecto )
        USING INDEX hr.proyecto_pk;

CREATE TABLE hr.reclutamiento (
    id_reclutamiento NUMBER(*, 0) NOT NULL,
    cedula           NUMBER(*, 0) NOT NULL,
    nombre           VARCHAR2(50 BYTE) NOT NULL,
    reclutador       NUMBER(*, 0) NOT NULL,
    evaluacion       VARCHAR2(50 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.reclutamiento_pk ON
    hr.reclutamiento (
        id_reclutamiento
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.reclutamiento
    ADD CONSTRAINT reclutamiento_pk PRIMARY KEY ( id_reclutamiento )
        USING INDEX hr.reclutamiento_pk;

CREATE TABLE hr.rendimiento (
    id_rendimiento         NUMBER(*, 0) NOT NULL,
    empleado_evaluador     NUMBER(*, 0) NOT NULL,
    fecha_evaluacion       DATE NOT NULL,
    evaluador              VARCHAR2(50 BYTE) NOT NULL,
    objetivos_evaluados    VARCHAR2(50 BYTE) NOT NULL,
    competencias_evaluadas VARCHAR2(50 BYTE) NOT NULL,
    resultados             VARCHAR2(50 BYTE) NOT NULL,
    comentarios_evaluador  VARCHAR2(50 BYTE) NOT NULL,
    plan_desarrollo        VARCHAR2(50 BYTE) NOT NULL,
    historial_rendimiento  VARCHAR2(50 BYTE) NOT NULL,
    fk_idempleado          NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

COMMENT ON COLUMN hr.rendimiento.id_rendimiento IS
    'Este dato maestro registrara el rendimiento de los empleados en funcion de evaluaciones periodicas';

CREATE UNIQUE INDEX hr.table3_pk ON
    hr.rendimiento (
        id_rendimiento
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.rendimiento
    ADD CONSTRAINT rendimiento_pk PRIMARY KEY ( id_rendimiento )
        USING INDEX hr.table3_pk;

CREATE TABLE hr.tarea (
    id_tarea        NUMBER(*, 0) NOT NULL,
    nombre          VARCHAR2(100 BYTE) NOT NULL,
    estado          VARCHAR2(100 BYTE) NOT NULL,
    fecha_de_inicio DATE NOT NULL,
    fecha_final     VARCHAR2(20 BYTE) NOT NULL,
    descripcion     VARCHAR2(500 BYTE) NOT NULL,
    fk_id_proyecto  NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
    )
NO INMEMORY;

COMMENT ON COLUMN hr.tarea.id_tarea IS
    'Seria de tipo secuencial en funcion de orden de la creaci�n del mismo y su inserci�n a la base de datos';

COMMENT ON COLUMN hr.tarea.fk_id_proyecto IS
    'Seria la llave foranea para la tabla proyecto';

CREATE UNIQUE INDEX hr.table1_pk ON
    hr.tarea (
        id_tarea
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( INITIAL 65536 NEXT 1048576 PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS 2147483645 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
            DEFAULT )
        LOGGING;

ALTER TABLE hr.tarea
    ADD CONSTRAINT tarea_pk PRIMARY KEY ( id_tarea )
        USING INDEX hr.table1_pk;

CREATE TABLE hr.tipo_de_venta (
    id_tipo_de_venta NUMBER(*, 0) NOT NULL,
    descripcion      VARCHAR2(80 BYTE) NOT NULL,
    fk_id_cliente    NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.tipo_de_venta_pk ON
    hr.tipo_de_venta (
        id_tipo_de_venta
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.tipo_de_venta
    ADD CONSTRAINT fk_tipo_venta PRIMARY KEY ( id_tipo_de_venta )
        USING INDEX hr.tipo_de_venta_pk;

CREATE TABLE hr.transaccion (
    id_transaccion                NUMBER(*, 0) NOT NULL,
    tipo_transaccion              VARCHAR2(100 BYTE) NOT NULL,
    fecha_transaccion             DATE NOT NULL,
    monto_transaccion             NUMBER(*, 0) NOT NULL,
    id_informe                    NUMBER(*, 0) NOT NULL,
    fk_id_cliente                 NUMBER(*, 0) NOT NULL,
    fk_id_presupuesto             NUMBER(*, 0) NOT NULL,
    fk_id_transaccion_activo_fijo NUMBER(*, 0) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008464 ON
    hr.transaccion (
        id_transaccion
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.transaccion
    ADD CONSTRAINT transaccion_pk PRIMARY KEY ( id_transaccion )
        USING INDEX hr.sys_c008464;

CREATE TABLE hr.transaccion_activo_fijo (
    id_activo_fijo      NUMBER(*, 0) NOT NULL,
    nombre              VARCHAR2(100 BYTE) NOT NULL,
    valor_original      NUMBER(*, 0) NOT NULL,
    fecha_adquirido     DATE NOT NULL,
    vida_util           NUMBER(*, 0) NOT NULL,
    metodo_depreciacion NUMBER(*, 0) NOT NULL,
    estado_actual       NUMBER(1) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.sys_c008530 ON
    hr.transaccion_activo_fijo (
        id_activo_fijo
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.transaccion_activo_fijo
    ADD CONSTRAINT transaccion_activo_fijo_pk PRIMARY KEY ( id_activo_fijo )
        USING INDEX hr.sys_c008530;

CREATE TABLE hr.venta (
    id_venta                NUMBER(*, 0) NOT NULL,
    total_de_la_venta       FLOAT(126) NOT NULL,
    fecha_de_la_venta       DATE NOT NULL,
    fk_tipo_venta           NUMBER(*, 0) NOT NULL,
    descripcion_de_la_venta VARCHAR2(80 BYTE) NOT NULL
)
PCTFREE 10 PCTUSED 40 TABLESPACE users LOGGING
    STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
NO INMEMORY;

CREATE UNIQUE INDEX hr.venta_pk ON
    hr.venta (
        id_venta
    ASC )
        TABLESPACE users PCTFREE 10
            STORAGE ( PCTINCREASE 0 MINEXTENTS 1 MAXEXTENTS UNLIMITED FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT )
        LOGGING;

ALTER TABLE hr.venta
    ADD CONSTRAINT venta_pk PRIMARY KEY ( id_venta )
        USING INDEX hr.venta_pk;

ALTER TABLE hr.cargo
    ADD CONSTRAINT cargo_departamento FOREIGN KEY ( id_departamentofk )
        REFERENCES hr.departamento ( id_departamento )
    NOT DEFERRABLE;

ALTER TABLE hr.tipo_de_venta
    ADD CONSTRAINT cliente_a_tipo_de_venta FOREIGN KEY ( fk_id_cliente )
        REFERENCES hr.cliente ( id_cliente )
    NOT DEFERRABLE;

ALTER TABLE hr.transaccion
    ADD CONSTRAINT cliente_transaccion FOREIGN KEY ( fk_id_cliente )
        REFERENCES hr.cliente ( id_cliente )
    NOT DEFERRABLE;

ALTER TABLE hr.empleados
    ADD CONSTRAINT contrato_empleado FOREIGN KEY ( fk_id_contrato )
        REFERENCES hr.contrato ( id_contrato )
    NOT DEFERRABLE;

ALTER TABLE hr.cuentas_por_cobrar
    ADD CONSTRAINT cuentasporcobrar_transaccion FOREIGN KEY ( fk_id_transaccion )
        REFERENCES hr.transaccion ( id_transaccion )
    NOT DEFERRABLE;

ALTER TABLE hr.cuentas_por_pagar
    ADD CONSTRAINT cuentaspp_transaccion FOREIGN KEY ( fk_id_transaccion )
        REFERENCES hr.transaccion ( id_transaccion )
    NOT DEFERRABLE;

ALTER TABLE hr.empleados
    ADD CONSTRAINT empleado_cargo FOREIGN KEY ( fkcargo_empleado )
        REFERENCES hr.cargo ( id_cargo )
    NOT DEFERRABLE;

ALTER TABLE hr.empleados
    ADD CONSTRAINT empleado_despido FOREIGN KEY ( fk_id_despido )
        REFERENCES hr.despidos ( id_despidos )
    NOT DEFERRABLE;

ALTER TABLE hr.permisos
    ADD CONSTRAINT empleado_permisos FOREIGN KEY ( fk_id_empleado )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.reclutamiento
    ADD CONSTRAINT empleado_reclutamiento FOREIGN KEY ( cedula )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.rendimiento
    ADD CONSTRAINT empleado_rendimiento FOREIGN KEY ( fk_idempleado )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.factura
    ADD CONSTRAINT factura_a_venta FOREIGN KEY ( fk_id_venta )
        REFERENCES hr.venta ( id_venta )
    NOT DEFERRABLE;

ALTER TABLE hr.transaccion
    ADD CONSTRAINT fk_informe_financiera FOREIGN KEY ( id_informe )
        REFERENCES hr.informe_financiera ( id_informe )
    NOT DEFERRABLE;

ALTER TABLE hr.empleados
    ADD CONSTRAINT fk_transaccion FOREIGN KEY ( id_transaccion )
        REFERENCES hr.transaccion ( id_transaccion )
    NOT DEFERRABLE;

ALTER TABLE hr.formacion
    ADD CONSTRAINT formacion_empleado FOREIGN KEY ( cedula )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.horarios_laborales
    ADD CONSTRAINT horario_empleado FOREIGN KEY ( fk_asignacion_empleados )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.cliente
    ADD CONSTRAINT lead_cliente FOREIGN KEY ( fk_id_leads )
        REFERENCES hr.leads ( id_lead )
    NOT DEFERRABLE;

ALTER TABLE hr.nomina
    ADD CONSTRAINT nomina_empleado FOREIGN KEY ( fk_cedula_empleado )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.oportunidad_de_venta
    ADD CONSTRAINT oportunidadventa_cliente FOREIGN KEY ( fk_id_cliente )
        REFERENCES hr.cliente ( id_cliente )
    NOT DEFERRABLE;

ALTER TABLE hr.proveedor
    ADD CONSTRAINT proveedor_cuentaspp FOREIGN KEY ( fk_cuentas_por_pagar )
        REFERENCES hr.cuentas_por_pagar ( id_cuentas_pp )
    NOT DEFERRABLE;

ALTER TABLE hr.proyecto
    ADD CONSTRAINT proyecto_empleado FOREIGN KEY ( fk_id_empleado )
        REFERENCES hr.empleados ( id_empleado )
    NOT DEFERRABLE;

ALTER TABLE hr.tarea
    ADD CONSTRAINT tarea_proyecto FOREIGN KEY ( fk_id_proyecto )
        REFERENCES hr.proyecto ( id_proyecto )
    NOT DEFERRABLE;

ALTER TABLE hr.transaccion
    ADD CONSTRAINT transaccion_presupuesto FOREIGN KEY ( fk_id_presupuesto )
        REFERENCES hr.presupuesto ( id_presupuesto )
    NOT DEFERRABLE;

ALTER TABLE hr.transaccion
    ADD CONSTRAINT transaccion_transaccionactivofijo FOREIGN KEY ( fk_id_transaccion_activo_fijo )
        REFERENCES hr.transaccion_activo_fijo ( id_activo_fijo )
    NOT DEFERRABLE;

ALTER TABLE hr.venta
    ADD CONSTRAINT venta_tipoventa FOREIGN KEY ( fk_tipo_venta )
        REFERENCES hr.tipo_de_venta ( id_tipo_de_venta )
    NOT DEFERRABLE;

CREATE OR REPLACE TRIGGER HR.PROYECTO_TRIGGER 
    BEFORE INSERT ON HR.PROYECTO 
    FOR EACH ROW 
BEGIN
  SELECT proyecto_seq.NEXTVAL INTO :NEW.ID_PROYECTO FROM dual;
END; 
/

CREATE OR REPLACE TRIGGER HR.TAREA_TRIGGER 
    BEFORE INSERT ON HR.TAREA 
    FOR EACH ROW 
BEGIN
  SELECT tarea_seq.NEXTVAL INTO :NEW.ID_TAREA FROM dual;
END; 
/



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            26
-- CREATE INDEX                            26
-- ALTER TABLE                             51
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              1
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
