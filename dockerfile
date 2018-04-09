FROM centos:7
MAINTAINER Brian Ogden

#Timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN yum update -y && \
         yum clean all

#############################################
# .NET Core SDK
#############################################
RUN yum install -y \
    libunwind \
    libicu

RUN curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=848821
RUN mkdir -p /opt/dotnet && tar zxf dotnet.tar.gz -C /opt/dotnet
RUN ln -s /opt/dotnet/dotnet /usr/local/bin

#speed up dotnet core builds
ENV NUGET_XMLDOC_MODE skip
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE true
#############################################

#############################################
# Setup Container for SSH
#############################################
WORKDIR /
RUN yum install -y \
    unzip \
    openssh-server \
    curl

RUN mkdir -p /var/run/sshd
RUN echo 'root:password' | chpasswd

# SSH login fix. Otherwise user is kicked off after login
#ref https://engineering.riotgames.com/news/jenkins-ephemeral-docker-tutorial
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# gen dummy keys, centos doesn't autogen them like ubuntu does
#ref https://engineering.riotgames.com/news/jenkins-ephemeral-docker-tutorial
RUN /usr/bin/ssh-keygen -A 

#to pass environment variables when running a Dockerized SSHD service. 
#SSHD scrubs the environment, therefore ENV variables contained in Dockerfile 
#must be pushed to /etc/profile in order for them to be available.
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
#############################################



#############################################
# .NET Sevrice setup
#############################################
#install CLRDBG, Microsoft's new cross-platform command line debugger used for debugging code running on .NET Core
RUN curl -sSL https://aka.ms/getclrdbgsh | bash /dev/stdin vs2015u2 ~/clrdbg

# Copy our code from the "/src/MyWebApi/bin/Debug/netcoreapp1.1/publish" folder to the "/app" folder in our container
WORKDIR /app
COPY ./src/TSL.Security.Service/bin/Debug/netcoreapp1.1/publish .

ARG ASPNETCORE_ENVIRONMENT
# Expose port 5000 for the Web API traffic
ENV ASPNETCORE_URLS http://+:5000
ENV ASPNETCORE_ENVIRONMENT $ASPNETCORE_ENVIRONMENT 

EXPOSE 5000 22

ENTRYPOINT ["dotnet", "TSL.Security.Service.dll"]

#############################################


#I wish this would start ssh when the container is ran but it doesn't, tried lots to get this to work
CMD ["/usr/sbin/sshd","-D"]
