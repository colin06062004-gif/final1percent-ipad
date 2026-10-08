"""Copies the web app into the Swift Playgrounds project (FinalOnePercent.swiftpm/Web).

Run after every change to index.html, the images or fonts/, and commit both together —
the App Store build only ever sees the copy:  python tools/sync_playgrounds.py
"""
import shutil
from pathlib import Path

repo = Path(__file__).resolve().parent.parent
web = repo / "FinalOnePercent.swiftpm" / "Web"

shutil.rmtree(web, ignore_errors=True)   # start clean, so files removed from the app don't linger
web.mkdir()
for name in ["index.html", "helmet-mark.png", "watermark-helmet.png"]:
    shutil.copy2(repo / name, web / name)
shutil.copytree(repo / "fonts", web / "fonts")
print("synced", sorted(p.relative_to(web).as_posix() for p in web.rglob("*") if p.is_file()))
