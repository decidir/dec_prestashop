# payway - Gateway de Pago
Este módulo conecta su tienda PrestaShop con payway, permitiéndole procesar los pagos realizados en su tienda mediante esta plataforma.

### Compatible con
- PrestaShop 1.6 - 1.7 - 1.7.8.2 - 1.7.8.5 - 1.7.8.8

### Instalación
1. Tenga a mano el archivo payway.zip
2. En su BackOffice de PrestaShop, diríjase al menú Módulos > Gestor de módulo
3. Haga click en el botón "Subir módulo" y seleccione el archivo "payway.zip"
4. Se abrirá un popup, con el botón "Configurar". Clickéelo.

### Configuración
La configuración del módulo payway es sencilla, y se divide en tres paneles:
- Credenciales
- Opciones

#### Credenciales
- Puede elegir probar el módulo sin realizar pagos reales, usando el modo Sandbox.
- Deberá ingresar su "Public key" y su "Private key".
- Necesita pedir a su agente de cuentas tanto llaves de prueba, como las del entorno de producción.
- Deshabilitando el modo de pruebas desde el switch "Sandbox", se mostrarán los campos para ingresar también sus llaves de producción.
- Puede ingresar todas, el módulo sólo utilizará las que correspondan.
- También deberá ingresar el Site ID que su agente de cuentas le provea.

#### Opciones
En este apartado podrá configurar las opciones generales.
- El campo título define el texto que verá el comprador en la selección de pagos, dentro del proceso de Checkout.

El módulo cuenta con la protección anti-fraude Cybersource.
- Puede habilitar o deshabilitar esta opción si así lo desea.
- Deberá ingresar su Merchant ID
- Podrá seleccionar el tipo de Vertical que utilizará para sus pagos.

#### Guardar
Presionando sobre cualquiera de los botones "Guardar", salvará sus cambios, y el módulo quedará configurado.

En cualquier momento que lo necesite, puede modificar sus datos ingresando al menú Módulos > Gestor de módulo y buscando el módulo con el nombre "payway".

### Desactivación
Si necesita desactivar el módulo, sin perder ninguno de sus datos, diríjase al menú Módulos > Gestor de módulo y busque "payway".
- Verá que a la derecha del botón "Configurar", hay una flecha para desplegar más opciones.
- Puede clickear la opción "Desactivar", para ocultar el módulo sin perder ningún dato. Los compradores no tendrán la opción de pagos de payway, hasta que vuelva a activarlo desde el mismo menú.

## Menú lateral
En el menú lateral de su Backoffice, se habilitará el grupo "PAYWAY", donde podrá configurar tarjetas de crédito/débito, bancos y promociones/cuotas.

### Tarjetas
- En el menú payway > Tarjetas, podrá administrar los tipos de tarjetas con las que necesite operar.
- Inicialmente, verá una lista con las tarjetas más utilizadas, puede añadir nuevas o eliminar las que desee.

**Añadir tarjeta:**
- En la esquina superior derecha de la tabla de tarjetas presione en el botón con el ícono "+".
- Ingrese los datos requeridos en el formulario que se desplegará.
- Puede cargar una imagen desde su computadora, y activar o desactivar la tarjeta.
- Presione guardar para aplicar los cambios.

**Editar tarjeta:**
- En la tabla de tarjetas, sobre la fila correspondiente, presione el botón "Editar".
- Se desplegará el mismo formulario del ítem anterior. Aquí puede modificar los datos a su gusto.

**Eliminar tarjeta:**
- En la tabla de tarjetas, sobre la fila correspondiente, presione el botón "Eliminar".
- Se le pedirá confirmar la eliminación de la tarjeta.

### Bancos
- En el menú payway > Bancos, podrá administrar los bancos o emisores de tarjetas con los que necesite operar.
- Inicialmente, verá una lista con los bancos más utilizados, puede añadir nuevos o eliminar los que desee.

**Añadir banco:**
- En la esquina superior derecha de la tabla de bancos presione en el botón con el ícono "+".
- Ingrese los datos requeridos en el formulario que se desplegará.
- Puede cargar una imagen desde su computadora, y activar o desactivar el banco.
- Presione guardar para aplicar los cambios.

**Editar banco:**
- En la tabla de bancos, sobre la fila correspondiente, presione el botón "Editar".
- Se desplegará el mismo formulario del ítem anterior. Aquí puede modificar los datos a su gusto.

**Eliminar banco:**
- En la tabla de bancos, sobre la fila correspondiente, presione el botón "Eliminar".
- Se le pedirá confirmar la eliminación del banco.

### Promociones
- En el menú payway > Promociones, podrá administrar las promociones y condiciones de cuotas sobre los pedidos realizados.
- Por defecto a todo pedido como mínimo se le asigna 1 cuota. Defina sus cuotas en esta sección según sea necesario.
- Si se crea una promoción y posteriormente se elimina la tarjeta o banco que la conforman, la promoción no se visualizará.
- Si no hay promociones configuradas, se muestran todos los bancos y tarjetas
**Añadir promoción:**
- En la esquina superior derecha de la tabla de promociones presione en el botón con el ícono "+".
- Ingrese los datos requeridos en el formulario que se desplegará.
- Deberá seleccionar las tarjetas y bancos a los que alcanzará la promoción.
- Deberá seleccionar en qué días de la semana esta promoción estará disponible y desde y hasta qué fechas.
- Si su PrestaShop maneja multitienda, deberá seleccionar sobre cuál de ellas ésta promoción será aplicada.
- Elija una posición para darle mayor prioridad a esta promoción.
- Puede activar o desactivar la promoción.

**Editar promoción:**
- En la tabla de promociones, sobre la fila correspondiente, presione el botón "Editar".
- Se desplegará el mismo formulario del ítem anterior. Aquí puede modificar los datos a su gusto.

**Eliminar promoción:**
- En la tabla de promociones, sobre la fila correspondiente, presione el botón "Eliminar".
- Se le pedirá confirmar la eliminación de la promoción.

### Cuotas
- En el mismo formulario de promociones, tendrá disponible una tabla de cuotas.
- Estas cuotas se mostrarán al comprador en caso de que se cumplan las condiciones que hayamos configurado en el ítem anterior.

**Añadir cuota:**
- En la esquina superior derecha de la tabla de cuotas presione en el botón con el ícono "+".
- Se añadirá una nueva fila a la tabla con los campos que deberá completar según lo necesite.
- El campo "cuota" indica el número de cuotas que se asignarán al pago.
- El campo "coeficiente" indica el interés correspondiente al número de cuota.
- Los campos "%TEA" y "%CFT" son indicativos, y no son requeridos.
- El campo "Reintegro Bancario" es indicativo de la operatoria del banco una vez realizado el pago.
- En el campo "Descuento", puede asignar una reducción del valor total de la compra.
- El campo "Cuota a enviar" se utiliza para indicar el número de cuotas que se enviarán al gateway de pago. Este campo debe tener el mismo valor que el campo "Cuota", a excepción de casos especiales, como al utilizar el emisor de tarjeta "Ahora 12".

**Editar cuota:**
- En la tabla de promociones, sobre la fila correspondiente, modifique los campos que necesite y presione el botón guardar en la parte inferior del formulario.

**Eliminar cuota:**
- En la tabla de cuotas, sobre la fila correspondiente, presione el botón con el ícono del cesto de residuos.
- Se le pedirá confirmar la eliminación de la cuota.
