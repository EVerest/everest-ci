import sys
from pathlib import Path

dist_root = Path(__file__).parent.parent / 'src'
sys.path.append(dist_root.as_posix())
