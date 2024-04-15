# # Use the official Node.js image as the base image
# FROM node:alpine3.18 as base
# RUN apk add --no-cache g++ make py3-pip libc6-compat
# # Set the working directory inside the container
# WORKDIR /app
# COPY package*.json ./
# EXPOSE 3000

# FROM base as builder
# WORKDIR /app
# COPY . .
# RUN npm run build

# FROM base as production
# WORKDIR /app
# ENV NODE_ENV=production
# RUN npm ci
# RUN addgroup -g 1001 -S nodejs
# RUN adduser -S nextjs -u 1001
# USER nextjs
# COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/public ./public
# COPY --chown=nextjs:nodejs prisma ./prisma/ 
# COPY --chown=nextjs:nodejs docker-bootstrap-app.sh ./
# CMD ["sh", "/app/docker-bootstrap-app.sh"]

# # FROM base as dev
# # ENV NODE_ENV=development
# # RUN npm install 
# # COPY . .
# # CMD ["npm", "run", "dev"]

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
# Install dependencies
RUN npm ci --production

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