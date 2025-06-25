# 🔐 SecureCrypt

A robust, command-line file encryption and decryption utility built with industry-standard security practices. SecureCrypt provides **military-grade AES-256 encryption** with advanced key derivation and integrity verification.

---

## 🔒 Security Features

- **AES-256-CBC Encryption** – Advanced Encryption Standard with 256-bit keys  
- **PBKDF2 Key Derivation** – 100,000 iterations for password strengthening  
- **HMAC-SHA256 Integrity Verification** – Tamper detection and authenticity validation  
- **Secure Password Input** – Hidden input with real-time masking  
- **Strong Password Requirements** – Enforced complexity standards  
- **Memory-Safe Operations** – Automatic cleanup of temporary files  

---

## User Guide

### Prerequisites
- Bash shell (Linux/macOS/WSL)
- OpenSSL

### Installation

Follow these steps to set up and run SecureCrypt on your computer:

1. **Download the project**
   - Open your terminal.
   - Run the following command to download the SecureCrypt project to your computer:
     ```bash
     git clone https://github.com/Brandon-Kee/SecureCrypt.git
     ```
   - This creates a new folder called `SecureCrypt` with all the files.

2. **Go into the project folder**
   - Change your current directory to the SecureCrypt folder:
     ```bash
     cd SecureCrypt
     ```

3. **Make the script executable**
   - This step gives permission for the script to run like a program:
     ```bash
     chmod +x SecureCrypt.sh
     ```

4. **Run SecureCrypt**
   - Start the program with:
     ```bash
     ./SecureCrypt.sh
     ```
   - You'll see an interactive menu with options to encrypt or decrypt files.

### Encrypting a File

### Decrypting a File
---
## 🛡️ Security Architecture

### Why These Security Measures Matter
In today's digital landscape, data breaches and unauthorized access are constant threats. Whether you're protecting personal documents, business secrets, or sensitive communications, proper encryption is your first line of defense against:

- **Data Theft** - Hackers accessing your personal or business files

- **Corporate Espionage** - Competitors stealing trade secrets

- **Identity Theft** - Personal information falling into wrong hands

- **Compliance Violations** - Legal requirements for data protection

- **Ransomware Attacks** - Malicious encryption of your files by attackers
---
### Encryption Implementation Details

#### 🔸 AES-256-CBC Encryption

**What it is**  
Advanced Encryption Standard with 256-bit keys in Cipher Block Chaining (CBC) mode.

**How it works**
- Divides your data into 128-bit blocks
- Each block is encrypted using the previous block’s ciphertext (CBC mode)
- A 256-bit key results in **2²⁵⁶ possible combinations** (virtually unbreakable)

---

#### 🔸 PBKDF2 Key Derivation (100,000 iterations)

**What it is**  
A cryptographic algorithm that transforms a password into a secure encryption key using SHA-256 hashing and repeats the process 100,000 times.

**How it works**
- Your password is hashed **100,000 times** using SHA-256
- Each round makes brute force attacks significantly harder
- Even with the encrypted file, cracking the password can take years

---

#### 🔸 HMAC-SHA256 Integrity Verification

**What it is**  
A cryptographic technique that generates a secure fingerprint of a file using your passkey and SHA-256 to ensure that a file hasn't been tampered with.

**How it works**
- Creates a unique **HMAC** fingerprint of the encrypted file
- Any change in the file alters the HMAC completely
- If the fingerprint doesn’t match, decryption fails — protecting against tampering

---

#### 🔸 Password Security Requirements

To ensure robust protection, SecureCrypt enforces strict password standards:

- **Minimum 12 Characters** – Enhances entropy and security
- **Mixed Case Letters** – Makes brute-force attacks more difficult
- **Numbers & Special Characters** – Increases complexity
- **Confirmation Required** – Prevents lockouts from typos



## Interface

<img width="450" alt="Screenshot 2025-06-15 at 9 22 12 PM" src="https://github.com/user-attachments/assets/3e55b8c0-3e15-434f-9510-5cf82f47b5a6" />

<img width="436" alt="Screenshot 2025-06-15 at 9 22 26 PM" src="https://github.com/user-attachments/assets/4bdabb27-5037-4957-88bd-5a96ff0c3171" />
<img width="362" alt="Screenshot 2025-06-15 at 9 22 50 PM" src="https://github.com/user-attachments/assets/229ae6c2-6be9-4908-9055-6bd6f00cc587" />
<img width="163" alt="Screenshot 2025-06-15 at 9 23 37 PM" src="https://github.com/user-attachments/assets/94f0c503-f77f-4794-8461-25107658e179" />

## 📚 References
- [AES Specification (NIST)](https://csrc.nist.gov/publications/detail/fips/197/final)
- [PBKDF2 Specification (RFC 2898)](https://tools.ietf.org/html/rfc2898)
- [HMAC Specification (RFC 2104)](https://tools.ietf.org/html/rfc2104)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
