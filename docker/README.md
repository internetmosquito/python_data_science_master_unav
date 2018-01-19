# Docker

Veamos como poner todo en marcha haciendo una instalación en local o utilizando Docker

Se incluye un fichero docker en el raíz que permite ejecutar Jupyter y los notebooks del master de forma automática y
isolada, siempre y cuando se instale Docker.

Por defecto, se incluyen los siguientes paquetes si se utiliza Docker:

* conda
* numpy
* pandas
* scipy
* matplotlib
* seaborn
* scikit-learn
* jupyter
* hide_code

## Instalación de Docker


### Entornos Windows

Descargar la version estable de Docker para Windows de [aqui](https://docs.docker.com/docker-for-windows/install/)

El instalador de Windows instala todo lo necesario para ponerse en marcha: Docker, Docker-machine y Docker-compose

A partir de aquí el proceso es muy parecido a Linux, seguir las instrucción de abajo.

### Entornos Linux


A continuación se explica el proceso para instalar Docker en un SO Ubuntu 16.04

Hay dos alternativas:

1. Instalar la versión oficial de los repositorios de Docker

```
$ sudo apt-get update
$ sudo apt-get install docker-ce 
```

2. Instalar la ultima versión (recomendado)


Añadimos la clave GPG para el repo oficial de Docker en nuestro sistema:

```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Añadimos el repo Docker a la lista de fuentes para apt:

```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```


Actualizamos la lista de paquetes:

```
$ sudo apt-get update
```

Nos aseguramos que vamos a obtener la ultima version de Docker:

```
$ apt-cache policy docker-ce
```

Deberiamos ver una salida similar a esta si todo va bien:

```
docker-ce:
  Installed: (none)
  Candidate: 17.03.1~ce-0~ubuntu-xenial
  Version table:
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
```

Instalamos Docker:

```
$ sudo apt-get install -y docker-ce
```

Si todo ha ido bien, Docker deberia estar instalado y ejecutandose, lo comprobamos:

```commandline
$ sudo systemctl status docker
```

Deberiamos ver el demonio activo:

```commandline
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2016-05-01 06:53:52 CDT; 1 weeks 3 days ago
     Docs: https://docs.docker.com
 Main PID: 749 (docker)
```

A continuación debemos garantizar que nuestro usuario puede ejecutar Docker sin sudo:

```commandline
$ sudo usermod -aG docker ${USER}
```

# Instalación de Docker-compose (opcional)

Instalar docker-compose es opcional, pero permite inicializar todo de forma bastante mas sencilla,
por lo que su instalación es recomendable.

Comprobamos primero si la ultima versión y nos la bajamos:

```commandline
$ sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
```

Garantizamos permisos:

```commandline
$ sudo chmod +x /usr/local/bin/docker-compose
```

Comprobamos que se ha instalado correctamente docker-compose:

```commandline
$ docker-compose --version
```

El resultado deberia ser algo parecido a lo siguiente:

```commandline
Output
docker-compose version 1.18.0, build 8dd22a9
```

Listo, ya podemos usar docker-compose en vez de docker para gestionar nuestros containers

# Jupyter

Para la instalación y uso de Jupyter dockerizada, vamos a utilizar como base la siguiente
imagen que se encuentra en el Hub de Docker:

* [Miniconda3](https://hub.docker.com/r/continuumio/miniconda3/)


Además, hemos escogido la extensión Hide_code que nos permite esconder y mostrar celdas
de los notebooks a discreción.

* [Hide_code](https://github.com/kirbs-/hide_code)

El fichero Dockerfile y Docker se encargan de la instalación y puesta en marcha de Jupyter

## Puesta en marcha


### Utilizando Docker-compose

Si utilizamos docker-compose, la puesta en marcha es mucho mas sencilla. Lo único que tenemos
que hacer es colocarnos en el directorio /python_data_science_master_unav y ejecutar el
siguiente comando:

```commandline
$ docker-compose up
```

Al finalizarse este comando tendremos Jupyter accesible en [http://localhost:8888](http:localhost:8888)


### Utilzando Docker

Una vez instalado Docker, procedemos a crear la imagen Docker que nos permitirá trabajar:

```commandline
docker build . -t miniconda
```

El parámetro t especifica el nombre de la imagen, no es obligatorio y podeís poner lo que
queraís ahí.

La primera vez que se lanza este comando se ejecutan todos los pasos definidos en el fichero 
Docker (Dockerfile) secuencialmente. Por este motivo puede tardar unos minutos dependiendo de 
la velocidad de conexión. La imagen que pedimos no se encuentra en nuestro repositorio local
y por lo tanto debe bajarse del Hub de Docker primero.

Posteriormente se instalan todos los paquetes necesarios.


En posteriores ejecuciones, veríamos una salida parecida a la siguiente:

```commandline
Sending build context to Docker daemon  129.5kB
Step 1/15 : FROM continuumio/miniconda3:latest
 ---> f700f7f570c7
Step 2/15 : RUN mkdir /opt/notebooks
 ---> Using cache
 ---> c61e60f2e9f1
Step 3/15 : RUN /opt/conda/bin/conda install numpy
 ---> Using cache
 ---> e166faab94ef
Step 4/15 : RUN /opt/conda/bin/conda install pandas
 ---> Using cache
 ---> 8e98087cb01e
Step 5/15 : RUN /opt/conda/bin/conda install scipy
 ---> Using cache
 ---> f2a2ec00c405
Step 6/15 : RUN /opt/conda/bin/conda install matplotlib
 ---> Using cache
 ---> 6c08b91f32d2
Step 7/15 : RUN /opt/conda/bin/conda install seaborn
 ---> Using cache
 ---> 5b0a58fc836f
Step 8/15 : RUN /opt/conda/bin/conda install scikit-learn
 ---> Using cache
 ---> 9cce67701728
Step 9/15 : RUN /opt/conda/bin/conda install jupyter -y
 ---> Using cache
 ---> 74f39c0a201c
Step 10/15 : RUN /opt/conda/bin/pip install hide_code
 ---> Using cache
 ---> 73de6c4ea5ff
Step 11/15 : RUN /opt/conda/bin/jupyter nbextension install --py hide_code
 ---> Using cache
 ---> aa5ae8c05f63
Step 12/15 : RUN /opt/conda/bin/jupyter nbextension enable --py hide_code
 ---> Using cache
 ---> 42e91d6442b4
Step 13/15 : RUN /opt/conda/bin/jupyter serverextension enable --py hide_code
 ---> Using cache
 ---> c81e79d6253b
Step 14/15 : EXPOSE 8888
 ---> Using cache
 ---> 2d828a4f51ee
Step 15/15 : CMD /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root --NotebookApp.token=''
 ---> Using cache
 ---> eddc40e42e4c
Successfully built eddc40e42e4c
Successfully tagged miniconda:latest
```

Una vez finalizado, podemos comprobar que tenemos las imagenes en local con el siguiente comando:

```commandline
$ sudo docker images
```

Que nos deberia mostrar algo parecido a lo siguiente:

```commandline
REPOSITORY                     TAG                 IMAGE ID            CREATED              SIZE
miniconda                      latest              eddc40e42e4c        About a minute ago   2.56GB
```

Ya podemos crear y arrancar nuestro primer container Docker:

```commandline
docker run --name datascience_master -d -v $(pwd)/master_notebooks:/opt/notebooks -p 8888:8888 miniconda
```

Veamos que significa esto cada parámetro

* name: Especifica el nombre del container, opcional
* d: Ejecuta el container en mode detached (en background)
* v: Especificamos un volumen para el container, que en este caso mapea la carpeta master_notebooks al 
path /opt/notebooks dentro del container, de modo que tenemos acceso a los notebooks
* p: Especificamos el puerto que queremos exponer desde dentro y fuera, 8888 en este caso
* miniconda: El tag (nombre) de la imagen que hemos creado en el paso anterior


La salida de este comando deberia parecerse a lo siguiente:

```commandline
13ef3b1a33ae03cad7fc3bb5eb58cfea2eb691fa3e8fee3b476b05b1f3df8c9a
```

Ya estamos listos para trabajar en Jupyter

## Acceder a Jupyter

Si hemos ejecutado los pasos anteriores correctamente, Jupyter esta accessible en 
[http://localhost:8888](http:localhost:8888)

Dentro de Jupyter, podemos acceder a los contenidos de master_notebooks y a los notebooks
que ahí se encuentran


## Instalación local

Se recomienda usar Anaconda si no se quiere utilizar Docker para instalar Anaconda y Jupyter

## Entornos Windows

Descargar Anaconda desde este [enlace](https://www.anaconda.com/download/#windows) y seguir los pasos de instalación.

Este paquete instala todo lo necesario para ponerse en marcha tanto con Jupyter (si queremos) como con todos los
paquetes de datos que vamos a utilizar. 

Una vez finalizada la instalación, podremos ejecutar los notebooks del curso como si estuvieramos en Docker.


