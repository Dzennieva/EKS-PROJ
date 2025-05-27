# Multi-stage
# 1) Node image for building frontend assets
# 2) nginx stage to serve frontend assets

# Base Image named builder
FROM node:19.9.0-alpine3.18 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy all files from current directory to working directory
COPY . . 

# install node modules and build assets
RUN yarn install && yarn run build

# Nginx based on debian bullsey for serving content
FROM nginx:bullseye

# Set working directory inside the container 
WORKDIR /usr/share/nginx/html

# Remove all existing files
RUN rm -rf ./*

# Copy built file from builder stage
COPY --from=builder /app/build .

# Start the NGINX server with the daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
