# Get current projectID
export PROJECTID=$(gcloud config get-value core/project 2>/dev/null)

# Create a service account
gcloud iam service-accounts create inlets \
  --description "inlets-operator service account" \
  --display-name "inlets"

# Get service account email
export SERVICEACCOUNT=$(gcloud iam service-accounts list | grep inlets | awk '{print $2}')

# Assign appropriate roles to inlets service account
gcloud projects add-iam-policy-binding $PROJECTID \
  --member serviceAccount:$SERVICEACCOUNT \
  --role roles/compute.admin

gcloud projects add-iam-policy-binding $PROJECTID \
  --member serviceAccount:$SERVICEACCOUNT \
  --role roles/iam.serviceAccountUser

# Create inlets service account key file
gcloud iam service-accounts keys create key.json \
  --iam-account $SERVICEACCOUNT