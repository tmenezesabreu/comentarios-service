FROM python:3.9

WORKDIR /app

COPY ./app/requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY ./app /app
CMD ["gunicorn", "api:app", "--bind", "0.0.0.0:8080", "--log-level", "debug"]
