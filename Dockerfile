FROM jupyter/base-notebook:latest

USER root

# 基础镜像不带 curl，先安装
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# 设置 .NET 环境变量
ENV DOTNET_ROOT=/home/jovyan/.dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1 \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    PATH=/home/jovyan/.dotnet:/home/jovyan/.dotnet/tools:$PATH

USER jovyan

# 下载安装 .NET 10 SDK（dotnet-interactive 1.0.712001 需要 .NET 10）
RUN curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
 && bash /tmp/dotnet-install.sh --channel 10.0 --install-dir "$HOME/.dotnet" \
 && rm /tmp/dotnet-install.sh

# 安装 .NET Interactive，并把 C# 内核注册给 Jupyter
RUN dotnet tool install -g Microsoft.dotnet-interactive \
 && dotnet interactive jupyter install
