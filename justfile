# Homebrew Formula Automation
# This justfile provides recipes for managing Homebrew formulas in this tap

# Default recipe - show available commands
default:
    @just --list

# List all formulas with their current versions
list:
    #!/usr/bin/env python3
    import re
    from pathlib import Path

    print("📦 Formulas in this tap:\n")

    formula_dir = Path("Formula")
    for formula_file in sorted(formula_dir.glob("*.rb")):
        with open(formula_file) as f:
            content = f.read()

        # Extract package name and version from URL
        url_match = re.search(r'url\s+"https://files\.pythonhosted\.org/packages/.*/([^/]+)-(\d+\.\d+\.\d+)\.tar\.gz"', content)
        if url_match:
            package = url_match.group(1)
            version = url_match.group(2)
            print(f"  • {formula_file.stem}: {package} v{version}")
        else:
            print(f"  • {formula_file.stem}: (version not found)")

# Check for available updates from PyPI
check-updates:
    #!/usr/bin/env python3
    import re
    import json
    import urllib.request
    from pathlib import Path

    print("🔍 Checking for updates...\n")

    formula_dir = Path("Formula")
    updates_available = False

    for formula_file in sorted(formula_dir.glob("*.rb")):
        with open(formula_file) as f:
            content = f.read()

        # Extract package name and current version from URL
        url_match = re.search(r'url\s+"https://files\.pythonhosted\.org/packages/.*/([^/]+)-(\d+\.\d+\.\d+)\.tar\.gz"', content)
        if not url_match:
            print(f"⚠️  {formula_file.stem}: Could not parse version")
            continue

        package = url_match.group(1)
        current_version = url_match.group(2)

        # Query PyPI for latest version
        try:
            with urllib.request.urlopen(f"https://pypi.org/pypi/{package}/json", timeout=10) as response:
                data = json.loads(response.read())
                latest_version = data["info"]["version"]

                if current_version == latest_version:
                    print(f"✅ {formula_file.stem}: v{current_version} (up to date)")
                else:
                    print(f"🔄 {formula_file.stem}: v{current_version} → v{latest_version} (update available)")
                    updates_available = True
        except Exception as e:
            print(f"❌ {formula_file.stem}: Error checking PyPI - {e}")

    if updates_available:
        print("\n💡 Run 'just update <formula>' to update a specific formula")
        print("💡 Run 'just update-all' to update all formulas")

