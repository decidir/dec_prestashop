# Prisma Decidir - Gateway de Pago
Este módulo conecta su tienda PrestaShop con Prisma Decidir, permitiéndole procesar los pagos realizados en su tienda mediante esta plataforma.

### Compatible con
- PrestaShop 1.6
- PrestaShop 1.7

### Instalación
1. Tenga a mano el archivo decidir.zip
2. En su BackOffice de PrestaShop, diríjase al menú Módulos > Gestor de módulo
3. Haga click en el botón "Subir módulo" y seleccione el archivo "decidir.zip"
4. Se abrirá un popup, con el botón "Configurar". Clickéelo.

### Configuración
La configuración del módulo Prisma Decidir es sencilla, y se divide en tres paneles:
- Credenciales
- Cybersource
- Pedido

#### Credenciales
- Puede elegir probar el módulo sin realizar pagos reales, usando el modo Sandbox.
- Deberá ingresar su "Public key" y su "Private key".
- Necesita pedir a su agente de cuentas tanto llaves de prueba, como las del entorno de producción.
- Deshabilitando el modo de pruebas desde el switch "Sandbox", se mostrarán los campos para ingresar también sus llaves de producción.
- Puede ingresar todas, el módulo sólo utilizará las que correspondan.
- También deberá ingresar el Site ID que su agente de cuentas le provea.

#### Cybersource
El módulo cuenta con la protección anti-fraude Cybersource.
- Puede habilitar o deshabilitar esta opción si así lo desea.
- Deberá ingresar su Merchant ID
- Podrá seleccionar el tipo de Vertical que utilizará para sus pagos.

#### Pedido
En este apartado podrá configurar datos referidos a sus pedidos.
- El campo título define el texto que verá el comprador en la selección de pagos, dentro del proceso de Checkout.
- Desde el selector "Tarjetas de crédito", puede seleccionar aquellas que quiera habilitar.
- Desde el selector "Cuotas", puede definir la cantidad de cuotas que desee proveerle al comprador.

#### Guardar
Presionando sobre cualquiera de los botones "Guardar", salvará sus cambios, y el módulo quedará configurado.

En cualquier momento que lo necesite, puede modificar sus datos ingresando al menú Módulos > Gestor de módulo y buscando el módulo con el nombre "Decidir".

### Desactivación
Si necesita desactivar el módulo, sin perder ninguno de sus datos, diríjase al menú Módulos > Gestor de módulo y busque "Decidir".
- Verá que a la derecha del botón "Configurar", hay una flecha para desplegar más opciones.
- Puede clickear la opción "Desactivar", para ocultar el módulo sin perder ningún dato. Los compradores no tendrán la opción de pagos de Prisma Decidir, hasta que vuelva a activarlo desde el mismo menú. 
