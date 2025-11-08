#!/usr/bin/env python3
"""
GitHub Activity Generator
Automates commits, refactors, and documentation updates for continuous activity
"""

import os
import random
import subprocess
import datetime
import json
from pathlib import Path
from typing import List, Dict

class ActivityGenerator:
    def __init__(self, repo_path: str = "."):
        self.repo_path = Path(repo_path)
        self.examples_dir = self.repo_path / "examples"

    def get_all_language_dirs(self) -> List[Path]:
        """Get all language example directories"""
        return [d for d in self.examples_dir.iterdir() if d.is_dir()]

    def generate_documentation_update(self, lang_dir: Path) -> bool:
        """Add or update documentation in a language directory"""
        readme = lang_dir / "README.md"

        if readme.exists():
            content = readme.read_text()

            # Add timestamp or update
            timestamp = datetime.datetime.now().strftime("%Y-%m-%d")
            update_line = f"\n\n*Last updated: {timestamp}*\n"

            if "*Last updated:" not in content:
                with open(readme, 'a') as f:
                    f.write(update_line)
                return True

        return False

    def generate_test_file(self, lang_dir: Path) -> bool:
        """Generate a simple test file"""
        test_extensions = {
            'python': 'test_example.py',
            'javascript': 'example.test.js',
            'typescript': 'example.test.ts',
            'rust': 'tests/integration_test.rs',
            'go': 'example_test.go',
            'java': 'ExampleTest.java',
        }

        lang_name = lang_dir.name
        test_file = None

        for key, filename in test_extensions.items():
            if key in lang_name.lower():
                test_file = lang_dir / filename
                break

        if test_file and not test_file.exists():
            test_file.parent.mkdir(exist_ok=True)
            test_file.write_text(f"// Test file generated on {datetime.datetime.now()}\n")
            return True

        return False

    def generate_config_update(self, lang_dir: Path) -> bool:
        """Update configuration files"""
        config_files = [
            '.editorconfig',
            '.gitignore',
            'config.json'
        ]

        for config in config_files:
            config_path = lang_dir / config
            if not config_path.exists():
                config_path.write_text(f"# Configuration generated on {datetime.datetime.now()}\n")
                return True

        return False

    def commit_changes(self, message: str):
        """Commit changes with given message"""
        try:
            subprocess.run(['git', 'add', '.'], cwd=self.repo_path, check=True)
            subprocess.run(
                ['git', 'commit', '-m', message],
                cwd=self.repo_path,
                check=True
            )
            return True
        except subprocess.CalledProcessError:
            return False

    def run_daily_activity(self):
        """Generate daily activity"""
        lang_dirs = self.get_all_language_dirs()
        random.shuffle(lang_dirs)

        activities = [
            (self.generate_documentation_update, "docs: update documentation timestamp"),
            (self.generate_test_file, "test: add test file"),
            (self.generate_config_update, "chore: update configuration"),
        ]

        commits_made = 0
        target_commits = random.randint(3, 8)

        for lang_dir in lang_dirs:
            if commits_made >= target_commits:
                break

            activity, commit_msg = random.choice(activities)

            if activity(lang_dir):
                full_msg = f"{commit_msg} for {lang_dir.name}"
                if self.commit_changes(full_msg):
                    commits_made += 1
                    print(f"✅ {full_msg}")

        print(f"\n🎉 Generated {commits_made} commits today!")

    def generate_metrics_file(self):
        """Generate repository metrics"""
        lang_dirs = self.get_all_language_dirs()

        metrics = {
            "total_languages": len(lang_dirs),
            "languages": [d.name for d in lang_dirs],
            "last_updated": datetime.datetime.now().isoformat(),
            "total_examples": len(lang_dirs),
        }

        metrics_file = self.repo_path / "metrics.json"
        with open(metrics_file, 'w') as f:
            json.dump(metrics, f, indent=2)

        self.commit_changes("chore: update repository metrics")
        print(f"📊 Metrics updated: {len(lang_dirs)} languages")

def main():
    generator = ActivityGenerator()

    import sys
    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command == "daily":
            generator.run_daily_activity()
        elif command == "metrics":
            generator.generate_metrics_file()
        else:
            print(f"Unknown command: {command}")
            print("Usage: generate_activity.py [daily|metrics]")
    else:
        # Default: run daily activity
        generator.run_daily_activity()

if __name__ == "__main__":
    main()
