FROM ubuntu
RUN apt update -y
RUN apt install nginx -y
ADD index.html /var/www/html
CMD ["nginx", "-g", "daemon off;"]
