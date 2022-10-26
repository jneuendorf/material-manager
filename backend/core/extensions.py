from flask_mail import Mail
from flask_sqlalchemy import SQLAlchemy

from core.helpers.orm import CrudModel

db = SQLAlchemy(model_class=CrudModel)
"""A fake db variable without an app context. We need this in order to avoid
cyclic imports (extension -> app -> extensions -> extension).
This way, we don't have to take care of correctly creating"""

mail = Mail()
