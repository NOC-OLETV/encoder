#INSTALANDO PACOTES
apt install -y postfix mailutils mutt

#ALTERANDO SERVIDOR DE E-MAIL
sed -i 's/relayhost = /relayhost = [corpmail.ole.net.br]:25/' /etc/postfix/main.cf
echo smtp_sasl_auth_enable = yes >> /etc/postfix/main.cf
echo smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd >> /etc/postfix/main.cf
echo smtp_sasl_security_options = noanonymous >> /etc/postfix/main.cf

#CONFIGURANDO CREDENCIAS
echo [corpmail.ole.net.br]:25 monitoramento@oletv.net.br:MOnitor@@2026 > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
systemctl restart postfix.service

#PERMISSAO FLUSSONIC
chmod 644 /etc/flussonic/flussonic.conf
