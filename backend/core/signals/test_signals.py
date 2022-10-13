import unittest


class TestSignals(unittest.TestCase):
    def test_signals_are_importable(self):
        try:
            from backend.core.signals.model import (  # noqa
                model_created,
                model_deleted,
                model_updated,
            )
        except ImportError:
            self.fail("Could not import model signals")
