#!/usr/bin/env bash
# =============================================================================
# macOS Defaults — Sensible developer settings
# =============================================================================

# Close System Preferences to prevent overrides
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

# --- Finder -----------------------------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true          # show hidden files
defaults write com.apple.finder ShowPathbar -bool true                # show path bar
defaults write com.apple.finder ShowStatusBar -bool true              # show status bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true    # full path in title
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true       # show all extensions

# --- Dock -------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true                    # auto-hide dock
defaults write com.apple.dock autohide-delay -float 0                # no delay
defaults write com.apple.dock autohide-time-modifier -float 0.3      # faster animation
defaults write com.apple.dock tilesize -int 48                       # icon size
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false               # no recent apps
defaults write com.apple.dock mru-spaces -bool false                 # don't rearrange spaces

# --- Keyboard ---------------------------------------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2                       # fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15               # short delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false   # key repeat, not accents
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# --- Trackpad ----------------------------------------------------------------
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5  # faster tracking

# --- Screenshots -------------------------------------------------------------
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
mkdir -p "$HOME/Screenshots"

# --- Misc -------------------------------------------------------------------
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true   # no .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true       # no .DS_Store on USB
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false     # save to disk, not iCloud

# --- Safari Dev (skip if sandboxed — fails on modern macOS) -----------------
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null || true

# --- Activity Monitor --------------------------------------------------------
defaults write com.apple.ActivityMonitor ShowCategory -int 0         # show all processes
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# --- Restart affected apps ---------------------------------------------------
for app in "Finder" "Dock" "SystemUIServer"; do
  killall "$app" &>/dev/null || true
done
