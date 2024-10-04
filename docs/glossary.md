# Glossary

## Worker
(Synology Term)

During SPK installation or removal, "workers" read a configuration block to see what actions need to be performed.  For example:

* a [/usr/local worker](https://help.synology.com/developer-guide/resource_acquisition/usrlocal_linker.html) maintains softlinks in /usr/local
* a [Docker Project Worker](https://help.synology.com/developer-guide/resource_acquisition/docker-project.html) runs multi-container services using one or more `docker-compose` projects

