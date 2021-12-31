PROJECT_ID="ironsecurity"
TERRAFORM_DIR="."
TERRAFORM_VARFILE="settings.tfvars"
TERRAFORM_AUTH="terraform-sa.json"

all: fmt validate plan

setup:
	echo "Installing Google Cloud SDK"
	brew install google-cloud-sdk aquasecurity/trivy/trivy
	echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"' >> $HOME/.zshrc
	echo 'source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"' >> $HOME/.zshrc
	echo "Logging into Google Cloud"
	gcloud auth login

clean:
	rm .terraform.lock.hcl || true
	rm -r .terraform/ || true
	rm .terraform.lock.hcl || true

create-terraform-account:
	gcloud --project $(PROJECT_ID) iam service-accounts create terraform-sa
	gcloud --project $(PROJECT_ID) iam service-accounts keys create $(TERRAFORM_AUTH) \
		--iam-account "terraform-sa@$(PROJECT_ID).iam.gserviceaccount.com"
	chmod u=r,g=,o= terraform-sa.json

set-terraform-permissions:
	gcloud projects add-iam-policy-binding $(PROJECT_ID) \
		--member "serviceAccount:terraform-sa@$(PROJECT_ID).iam.gserviceaccount.com" \
		--role roles/editor \
		--role roles/storage.admin \
		--role roles/resourcemanager.projectIamAdmin \
		--role roles/container.admin \
		--role roles/cloudkms.admin \
		--role roles/iam.securityAdmin \
		--role roles/servicenetworking.networksAdmin \
		--role roles/orgpolicy.policyAdmin

enable-services:
	gcloud --project $(PROJECT_ID) services enable cloudresourcemanager.googleapis.com
	gcloud --project $(PROJECT_ID) services enable cloudbilling.googleapis.com
	gcloud --project $(PROJECT_ID) services enable iam.googleapis.com
	gcloud --project $(PROJECT_ID) services enable compute.googleapis.com
	gcloud --project $(PROJECT_ID) services enable serviceusage.googleapis.com
	gcloud --project $(PROJECT_ID) services enable container.googleapis.com
	gcloud --project $(PROJECT_ID) services enable cloudkms.googleapis.com
	gcloud --project $(PROJECT_ID) services enable sqladmin.googleapis.com
	gcloud --project $(PROJECT_ID) services enable servicenetworking.googleapis.com
	gcloud --project $(PROJECT_ID) services enable iamcredentials.googleapis.com

create-state-bucket:
	gsutil mb -p $(PROJECT_ID) -c NEARLINE -l eu -b on gs://terraform-gcloud-state

setup-helm:
	GOOGLE_APPLICATION_CREDENTIALS="terraform-sa.json" \
	helm repo add intigriti gs://intigriti-hybrid-helm-repo

update-helm:
	GOOGLE_APPLICATION_CREDENTIALS="terraform-sa.json" \
	helm repo update

lint:
	trivy config --format table --exit-code 2 --severity MEDIUM,HIGH,CRITICAL $(TERRAFORM_DIR) | less

init:
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) init \
		-upgrade \
		-reconfigure
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) get -update

validate:
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) validate .

plan:
	@if [ -f dev.env ]; then source dev.env; fi; \
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) plan \
		-lock=false \
		-input=false
		
apply:
	@if [ -f dev.env ]; then source dev.env; fi; \
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) apply \
		-auto-approve \
		-lock=false \
		-input=false \
		-refresh=false

TARGET="foo"
destroy:
	@if [ -f dev.env ]; then source dev.env; fi; \
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) destroy \
		-input=false \
		-target=$(TARGET) -auto-approve

refresh:
	@if [ -f dev.env ]; then source dev.env; fi; \
	GOOGLE_APPLICATION_CREDENTIALS=$(TERRAFORM_AUTH) \
	terraform -chdir=$(TERRAFORM_DIR) refresh

fmt:
	terraform fmt -recursive
