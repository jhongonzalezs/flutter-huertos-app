# 🌱 APP PARA GESTIÓN DE HUERTOS URBANOS COMUNITARIOS

Una aplicación destinada a facilitar la **organización, participación y educación** en proyectos de **agricultura urbana**, promoviendo el **desarrollo sostenible** y la **colaboración vecinal**.

---

## 🔧 Tecnologías utilizadas

- ⚙️ **Backend:** API REST con [Express.js](https://expressjs.com/)
- ☁️ **Base de datos:** [Firebase Firestore](https://firebase.google.com/docs/firestore)
- 🔐 **Autenticación:** Firebase Authentication (correo y contraseña)
- 📱 **Frontend:** Aplicación móvil desarrollada con [Flutter](https://flutter.dev/) usando el paquete `http`

---

## 📦 Funcionalidades principales

### 1. 🌾 Planificación y gestión de espacios de cultivo
- Registro de parcelas (nombre, tamaño, tipo de cultivo, estado actual)
- Asignación de responsables según disponibilidad
- Calendario de tareas: siembra, riego, poda, limpieza, cosecha

### 2. 🤝 Participación comunitaria
- Inscripción de usuarios como voluntarios
- Registro de participación en tareas con tiempo dedicado
- Bitácora personal con historial de colaboración

### 3. 📚 Educación y sensibilización ambiental
- Sección educativa con talleres, charlas y eventos
- Calendario de actividades comunitarias

### 4. 📊 Estadísticas e impacto ambiental
- Participación por zonas
- Horas acumuladas de trabajo comunitario

---

## 🛠️ Estructura general de la app

- `Zonas de cultivo`
- `Mi participación`
- `Educación`
- `Perfil`

Cada sección incluye formularios, listas, botones de registro y otros widgets de interacción.


## 🗂️ Estructura del proyecto (backend)


---

## 🧪 Endpoints principales (API)

| Método | Ruta                          | Descripción                      |
|--------|-------------------------------|----------------------------------|
| POST   | `/api/usuarios`               | Registrar nuevo usuario          |
| POST   | `/api/usuarios/login`         | Iniciar sesión con correo y clave|
| GET    | `/api/usuarios`               | Listar todos los usuarios        |
| GET    | `/api/usuarios/:id`           | Obtener usuario por ID           |

> *Puedes consultar toda la documentación de la API usando Swagger.

---

## 🚀 Cómo ejecutar este proyecto

1. Clona el repositorio:
   ```bash
   git clone https://github.com/jhongonzalezs/flutter-huertos-app.git
   cd flutter-huertos-app


