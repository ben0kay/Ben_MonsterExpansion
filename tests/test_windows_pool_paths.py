"""Exercise pool-preservation checks with Windows paths on any test host."""
from pathlib import Path, PureWindowsPath
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import generate_variants as gen
import test_ascended as ascended
import test_elites as elites
from test_natural_spawns import catalog


class WindowsPoolPathTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.families, cls.tiers = catalog()
        cls.files = {PureWindowsPath(path.as_posix()): text
                     for path, text in gen.configured_plan(include_spawns=True).items()}

    def check_preservation(self, module, case_type, method):
        original_build = gen.build_plan

        def windows_plan(*args, **kwargs):
            return {PureWindowsPath(path.as_posix()): text
                    for path, text in original_build(*args, **kwargs).items()}

        case = case_type(method)
        case.families, case.tiers, case.files = self.families, self.tiers, self.files
        case.family = next(f for f in self.families if f['id'] == 'discovered_ascended')
        with patch.object(module, 'Path', PureWindowsPath), \
             patch.object(gen, 'build_plan', side_effect=windows_plan), \
             patch.object(gen, 'configured_plan', return_value=self.files):
            getattr(case, method)()

    def test_ascended_preservation_with_windows_paths(self):
        self.check_preservation(ascended, ascended.AscendedTests,
                                'test_previous_variants_settings_and_unrelated_fields_preserved')

    def test_elite_preservation_with_windows_paths(self):
        self.check_preservation(elites, elites.EliteTests,
                                'test_veteran_records_and_regular_selections_preserved_in_combined_build')
