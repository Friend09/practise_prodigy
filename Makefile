compile:
	uv pip compile requirements.in -o requirements.txt

install:
	uv pip install --upgrade pip && \
		uv pip install -r requirements.txt

install-prodigy:
	@if [ -f .env ]; then \
		export $$(grep PRODIGY_LICENSE_KEY .env | xargs) && \
		uv pip install prodigy==1.15.7 -f https://$$PRODIGY_LICENSE_KEY@download.prodi.gy; \
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

# --- LLM-powered recipes (spacy-llm) ---

ner-llm-correct:
	dotenv run -- python -m prodigy ner.llm.correct cooking_ner_llm \
		dev/_config/prodigy_config_ner.cfg ./data/examples.jsonl

ner-llm-fetch:
	dotenv run -- python -m prodigy ner.llm.fetch \
		dev/_config/prodigy_config_ner.cfg ./data/examples.jsonl \
		./data/ner_llm_annotations.jsonl

textcat-llm-correct:
	dotenv run -- python -m prodigy textcat.llm.correct cooking_textcat_llm \
		dev/_config/config.cfg ./data/examples.jsonl

textcat-llm-fetch:
	dotenv run -- python -m prodigy textcat.llm.fetch \
		dev/_config/config.cfg ./data/examples.jsonl \
		./data/textcat_llm_annotations.jsonl

terms-llm-fetch:
	dotenv run -- python -m prodigy terms.llm.fetch cooking_terms \
		dev/_config/config.cfg "cooking ingredients"

# --- OpenAI direct recipes (uses PRODIGY_OPENAI_KEY from .env) ---

ner-openai-correct:
	python -m prodigy ner.openai.correct cooking_ner_openai ./data/examples.jsonl \
		--label DISH,INGREDIENT,EQUIPMENT

ner-openai-fetch:
	python -m prodigy ner.openai.fetch ./data/examples.jsonl \
		./data/ner_openai_annotations.jsonl \
		--label DISH,INGREDIENT,EQUIPMENT

textcat-openai-correct:
	python -m prodigy textcat.openai.correct cooking_textcat_openai ./data/examples.jsonl \
		--label RECIPE,FEEDBACK,QUESTION

textcat-openai-fetch:
	python -m prodigy textcat.openai.fetch ./data/examples.jsonl \
		./data/textcat_openai_annotations.jsonl \
		--label RECIPE,FEEDBACK,QUESTION

terms-openai-fetch:
	python -m prodigy terms.openai.fetch "cooking ingredients" \
		./data/terms_openai.jsonl --n 100

# --- Prompt comparison & tournaments ---

ab-llm-tournament:
	dotenv run -- python -m prodigy ab.llm.tournament haiku-tournament \
		./data/inputs.jsonl ./dev/prompts ./dev/_config \
		./dev/display-template.jinja2 --resume

ab-openai-prompts:
	python -m prodigy ab.openai.prompts prompt-compare \
		./data/inputs.jsonl ./dev/display-template.jinja2 \
		./dev/prompts/prompt1.jinja2 ./dev/prompts/prompt2.jinja2 --repeat 4

ab-openai-tournament:
	python -m prodigy ab.openai.tournament prompt-tournament \
		./data/inputs.jsonl ./dev/display-template.jinja2 ./dev/prompts

# --- Export & utilities ---

db-out:
	python -m prodigy db-out cooking_ner > ./data/cooking_ner_annotations.jsonl

db-out-llm:
	python -m prodigy db-out cooking_ner_llm > ./data/cooking_ner_llm_annotations.jsonl

stats:
	python -m prodigy stats

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name '*.pyc' -delete 2>/dev/null || true
