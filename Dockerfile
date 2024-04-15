# Use the official Node.js image as the base image
FROM node:alpine3.18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./
COPY .env .env
COPY ./docker-bootstrap-app.sh ./
COPY ./prisma ./
RUN npx prisma generate

# Copy the rest of the app's source code to the working directory
COPY . .

# Build the Next.js application
RUN npm run build

# Use a lightweight Node.js image for the production environment
FROM node:alpine3.18 AS production

# Set the working directory inside the container
WORKDIR /app

# Copy the built Next.js application from the build stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./
COPY --from=build /app/.env ./
COPY --from=build /app/docker-bootstrap-app.sh ./
COPY --from=build /app/prisma ./prisma


# Install only production dependencies
RUN npm ci --production

# Expose the port that the app will run on
EXPOSE 3000

# Start the app
CMD ["sh", "/app/docker-bootstrap-app.sh"]