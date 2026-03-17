# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A learning repository for [Prodigy](https://prodi.gy/) annotation workflows integrated with spaCy and spacy-llm. The primary use case is LLM-assisted NER annotation for a cooking domain (DISH, INGREDIENT, EQUIPMENT), with support for text classification and prompt A/B testing.

## Environment Setup

Copy `.env.example` to `.env` and populate:
- `PRODIGY_LICENSE_KEY` — required to install Prodigy
- `OPENAI_API_KEY` — required for all spacy-llm and OpenAI recipes

```bash
# Full setup (dependencies + Prodigy)
make setup

# Just Python dependencies (no Prodigy)
make install

# Verify Prodigy installation
python -m prodigy stats
```

**Note:** Prodigy v1.15.7 is the maximum eligible version for the current personal license. Install via `make install-prodigy` (reads license key from `.env`).

## Common Commands

```bash
# Manual annotation
make ner-manual          # Annotate from scratch in Prodigy UI
make ner-correct         # Correct predictions from trained model

# LLM-powered annotation (spacy-llm, recommended)
make ner-llm-correct     # Review/correct GPT predictions in UI
make ner-llm-fetch       # Batch-fetch predictions to JSONL
make textcat-llm-correct # Text classification correction UI
make textcat-llm-fetch   # Batch text classification
make terms-llm-fetch     # Generate domain terminology

# Export annotated data
make db-out              # Export cooking_ner dataset
make db-out-llm          # Export cooking_ner_llm dataset

# Prompt A/B testing
make ab-llm-tournament   # Tournament-style prompt comparison

# Dependency management
make compile             # Recompile requirements.txt from requirements.in
make clean               # Remove __pycache__ and .pyc files
```

## Architecture

### Two Annotation Paths

1. **spacy-llm recipes** (`*.llm.*`) — config-file driven, flexible, recommended. Use `dotenv run --` to load `.env`. Configs live in `dev/_config/`.
2. **OpenAI direct recipes** (`*.openai.*`) — simpler but deprecated; use `PRODIGY_OPENAI_KEY` from `.env`.

### Configuration System (`dev/_config/`)

| File | Task | Labels |
|------|------|--------|
| `prodigy_config_ner.cfg` | Cooking NER (main) | DISH, INGREDIENT, EQUIPMENT |
| `config_ner.cfg` | Generic NER | PERSON, ORGANIZATION, LOCATION |
| `config.cfg` | Text classification | COMPLIMENT, INSULT |
| `config_classif.cfg` | Text classification (alt) | COMPLIMENT, INSULT |

All configs use `spacy.GPT-4.v3` as the LLM component, which accepts any OpenAI model name (e.g., `gpt-4.1-mini`, `gpt-4.1`, `o3-mini`). The model name is set in the config under `[components.llm.model]`.

### Few-Shot Examples (`dev/_fewshot/ner_examples.yml`)

Loaded via `FewShotReader.v1` in `prodigy_config_ner.cfg`. Add new cooking domain examples here to improve LLM pre-annotation quality.

### Data Flow

```
data/examples.jsonl  →  [LLM pipeline / Prodigy UI]  →  Prodigy DB  →  db-out  →  data/*.jsonl
```

Fetched annotations (non-interactive) go directly to `data/ner_llm_annotations.jsonl` etc.

### `app.py`

Demonstrates minimal spacy-llm pipeline assembly:
```python
from spacy_llm.util import assemble
nlp = assemble("dev/_config/prodigy_config_ner.cfg")
doc = nlp("some text")
print(doc.ents)
```

## Key Dependencies

- `spacy` + `spacy-llm` — NLP pipeline and LLM integration
- `prodigy` — annotation UI (install separately via license key)
- `openai` — LLM API client
- `python-dotenv` / `dotenv` CLI — environment variable loading

Dependencies are managed with `uv`. To add a dependency: add it to `requirements.in`, then run `make compile` to regenerate `requirements.txt`.