# Get SHA256 checksum for a PyPI package
sha256 PACKAGE VERSION:
    #!/usr/bin/env python3
    import sys
    import json
    import urllib.request

    package = "{{PACKAGE}}"
    version = "{{VERSION}}"

    try:
        url = f"https://pypi.org/pypi/{package}/{version}/json"
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read())

        # Find the source tarball
        for file_info in data["urls"]:
            if file_info["packagetype"] == "sdist" and file_info["filename"].endswith(".tar.gz"):
                print(f"Package: {package} v{version}")
                print(f"URL:     {file_info['url']}")
                print(f"SHA256:  {file_info['digests']['sha256']}")
                sys.exit(0)

        print(f"❌ No source tarball found for {package} v{version}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)

# Update a formula to a specific version (or latest if not specified)
update FORMULA VERSION="":
    #!/usr/bin/env python3
    import sys
    import re
    import json
    import urllib.request
    from pathlib import Path

    formula_name = "{{FORMULA}}"
    target_version = "{{VERSION}}"

    formula_file = Path(f"Formula/{formula_name}.rb")

    if not formula_file.exists():
        print(f"❌ Formula not found: {formula_file}", file=sys.stderr)
        sys.exit(1)

    # Read current formula
    with open(formula_file) as f:
        content = f.read()

    # Extract package name from current URL
    url_match = re.search(r'url\s+"https://files\.pythonhosted\.org/packages/.*/([^/]+)-(\d+\.\d+\.\d+)\.tar\.gz"', content)
    if not url_match:
        print(f"❌ Could not parse package name from {formula_file}", file=sys.stderr)
        sys.exit(1)

    package = url_match.group(1)
    current_version = url_match.group(2)

    # Get version to update to
    if not target_version:
        try:
            with urllib.request.urlopen(f"https://pypi.org/pypi/{package}/json", timeout=10) as response:
                data = json.loads(response.read())
                target_version = data["info"]["version"]
        except Exception as e:
            print(f"❌ Error fetching latest version from PyPI: {e}", file=sys.stderr)
            sys.exit(1)

    if current_version == target_version:
        print(f"✅ {formula_name} is already at version {target_version}")
        sys.exit(0)

    print(f"🔄 Updating {formula_name}: v{current_version} → v{target_version}")

    # Get new package info from PyPI
    try:
        url = f"https://pypi.org/pypi/{package}/{target_version}/json"
        with urllib.request.urlopen(url, timeout=10) as response:
            data = json.loads(response.read())
    except Exception as e:
        print(f"❌ Error fetching package info from PyPI: {e}", file=sys.stderr)
        sys.exit(1)

    # Find the source tarball
    new_url = None
    new_sha256 = None
    for file_info in data["urls"]:
        if file_info["packagetype"] == "sdist" and file_info["filename"].endswith(".tar.gz"):
            new_url = file_info["url"]
            new_sha256 = file_info["digests"]["sha256"]
            break

    if not new_url or not new_sha256:
        print(f"❌ No source tarball found for {package} v{target_version}", file=sys.stderr)
        sys.exit(1)

    # Update the formula file
    old_url_pattern = r'url\s+"https://files\.pythonhosted\.org/packages/[^"]+\.tar\.gz"'
    old_sha_pattern = r'sha256\s+"[0-9a-f]{64}"'

    new_content = re.sub(old_url_pattern, f'url "{new_url}"', content)
    new_content = re.sub(old_sha_pattern, f'sha256 "{new_sha256}"', new_content)

    with open(formula_file, 'w') as f:
        f.write(new_content)

    print(f"✅ Updated {formula_file}")
    print(f"   URL:    {new_url}")
    print(f"   SHA256: {new_sha256}")
    print(f"\n💡 Run 'just test {formula_name}' to test the update")
    print(f"💡 Run 'just commit {formula_name} {target_version}' to commit the changes")

# Update all formulas to their latest versions
update-all:
    #!/usr/bin/env python3
    import re
    import json
    import urllib.request
    from pathlib import Path
    import subprocess

    print("🔄 Updating all formulas to latest versions...\n")

    formula_dir = Path("Formula")
    updated = []

    for formula_file in sorted(formula_dir.glob("*.rb")):
        formula_name = formula_file.stem

        with open(formula_file) as f:
            content = f.read()

        # Extract package name and version
        url_match = re.search(r'url\s+"https://files\.pythonhosted\.org/packages/.*/([^/]+)-(\d+\.\d+\.\d+)\.tar\.gz"', content)
        if not url_match:
            print(f"⚠️  Skipping {formula_name}: Could not parse version")
            continue

        package = url_match.group(1)
        current_version = url_match.group(2)

        # Check for updates
        try:
            with urllib.request.urlopen(f"https://pypi.org/pypi/{package}/json", timeout=10) as response:
                data = json.loads(response.read())
                latest_version = data["info"]["version"]

            if current_version == latest_version:
                print(f"✅ {formula_name}: Already at v{latest_version}")
                continue

            print(f"🔄 {formula_name}: v{current_version} → v{latest_version}")

            # Run update recipe
            result = subprocess.run(
                ["just", "update", formula_name, latest_version],
                capture_output=True,
                text=True
            )

            if result.returncode == 0:
                updated.append((formula_name, latest_version))
            else:
                print(f"❌ Failed to update {formula_name}")
                print(result.stderr)

        except Exception as e:
            print(f"❌ {formula_name}: Error - {e}")

    if updated:
        print(f"\n✅ Updated {len(updated)} formula(s):")
        for name, version in updated:
            print(f"   • {name} → v{version}")
        print("\n💡 Run 'just test-all' to test all updates")
    else:
        print("\n✅ All formulas are up to date!")

# Test a formula by installing it
test FORMULA:
    #!/usr/bin/env python3
    import sys
    import subprocess
    from pathlib import Path

    formula_name = "{{FORMULA}}"
    formula_file = Path(f"Formula/{formula_name}.rb")

    if not formula_file.exists():
        print(f"❌ Formula not found: {formula_file}", file=sys.stderr)
        sys.exit(1)

    print(f"🧪 Testing {formula_name}...")
    print("   Note: This will uninstall and reinstall the formula\n")

    # Uninstall if already installed
    subprocess.run(["brew", "uninstall", "--ignore-dependencies", formula_name],
                   capture_output=True)

    # Install from tap
    print(f"📦 Installing {formula_name}...")
    result = subprocess.run(
        ["brew", "install", f"henriqueslab/formulas/{formula_name}"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"❌ Installation failed:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    print(f"✅ {formula_name} installed successfully")

    # Run brew test
    print(f"\n🔬 Running brew test...")
    result = subprocess.run(
        ["brew", "test", formula_name],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"⚠️  brew test output:")
        print(result.stdout)
        if result.stderr:
            print(result.stderr)
    else:
        print(f"✅ All tests passed!")

# Test all formulas
test-all:
    #!/usr/bin/env python3
    from pathlib import Path
    import subprocess

    print("🧪 Testing all formulas...\n")

    formula_dir = Path("Formula")
    failed = []

    for formula_file in sorted(formula_dir.glob("*.rb")):
        formula_name = formula_file.stem
        print(f"Testing {formula_name}...")

        result = subprocess.run(
            ["just", "test", formula_name],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            failed.append(formula_name)
            print(result.stderr)
        else:
            print(result.stdout)

    if failed:
        print(f"\n❌ {len(failed)} formula(s) failed:")
        for name in failed:
            print(f"   • {name}")
        exit(1)
    else:
        print("\n✅ All formulas passed!")

# Commit an update with proper message format
commit FORMULA VERSION:
    #!/usr/bin/env python3
    import sys
    import subprocess
    from pathlib import Path

    formula_name = "{{FORMULA}}"
    version = "{{VERSION}}"
    formula_file = Path(f"Formula/{formula_name}.rb")

    if not formula_file.exists():
        print(f"❌ Formula not found: {formula_file}", file=sys.stderr)
        sys.exit(1)

    # Check if there are changes to commit
    result = subprocess.run(
        ["git", "diff", "--quiet", str(formula_file)],
        capture_output=True
    )

    if result.returncode == 0:
        print(f"⚠️  No changes to commit for {formula_name}")
        sys.exit(0)

    commit_message = (
        formula_name + ": update to version " + version + "\n\n" +
        "Updates the " + formula_name + " formula to version " + version + ".\n" +
        "- Updated PyPI download URL\n" +
        "- Updated SHA256 checksum"
    )

    # Stage and commit
    subprocess.run(["git", "add", str(formula_file)], check=True)
    subprocess.run(["git", "commit", "-m", commit_message], check=True)

    print(f"✅ Committed update for {formula_name} v{version}")
    print(f"💡 Run 'git push' to push the changes")

# Full release workflow: update, test, commit, and push
release FORMULA VERSION="":
    #!/usr/bin/env python3
    import sys
    import subprocess

    formula_name = "{{FORMULA}}"
    version = "{{VERSION}}"

    print(f"🚀 Starting release workflow for {formula_name}...\n")

    # Step 1: Update
    print("Step 1: Updating formula...")
    cmd = ["just", "update", formula_name]
    if version:
        cmd.append(version)

    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"❌ Update failed:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    print(result.stdout)

    # Extract version from output if not provided
    if not version:
        import re
        match = re.search(r'v[\d.]+\s+→\s+v([\d.]+)', result.stdout)
        if match:
            version = match.group(1)
        else:
            print("❌ Could not determine version", file=sys.stderr)
            sys.exit(1)

    # Step 2: Test
    print("\nStep 2: Testing formula...")
    result = subprocess.run(
        ["just", "test", formula_name],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"❌ Tests failed:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    print(result.stdout)

    # Step 3: Commit
    print(f"\nStep 3: Committing changes...")
    result = subprocess.run(
        ["just", "commit", formula_name, version],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"❌ Commit failed:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    print(result.stdout)

    # Step 4: Push
    print("\nStep 4: Pushing to remote...")
    result = subprocess.run(
        ["git", "push"],
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"❌ Push failed:", file=sys.stderr)
        print(result.stderr, file=sys.stderr)
        sys.exit(1)

    print(f"✅ Successfully released {formula_name} v{version}!")
