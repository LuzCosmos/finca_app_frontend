import argparse
import math
import sys
from pathlib import Path


def _parse_lcov_lines_coverage(lcov_text: str) -> tuple[int, int]:
    """
    Returns (LH, LF) totals found in the LCOV file.
    LCOV keys:
      - LH: lines hit
      - LF: lines found
    """
    lh_total = 0
    lf_total = 0
    for raw in lcov_text.splitlines():
        line = raw.strip()
        if line.startswith("LH:"):
            lh_total += int(line[3:])
        elif line.startswith("LF:"):
            lf_total += int(line[3:])
    return lh_total, lf_total


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fail CI if Flutter LCOV line coverage is below a minimum.",
    )
    parser.add_argument(
        "--lcov",
        default="coverage/lcov.info",
        help="Path to coverage/lcov.info (default: coverage/lcov.info)",
    )
    parser.add_argument(
        "--min",
        type=float,
        required=True,
        help="Minimum line coverage percentage, e.g. 60",
    )
    args = parser.parse_args()

    lcov_path = Path(args.lcov)
    if not lcov_path.exists():
        print(f"[coverage] ERROR: LCOV file not found: {lcov_path}", file=sys.stderr)
        return 2

    text = lcov_path.read_text(encoding="utf-8", errors="replace")
    lh, lf = _parse_lcov_lines_coverage(text)
    if lf <= 0:
        print(
            f"[coverage] ERROR: LF is {lf}. LCOV seems empty or invalid: {lcov_path}",
            file=sys.stderr,
        )
        return 2

    pct = (lh / lf) * 100.0
    # Keep output stable and CI-friendly.
    pct_rounded = math.floor(pct * 100) / 100.0  # floor to 2 decimals (avoid flapping)

    print(f"[coverage] lines: {lh}/{lf} = {pct_rounded:.2f}% (min: {args.min:.2f}%)")

    if pct + 1e-9 < args.min:
        print(
            f"[coverage] FAIL: {pct_rounded:.2f}% is below minimum {args.min:.2f}%",
            file=sys.stderr,
        )
        return 1

    print("[coverage] OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

