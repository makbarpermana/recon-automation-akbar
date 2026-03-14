# Recon Automation Tool

## Deskripsi Proyek

Recon Automation Tool adalah script Bash yang digunakan untuk mengotomatisasi proses reconnaissance (pengumpulan informasi awal) dalam penetration testing atau bug bounty.

Script ini mengintegrasikan beberapa tools keamanan untuk melakukan proses berikut:

1. **Subdomain Enumeration** menggunakan `subfinder`
2. **Deduplication** menggunakan `anew`
3. **Live Host Detection** menggunakan `httpx`
4. **Logging** proses eksekusi dengan timestamp
5. **Error Handling** dengan memisahkan error log

---

# Tools yang Digunakan

Tools yang digunakan dalam project ini:

* Bash
* subfinder
* httpx
* anew
* tee
* Go (Golang)

---

# Setup Environment

## 1. Install Golang

Jika Go belum terinstall, jalankan:

sudo apt install golang -y

Cek instalasi:

go version

---

## 2. Install Recon Tools
### Install PDTools Manager (pdtm)

PDTools Manager (pdtm) adalah tool dari ProjectDiscovery yang digunakan untuk mengelola dan menginstall berbagai tools security seperti subfinder, httpx, nuclei, dan lainnya dengan lebih mudah.

Install pdtm dengan perintah berikut:

```bash
go install github.com/projectdiscovery/pdtm/cmd/pdtm@latest

### Install subfinder

go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

### Install httpx

go install github.com/projectdiscovery/httpx/cmd/httpx@latest

### Install anew

go install github.com/tomnomnom/anew@latest

---

## 3. Tambahkan Go Binary ke PATH

Tambahkan ke file `.zshrc` atau `.bashrc`:

export PATH=$PATH:$HOME/go/bin

Reload shell:

source ~/.zshrc

Cek apakah tools sudah tersedia:

which subfinder
which httpx
which anew

---

# Struktur Project

recon-automation-akbar

├── input
│   └── domains.txt

├── output
│   ├── all-subdomains.txt
│   └── live.txt

├── logs
│   ├── progress.log
│   └── errors.log

├── scripts
│   └── recon-auto.sh

└── README.md

Penjelasan:

* **input/** → berisi daftar domain target
* **output/** → menyimpan hasil recon
* **logs/** → menyimpan log proses dan error
* **scripts/** → berisi script automation

---

# Cara Menjalankan Script

Masuk ke folder project:

cd recon-automation-akbar

Jalankan script:

bash scripts/recon-auto.sh

Script akan otomatis:

1. Membaca domain dari file `input/domains.txt`
2. Melakukan subdomain enumeration
3. Menghapus duplikasi subdomain
4. Mengecek host yang aktif
5. Menyimpan hasil ke file output

---

# Contoh Input

File: `input/domains.txt`

hackerone.com
dibimbing.id
kodenstore.com
tesla.com
uber.com

---

# Contoh Output

File: `output/all-subdomains.txt`

a.ns.hackerone.com
b.ns.hackerone.com
go.hackerone.com
design.hackerone.com
api.hackerone.com
docs.hackerone.com
mta-sts.forwarding.hackerone.com
mta-sts.hackerone.com

File: `output/live.txt`

[https://www.iana.org [200] [Internet Assigned Numbers Authority]](https://15205598.uber.com [404] [404 Not Found]
https://4460893.sodigital.uber.com [404] [404 Not Found]
https://a.uber.com [301] [301 Moved Permanently]
http://a.ns.hackerone.com [301] [301 Moved Permanently]
https://account.uber.com [302] [302 Found]
)

---

# Logging

Script mencatat proses eksekusi dalam dua file log:

## progress.log

Berisi aktivitas script selama berjalan.

Contoh:

Recon started at Sat Mar 14 03:21:36 AM WITA 2026
[+] Starting enumeration for hackerone.com
[+] Starting enumeration for dibimbing.id
[+] Starting enumeration for kodenstore.com
[+] Starting enumeration for tesla.com
[+] Starting enumeration for uber.com
[+] Checking which hosts are alive...
[+] Total unique subdomains found : 11043
[+] Total live hosts detected     : 101
Recon finished at Sat Mar 14 04:05:48 AM WITA 2026

---

## errors.log

Berisi error yang terjadi selama proses recon.

---

# Penjelasan Script recon-auto.sh

Script `recon-auto.sh` mengotomatisasi proses reconnaissance menggunakan pipeline berikut:

domains.txt
↓
subfinder
↓
anew (deduplikasi)
↓
all-subdomains.txt
↓
httpx
↓
live.txt

---

## 1. Membaca Daftar Domain

Script membaca target domain dari file:

input/domains.txt

Loop digunakan untuk memproses setiap domain secara otomatis.

---

## 2. Subdomain Enumeration

Menggunakan tool **subfinder** untuk menemukan subdomain dari target domain.

Contoh command:

subfinder -d domain.com

---

## 3. Deduplication

Tool **anew** digunakan untuk memastikan tidak ada subdomain yang tersimpan dua kali.

---

## 4. Live Host Detection

Tool **httpx** digunakan untuk mengecek apakah subdomain aktif.

Command yang digunakan:

httpx -status-code -title

Output akan menampilkan:

URL
Status Code
Judul halaman web

---

## 5. Logging dan Error Handling

Script menggunakan `tee` untuk menampilkan output di terminal sekaligus menyimpan log.

Error diarahkan ke file:

logs/errors.log

---

# Contoh Eksekusi Script

Recon started at Thu Mar 12 22:51:34

[+] Starting enumeration for hackerone.com
[+] Starting enumeration for kodenstore.com
[+] Starting enumeration for iana.org

[+] Checking which hosts are alive...

https://www.iana.org [200] [Internet Assigned Numbers Authority]

Total unique subdomains found : 21
Total live hosts detected : 1

Recon finished at Thu Mar 12 22:55:35

---
