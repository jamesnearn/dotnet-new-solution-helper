#!/bin/bash

# check for $1 $2 $3

function createGitRepo {
    git init $1
    cd $1

    git config user.email $2
    git config user.name $3

    echo bin/ > .gitignore
    echo obj/ >> .gitignore
    git add .gitignore
    git commit -m "adding .gitignore"
}

function createSolution {
    dotnet new sln
    git add $1.sln
    git commit -m "adding .sln"
}

function createProject {
    dotnet new $1 -o $2
    dotnet sln add $2
    dotnet list $2 package
}

function commitProject {
    git add $1/$1.csproj
    git commit -m "adding project for $1"
}

createGitRepo $1 $2 $3

createSolution $1

createProject classlib $1Helper
dotnet add $1Helper package Newtonsoft.Json
commitProject $1Helper

createProject xunit $1Tests
dotnet add $1Tests reference $1Helper/$1Helper.csproj
commitProject $1Tests

createProject console $1Console
dotnet add $1Console reference $1Helper/$1Helper.csproj
commitProject $1Console

dotnet build
dotnet test
dotnet run --project $1Console
