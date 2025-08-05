# Base image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Install Tailwind dependencies and build CSS
RUN npm install
RUN npm run build

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose port
EXPOSE 8000

CMD ["sh", "-c", "python manage.py collectstatic --noinput && gunicorn Mainpro.wsgi:application --bind 0.0.0.0:8000"]
