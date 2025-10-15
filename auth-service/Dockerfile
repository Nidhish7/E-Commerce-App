# -------Stage 1: builder-------
FROM python:3.12-slim AS builder

# Set working directory
WORKDIR /usr/src/app

# Copying only requirements for caching
COPY requirements.txt .

#   Install dependencies to a temporary folder
RUN pip install --user -r requirements.txt && python -m site --user-site

FROM python:3.12-slim
WORKDIR /usr/src/app
COPY --from=builder /root/.local/ /root/.local/
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 5001
ENTRYPOINT ["python", "app.py"]
