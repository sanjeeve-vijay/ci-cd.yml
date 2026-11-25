FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run as non-root
RUN useradd --create-home appuser
USER appuser

EXPOSE 8000

# Assumes a WSGI app at app:app (Flask etc.) and gunicorn in requirements.txt.
# For FastAPI use: uvicorn app:app --host 0.0.0.0 --port 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "app:app"]
