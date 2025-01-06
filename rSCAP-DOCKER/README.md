# rSCAP-Docker

## Overview
**rSCAP-Docker** is a modular Bash-based security guidelines scanner for Linux Docker containers. It is designed to read Security Technical Implementation Guide (STIG) files and ensure compliance by scanning Docker containers against specified rules.

## Features
- Modular structure for easy maintenance and updates.
- Parses STIG files in YAML or JSON format.
- Scans Docker containers for compliance with security guidelines.
- Generates detailed logs and compliance reports.

## Prerequisites
- **Linux OS** with Bash shell.
- **Docker** installed and running.
- Optional: `jq` for parsing JSON, `yq` for YAML.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/rSCAP-Docker.git
   cd rSCAP-Docker
