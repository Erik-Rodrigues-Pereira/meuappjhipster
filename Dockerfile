# Estágio de Build (onde o Maven compila o JAR)
FROM eclipse-temurin:21-jdk-jammy AS build

# Define o diretório de trabalho no container
WORKDIR /app

# Copia o código e as ferramentas de build
COPY . /app

# --- CORREÇÃO: Adiciona permissão de execução ao Maven Wrapper (AGORA NO LOCAL CORRETO) ---
RUN chmod +x ./mvnw

# Roda o Build do Maven (o mesmo comando que resultou em BUILD SUCCESS)
RUN ./mvnw -Pprod package -DskipTests

# --- Estágio de Execução (Runtime) ---
# Imagem base mais robusta para execução
FROM eclipse-temurin:21-jdk-jammy
 
# Define o perfil de produção
ENV SPRING_PROFILES_ACTIVE=prod
 
# Porta exposta
EXPOSE 8080

# Copia o JAR do estágio de build
COPY --from=build /app/target/*.jar app.jar

# Define o comando de inicialização
ENTRYPOINT ["java", "-jar", "/app.jar"]