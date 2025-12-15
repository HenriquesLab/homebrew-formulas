# Testing Strategy

## Current Status

**CI Tests**: Temporarily disabled due to Homebrew core issue.

**Error**: `missing keywords: :date, :because` in versioned Python formulas.

**Affected**: All formulas that depend on `python@3.12` or `python@3.13`.

## Local Testing

All formulas are tested locally before release using the `just release` command:

```bash
# Test and release a formula
just release taskrepo

# Or step-by-step
just update taskrepo
just test taskrepo
just commit taskrepo VERSION
git push
```

This workflow:
1. Updates the formula from PyPI
2. **Uninstalls and reinstalls** the formula locally
3. Runs `brew test` to verify functionality
4. Commits with standardized message
5. Pushes to remote

## Manual Verification

After `just release`, the formulas are also manually verified:

```bash
# Check versions
tsk --version
rxiv --version
folder2md --version

# Run basic commands
tsk list
rxiv --help
folder2md --help
```

## CI Re-enablement

The CI workflows will be re-enabled once Homebrew core fixes the versioned Python formula deprecation issue.

**Tracking Issue**: https://github.com/Homebrew/homebrew-core/issues (versioned Python deprecation)

## Conclusion

**Local testing is more reliable than CI** for Homebrew formulas because:
- Tests actual installation on the developer's machine
- Catches platform-specific issues
- Not affected by transient Homebrew core bugs
- Provides immediate feedback

The disabled CI tests are **redundant**, not **missing** - formulas are thoroughly tested before release.
