# ShiftCare CLI Assessment

A minimalist Ruby command-line application to:

-  Search for clients with names that partially match a given query.
-  Detect duplicate client emails.

---

##  Requirements

- **Operating System**: Ubuntu 20.04+ or any Debian-based distro
- **Ruby**: v2.7 or later (I used 3.0.2)

---

##  Installation

### 1. Install Ruby

If you already have Ruby installed, you can skip this step.

```bash
sudo apt update
sudo apt install ruby-full -y
```

Verify Ruby is installed:

```bash
ruby -v
```

---

### 2. Clone the repository and test the result

```bash
git clone git@github.com:cool-guru/shiftcare-asessment.git
cd shiftcare-asessment
```

Make sure `clients.json` and `main.rb` are in the project folder.

---

##  How to Run

From the root directory of the project:

###  Search by Name

```bash
ruby main.rb search <name_query>
```

Example:

```bash
ruby main.rb search Jane
```

Expected output:

```
Clients matching 'Jane':
2: Jane Smith - jane.smith@yahoo.com
15: Another Jane Smith - jane.smith@yahoo.com
```

---

###  Find Duplicate Emails

```bash
ruby main.rb duplicates
```

Expected output:

```
Duplicate emails found:
Email: jane.smith@yahoo.com
  2: Jane Smith
  15: Another Jane Smith
```

---

###  Unit Testing Script"
```bash
ruby -I. test_client_searcher.rb
```

Thanks,
Carlo