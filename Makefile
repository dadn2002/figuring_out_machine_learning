install:
	pip install --upgrade pip && \
	pip install -r requirements.txt

format:
#	black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
   
	echo '\n## Confusion Matrix Plot' >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
   
	cml comment create report.md

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git add report.md
	git commit -am "Update with new results"
	git push --force origin HEAD:update

hf-login:
	pip install -U "huggingface_hub[cli]"
	git pull origin update
	git switch update
	git config --global credential.helper store
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload dadn/first_attempt ./App 	--repo-type=space --commit-message="Sync App files" --create-pr
	huggingface-cli upload dadn/first_attempt ./Model 	--repo-type=space --commit-message="Sync Model" 	--create-pr
	huggingface-cli upload dadn/first_attempt ./Results --repo-type=space --commit-message="Sync Model" 	--create-pr

deploy: hf-login push-hub
