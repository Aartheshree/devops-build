# Stage 1: Build the React application
FROM node:14 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of the application source code to the working directory
COPY ./build ./build

RUN ls build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Copy the build output to Nginx's default static directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
