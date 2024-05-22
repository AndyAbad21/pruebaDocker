
FROM ubuntu:20.04 as build

# enviroments (variablesd de entorno)
ENV DEBIAN_FRONTEND=noninteractive

# Instalación de dependencias
RUN apt-get update
RUN apt-get install -y curl gnupg2
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs npm

# Instalación de Angular CLI
RUN npm install -g @angular/cli

#Copiamos eh instalamos las dependencias de angular
WORKDIR /app
COPY appCliente/ /app
RUN npm install

# construimos la app
RUN ng build --prod

# Etapa 2: Configuración de Nginx para servir la aplicación Angular
FROM ubuntu:20.04

# enviroment (variables de entorno)
ENV DEBIAN_FRONTEND=noninteractive

# Instalación de Nginx
RUN apt-get update
RUN apt-get install -y nginx
RUN rm -rf /var/lib/apt/lists/*

COPY nginx/default.conf /etc/nginx/sites-available/default
COPY --from=build /app/dist/appCliente /usr/share/nginx/html

# Se expone el puerto 80
EXPOSE 80

# Iniciar el nginx
CMD ["nginx", "-g", "daemon off;"]
