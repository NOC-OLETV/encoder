#!/bin/bash
#CRIANDO ROTA MULTICAST
echo "INSTALANDO ROTA MULTICAST"
cat <<EOF > /usr/local/src/route_multicast.sh
#!/bin/bash
ip route add 224.0.0.0/4 dev NOME_INTERFACE_AQUI
EOF
chmod +x /usr/local/src/rota_multicast.sh

#FLUSSONIC
echo "INSTALANDO FLUSSONIC"
cd /usr/local/src/
wget http://200.194.238.229:5000/2402.tgz
tar -xvzf 2402.tgz
cd flu2402/
dpkg -i *.deb
systemctl restart  flussonic.service

#ASTRA PARA ANALYZE
echo "INSTALANDO ASTRA"
cd /usr/local/src/
git clone https://github.com/cesbo/astra-4
cd astra-4
./configure.sh
make & make install

#SYSCTL PARA MULTICAST
echo "INSTALANDO SYSCTL"
cat <<EOF > /etc/sysctl.conf 
net.ipv4.conf.all.log_martians = 0
net.ipv4.icmp_ignore_bogus_error_responses = 0
net.ipv4.conf.default.log_martians = 0

net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

net.ipv4.icmp_echo_ignore_broadcasts = 0

net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 20000
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_rfc1337 = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_dsack = 1

net.ipv4.ip_forward = 1

net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 19247
net.ipv4.tcp_orphan_retries = 1
net.ipv4.tcp_fin_timeout = 20
net.ipv4.tcp_max_tw_buckets = 1539584
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1

net.core.rmem_max = 16777216
net.core.rmem_default = 16777216
net.ipv4.udp_mem = 8388608 12582912 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_wmem = 4096 4194394 16777216

vm.min_free_kbytes = 123186
vm.swappiness = 0
vm.dirty_background_ratio = 5
vm.dirty_ratio = 15

net.ipv4.tcp_congestion_control = htcp
net.ipv4.tcp_slow_start_after_idle = 0

net.core.netdev_max_backlog = 2500
net.core.somaxconn = 65000

fs.file-max = 769792
fs.suid_dumpable = 2

kernel.printk = 4 4 1 7
kernel.core_uses_pid = 1
kernel.sysrq = 0
kernel.msgmax = 65536
kernel.perf_cpu_time_max_percent = 0

net.netfilter.nf_conntrack_tcp_timeout_established = 300
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
EOF
sysctl -p
