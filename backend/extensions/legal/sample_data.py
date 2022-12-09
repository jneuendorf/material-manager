from extensions.legal.models import BoardMember, Imprint, PrivacyPolicy

member0 = BoardMember.get_or_create(
    member_first_name="Peter", member_last_name="Müller", position="Vorsitzender"
)
member1 = BoardMember.get_or_create(member_first_name="Herta", member_last_name="Meyer")

Imprint.get_or_create(
    club_name="Deutscher Alpenverein Sektion Berlin e.V.",
    street="Musterstraße",
    house_number="56A",
    city="Berlin",
    zip_code="12553",
    phone="+49 12345678942",
    email="muster@mail.com",
    registration_number=7235,
    registry_court="Amtgericht Berlin",
    vat_number="1234 567 89",
    dispute_resolution_uri="http://ec.europa.eu/consumers/odr/",
    _related=dict(board_members=[member0, member1]),
)

PrivacyPolicy.get_or_create(
    company="(company name)",
    first_name="(first name)",
    last_name="(last name)",
    street="(street name)",
    house_number="(house number)",
    city="(city name)",
    zip_code="(zip code)",
    phone="(phone number)",
    email="(email address)",
)
