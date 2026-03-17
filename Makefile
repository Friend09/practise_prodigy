install:
	pip install --upgrade pip && \
		pip install -r requirements.txt

install-prodigy:
	@if [ -f .env ]; then \
		export $$(grep PRODIGY_LICENSE_KEY .env | xargs) && \
		pip install prodigy==1.15.8 -f https://$$PRODIGY_LICENSE_KEY@download.prodi.gy; \
	else \
		echo "ERROR: .env file not found. Copy .env.example to .env and add your license key."; \
		exit 1; \
	fi

setup: install install-prodigy
	@echo "Setup complete. Run 'python -m prodigy stats' to verify."

ner-manual:
	python -m prodigy ner.manual cooking_ner blank:en ./data/examples.jsonl \
		--label DISH,INGREDIENT,EQUIPMENT

ner-correct:
	python -m prodigy ner.correct cooking_ner_corrected models/en_cooking_ner ./data/examples.jsonl \
		--label DISH,INGREDIENT,EQUIPMENT

db-out:
	python -m prodigy db-out cooking_ner > ./data/cooking_ner_annotations.jsonl

stats:
	python -m prodigy stats

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name '*.pyc' -delete 2>/dev/null || true
