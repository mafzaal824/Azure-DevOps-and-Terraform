# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/core/sdk:7.0 AS build-env
WORKDIR /app

# Copy csproj and restore
COPY *.csproj ./
RUN dotnet restore --use-current-runtime

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore

# Generate runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:7.0
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app .
ENTRYPOINT ["dotnet", "weatherapi.dll"]