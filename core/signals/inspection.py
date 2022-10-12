from blinker import Namespace

inspection = Namespace()

material_ok = inspection.signal("inspection-material_ok")
material_needs_repair = inspection.signal("inspection-material_needs_repair")
material_broken = inspection.signal("inspection-material_broken")
