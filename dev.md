# useful commands
## clean up docker 
```
docker system prune -f
```

## build container with no cache
```
docker-compose build --no-cache
```

## start container
```
docker-compose up -d
```

## open terminal to docker
```
docker-compose exec iris iris session iris -U FHIRServer
```

## FHIR Namespace setup

do ##class(HS.HC.Util.Installer).InstallFoundation("FHIRServer")

## fhir server configuration setup
```
do ##class(HS.FHIRServer.ConsoleSetup).Setup()
```

## load fhir resources
```
zw ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/irisdev/app/output/fhir/", "FHIRServer", "/fhir/r4")

kill ^%ISCLOG

kill ^ISCLOG

set ^%ISCLOG=3

## Patient data

The template goes with 5 preloaded patents in [/data/fhir](https://github.com/jrpereirajr/iris-fhir-generative-ai-ai/tree/master/data/fhir) folder which are being loaded during [docker build](https://github.com/jrpereirajr/iris-fhir-generative-ai-ai/src/fhirtemplate/Setup.cls#L32)
You can generate more patients doing the following. Open shel terminal in repository folder and call:

```bash
./synthea-loader.sh 10
```
this will create 10 more patients in data/fhir folder.
Then open IRIS terminal in FHIRSERVER namespace with the following command:

```bash
docker-compose exec iris iris session iris -U FHIRServer
```

and call the loader method:

```objectscript
Do ##class(fhirtemplate.Setup).LoadPatientData("/irisdev/app/output/fhir","FHIRSERVER","/fhir/r4")
```

with using the [following project](https://github.com/intersystems-community/irisdemo-base-synthea)

## Testing FHIR R4 API

Open URL http://localhost:32783/fhir/r4/metadata
you should see the output of fhir resources on this server

## Testing Postman calls

Get fhir resources metadata
GET call for http://localhost:32783/fhir/r4/metadata

<img width="881" alt="Screenshot 2020-08-07 at 17 42 04" src="https://user-images.githubusercontent.com/2781759/89657453-c7cdac00-d8d5-11ea-8fed-71fa8447cc45.png">

Open Postman and make a GET call for the preloaded Patient:
http://localhost:32783/fhir/r4/Patient/1

<img width="884" alt="Screenshot 2020-08-07 at 17 42 26" src="https://user-images.githubusercontent.com/2781759/89657252-71606d80-d8d5-11ea-957f-041dbceffdc8.png">

## Development Resources

- [InterSystems IRIS FHIR Documentation](https://docs.intersystems.com/irisforhealth20203/csp/docbook/Doc.View.cls?KEY=HXFHIR)
- [FHIR API](http://hl7.org/fhir/resourcelist.html)
- [Developer Community FHIR section](https://community.intersystems.com/tags/fhir)

## What's inside the repository

### Dockerfile

The simplest dockerfile which starts IRIS and imports Installer.cls and then runs the Installer.setup method, which creates FHIRSERVER Namespace and imports code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.
Use .env/ file to adjust the dockerfile being used in docker-compose.

### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))

### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

## Troubleshooting

**ERROR #5001: Error -28 Creating Directory /usr/irissys/mgr/FHIRSERVER/**

If you see this error it probably means that you ran out of space in docker.
you can clean up it with the following command:

```bash
docker system prune -f
```

And then start rebuilding image without using cache:

```bash
docker-compose build --no-cache
```

and start the container with:

```bash
docker-compose up -d
```

This and other helpful commands you can find in [dev.md](https://github.com/jrpereirajr/iris-fhir-generative-ai-ai/tree/master/dev.md)