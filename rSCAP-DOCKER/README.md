# rSCAP-Docker

## Overview
**rSCAP-Docker** is a Bash-based modular tool designed to scan Docker containers for compliance with Security Technical Implementation Guide (STIG) rules. It parses STIG files in XML format, extracts compliance rules, and evaluates Docker containers against these guidelines to ensure security hardening.

## Features
- Parses STIG files in **XML format** (DoD standards).
- Scans Docker containers for compliance with security rules.
- Modular and extensible for additional compliance checks.
- Generates detailed compliance reports and logs.
- Easy configuration and setup.

## Prerequisites
1. **Operating System**: Linux with Bash shell.
2. **Docker**: Installed and configured.
3. **Utilities**: `xmlstarlet`, `docker`, and standard GNU tools.

### Install Required Tools
```
sudo apt install xmlstarlet jq docker

```
1. Clone the repo
```
git clone https://github.com/your-repo/rSCAP-Docker.git
cd rSCAP-Docker
```
2. Make scripts executable:
```
chmod +x rSCAP-Docker.sh modules/*.sh utils/*.sh
```