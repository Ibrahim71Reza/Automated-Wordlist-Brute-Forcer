# 🔐 Automated Wordlist Brute Forcer

A powerful and customizable Bash script to automate brute force attempts using any command-line cracking tool of your choice. Perfect for ethical hacking, CTFs, and penetration testing with permission.

---

## Legal Wordlists (Recommended)

We **strongly discourage** using illegal or unauthorized password dumps. For ethical testing or CTF practice, use wordlists from the excellent **SecLists Project**:

📦 **SecLists GitHub**  
👉 https://github.com/danielmiessler/SecLists

Clone it to your system:
```bash
git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists
````

---

## How to Use

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Ibrahim71Reza/Automated-Wordlist-Brute-Forcer.git
cd wordlist-cracker-automator
chmod +x script.sh
```

### 2️⃣ Configure Your Cracking Command

Edit the `CRACK_COMMAND` variable at the top of the script:

```bash
CRACK_COMMAND="flask-unsign --unsign --cookie '<YOUR_COOKIE>' --wordlist {WORDLIST} --no-literal-eval"
```

Replace:

* `<YOUR_COOKIE>` with your actual Flask cookie.
* `{WORDLIST}` **must stay unchanged** — the script will substitute each wordlist file automatically.

### 3️⃣ Set Your Wordlist Directory

Modify the path in the script:

```bash
WORDLIST_DIR="/opt/SecLists/Passwords/"
```

This should point to your wordlist folder.

### 4️⃣ Run the Script

```bash
./script.sh
```

---

## 🔁 Sample Use Cases

The script is **tool-agnostic** — just plug in your cracking command!

### Flask Cookie Cracking (flask-unsign)

```bash
CRACK_COMMAND="flask-unsign --unsign --cookie '<cookie>' --wordlist {WORDLIST} --no-literal-eval"
```

### JWT Secret Brute Force (jwt\_tool)

```bash
CRACK_COMMAND="python3 jwt_tool.py -t '<jwt_token>' -C {WORDLIST}"
```

### Zip File Password Crack (fcrackzip)

```bash
CRACK_COMMAND="fcrackzip -v -u -D -p {WORDLIST} ./secret.zip"
```

### SSH Key Brute Force (hydra)

```bash
CRACK_COMMAND="hydra -L usernames.txt -P {WORDLIST} ssh://192.168.0.1"
```

### PDF Password Crack (pdfcrack)

```bash
CRACK_COMMAND="pdfcrack -f secret.pdf -w {WORDLIST}"
```

> 💡 You can integrate any tool that accepts a wordlist as an argument.

---

## 📝 Output Log

The script logs every result in `crack_log.txt`, including:

* `[CRACKED]` — Successes
* ❌ `[FAILED]` — Tried but didn’t work
* ⚠️ `[ERROR]` — Tool or input-related errors

---

## ⚠️ Legal Notice

> This script is provided for **legal, educational, and ethical use only** (e.g., Capture The Flag competitions, research, or penetration testing with proper authorization).
>
> ❗ Misuse is strictly discouraged. The author is not responsible for any illegal activities.

---

## 🙋 Contributions

Feel free to submit pull requests or open issues if you'd like to contribute or suggest improvements!

---