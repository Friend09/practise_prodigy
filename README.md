# NLP with Prodigy

A learning and practice repository for [Prodigy](https://prodi.gy/) — Explosion's annotation tool for NLP, computer vision, and audio/video — integrated with [spaCy](https://spacy.io/) and [spacy-llm](https://github.com/explosion/spacy-llm) for LLM-powered NLP pipelines.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Create a Virtual Environment](#2-create-a-virtual-environment)
  - [3. Install Dependencies](#3-install-dependencies)
  - [4. Install Prodigy](#4-install-prodigy)
  - [5. Set Up Environment Variables](#5-set-up-environment-variables)
  - [6. Verify Installation](#6-verify-installation)
- [Prodigy License & Versions](#prodigy-license--versions)
- [Project Structure](#project-structure)
- [LLM Configuration](#llm-configuration)
- [Quick Start](#quick-start)
- [Reference Repos (Optional)](#reference-repos-optional)
- [Resources](#resources)

## Prerequisites

- **Python 3.9+** (tested with 3.11)
- **Prodigy license key** — purchase at [prodi.gy/buy](https://prodi.gy/buy)
- **OpenAI API key** — required for LLM-based recipes (spacy-llm with GPT models)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Friend09/practise_prodigy.git
cd practise_prodigy
```

### 2. Create a Virtual Environment

```bash
python -m venv .venv
source .venv/bin/activate   # macOS/Linux
# .venv\Scripts\activate    # Windows
```

### 3. Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

Or use the Makefile:

```bash
make install
```

### 4. Install Prodigy

Prodigy is a commercial tool and requires a license key. Install it using your personal download link:

```bash
python -m pip install prodigy -f https://YOUR_LICENSE_KEY@download.prodi.gy
```

Replace `YOUR_LICENSE_KEY` with your actual key (format: `XXXX-XXXX-XXXX-XXXX`).

Or use the Makefile (reads the key from your `.env` file):

```bash
make install-prodigy
```

> **Note**: Your license key and download link are provided in the purchase confirmation email from Explosion. You can also find them at `https://YOUR_LICENSE_KEY@download.prodi.gy`.

### 5. Set Up Environment Variables

Copy the example environment file and fill in your keys:

```bash
cp .env.example .env
```

Edit `.env` with your values:

```dotenv
PRODIGY_LICENSE_KEY=XXXX-XXXX-XXXX-XXXX
OPENAI_API_KEY=sk-...
OPENAI_API_ORG=org-...
PRODIGY_OPENAI_KEY=sk-...
PRODIGY_OPENAI_ORG=org-...
```

> **Important**: `.env` is gitignored and will never be committed. Do not commit your license key or API keys.
> The `*.llm.*` recipes use `OPENAI_API_KEY`/`OPENAI_API_ORG`, while the `*.openai.*` recipes use `PRODIGY_OPENAI_KEY`/`PRODIGY_OPENAI_ORG`.

### 6. Verify Installation

```bash
# Check Prodigy version
python -m prodigy stats

# Check spaCy installation
python -m spacy info
```

## Prodigy License & Versions

| Detail               | Value                          |
| -------------------- | ------------------------------ |
| License type         | Personal license               |
| Upgrades valid until | Oct 18, 2024                   |
| Latest eligible      | **Prodigy v1.15.7** (Oct 2024) |
| Current latest       | v1.18.4 (Nov 2025)             |

Your license key grants access to all Prodigy versions released up to your upgrade expiry date. The latest version you can install is **v1.15.7**.

To install a specific version:

```bash
python -m pip install prodigy==1.15.7 -f https://YOUR_LICENSE_KEY@download.prodi.gy
```

### Renewing Upgrades

To unlock newer versions (v1.16+), purchase a 12-month upgrade extension:

1. Go to [prodi.gy/buy](https://prodi.gy/buy)
2. Click **"Already have a personal license?"**
3. Complete checkout
4. Your existing key will be reactivated within 24 hours

See the full [Prodigy Changelog](https://prodi.gy/docs/changelog) for all version details.

## Project Structure

```
.
├── app.py                  # Example: spacy-llm pipeline assembly
├── Makefile                # Common commands (install, prodigy recipes, LLM recipes)
├── prodigy.json            # Prodigy UI configuration
├── requirements.txt        # Python dependencies
├── .env.example            # Template for environment variables
│
├── data/                   # Datasets for annotation
│   ├── examples.jsonl      #   Cooking-domain examples
│   └── news_headlines.jsonl#   News headline examples (NYT)
│
├── dev/                    # Development configs & few-shot examples
│   ├── _config/            #   spaCy/Prodigy pipeline configs
│   │   ├── config.cfg      #     TextCat (GPT-3.5)
│   │   ├── config_classif.cfg  # TextCat classification
│   │   ├── config_ner.cfg  #     NER (GPT-4)
│   │   └── prodigy_config_ner.cfg  # Cooking NER with label defs & few-shot (GPT-3.5)
│   └── _fewshot/           #   Few-shot learning examples
│       └── ner_examples.yml#     NER few-shot examples for spacy-llm prompts
│
├── models/                 # Trained spaCy models
│   └── en_cooking_ner/     #   Cooking NER model (spaCy 3.7.5, LLM-based)
│
├── notebooks/              # Jupyter notebooks for learning
│   ├── practise_prodigy.ipynb  # Prodigy practice & testing
│   └── spacy_llm.ipynb    #   spacy-llm exploration
│
├── files/                  # Reference documents & PDFs
│
└── ref_explosion/          # (gitignored) Cloned reference repos
└── ref_spacy_llm/          # (gitignored) explosion/spacy-llm source
```

## LLM Configuration

Prodigy offers two integration paths for LLMs:

1. **`*.llm.*` recipes** (recommended) — use `spacy-llm` config files, support multiple LLM backends, caching, and few-shot examples. Require `OPENAI_API_KEY` in `.env`.
2. **`*.openai.*` recipes** — direct OpenAI integration, simpler setup (labels on command line). Require `PRODIGY_OPENAI_KEY` and `PRODIGY_OPENAI_ORG` in `.env`.

> **Note**: OpenAI is deprecating some APIs that `*.openai.*` recipes depend on. The `*.llm.*` variants via `spacy-llm` are the recommended path forward.

### Environment Variables

The two recipe families use **different** env var names:

| Recipe family         | Variables needed                           |
| --------------------- | ------------------------------------------ |
| `*.llm.*` (spacy-llm) | `OPENAI_API_KEY`, `OPENAI_API_ORG`         |
| `*.openai.*` (direct) | `PRODIGY_OPENAI_KEY`, `PRODIGY_OPENAI_ORG` |

Add both sets to your `.env` file if you plan to use both recipe types.

### spacy-llm Config Files

The `*.llm.*` recipes use `spacy-llm` configuration files in `dev/_config/`. The main config for LLM-assisted NER is `prodigy_config_ner.cfg`, which defines:

- **Task**: `spacy.NER.v2` with labels `DISH`, `INGREDIENT`, `EQUIPMENT`
- **Label definitions**: Descriptions to guide the LLM (e.g., "Extract the name of a cooking ingredient")
- **Few-shot examples**: Loaded from `dev/_fewshot/ner_examples.yml` via `spacy.FewShotReader.v1`
- **Model**: `spacy.GPT-3-5.v1` (requires `OPENAI_API_KEY`)

You can swap the model backend (e.g., to GPT-4 or a local model) by editing the `[components.llm.model]` section. Enable caching by uncommenting `[components.llm.cache]` to avoid duplicate LLM calls.

## Quick Start

### Run a Prodigy NER annotation session (manual)

```bash
# Manual NER annotation on cooking data
make ner-manual
# Open the Prodigy UI at http://localhost:8080
# Remember to hit the save button (💾) before closing!
```

### LLM-powered annotation

These recipes use large language models to pre-annotate data, so you review and correct predictions instead of annotating from scratch.

#### Named Entity Recognition (NER)

LLMs can pre-highlight entities that aren't supported by pretrained spaCy pipelines. Use `*.correct` to review in the UI, or `*.fetch` to download annotations for later batch review.

```bash
# spacy-llm recipes (uses OPENAI_API_KEY, config-driven)
make ner-llm-correct       # Review/correct LLM NER predictions in the UI
make ner-llm-fetch         # Batch-download LLM NER annotations to JSONL

# OpenAI direct recipes (uses PRODIGY_OPENAI_KEY, label-driven)
make ner-openai-correct    # Review/correct OpenAI NER predictions in the UI
make ner-openai-fetch      # Batch-download OpenAI NER annotations to JSONL
```

#### Text Classification

LLMs can attach class predictions without training a model first.

```bash
# spacy-llm recipes
make textcat-llm-correct   # Review/correct LLM textcat predictions in the UI
make textcat-llm-fetch     # Batch-download LLM textcat annotations to JSONL

# OpenAI direct recipes
make textcat-openai-correct  # Review/correct OpenAI textcat predictions in the UI
make textcat-openai-fetch    # Batch-download OpenAI textcat annotations to JSONL
```

#### Terminology Lists

Generate terms and phrases from an LLM, then curate them into pattern files for downstream annotation.

```bash
make terms-llm-fetch       # Generate terms via spacy-llm
make terms-openai-fetch    # Generate terms via OpenAI directly
```

#### Finding Interesting Data Subsets

The `*.fetch` recipes (e.g., `ner-llm-fetch`, `textcat-openai-fetch`) let you download LLM predictions upfront. This is useful for **rare labels** — instead of reviewing all examples manually, filter to only those where the LLM predicts the label of interest.

#### Prompt Comparison & Tournaments

Compare and benchmark custom prompts to find the best performing LLM configuration.

```bash
make ab-llm-tournament     # spacy-llm tournament (multiple prompts × multiple backends)
make ab-openai-prompts     # A/B test two OpenAI prompts
make ab-openai-tournament  # Tournament across many OpenAI prompts
```

> **Setup**: Tournament recipes require Jinja2 prompt templates in `dev/prompts/`, input data in `data/inputs.jsonl`, and a display template. See the [Prodigy LLM docs](https://prodi.gy/docs/large-language-models) for the expected file formats.

> **Note**: The `*.llm.correct` recipes show the LLM's prompt and response in the UI. The `*.llm.fetch` recipes download annotations to a JSONL file for later review with manual recipes.

### Use spacy-llm to assemble a pipeline

```bash
python app.py
```

### Export annotations from the Prodigy database

```bash
# Export manual annotations
make db-out

# Export LLM-corrected annotations
make db-out-llm
```

### View all available Prodigy recipes

```bash
python -m prodigy --help
```

## Reference Repos (Optional)

For deeper learning, you can clone these Explosion repositories locally:

```bash
# Explosion assets (cheat sheets, flowcharts, posters)
git clone https://github.com/explosion/assets.git ref_explosion

# spacy-llm source code (models, tasks, usage examples)
git clone https://github.com/explosion/spacy-llm.git ref_spacy_llm
```

These directories are gitignored and not included in the repository.

## Resources

- [Prodigy Documentation](https://prodi.gy/docs)
- [Prodigy Changelog](https://prodi.gy/docs/changelog)
- [Prodigy Support Forum](https://support.prodi.gy/)
- [spaCy Documentation](https://spacy.io/)
- [spacy-llm Documentation](https://spacy.io/usage/large-language-models)
- [Prodigy Recipes Reference](https://prodi.gy/docs/recipes)
- [Explosion Blog](https://explosion.ai/blog)
