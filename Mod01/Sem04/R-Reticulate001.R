remove.packages("reticulate")
install.packages("reticulate", dependencies = TRUE)

library(reticulate)

# Paso opcional: Asegúrate de tener el módulo 'virtualenv' de Python instalado globalmente
# Esto solo es necesario si es la primera vez que usas reticulate para crear entornos
# py_install("virtualenv", pip = TRUE)

# 1. Define la RUTA donde quieres crear el nuevo entorno.
# Usaremos un nombre diferente para no sobrescribir el existente.
new_env_path <- "C:/virtual_environment/r_python_env" # ¡Nuevo nombre!

# 2. Crea el nuevo entorno virtual en la ruta especificada.
# Esto puede tardar un poco mientras se descarga e instala Python y los paquetes básicos.
# Si ya tienes una instalación de Python reconocida por reticulate, la usará.
# Si no, intentará descargar una versión compatible.
virtualenv_create(envname = new_env_path)
message(paste("¡Nuevo entorno virtual creado con éxito en:", new_env_path, "!"))

# 3. Indica a reticulate que use este nuevo entorno.
use_virtualenv(virtualenv = new_env_path, required = TRUE)
message(paste("Reticulate está usando ahora el entorno:", py_config()$python))

# 4. (Opcional pero recomendado) Instala algunos paquetes comunes de Python en este NUEVO entorno.
# Es buena práctica instalar aquí los paquetes de Python que vayas a usar.
py_install(packages = c("pandas", "numpy", "scikit-learn", "matplotlib"), envname = new_env_path)
message("Paquetes esenciales de Python instalados en el nuevo entorno.")

# 5. Verifica la configuración de Python una vez más para confirmar.
py_config()
