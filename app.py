"""Example script demonstrating spacy-llm pipeline assembly for cooking NER."""

from spacy_llm.util import assemble
from dotenv import load_dotenv

# Make sure the environment variables are loaded
load_dotenv()

# Assemble a spaCy pipeline from the config
nlp = assemble("dev/_config/prodigy_config_ner.cfg")

# Use this pipeline as you would normally
doc = nlp("I know of a great pizza recipe with anchovis.")
print(doc.ents)  # (pizza, anchovis)
