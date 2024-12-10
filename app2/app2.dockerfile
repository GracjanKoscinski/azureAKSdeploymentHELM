FROM python:3.9-slim

RUN pip install flask
COPY app2/ /app/

WORKDIR /app
EXPOSE 80
CMD ["python", "app2.py"]
