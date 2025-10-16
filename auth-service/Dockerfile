# -------Stage 1: builder-------
FROM python:3.12-slim AS builder
# Set working directory
WORKDIR /usr/src/app
# Copying only requirements for caching
COPY requirements.txt .
#   Install dependencies to a temporary folder
RUN pip install --user -r requirements.txt && python -m site --user-site

# -------Stage 2: image-------
FROM python:3.12-slim
# Set working directory
WORKDIR /usr/src/app
# Copying from the builder stage
COPY --from=builder /root/.local/ /root/.local/
# Copying everything from image to container directory
COPY . .
# Setting the environment variable
ENV PATH=/root/.local/bin:$PATH
# Exposing port
EXPOSE 5001
# Defining Entrypoint
ENTRYPOINT ["python", "app.py"]
