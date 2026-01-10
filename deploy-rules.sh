#!/bin/bash

# Fivondronana Firebase Rules Deployment Script
# Deploys Firestore security rules to Firebase project

set -e

PROJECT_ID="gestion-esmia"
RULES_FILE="firestore.rules"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "=========================================="
echo "🔐 Fivondronana Firestore Rules Deployment"
echo "=========================================="
echo ""
echo "Project ID: $PROJECT_ID"
echo "Rules File: $RULES_FILE"
echo "Timestamp: $TIMESTAMP"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}✗ Firebase CLI not found!${NC}"
    echo "Install with: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✓ Firebase CLI found${NC}"
echo ""

# Check if rules file exists
if [ ! -f "$RULES_FILE" ]; then
    echo -e "${RED}✗ Rules file not found: $RULES_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Rules file found${NC}"
echo ""

# Validate rules syntax (if firebase validate available)
echo "📋 Validating Firestore rules..."
firebase deploy --only firestore:rules --dry-run 2>&1 | tee /tmp/firestore-deploy.log

if grep -q "Error" /tmp/firestore-deploy.log; then
    echo ""
    echo -e "${RED}✗ Validation failed! Check syntax and try again.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Validation successful!${NC}"
echo ""

# Confirm deployment
echo -e "${YELLOW}Ready to deploy rules to project: $PROJECT_ID${NC}"
read -p "Continue with deployment? (y/n) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 1
fi

# Deploy rules
echo ""
echo "🚀 Deploying Firestore rules..."
firebase deploy --only firestore:rules

echo ""
echo -e "${GREEN}✓ Deployment successful!${NC}"
echo ""

# Show current rules
echo "📄 Current Firestore Rules:"
echo "========================================"
firebase firestore:get-rules

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Deployment completed at $TIMESTAMP${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Test rules in Firebase Emulator:"
echo "   firebase emulators:start --only firestore"
echo ""
echo "2. Monitor rules violations:"
echo "   firebase functions:logs"
echo ""
echo "3. View rules in Firebase Console:"
echo "   https://console.firebase.google.com/project/$PROJECT_ID/firestore/rules"
echo ""
