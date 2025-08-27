# Instructions to set up spotify with spicetify

# Install required programs
yay -S --noconfirm spotify-launcher spicetify-cli unzip

# Open and log into spotify, after which you can proceed with the next steps 

# Inject spotify with spicetify
spicetify backup apply

# Install spicetify marketplace
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

# Apply custom spicetify theme
spicetify config current_theme walspot
spicetify apply
