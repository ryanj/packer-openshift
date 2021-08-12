# OpenShift images for Instruqt

latest build preview available here: https://storage.googleapis.com/crc-vm/crc-1.31.vmdk

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

$ export PROJECT=YOUR_PROJECT_ID

$ gcloud iam service-accounts create packer \
  --project $PROJECT \
  --description="Packer Service Account" \
  --display-name="Packer Service Account"

$ gcloud projects add-iam-policy-binding $PROJECT \
    --member=serviceAccount:packer@$PROJECT.iam.gserviceaccount.com \
    --role=roles/compute.instanceAdmin.v1

$ gcloud projects add-iam-policy-binding $PROJECT \
    --member=serviceAccount:packer@$PROJECT.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

$ gcloud projects add-iam-policy-binding $PROJECT \
    --member=serviceAccount:packer@$PROJECT.iam.gserviceaccount.com \
    --role=roles/iap.tunnelResourceAccessor

$ qemu-img convert -f qcow2 -O vmdk -o subformat=streamOptimized,compat6 ~/.crc/cache/crc_libvirt_4.8.4/crc.qcow2 crc-1.31.vmdk

upload the resulting image to google cloud storage
