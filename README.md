# Jwt Auth Microservice

Servicio/Microservicio hecho en Rails para administrar autorización y autenticación de aplicaciones, usuarios y permisos de usuarios sobre aplicaciones, usando JWT.

Está diseñado para ser una pieza más dentro un conjunto de aplicaciones o APIs que necesiten control de acceso de usuarios, con una configuración simple de permisos.

Si bien está creada para administrar usuarios relacionados con varias apliaciones, debido a su simpleza, sirve perfectamente como servicio de autenticación para una sola app.

# Utilización

El servicio consta de dos partes, un **Dashboard** de configuración y una **Interface API**.

## Dashboard

Administra los CRUD para:

### Apps

En el dashboard se crean las `Apps`, que representa cada una de las aplicaciones que queremos administrar.

Requiere los campos:

* Name
* Timeout
* Permissions

`Name` es un nombre descriptivo para la aplicación.
`Timeout` es el tiempo en segundos que tendrá como parámetro `exp` el JWT. Es el tiempo en el que el token generado expirará y será inválido para su uso.
`Permissions` son los atributos necesarios que deben ser seteados para un usuario cuando se lo vincula con esta aplicación. Es un parámetro que requiere el ingreso de un JSON válido, con una determinada estructura.

#### Permissions

En el caso de las `Apps`, el campo `permissions` es el equema de los permisos y atributos que obligatoriamente tendrán que setearse para un usuario cuando se lo vincule con ésta aplicación.

Tiene que ser un `JSON` bien formado. Cada permission tiene un nombre y un tipo.
Permite 4 tipos:

* array
* string
* integer
* boolean

Ejemplo:

```
{
  "role":     ["admin", "user"],
  "code":     "string",
  "quantity": "integer",
  "enabled":  "boolean"
}
```

En este caso, un `User` que sea vinculado con ésta aplicación, se tendrá que **obligatoriamente** asignar valor a cada uno de estos atributos.

TODO: Hacer configurable que los permissions sean opcionales.

#### app_key

Una vez creada la `App`, se genera automáticamente una `app_key`.
La `app_key` es una de las partes necesarias para que el servicio entrege JWT.
La `app_key` debe ser configurada en la aplicación que se quiere asegurar con este servicio.

Todos los pedidos que haga la aplicación al servicio, tienen que tener como parámetro obligatorio la `app_key`.
En caso de necesitar rotación, la función `Reset App Key` genera una nueva.

TODO: Armar la `app_key` como JWT y autenticar la sección de API.

#### JWT RSA Public Key

Los JWT que crea el servicio utilizan RS256 para su firma.

A cada aplicación se le crea un par de claves privada/pública.
La pribada se guarda encriptada en la base de datos y no se muestra nunca.

La pública se muestra en el show de cada `App`.

Esta es la clave pública para validar en la aplicación que se está asegurando que los JWT son auténticos.

Esta clave debe ser configurada en la aplicación que se desea asegurar.

En caso de necesitar rotación, la función `Reset JWT Secret` genera un nuevo par de claves privada/pública.

TODO: Implementar un endpoint en la API para bajar la clave pública para una app.

### Users

Aquí se crean los usuarios que después, opcionalmente, se vincularán con la/las aplicación/es creadas en la sección de `Apps`.

Requiren:

* Name
* Email

#### user_key

Una vez que está creado, nos muestra un `user_key`, una key para dar autenticación desde un cliente que utiliza el esquema de nombre de usuario y contraseña, por ejemplo una API que consume de nuestra aplicación.
El `user_key` se utiliza para una de las dos formas de autenticación que provee el servicio.
El `user_key` es todo lo que necesita el cliente final para obtener un un JWT válido para una aplicación en particular.
No debe ser expuesto públicamente ya que tiene la misma función que un nombre de usuario y contraseña.

En caso de haberse revelado, o por simple rotación, existe la función `Reset User Key`, que genera otro `user_key`.

#### Password Setted

En caso de que sea necesario usar el esquema de nombre de usuario y contraseña, se puede asignar una contraseña al usuario creado, utilizando la función `Set Password`.

