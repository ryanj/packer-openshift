# OpenShift images for Instruqt

GCloud Pre-requisites:

1. python3.8 or newer is required. reboot after installing python3
2. install the gcloud client (brew or rpm)
3. Create a new project for this work in Google Cloud
4. run `gcloud init` to authenticate and select your project id
5. Check to make sure you have the following services enabled:
  * https://console.cloud.google.com/marketplace/product/google/compute.googleapis.com
  * https://console.cloud.google.com/marketplace/product/google/cloudbuild.googleapis.com
6. Create a custom service account for Packer and assign it 'Compute Instance Admin (v1)' & 'Service Account User' roles. Name: packer

n. Create a new service account? (default)

gcloud iam service-accounts create packer \
  --project YOUR_GCP_PROJECT \
  --description="Packer Service Account" \
  --display-name="Packer Service Account"

$ gcloud projects add-iam-policy-binding YOUR_GCP_PROJECT \
    --member=serviceAccount:packer@YOUR_GCP_PROJECT.iam.gserviceaccount.com \
    --role=roles/compute.instanceAdmin.v1

$ gcloud projects add-iam-policy-binding YOUR_GCP_PROJECT \
    --member=serviceAccount:packer@YOUR_GCP_PROJECT.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

$ gcloud projects add-iam-policy-binding YOUR_GCP_PROJECT \
    --member=serviceAccount:packer@YOUR_GCP_PROJECT.iam.gserviceaccount.com \
    --role=roles/iap.tunnelResourceAccessor

$ gcloud compute instances create INSTANCE-NAME \
  --project YOUR_GCP_PROJECT \
  --image-family ubuntu-2004-lts \
  --image-project ubuntu-os-cloud \
  --network YOUR_GCP_NETWORK \
  --zone YOUR_GCP_ZONE \
  --service-account=packer@YOUR_GCP_PROJECT.iam.gserviceaccount.com \
  --scopes="https://www.googleapis.com/auth/cloud-platform"
