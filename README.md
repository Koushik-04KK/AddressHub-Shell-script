# Address Database Management System (BASH Shell Scripting Project) 📚💻

This project implements an **Address Book Database Management System** using BASH shell scripting and a local text-based database (CSV file). It provides various operations to handle and manage a particular database through command-line user interaction. The main goal is to help users understand CRUD (Create, Read, Update, Delete) operations in a practical, shell-script-based environment. This project also features activity logging, user input validation, and more. 📝

The tool performs CRUD operations, allowing users to manage address book entries. Additionally, it logs every action with timestamps for future reference. The database is stored in a CSV format, and all actions are logged to a `.log` file. 🗂️

## Table of Contents 📑

- [Project Overview](#project-overview)
- [Requirements](#requirements)
- [Features](#features)
- [Installation](#installation)


## Project Overview 📂

The **Address Database** project allows users to manage contact entries with CRUD operations. It provides functionalities to add, search, edit, and delete contact entries. The tool records all actions with timestamps, allowing users to track their interactions with the system. The database is stored in a CSV file, and each change is logged to a `.log` file for future reference. 🗂️

The tool manages the following operations:
1. **Add Entry** ➕: Allows users to add new entries to the address book.
2. **Search/Edit Entry** 🔍✏️: Enables searching for existing entries and modifying them.
3. **Activity Logging** 📝: Logs every operation performed, including time-stamped actions.

## Requirements 📋

### Activity Log File 📝

- Every activity performed within the script should be logged in a file named `database.log`.
- Each log entry should include a timestamp to track when the action was performed.

### Working Environment Settings ⚙️

- The script should create a directory named `Database` in the user's home directory (i.e., `~/ECEP/LinuxSystems/Projects/`) if it doesn't already exist.
- A file named `database.csv` should be created in the `Database` directory if it doesn't exist.
- The script will check if `database.csv` contains at least one valid entry. If the file is empty, the script will prompt the user to add an entry until it has at least one valid record.

### User Interface 👤

The script provides the following functionalities:

#### Add Entry ➕
When the user selects the "Add Entry" option, the following fields are requested, and each is validated as per the specifications:

1. **Name** ✨
   - Accepts alphabets and spaces only.
   - The input is converted to sentence case for storage (e.g., "john doe" becomes "John Doe").

2. **E-mail** 📧
   - Accepts symbols like `.`, `_`, alphabets, and numbers.
   - The email is validated to ensure it contains the `@` symbol and a `.` after it.

3. **Telephone Number** 📞
   - Accepts only numeric input.
   - The input is validated to ensure it contains only digits.

4. **Mobile Number** 📱
   - Assumes Indian customers with country code (e.g., `+91`).
   - The mobile number is validated for a 10-digit input.

5. **Place** 🏙️
   - Accepts alphabets and spaces only.
   - The input is converted to sentence case for storage.

6. **Message** ✍️
   - Accepts any character.
   - No formatting is done; the user's input is captured as-is.

After the user completes the fields, the information is stored along with the current date and time. 🗓️⏰

## Features 🌟

- **CRUD Operations**: Enables creating, reading, updating, and deleting contact entries.
- **Activity Logging** 📜: Logs each action performed, with a timestamp.

## Installation 🛠️

To set up and use this project, follow these steps:

1. Clone the repository or download the script:
```bash
   git clone https://github.com/yourusername/AddressHub-Shell-script.git
   ```
2.Navigate to the directory where the script is located:
```bash
   cd AddressHub-Shell-script
   ```
3.Make the script executable:
```bash
    chmod +x Addresshub.sh
  ```
4.Run the script:
```bash
    ./Addresshub.sh
  ```
## System Requirements 🖥️

    Linux-based operating system (e.g., Ubuntu, CentOS, etc.)
    BASH shell environment 🖱️
    Basic knowledge of using terminal/command line 💡
