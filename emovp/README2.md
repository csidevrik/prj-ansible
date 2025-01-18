# * Resetear o recordar el pasword del admin del zimbra

- [ ] revisar la clave del admin del webmail

  ![1737173321219](image/README2/1737173321219.png)

  En caso de no recordar hay que cambiar el password del admin de los certificados en el active directory y luego conectarse al https://172.20.1.99 una vez cambiado el password.

Prueba con ansible


openssl req -new -newkey rsa:2048 -nodes -keyout wildcard_emov_gob_ec.key -out wildcard_emov_gob_ec.csr

Primero creamos un inventario que haga uso de credenciales en los servidores


<script type="text/javascript"> //<![CDATA[
  var tlJsHost = ((window.location.protocol == "https:") ? "https://secure.trust-provider.com/" : "http://www.trustlogo.com/");
  document.write(unescape("%3Cscript src='" + tlJsHost + "trustlogo/javascript/trustlogo.js' type='text/javascript'%3E%3C/script%3E"));
//]]></script>

<script language="JavaScript" type="text/javascript">
  TrustLogo("https://www.positivessl.com/images/seals/positivessl_trust_seal_lg_222x54.png", "POSDV", "none");
</script>


-----BEGIN CERTIFICATE-----

MIIGMjCCBRqgAwIBAgIRAK3fgIz8ILAnBxe+TZgSFt4wDQYJKoZIhvcNAQELBQAw

gY8xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO

BgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE3MDUGA1UE

AxMuU2VjdGlnbyBSU0EgRG9tYWluIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBD

QTAeFw0yNTAxMTgwMDAwMDBaFw0yNjAxMTgyMzU5NTlaMBgxFjAUBgNVBAMMDSou

ZW1vdi5nb2IuZWMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDaOvOF

CpWZWNv/w0A+zsQiVLhZwFKOy6BMS2uoyYvGX0xuIKaqUhD0Ln3eFFPKC+kM2iiZ

0rn1uEUkY8VDRuBmDdFjVj6jDxU2zUZEDRK+jc3AzjnUYEqsZLrAw23WJmupON8u

eb9SA8yQt7apGBBUV8LPzEnEa3eYAG+Vp9gyxTRVdocSnsgSz2+HWUrYwBON0Kd6

oZaa+YyZqQJZm49VKAY4F8HcyAiq65W+b/NhfvEHV6d+IcNRdD3jRrrQIvfMflSz

5cP2X2+Hn5oMSAmw7vgYdsH5hh6BspiLyi0CvAehyPTsmnkcEXb1mWXb5pFIqoCp

rRRdqGt1tL9L9pT5AgMBAAGjggL9MIIC+TAfBgNVHSMEGDAWgBSNjF7EVK2K4Xfp

m/mbBeG4AY1h4TAdBgNVHQ4EFgQUA11sahtD62UNbCpazYCVAvOEDskwDgYDVR0P

AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsG

AQUFBwMCMEkGA1UdIARCMEAwNAYLKwYBBAGyMQECAgcwJTAjBggrBgEFBQcCARYX

aHR0cHM6Ly9zZWN0aWdvLmNvbS9DUFMwCAYGZ4EMAQIBMIGEBggrBgEFBQcBAQR4

MHYwTwYIKwYBBQUHMAKGQ2h0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JT

QURvbWFpblZhbGlkYXRpb25TZWN1cmVTZXJ2ZXJDQS5jcnQwIwYIKwYBBQUHMAGG

F2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMCUGA1UdEQQeMByCDSouZW1vdi5nb2Iu

ZWOCC2Vtb3YuZ29iLmVjMIIBfwYKKwYBBAHWeQIEAgSCAW8EggFrAWkAdwCWl2S/

VViXrfdDh2g3CEJ36fA61fak8zZuRqQ/D8qpxgAAAZR5w/JNAAAEAwBIMEYCIQDR

M7ZmmQHJ+/aP4o8NMBiHL/2c4M6EDLJL+g3oiPKvQQIhAMEAKEkjEk3qsQdgpDij

2+8DkTaw2VVnIVnAAWLZcsitAHcAGYbUxyiqb/66A294Kk0BkarOLXIxD67OXXBB

LSVMx9QAAAGUecPyKgAABAMASDBGAiEA4iSakBymql7Ug/tY1KiyP66AzQ9WNDgW

AcdHOEbyA6MCIQCS00P4XPTtMYuJC9nbxOS5nJmg/y383WU54ujxHEI63QB1AMs4

9xWJfIShRF9bwd37yW7ymlnNRwppBYWwyxTDFFjnAAABlHnD8lsAAAQDAEYwRAIh

AMpL9zaJJIHCOw5i7oyHb0I1MxmCVq7X5fnF9hwtmIymAh9UdG42CRPaBjEMOmWe

vIK9YbctZpCm2NYDXAN55cCTMA0GCSqGSIb3DQEBCwUAA4IBAQCYLySF9L1Hly2+

ay+nGBz2LeyW5138Q8+5pBotxmbT4bEH5mR6Knh7FhtFeozz0oj6sLbXyC6F7Opc

uS4tv6RaRK3VbGd6DtsL0eRU6eMjEh1X/kk6Fp7AuL4MPkmbVRg57/1/K3syRVJD

AvoNsKOYnw41isOE42uTnvXK4G1PaY5FGRI2iB00XPOFvWpwL0j4uBxnr2rQOZpl

9UGQEO9Kv5II/LfEv00x8RaWoDbPPON4sE7Pa7GU9AaZEcJJbhfxQR4J6qSO8x7f

z5HZxI3ukQ+E+B3GECRZqXOCqB+wQWpTXdCU1a0WioD6H7crAp39mvpxfviNj7q9

4xh8BgRd

-----END CERTIFICATE-----


3. revisar en el caso del mail el snapshot
4. 88.10   serviciosssl    		ubuntu 20.04
   88.6    pagina web  			ubuntu 20.04
   1.34   dinardap			ubuntu 20.04
   1.30   erp					fedora 35
   1.57
   1.32   via web este es el waf  ------
   1.249  calidad del aire		fedora 34
   1.99   hay que revisarle especial Zimbra
5. 1.100  ANT				ubuntu 20.04
   secundarios
   glpi   1.88				Debian 10
   nextcloude  1.28			fedora 37
   alfresco 1.51
