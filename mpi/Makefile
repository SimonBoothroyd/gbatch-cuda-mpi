TAG ?=
PROJECT ?=

.PHONY: build
build:
	docker buildx build --platform linux/x86_64 -t $(TAG) .
	docker push $(TAG)

.PHONY: submit
submit:
	gcloud batch jobs submit --project $(PROJECT) --location us-central1 --config job.json
