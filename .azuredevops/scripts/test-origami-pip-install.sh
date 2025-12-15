#!/bin/bash
# Test Origami pip install workflow (editable mode)
# Usage: test-origami-pip-install.sh ROCM_PATH CMAKE_PREFIX_PATH CMAKE_CXX_COMPILER PYTHON_DIR

set -e  # Exit on any error

ROCM_PATH="$1"
CMAKE_PREFIX_PATH="$2"
CMAKE_CXX_COMPILER="$3"
PYTHON_DIR="$4"

# Export environment variables for pip install CMake build
export ROCM_PATH
export CMAKE_PREFIX_PATH
export CMAKE_CXX_COMPILER

echo "==================================================================="
echo "Testing pip install workflow (pip install -e .)"
echo "==================================================================="
echo "ROCM_PATH: $ROCM_PATH"
echo "CMAKE_PREFIX_PATH: $CMAKE_PREFIX_PATH"
echo "CMAKE_CXX_COMPILER: $CMAKE_CXX_COMPILER"
echo "PYTHON_DIR: $PYTHON_DIR"
echo ""

# Install from source directory (editable mode) - matches README instructions
cd "$PYTHON_DIR"
pip install -e .

# Verify import works
echo ""
echo "Verifying origami can be imported..."
python3 -c "import origami; print('✓ Successfully imported origami')"

# Run pytest on installed package
echo ""
echo "Running pytest tests..."
python3 -m pytest tests/ -v -m "not slow" --tb=short

echo ""
echo "==================================================================="
echo "✓ Pip install test completed successfully"
echo "==================================================================="
