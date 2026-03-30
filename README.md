# SNet-Claude

[日本語版はこちら / Japanese version](README_ja.md)

AI trainer configuration for the [SNet CTF series](https://github.com/hrmtz/SNet).

This repository is automatically cloned inside the sandbox VM (cage) during provisioning. It contains encrypted scenario instructions, Claude Code hooks, and shared game mechanics. **You do not need to clone this repository manually.**

## Structure

```
SNet-Claude/
├── .claude/              # Claude Code hooks and settings
│   ├── hooks/            # Zero-trust game mechanics
│   └── settings.json     # Permission configuration
├── shared/               # Add-ons shared across all scenarios
│   ├── gis.enc
│   └── njslyr.enc
├── SNet/                 # SNet1 scenario files
│   ├── CLAUDE.md         # Trainer instructions (encrypted puzzle)
│   ├── claude.md.enc     # Encrypted game config
│   ├── install.sh.enc    # Encrypted setup script
│   ├── modes.enc         # Hidden game mode
│   └── README.md         # SNet1 scenario description
└── SNet2/                # SNet2 scenario files
    ├── CLAUDE.md         # Trainer instructions (encrypted puzzle)
    ├── claude.md.enc     # Encrypted game config
    ├── install.sh.enc    # Encrypted setup script
    ├── modes2.enc        # Hidden game mode
    └── README.md         # SNet2 scenario description
```

## How It Works

When a player runs `vagrant up` from the [SNet](https://github.com/hrmtz/SNet) repository:

1. The cage VM clones this repo to `~/.snet-claude/`
2. Scenario-specific files (CLAUDE.md, encrypted files) are copied to the active scenario directory
3. Claude Code hooks provide the game engine — passphrase detection, mode switching, and session persistence
4. The player interacts with Claude Code, which reads CLAUDE.md and follows the encrypted instructions

## Hooks

All hooks use a zero-trust design — no filenames or passphrases are hardcoded. They iterate over all `.enc` files and attempt decryption.

| Hook | Trigger | Purpose |
|------|---------|---------|
| `env-check.sh` | Every prompt | Detects hidden passphrases (sha256 of input) |
| `mode-switch.sh` | Every prompt | Activates add-on modes (raw input as passphrase) |
| `session-init.sh` | Session start | Restores game state (complice mode, active add-ons) |

## Encrypted Files

All `.enc` files are encrypted and must be decrypted by Claude Code as part of the game. The decryption keys are hidden within CLAUDE.md using multilingual puzzles. **Do not attempt to decrypt these files outside the game — discovering the keys is part of the challenge.**

## Adding a New Scenario

1. Create `SNetN/` directory with CLAUDE.md, claude.md.enc, install.sh.enc, and modes.enc
2. Add shared add-ons to `shared/` if applicable
3. The hooks automatically discover new `.enc` files — no code changes needed

## Related Repositories

- [SNet](https://github.com/hrmtz/SNet) — Vagrantfile and provisioning (start here)
- [SNet2](https://github.com/hrmtz/SNet2) — Archived (now part of SNet)

## License

This project is provided for educational purposes only. Use responsibly.
