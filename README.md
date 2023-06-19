 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-fhir-generative)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fhir-generative&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fhir-generative)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fhir-generative&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fhir-generative)

# iris-fhir-generative
// todo: project description

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

// todo: include OpenAI API as prerequisite

## Installation 

### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```objectscript
zpm "install iris-fhir-generative"
```

This will install FHIR server in FHIRSERVER namespace.

Or call the following for installing programmatically:

```objectscript
Set sc = $zpm("install iris-fhir-generative")
```

### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```bash
git clone https://github.com/jrpereirajr/iris-fhir-generative-ai.git
```

Open the terminal in this directory and run the following.

In order to run this project, you need to have a OpenAI API key. So, set an environment called `OPENAI_API_KEY` variable with its value:

For Linux:
```bash
export OPENAI_API_KEY=your_api_key_here
```

For Windows (MS DOS):
```bat
set OPENAI_API_KEY=your_api_key_here
```

For Windows (Powershell):
```powershell
$env:OPENAI_API_KEY = "your_api_key_here"
```

Next, build and run the project image:

```bash
docker-compose build --build-arg OPENAI_API_KEY=$OPENAI_API_KEY
docker-compose up -d
```

## Patient data
The template goes with 5 preloaded patents in [/data/fhir](https://github.com/jrpereirajr/iris-fhir-generative-ai/tree/master/data/fhir) folder which are being loaded during [docker build](https://github.com/jrpereirajr/iris-fhir-generative-ai/src/fhirtemplate/Setup.cls#L32)
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

This and other helpful commands you can find in [dev.md](https://github.com/jrpereirajr/iris-fhir-generative-ai/tree/master/dev.md)
