ARG buildimagetag="2.1-sdk"
ARG runtimeimagetag="2.1-aspnetcore-runtime"
FROM microsoft/dotnet:${buildimagetag} AS build
COPY /code /code
WORKDIR /code
RUN dotnet build -c Release -o output
FROM microsoft/dotnet:${runtimeimagetag}
COPY --from=build /code/output .
EXPOSE 8080
ENTRYPOINT ["dotnet","code.dll"]
ENV ASPNETCORE_URLS http://*:8080
