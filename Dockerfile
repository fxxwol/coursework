FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy the solution file and the project file
COPY DotnetApiPostgres.sln .
COPY DotnetApiPostgres.Api/DotnetApiPostgres.Api.csproj DotnetApiPostgres.Api/

# Restore dependencies
RUN dotnet restore


# copy everything else and build app
COPY DotnetApiPostgres.Api/. ./DotnetApiPostgres.Api/
WORKDIR /source/DotnetApiPostgres.Api
RUN dotnet publish -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app ./

ENTRYPOINT ["dotnet", "DotnetApiPostgres.Api.dll"]