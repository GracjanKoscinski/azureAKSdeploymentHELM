FROM python:3.9-slim

RUN pip install flask

COPY app1/ /app/

WORKDIR /app
EXPOSE 80
CMD ["python", "app1.py"]
