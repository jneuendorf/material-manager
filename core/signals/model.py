from blinker import Namespace

model = Namespace()

model_created = model.signal("model-created")
model_updated = model.signal("model-updated")
model_deleted = model.signal("model-deleted")
