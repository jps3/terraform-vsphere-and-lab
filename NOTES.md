# Scratch/Random

Decrypt saved pfSense (2.5.x) backup file:
```bash
grep -v 'config.xml' config-gateway.lab.home-20210725191916.xml| base64 -d | /usr/local/Cellar/openssl@1.1/1.1.1l_1/bin/openssl enc -d -aes-256-cbc -out out.xml  -salt -md sha256 -pbkdf2
```

