# Use the official Python image as the base image
FROM python:3.9-slim

# Set environment variables to prevent Python from buffering stdout and stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Copy the application code and directories into the container
COPY . /app

# Install required Python packages
RUN pip install --no-cache-dir flask

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
