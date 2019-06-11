# Fedora Silverblue Documentation

This repository contains the Fedora Silverblue documentation.

## Structure

```
|-- README.md
|-- antora.yml ....................... 1.
|-- build.sh ......................... 2.
|-- preview.sh ....................... 3.
|-- nginx.conf ....................... 4.
|-- site.yml ......................... 5.
`-- modules
    `-- ROOT ......................... 6.
        |-- assets
        |   `-- images ............... 7.
        |       `-- *
        |-- nav.adoc ................. 8.
        `-- pages .................... 9.
            |-- *
```

1. Metadata definition.
2. A script that does a local build. Uses podman or docker.
3. A script that shows a preview of the site in a web browser by running a local web server. Uses podman or docker.
4. A configuration file used by the local preview web server. 
5. A definition file for the build script.
6. A "root module of this documentation component". Please read below for an explanation.
7. **Images** to be used on any page.
8. **Menu definition.** Also defines the hierarchy of all the pages.
9. **Pages with the actual content.** They can be also organised into subdirectories if desired.

## Components and Modules

Antora introduces two new terms:

* **Component** — Simply put, a component is a part of the documentation website with its own menu. Components can also be versioned. In the Fedora Docs, we use separate components for user documentation, the Fedora Project, Fedora council, Mindshare, FESCO, but also subprojects such as CommOps or Modulartity.
* **Module** — A component can be broken down into multiple modules. Modules still share a single menu on the site, but their sources can be stored in different git repositories, even owned by different groups. The default module is called "ROOT" (that's what is in this example). If you don't want to use multiple modules, only use "ROOT". But to define more modules, simply duplicate the "ROOT" directory and name it anything you want. You can store modules in one or more git repositories.

## Local preview

This repo includes scripts to build and preview the contents of this repository.

**NOTE**: Please note that if you reference pages from other repositories, such links will be broken in this local preview as it only builds this repository. If you want to rebuild the whole Fedora Docs site, please see [the Fedora Docs build repository](https://pagure.io/fedora-docs/docs-fp-o/) for instructions.

Both scripts use either podman or docker, so please make sure you have one of the two installed on your system.

To enable docker run:

```
$ sudo systemctl start docker && sudo systemctl enable docker
```

To build and preview the site, run:

```
$ ./build.sh && ./preview.sh
```

The result will be available at http://localhost:8080
