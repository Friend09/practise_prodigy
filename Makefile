install:
	pip install --upgrade pip
	pip install -r requirements.txt

prodigy_install:
	python -m pip install prodigy -f https://578E-EE16-4F66-50E7@download.prodi.gy/

all: install prodigy_install
