py -m venv venv 
call venv\Scripts\activate
pip install -r requirements-dev.txt
pip install -r requirements.txt
flask create-sample-data user material inspection rental