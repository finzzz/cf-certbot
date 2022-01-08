# Purpose
- Generate wildcard certificates
- Concatenate certificates for haproxy
- Auto-renewable using cron

# How to
1. Get API key with `DNS:Edit` permission
2. Install certbot 
```
apt install python3-certbot
```
3. Create `creds.txt` and fill necessary data
4. Make every `.sh` files in this repo executable
```
chmod +x *.sh
```
5. Uncomment last line of `get_cert.sh` for haproxy (optional)
6. Run `get_cert.sh` or add it to crontab like so:
```
@monthly /path/to/get_cert.sh
```
