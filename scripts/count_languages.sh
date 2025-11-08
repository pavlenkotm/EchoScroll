#!/bin/bash
# Count and display all programming languages in the repository

echo "🌐 EchoScroll Language Statistics"
echo "=================================="
echo ""

EXAMPLES_DIR="examples"
TOTAL=0

echo "📊 Languages Found:"
echo ""

for dir in "$EXAMPLES_DIR"/*/ ; do
    if [ -d "$dir" ]; then
        LANG=$(basename "$dir")
        echo "  ✓ $LANG"
        ((TOTAL++))
    fi
done

echo ""
echo "=================================="
echo "🎯 Total Languages: $TOTAL"
echo "=================================="

# Generate metrics
cat > metrics.json <<EOF
{
  "total_languages": $TOTAL,
  "last_updated": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repository": "EchoScroll",
  "description": "Multi-language Web3 development showcase"
}
EOF

echo "✅ Metrics saved to metrics.json"
