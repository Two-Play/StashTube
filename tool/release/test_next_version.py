"""Tests for next_version.py: python3 -m unittest discover -s tool/release"""
import unittest

from next_version import next_version


class NextVersionTest(unittest.TestCase):
    def test_without_labels(self):
        self.assertEqual(next_version('v1.0.0-beta.5', []), '1.0.0-beta.6')
        self.assertEqual(next_version('v1.0.0', []), '1.0.1')

    def test_stable(self):
        self.assertEqual(next_version('v1.0.0-beta.5', ['release:stable']), '1.0.0')
        self.assertEqual(next_version('v1.0.0', ['release:stable']), '1.0.1')

    def test_parts(self):
        self.assertEqual(next_version('v1.2.3', ['release:patch']), '1.2.4')
        self.assertEqual(next_version('v1.2.3', ['release:minor']), '1.3.0')
        self.assertEqual(next_version('v1.2.3', ['release:major']), '2.0.0')
        self.assertEqual(next_version('v1.0.0-beta.5', ['release:minor']), '1.1.0')
        self.assertEqual(next_version('v1.2.3', ['release:minor', 'release:major']), '2.0.0')

    def test_beta(self):
        self.assertEqual(next_version('v1.0.0', ['release:minor', 'release:beta']), '1.1.0-beta.1')
        self.assertEqual(next_version('v1.0.0', ['release:beta']), '1.0.1-beta.1')
        self.assertEqual(next_version('v1.0.0-beta.5', ['release:beta']), '1.0.0-beta.6')

    def test_other_labels_and_first_release(self):
        self.assertEqual(next_version('v1.0.0-beta.5', ['documentation']), '1.0.0-beta.6')
        self.assertEqual(next_version('', []), '0.0.1')

    def test_rejects_other_tags(self):
        with self.assertRaises(ValueError):
            next_version('v1.0', [])
        with self.assertRaises(ValueError):
            next_version('v1.0.0-rc.1', [])


if __name__ == '__main__':
    unittest.main()
