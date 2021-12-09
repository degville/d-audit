# d-audit
Scans given Discourse docs index URL for non-inclusive language using the required woke tool

Make sure the _woke_ tool is first installed and in your path: [https://github.com/get-woke/woke](https://github.com/get-woke/woke)

Usage: d-audit.sh [OPTION] ...

  -u \<url\>     URL for Discourse index page (mandatory)</br>
  -d \<dir\>     Flag to optionally download documentation pages to given directory

Examples:

Audit an online set of docs:
```bash
d-audit.sh -u https://discourse.ubuntu.com/t/ubuntu-core-documentation/19764
```

Download a set of docs to a _mydocs_ directory:
```bash
d-audit.sh -d mydocs -u https://discourse.ubuntu.com/t/ubuntu-core-documentation/19764
```
