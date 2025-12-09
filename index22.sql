CREATE DATABASE SienaShopping;
USE SienaShopping;

-- ==========================================
-- ROLES
-- ==========================================
CREATE TABLE t_rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    rol VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

INSERT INTO t_rol (rol) VALUES
("Administrador"),
("Vendedor"),
("Clienta");

-- ==========================================
-- USUARIOS (Empleados y clientas si deseas fusionarlos)
-- ==========================================
CREATE TABLE t_usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    CONSTRAINT fk_usuario_rol FOREIGN KEY(id_rol) REFERENCES t_rol(id_rol)
) ENGINE=InnoDB;

-- ==========================================
-- CLIENTAS / CLIENTES
-- ==========================================
CREATE TABLE t_cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    direccion VARCHAR(255)
) ENGINE=InnoDB;

-- ==========================================
-- CATEGORÍAS
-- ==========================================
CREATE TABLE t_categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- ==========================================
-- TALLAS
-- ==========================================
CREATE TABLE t_talla (
    id_talla INT AUTO_INCREMENT PRIMARY KEY,
    talla VARCHAR(10) NOT NULL
) ENGINE=InnoDB;

-- ==========================================
-- COLORES
-- ==========================================
CREATE TABLE t_color (
    id_color INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- ==========================================
-- PRODUCTOS
-- ==========================================
CREATE TABLE t_producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    id_categoria INT,
    precio_costo DECIMAL(10,2),
    precio_venta DECIMAL(10,2),
    CONSTRAINT fk_prod_categoria FOREIGN KEY(id_categoria) REFERENCES t_categoria(id_categoria)
) ENGINE=InnoDB;

-- ==========================================
-- FOTOS DE PRODUCTOS
-- ==========================================
CREATE TABLE t_foto_producto (
    id_foto INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    CONSTRAINT fk_foto_producto FOREIGN KEY(id_producto) REFERENCES t_producto(id_producto)
) ENGINE=InnoDB;

-- ==========================================
-- VARIANTES (Talla, color, stock) - CON UNIQUE
-- ==========================================
CREATE TABLE t_producto_variante (
    id_variante INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_talla INT NOT NULL,
    id_color INT NOT NULL,
    stock INT DEFAULT 0,
    CONSTRAINT fk_var_prod FOREIGN KEY(id_producto) REFERENCES t_producto(id_producto),
    CONSTRAINT fk_var_talla FOREIGN KEY(id_talla) REFERENCES t_talla(id_talla),
    CONSTRAINT fk_var_color FOREIGN KEY(id_color) REFERENCES t_color(id_color),
    
    -- Evita duplicados de combinaciones
    CONSTRAINT uq_variante_unica UNIQUE (id_producto, id_talla, id_color)
) ENGINE=InnoDB;

-- ==========================================
-- VENTAS
-- ==========================================
CREATE TABLE t_venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_usuario INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago VARCHAR(30),
    total DECIMAL(10,2),
    CONSTRAINT fk_venta_cliente FOREIGN KEY(id_cliente) REFERENCES t_cliente(id_cliente),
    CONSTRAINT fk_venta_usuario FOREIGN KEY(id_usuario) REFERENCES t_usuario(id_usuario)
) ENGINE=InnoDB;

-- ==========================================
-- DETALLE DE VENTA
-- ==========================================
CREATE TABLE t_detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_det_venta FOREIGN KEY(id_venta) REFERENCES t_venta(id_venta),
    CONSTRAINT fk_det_variante FOREIGN KEY(id_variante) REFERENCES t_producto_variante(id_variante)
) ENGINE=InnoDB;

-- ==========================================
-- PROMOCIONES
-- ==========================================
CREATE TABLE t_promocion (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    descuento DECIMAL(5,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
) ENGINE=InnoDB;

-- ==========================================
-- NOTIFICACIONES
-- ==========================================
CREATE TABLE t_notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_promocion INT NOT NULL,
    fecha_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    leida TINYINT DEFAULT 0,
    CONSTRAINT fk_notif_cliente FOREIGN KEY(id_cliente) REFERENCES t_cliente(id_cliente),
    CONSTRAINT fk_notif_prom FOREIGN KEY(id_promocion) REFERENCES t_promocion(id_promocion)
) ENGINE=InnoDB;

-- ==========================================
-- FOTOS QUE SUBEN CLIENTAS
-- ==========================================
CREATE TABLE t_foto_cliente (
    id_foto_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    url_foto VARCHAR(255) NOT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_foto_cli FOREIGN KEY(id_cliente) REFERENCES t_cliente(id_cliente),
    CONSTRAINT fk_foto_prod FOREIGN KEY(id_producto) REFERENCES t_producto(id_producto)
) ENGINE=InnoDB;

-- ==========================================
-- RESEÑAS (Con UNIQUE opcional)
-- ==========================================

CREATE TABLE t_resena (
    id_resena INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    calificacion TINYINT NOT NULL,
    comentario TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_calificacion CHECK (calificacion BETWEEN 1 AND 5),
    CONSTRAINT fk_resena_cliente FOREIGN KEY(id_cliente) REFERENCES t_cliente(id_cliente),
    CONSTRAINT fk_resena_producto FOREIGN KEY(id_producto) REFERENCES t_producto(id_producto),

    -- Una reseña por cliente por producto
    CONSTRAINT uq_resena_unica UNIQUE (id_cliente, id_producto)
) ENGINE=InnoDB;

CREATE TABLE t_factura(
    id_factura       int(11)  AUTO_INCREMENT NOT NULL,
    fecha            date,
    id_cliente       int(11),
    id_usuario       int(11),
    id_producto      int(11),
    cantidad         int(11),
    valor_unitario DECIMAL(10,2),
    CONSTRAINT       pk_factura   PRIMARY KEY(id_factura),
    CONSTRAINT       fk_cliente   FOREIGN KEY(id_cliente)   REFERENCES t_cliente(id_cliente),
    CONSTRAINT       fk_producto  FOREIGN KEY(id_producto)  REFERENCES t_producto(id_producto),
    CONSTRAINT       fk_usuario    FOREIGN KEY(id_usuario)   REFERENCES t_usuario(id_usuario)   
) ENGINE=InnoDB;

-- ==========================================
-- CIUDADES
-- ==========================================
CREATE TABLE t_ciudad(
    id_ciudad INT AUTO_INCREMENT NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_ciudad)
) ENGINE=InnoDb;

INSERT INTO t_ciudad (ciudad) VALUES
("Bogota"),
("Ibague"),
("Cartagena");

-- ==========================================
-- CARRITO (Artículos guardados antes de comprar)
-- ==========================================
CREATE TABLE t_carrito (
    id_carrito INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT DEFAULT 1,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_car_cliente FOREIGN KEY(id_cliente) REFERENCES t_cliente(id_cliente),
    CONSTRAINT fk_car_variante FOREIGN KEY(id_variante) REFERENCES t_producto_variante(id_variante),
    UNIQUE(id_cliente, id_variante)
) ENGINE=InnoDB;
