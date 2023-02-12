FROM node:alpine

COPY dist dist/
COPY package.json .

ENV AWS_ACCOUNT_ID="258038385982" AWS_DEFAULT_REGION="eu-central-1" CONTAINER_NAME="e-commerce-api" IMAGE_REPO_NAME="e-commerce-api" IMAGE_TAG="latest" SERVER_PORT="5000" POSTGRESQL_HOST="itemdb-cluster.cxcmcghvbbkd.eu-central-1.rds.amazonaws.com" POSTGRESQL_PORT="5432" POSTGRESQL_USER="squxq" POSTGRESQL_PW="Apessoa2007" POSTGRESQL_DATABASE="ItemDB"
EXPOSE 5000

CMD ["npm", "run", "production"]