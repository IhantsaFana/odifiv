#!/usr/bin/env bash
# 🚀 Fivondronana Setup Helper Script
# Usage: bash setup.sh

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║  🎯 Fivondronana - Setup Assistant                       ║"
echo "║  Application Mobile Scout - Semi-Offline                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Flutter Setup
echo -e "${BLUE}[1/6]${NC} Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Install from https://flutter.dev${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Flutter found: $(flutter --version | head -1)${NC}"
echo ""

# Step 2: Get dependencies
echo -e "${BLUE}[2/6]${NC} Installing Flutter dependencies..."
flutter pub get
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 3: FlutterFire Configure
echo -e "${BLUE}[3/6]${NC} Setting up Firebase..."
echo "Checking for FlutterFire CLI..."

if ! command -v flutterfire &> /dev/null; then
    echo "Installing FlutterFire CLI..."
    dart pub global activate flutterfire_cli
fi

echo ""
echo -e "${YELLOW}⚠️  Run: flutterfire configure${NC}"
echo "   or setup manually:"
echo "   1. Download google-services.json → android/app/"
echo "   2. Download GoogleService-Info.plist → ios/Runner/"
echo ""

# Step 4: Environment variables
echo -e "${BLUE}[4/6]${NC} Setting up environment variables..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Created .env from .env.example${NC}"
    echo "   Edit .env with your Firebase credentials"
else
    echo -e "${GREEN}✅ .env already exists${NC}"
fi
echo ""

# Step 5: Code generation
echo -e "${BLUE}[5/6]${NC} Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs
echo -e "${GREEN}✅ Code generation complete${NC}"
echo ""

# Step 6: Verification
echo -e "${BLUE}[6/6]${NC} Verifying setup..."
flutter analyze
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Code analysis passed${NC}"
else
    echo -e "${RED}⚠️  Code analysis found issues${NC}"
fi
echo ""

# Final summary
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║  ✅ Setup Completed!                                     ║"
echo "║                                                           ║"
echo "║  📚 Documentation:                                        ║"
echo "║     • QUICKSTART.md - Start here (5 min)                 ║"
echo "║     • DEVELOPER_GUIDE.md - Full architecture (20 min)    ║"
echo "║     • FIREBASE_SETUP.md - Firebase config (30 min)       ║"
echo "║     • CONVENTIONS.md - Code standards                    ║"
echo "║                                                           ║"
echo "║  🚀 Next Steps:                                          ║"
echo "║     1. Configure Firebase (if not done)                  ║"
echo "║     2. Edit .env with Firebase credentials               ║"
echo "║     3. Run: flutter run                                  ║"
echo "║                                                           ║"
echo "║  📖 Read QUICKSTART.md for detailed instructions         ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

echo -e "${GREEN}Happy coding! 🎉${NC}"
