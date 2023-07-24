FROM python:3.9.0

LABEL maintainer "EIP"

RUN mkdir /mlflow/

RUN pip install mlflow

EXPOSE 5000

CMD mlflow server \
  --backend-store-uri ./mlruns  \
  ---default-artifact-root ./mlruns \
  --host 0.0.0.0

#  --default-artifact-root ./mlruns  \

#  --file-store s3://${BUCKET}/test \
#  --default-artifact-root s3://${BUCKET}/test \
#    mkdir -p ./mlruns
#  mlflow server --backend-store-uri ./mlruns --default-artifact-root ./mlruns --host 0.0.0.0 &
