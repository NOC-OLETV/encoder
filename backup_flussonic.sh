#!/bin/bash
#Instalando pacotes
apt install -y postfix mailutils mutt 

#Criando arquivo para o scrip
cat <<EOF > /usr/local/src/encoder/backup_flussonic.sh
#!/bin/bash

ORIGEM="/etc/flussonic/flussonic.conf"
DESTINO="/etc/flussonic/backup"

DATA=$(date +%d%m%Y)

ARQUIVO_BACKUP="$DESTINO/backup_flussonic_IP-ENC-AQUI_$DATA.conf"

#COPIANDO LOCALMENTE
cp "$ORIGEM" "$ARQUIVO_BACKUP" 2>>/etc/flussonic/logs_backup

#ENVIADO E-MAIL
mutt -s "[Flussonic Backup] SRV-ENCODER-(NOME-ENC-AQUI) $DATA" -a "$ARQUIVO_BACKUP" -- noc@oletv.net.br < /dev/null 2>>/etc/flussonic/logs_backup
EOF
chmod +x /usr/local/src/encoder/backup_flussonic.sh 

#Criando diretorio para backup
mkdir /etc/flussonic/backup

#Criando arquivo para salvar os logs do backup
cd /etc/flussonic/
touch logs_backup

#Criando sasl_passwd
touch /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd*
systemctl restart postfix
