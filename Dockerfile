# Use the official Python base image, stripped down for smaller size
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first to take advantage of Docker layer caching
# This step is often the slowest, so isolating it helps speed up rebuilds
COPY requirements.txt .

# Install dependencies, ensuring no cache is saved to keep the image small
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files:
# iris_fastapi.py (the FastAPI app)
# model.joblib (the trained model file)
COPY iris_fastapi.py .
COPY model.joblib .

# Expose the port where the Uvicorn server will listen
# This must match the port specified in the CMD instruction
EXPOSE 8200

# Command to run the Uvicorn server:
# --host 0.0.0.0 makes the server accessible from outside the container
# --port 8200 matches the EXPOSE port
# iris_fastapi:app tells Uvicorn to load the 'app' object from 'iris_fastapi.py'
CMD ["uvicorn", "iris_fastapi:app", "--host", "0.0.0.0", "--port", "8200"]
