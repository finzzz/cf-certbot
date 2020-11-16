# Purpose
- Generate certificate for `example.com` and wildcard `*.example.com`
- Concatenate certificates for haproxy
- Auto-renewable using cron

# How to
1. Create `creds.txt` and fill necessary data
2. Make every `.sh` files in this repo executable
```
chmod +x *.sh
```
3. Uncomment last line of `get_cert.sh` for haproxy (optional)
4. Run `get_cert.sh` or add it to crontab like so:
```
@monthly /path/to/get_cert.sh
```
