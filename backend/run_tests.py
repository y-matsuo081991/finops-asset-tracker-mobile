import pytest
import sys
import os

# backendディレクトリをPythonパスに追加
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

# pytestを実行
sys.exit(pytest.main(['-v', 'tests/']))
