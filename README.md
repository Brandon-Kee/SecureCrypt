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

SecureCrypt provides an interactive menu system:

1. **Encrypt File** - Secure your sensitive data
2. **Decrypt File** - Restore encrypted files
3. **Exit** - Clean termination

### 🔐 Encrypting a File

Example workflow using the provided `input.txt` file:

**Step 1: Select Encryption Option**

<img width="405" alt="SecureCrypt Main Menu - Select Encryption" src="https://github.com/user-attachments/assets/b01bfcd9-e88f-4b7f-bd48-9191b17a7c91" />

**Step 2: Generate Your Secret Passkey**

Create a strong passkey following the security requirements:

<img width="436" alt="Passkey Creation with Security Requirements" src="https://github.com/user-attachments/assets/cea0b5f6-d684-461e-a9a4-357a82b78631" />

**Step 3: Encryption Complete**

Your file will now be encrypted and an HMAC generated for integrity verification:

<img width="362" alt="Successful Encryption with HMAC Generation" src="https://github.com/user-attachments/assets/757365a1-7b74-4092-a0b7-156eadff8a3a" />

✅ **Result:** You should now see `encrypt.txt` and `encrypt.txt.hmac` in your working directory.

---

### 🔓 Decrypting a File

**Step 1: Select Decryption Option**

<img width="409" alt="SecureCrypt Decryption Menu Selection" src="https://github.com/user-attachments/assets/3404c893-2f48-48eb-be72-78a013700656" />

**Step 2: Enter Passkey and Complete Decryption**

The system will verify the HMAC before decrypting to ensure file integrity:

<img width="440" alt="HMAC Verification and Successful Decryption" src="https://github.com/user-attachments/assets/cc45e020-15b5-42b1-bec7-34efebdca2f7" />

✅ **Result:** Your original file has been successfully restored and verified for integrity.

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


## 📚 References
- [AES Specification (NIST)](https://csrc.nist.gov/publications/detail/fips/197/final)
- [PBKDF2 Specification (RFC 2898)](https://tools.ietf.org/html/rfc2898)
- [HMAC Specification (RFC 2104)](https://tools.ietf.org/html/rfc2104)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
