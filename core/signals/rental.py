from blinker import Namespace

rental = Namespace()

export = rental.signal("rental-export")
request_sent = rental.signal("rental-request_sent")
request_confirmed = rental.signal("rental-request_confirmed")
invoice_email_sent = rental.signal("rental-invoice_email_sent")
material_ready = rental.signal("rental-material_ready")
material_ready_email_sent = rental.signal("rental-material_ready_email_sent")
picked_up = rental.signal("rental-picked_up")
returned = rental.signal("rental-returned")
not_returned = rental.signal("rental-not_returned")
inspection_material_ok = rental.signal("rental-inspection-material_ok")
inspection_material_needs_inspection = rental.signal(
    "rental-inspection-material_needs_inspection"
)
inspection_material_broken = rental.signal("rental-inspection-material_broken")