A partir de ese momento, el usuario podrá solicitar un JWT tango con su `user_key`, como con [`email`, `password`]

TODO: Envío de mail automático para que el usuario reciba su `user_key`.
TODO: Envío de mail automático para que el usuario entre al sistema mediante un link y configure él mismo su contraseña.

### Allowed Apps

Una vez creados `Apps` y `Users`, hay que vincularos.

Todos los usuarios creados pueden vinculares con todas las aplicaciones creadas. Este servicio **NO** provee listados o bases de usuarios específicas por aplicación.
Por eso, este servicio sirve para dar autorización y autenticación a aplicaciones que pertenezcan a una misma organización, o que al menos tengan un base de usuarios común.

Desde un usuario se puede acceder a `Configure Apps`, y desde allí agregar `App` al usuario.

No se puede borrar una `App` que tiene `Users` vinculados.
Se puede borrar un `User` que está vinculado a `Apps`. En ese caso se borran las vinculaciones.

#### Permissions en Allowed Apps

**Siempre** se puede vincular una `App` con un `User`, sin importar que el esquema de `Permissions` no sea válido.

Una vez vinculado, se verá si es válido o no según se indique un tick verde de una cruz roja.

A partir de ese momento **solo se podrá guardar** una configuración de `Pemissions` para la vinculación de un `User` y una `App`, unicamente si los permission son válidos según estén configurados en la `App`.


Para el ejemplo que vimos más arriba:
##### App Permissions
```
{
  "role":     ["admin", "user"],
  "code":     "string",
  "quantity": "integer",
  "enabled":  "boolean"
}
```

##### Valid permissions for Allowe App
```
{
  "role":     "admin",
  "code":     "abcd",
  "quantity": 10,
  "enabled":  true
}
```
## API

Endpoints disponibles:

### /api/v1/auth

Este endpoint entrega un JWT válido para el user y la app solicitado.

#### Parámetros

Puede recibir dos formas:

##### user_key

```
{
  "user_key" : "vaid_user_key",
  "app_key" : "vaid_app_key"
}
```

##### email y password

```
{
  "email" : "vaid_email",
  "password" : "vaid_password",
  "app_key" : "vaid_app_key"
}
```


#### Respuesta
##### Ok
En ambos casos, si todo está correcto, la repuesta será:

```
{
  "jwt": "valid_jwt_for_user_app",
  "refresh_token": "token_to_get_new_valid_jwt"
}
```
##### Error
En caso de **caulquier** campo inválido, la respuesta será:

```
{}
```
con `status:400 Bad Request`

### /api/v1/refresh

Este endpoint es para obtener un nuevo JWT para cuado el anterior esté expirado.

#### Parametros

```
{
  "refresh_token": "valid_refresh_token"
}
```

#### Respuesta
##### Ok
En ambos casos, si todo está correcto, la repuesta será:

```
{
  "jwt": "NEW_valid_jwt_for_user_app",
  "refresh_token": "NEW_token_to_get_new_valid_jwt"
}
```
##### Error
En caso de **caulquier** campo inválido, la respuesta será:

```
{}
```
con `status:400 Bad Request`

### /api/v1/valid

Este endpoint sirve para validar si un JWT es válido y no está expirado.
Este endpoint se provee solo por si no se quiere incluir el control del JWT dentro de la aplicación que se está asegurando.

#### Parametros

```
{
  "jwt_token": "jwt_to_evaluate",
  "app_key": "valid_app_key"
}
```

#### Respuesta
##### Ok
```
{ message: 'Valid token' }
```
`status: 200 success`
##### Invalid Siganure
```
{ error: 'Verification Signature Fail' }
```
`status: 401 unauthorized` 
##### Expired Token
```
{ error: 'Expired token' }
```
`status: 401 unauthorized` 
##### Unknown error
```
{ error: 'Unknown error' }
```
`status: 401 unauthorized`

### /api/v1/public_key

Endpoint para bajar la clave pública de una determinada `App`.
#### Parametros

```
{
  "app_key": "valid_app_key"
}
```

#### Respuesta
##### Ok
```
{ public_key: 'RSA PUBLIC KEY' }
```
`status: 200 success`