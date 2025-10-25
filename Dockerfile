# Gunakan image Node.js ringan
FROM node:18-alpine

# Tentukan folder kerja di container
WORKDIR /app

# Salin file konfigurasi package ke dalam container
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin seluruh isi project
COPY . .

# Build project (opsional kalau hanya dev)
RUN npm run build

# Buka port 5173 di container
EXPOSE 5173

# Jalankan server development
CMD ["npm", "run", "dev", "--", "--host"]
