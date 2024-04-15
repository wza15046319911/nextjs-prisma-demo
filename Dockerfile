# Use the official Node.js image as the base image
FROM node:alpine3.18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
COPY .env .env
COPY ./docker-bootstrap-app.sh  ./
# Install dependencies
RUN npm install

# Copy the rest of the app's source code to the working directory
COPY . .

# Expose the port that the app will run on
EXPOSE 3000

# Start the app
CMD ["sh", "/app/docker-bootstrap-app.sh"]