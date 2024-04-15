#!/bin/sh
DATABASE_URL="postgresql://admin:123456@postgres:5432/test"
npx prisma migrate reset
npx prisma db push
npm start