frontend fe-apiserver
   bind 0.0.0.0:6443
   mode tcp
   option tcplog
   timeout client 30s  # Adjust as needed
   log 127.0.0.1 local0  # Adjust the IP and log facility as needed
   default_backend be-apiserver

backend be-apiserver
   mode tcp
   option tcp-check
   balance roundrobin
   timeout connect 10s  # Adjust as needed
   timeout server 30s  # Adjust as needed
   default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

   server master1 ${private_ip}:6443 check
   server master2 ${private_ip1}:6443 check
   server master3 ${private_ip2}:6443 check