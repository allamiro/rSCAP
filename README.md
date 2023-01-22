# rSCAP


## rSCAP-Linux

rSCAP for Linux is a security automation and auditing for Linux systems using bash scripts adopting similar approach as openSCAP from available  internet  open source security standards such NIST etc.The tool can perform scap / scan checks against different security guidelines STIGs.

The given code is a Bash script that performs security compliance checks on a Linux system using the SCAP (Security Content Automation Protocol) standard. The script first checks if the xmlstarlet tool is installed and installs it if it is not. Then, it sets some environment variables, including the current date and time, and the path to the log file, the stig_checks, and the results. The script then checks if a SCAP check file is provided as an argument and exits if one is not provided.

The script is for performing compliance checks on Red Hat Enterprise Linux (RHEL) systems, and it uses the xmlstarlet tool to parse and process the SCAP check files. It also creates directories for storing the results and logs of the compliance checks.

To use the tool install the following packages

RHEL 7 , CentOS 7 , and Fedora 

```
wget --no-check-certificate https://dl.fedoraproject.org/pub/epel/7Server/x86_64/Packages/x/xmlstarlet-1.6.1-1.el7.x86_64.rpm
yum install xmlstarlet -y

```

Ubuntu 

```
apt-get install xmlstarlet -y

```
## How to use the tool


MAC OS



```
brew install xmlstarlet 

```
## References


* https://www.teimouri.net/what-is-openscap/
